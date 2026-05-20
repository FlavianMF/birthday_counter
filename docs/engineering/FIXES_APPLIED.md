# 🛠 Relatório de Correções Técnicas - Design & Assets

Este documento detalha os problemas enfrentados durante a implementação do Design System e as soluções aplicadas para estabilizar o ambiente Docker.

## 1. Problema: Assets Não Carregados (Página em Branco)

### Sintomas
- O site carregava apenas o HTML bruto (texto preto, fundo branco).
- Erros 404 para arquivos CSS no console do navegador.
- Ícones (Heroicons/SVG) sem dimensões definidas.

### Causa Raiz
A gem `tailwindcss-rails` gera por padrão um arquivo chamado `tailwind.css` na pasta `app/assets/builds`. No entanto, o layout padrão do Rails (`application.html.erb`) buscava por `application.css`. Além disso, o manifesto de assets (`manifest.js`) não estava vinculado à pasta de builds.

### Solução
- Atualizado `manifest.js` para incluir `//= link_tree ../builds`.
- Modificado o `Dockerfile` para copiar o `tailwind.css` gerado para `application.css` durante o build.
- Padronizado o `stylesheet_link_tag` no layout para `application`.

---

## 2. Problema: Falha no Build do Docker (`npm run build`)

### Sintomas
- O comando `docker build` falhava no step 36 com `exit code 1`.
- Erro indicando que `import.meta.glob` não era suportado.

### Causa Raiz
Tentei utilizar uma sintaxe de carregamento automático de controllers baseada no **Vite**, mas o projeto utiliza **esbuild** (via `jsbundling-rails`). O esbuild não suporta `import.meta.glob` nativamente sem plugins específicos.

### Solução
- Refatorado `app/javascript/controllers/index.js` para usar o método de registro manual do Stimulus, garantindo compatibilidade total com o esbuild e o pipeline de assets padrão do Rails.

---

## 3. Problema: Falha no Precompile (DATABASE_URL)

### Sintomas
- O build falhava ao tentar rodar `assets:precompile` porque o Rails tentava se conectar ao banco de dados (que ainda não existia na fase de build).

### Causa Raiz
O comando `assets:precompile` no Rails 7+ frequentemente inicializa a aplicação, exigindo uma conexão com o banco ou uma `SECRET_KEY_BASE`.

### Solução
- Adicionado mocks de ambiente no `Dockerfile`:
  ```dockerfile
  RUN RAILS_ENV=production \
      SECRET_KEY_BASE_DUMMY=1 \
      DATABASE_URL=postgresql://postgres@localhost/dummy_db \
      bundle exec rails assets:precompile
  ```
- O uso de subshell garante que essas variáveis não vazem para o runtime do container.

---

## 4. Problema: Erro de Conexão (Runtime)

### Sintomas
- `ActiveRecord::ConnectionNotEstablished` tentando conectar em `localhost:5432`.

### Causa Raiz
Variáveis de ambiente de build estavam persistindo no container, sobrescrevendo a configuração do `docker-compose.yml` que aponta para o host `db`.

### Solução
- Removidas as declarações `ENV` globais do `Dockerfile` em favor de argumentos de build ou execuções em linha (`RUN VAR=val cmd`), garantindo que em tempo de execução o Rails use as configurações do `docker-compose`.

---

**Status Final**: Ambiente estabilizado, pipeline de assets funcional e design system aplicado.

---

## 5. Problema: Erro na Registration Flow (ActionController::ParameterMissing)

### Sintomas
- Erro `ActionController::ParameterMissing in RegistrationsController#create` com mensagem "param is missing or the value is empty: user"
- Ocorria ao tentar criar uma nova conta de usuário
- Request parameters mostravam campos planos: `{"name"=>"...", "email"=>"...", "password"=>"[FILTERED]", ...}`

### Causa Raiz
O controlador `RegistrationsController` esperava parâmetros aninhados (`params.require(:user)`) mas o formulário estava enviando parâmetros planos (flat). Isso acontecia porque:

