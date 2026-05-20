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
