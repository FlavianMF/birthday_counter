# 📧 Guia de Testes de Email

Este documento descreve como testar o sistema de emails do **Birthday Counter Experience**.

## 1. Ambientes de Teste

### Local (Mailpit)
Por padrão, o ambiente de desenvolvimento utiliza o **Mailpit** para interceptar emails.
- **SMTP Host**: `mailpit`
- **SMTP Port**: `1025`
- **Web UI**: [http://localhost:8025](http://localhost:8025)

**Vantagem**: Os emails não saem para a internet, evitando spam acidental durante testes.

### Real (Gmail/SendGrid/etc.)
Para testar o envio real para sua caixa de entrada pessoal:
1. Acesse `/admin/settings/email`.
2. Configure o servidor SMTP do seu provedor.
3. **Importante**: Mude o endereço SMTP de `mailpit` para o endereço do seu provedor (ex: `smtp.gmail.com`).

---

## 2. Procedimento de Teste de Convite

1. **Login como Admin**: Certifique-se de que seu usuário tem `role: 'admin'`.
2. **Configuração**: Acesse o painel de email e salve as configurações do seu provedor.
3. **Criação de Evento**:
   - Vá em "Novo Evento".
   - Marque a opção **Surpresa**.
   - Preencha o campo **Email do Destinatário** com seu email pessoal.
   - Salve o evento.
4. **Validação**: 
   - Se estiver usando Mailpit, o email aparecerá na interface WebUI.
   - Se configurou um SMTP real, o email deve chegar na sua caixa de entrada em alguns segundos.

---

## 3. Teste de Contagem Regressiva (Daily Countdown)

A contagem regressiva é disparada por um Job agendado. Para forçar um teste manual:

1. Acesse o console do Rails:
   ```bash
   docker compose exec api bundle exec rails console
   ```
2. Execute o serviço manualmente:
   ```ruby
   NotificationService.send_daily_countdowns
   ```
3. Verifique o disparo no Mailpit ou na sua caixa de entrada.

---

## 4. Troubleshooting

- **Email aparece no Mailpit mas não chega no destinatário**: Isso é o comportamento esperado do Mailpit. Ele é um "buraco negro" de emails para testes. Para envio real, você **deve** mudar o SMTP Host para um servidor real nas configurações.
- **Erro de Autenticação**: Verifique se você está usando uma "Senha de App" se o provedor for Gmail ou Outlook.
- **Timeout**: Verifique se a porta SMTP (ex: 587) está aberta no seu firewall/rede.