1. O formulário `form_with model: @user` deveria encapsular os parâmetros automaticamente em `user[]`
2. Porém, a action `new` não inicializava `@user = User.new`, quebrando o comportamento esperado
3. O método `registration_params` usava `params.require(:user).permit(...)` que falhava ao não encontrar o escopo `user`

### Solução
Arquivo: `app/controllers/registrations_controller.rb`

**Mudanças aplicadas:**

1. **Inicializar `@user` na action `new`:**
```ruby
def new
  @user = User.new
end
```

2. **Remover `require(:user)` do método `registration_params`:**
```ruby
# Antes
def registration_params
  params.require(:user).permit(:email, :password, :password_confirmation, :name)
end

# Depois
def registration_params
  params.permit(:email, :password, :password_confirmation, :name)
end
```

**Branch:** `fix/registration-params`  
**Commit:** `7955a4a`

### Resultado
- Formulário de registro agora funciona corretamente
- Usuários podem criar contas sem erros de parâmetros
- Validações do model User continuam funcionando normalmente

---

**Status Final**: Ambiente estabilizado, pipeline de assets funcional, design system aplicado, e fluxo de registro corrigido.

---

## 6. Problema: Sessão não persiste (usuário é deslogado ao navegar)

### Sintomas
- Após fazer login, ao clicar em "Criar Evento" ou navegar para outras páginas, o usuário era redirecionado para a página de login
- A sessão não estava persistindo entre requisições
- Ocorria mesmo com `session[:user_id]` sendo definido corretamente no controller

### Causa Raiz
O Rails requer uma `SECRET_KEY_BASE` válida para criptografar e validar cookies de sessão. Sem essa configuração:
1. Os cookies de sessão não eram properly criptografados
2. Cada requisição tratava a sessão como inválida
3. O `current_user` retornava nil mesmo após login bem-sucedido
4. A configuração do session_store não estava otimizada para ambientes Docker

### Solução
Múltiplos arquivos modificados:

**1. config/initializers/session_store.rb** - Configuração robusta do session store:
```ruby
Rails.application.config.session_store :cookie_store, 
  key: '_birthday_project_session',
  same_site: :lax,
  expire_after: 14.days,
  secure: Rails.env.production?,
  httponly: true,
  domain: :all
```

**2. .env e .env.example** - Adicionado SECRET_KEY_BASE:
```bash
# Session Secret (required for session persistence)
SECRET_KEY_BASE=development-secret-key-base-change-in-production
```

**3. docker-compose.yml** - Adicionado SECRET_KEY_BASE para api e sidekiq:
```yaml
environment:
  SECRET_KEY_BASE: ${SECRET_KEY_BASE:-${RAILS_MASTER_KEY:-development-secret-key-base-change-in-production}}
```

**4. config/environments/production.rb** - Reforçar segurança em produção:
```ruby
config.require_master_key = true
```

**Branch:** `fix/session-persistence`  
**Commit:** `7526c6a`

### Resultado
- Sessão agora persiste corretamente entre navegações
- Usuários logados permanecem autenticados ao navegar entre páginas
- Cookies de sessão configurados com boas práticas de segurança
- Compatível com ambiente Docker e desenvolvimento local

---

## 7. Problema: NoMethodError no formulário de Novo Evento

### Sintomas
- Erro `NoMethodError in Events#new`
- Mensagem: `undefined method 'checkbox' for #<ActionView::Helpers::FormBuilder:...>`
- Ocorria ao acessar a página de criação de evento

### Causa Raiz
Houve um erro de digitação no arquivo `app/views/events/new.html.erb`. O helper correto do Rails para criar um checkbox em um `form_with` é `check_box`, mas foi utilizado `checkbox`.

### Solução
Arquivo: `app/views/events/new.html.erb`

**Mudança aplicada:**
Alterado `<%= form.checkbox :is_surprise, ... %>` para `<%= form.check_box :is_surprise, ... %>`.

**Branch:** `fix/event-form-typo`  
**Commit:** `[SHA-DRAFT]`

### Resultado
- A página de criação de novos eventos agora carrega corretamente sem erros de método indefinido.
- O campo "É uma surpresa?" funciona como esperado.

---
