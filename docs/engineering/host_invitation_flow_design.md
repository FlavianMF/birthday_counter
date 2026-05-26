# 📋 Design Document: Host Invitation Flow (Surprise Activation)

## 1. Problem Statement
Atualmente, a criação de eventos exige um `host_id` obrigatório. Para eventos surpresa (onde o Sponsor cria o evento para o Aniversariante), precisamos de um mecanismo onde o evento seja criado "em espera" até que o Aniversariante (Host) o reivindique (claim) através de um link de convite.

## 2. Proposed Solution
Introduzir o conceito de `invitation_token` na tabela `events` e permitir que `host_id` seja nulo inicialmente se `is_surprise` for verdadeiro.

### 2.1 Database Changes
- **Tabela `events`**:
    - `invitation_token`: `string`, unique index.
    - Alterar `host_id`: de `null: false` para `null: true`.
    - `invitation_claimed_at`: `datetime` (opcional, para auditoria).

### 2.2 Model Logic (`Event`)
- **Callbacks**: `before_create :generate_invitation_token`, apenas se `is_surprise` e `host_id` estiver ausente.
- **Validations**: Garantir que se não for surpresa, `host_id` deve estar presente.

### 2.3 Routing
- `GET /invite/:token` -> `invitations#show` (Exibe a surpresa).
- `POST /invite/:token/claim` -> `invitations#claim` (Associa o usuário logado como Host).

### 2.4 User Experience (UX)
1. **Sponsor**: Cria o evento -> Recebe um link (ex: `birthday.com/invite/XYZ123`).
2. **Sponsor**: Envia o link para o Host.
3. **Host**: Abre o link -> Vê uma landing page de "Surpresa! [Sponsor] preparou algo para você".
4. **Host**: Clica em "Reivindicar Aniversário".
5. **Host**: Faz login/cadastro.
6. **Sistema**: Redireciona e associa o Host ao evento.

## 3. Test Plan (TDD)

### 3.1 Unit Tests (`Event`)
- [ ] Deve gerar um token único ao criar um evento surpresa sem host.
- [ ] Não deve permitir criar um evento não-surpresa sem host.
- [ ] Deve validar a unicidade do `invitation_token`.

### 3.2 Request/Integration Tests
- **Sponsor Workflow**:
    - [ ] `POST /events` com `is_surprise: true` deve persistir o `sponsor_id` e gerar `invitation_token`.
- **Invitation Workflow**:
    - [ ] `GET /invite/:token` deve exibir detalhes do evento (nome, data) sem exigir login (visão pública da surpresa).
    - [ ] `POST /invite/:token/claim` deve falhar se o usuário não estiver logado.
    - [ ] `POST /invite/:token/claim` deve associar o `current_user` como `host_id` e limpar o token (ou marcar como usado).
    - [ ] Tentar usar um token já reivindicado deve retornar erro 404 ou mensagem amigável.

### 3.3 System Tests (End-to-End)
- [ ] Sponsor cria evento -> Copia link -> Host (em nova sessão) abre link -> Se cadastra -> Vê o dashboard do seu aniversário.
