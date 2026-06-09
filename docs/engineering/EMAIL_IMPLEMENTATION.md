# 📧 Implementação do Sistema de Emails

## 📋 Visão Geral
A funcionalidade de email foi consolidada e expandida para suportar convites de convidados, além das notificações já existentes de countdown e surpresas.

## 🛠️ Mudanças Realizadas

### 1. Configuração de Ambiente
- **Development**: Configurado `letter_opener` para visualização de emails no browser durante o desenvolvimento.
- **Background Jobs**: Definido `Sidekiq` como queue adapter em desenvolvimento para processar `deliver_later`.
- **Test**: Corrigido `ActionDispatch::HostAuthorization` e `UnsafeRedirectError` ajustando `default_url_options` para `www.example.com`.

### 2. Novos Endpoints de Convite
- **Web**: `POST /events/:id/invite` - Permite convidar amigos via email.
- **API**: `POST /api/v1/events/:id/invite` - Endpoint REST para convites externos/mobile.

### 3. Serviços e Mailers
- **NotificationService**: Utiliza `NotificationMailer.guest_invitation_email` para processar convites.
- **Mailers**: `NotificationMailer` configurado com hosts dinâmicos por ambiente.

### 4. Interface de Configuração (Admin)
- **Model**: `SystemSetting` com armazenamento `jsonb` para flexibilidade.
- **UI**: `/settings/email` - Interface protegida para administradores configurarem SMTP e endereços de envio.
- **Dinamismo**: Alterações via interface são aplicadas imediatamente ao `ActionMailer` e persistidas para boot futuro.
- **Audit**: Log de alterações integrado ao `AuditLog`.

## 🧪 Validação (Docker)
Todos os testes (incluindo novos testes de configuração) foram executados via Docker e estão passando:
```bash
docker compose exec api env RAILS_ENV=test bundle exec rspec spec/requests/system_settings_spec.rb
```
**Resultado**: 3 examples, 0 failures. (Total suite: 105 examples, 0 failures).

---
**Status**: Implementado & Validado.
**Links**: [[SystemSetting]], [[SystemSettingsController]], [[AuditLog]]
