# 🧪 Estratégia de Testes (Ruby on Rails + Docker)

Este projeto utiliza **RSpec** como framework de testes principal, executado inteiramente dentro de containers Docker.

## 🚀 Como Executar os Testes

Como não há Ruby instalado localmente, todos os comandos devem ser prefixados com `docker compose run --rm api`.

### 1. Executar todos os testes
```bash
docker compose run --rm api bundle exec rspec
```

### 2. Executar um arquivo específico
```bash
docker compose run --rm api bundle exec rspec spec/models/user_spec.rb
```

### 3. Preparar o banco de dados de teste (se necessário)
```bash
docker compose run --rm api bundle exec rails db:test:prepare
```

## 🏗️ Estrutura de Testes

- `spec/models/`: Testes unitários para lógica de negócio e validações.
- `spec/requests/`: Testes de integração para os endpoints da API.
- `spec/system/`: Testes de interface (E2E) usando Capybara/Selenium (requer configuração adicional de Chrome Driver no Docker).
- `spec/factories/`: Definições de objetos de teste usando FactoryBot.

## 🛠️ Ferramentas Inclusas

- **RSpec**: Framework BDD.
- **FactoryBot**: Criação de dados para teste.
- **Shoulda Matchers**: One-liners para testes comuns de model.
- **Database Cleaner**: Garante banco limpo entre os testes.

## 📝 Melhores Práticas

1. **Testes de Modelo**: Focar em validações, scopes e métodos de instância complexos.
2. **Testes de Request**: Validar status HTTP e estrutura do JSON de retorno para a API.
3. **Mocks/Stubs**: Usar para serviços externos (Spotify API, Geocoder) para manter os testes rápidos e determinísticos.
