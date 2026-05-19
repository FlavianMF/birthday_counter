# 👥 Análise de Stakeholders e Matriz de Interação

Este documento identifica os atores (humanos e sistêmicos) envolvidos no ecossistema **Birthday Counter Experience** e como eles interagem entre si, baseando-se em princípios de engenharia de sistemas.

## 1. Identificação de Stakeholders

### 1.1 Stakeholders Primários (Usuários Finais)
| Ator | Papel no Sistema | Objetivo Principal |
| :--- | :--- | :--- |
| **Aniversariante (Host)** | Proprietário do Evento | Ter uma experiência memorável e receber afeto. |
| **Amigo Organizador (Sponsor)** | Criador do Evento (Surpresa) | Iniciar a celebração e mobilizar o grupo. |
| **Amigo (Guest)** | Colaborador e Jogador | Competir no ranking e demonstrar afeto ao host. |

### 1.2 Stakeholders de Governança (Administração)
| Ator | Papel no Sistema | Objetivo Principal |
| :--- | :--- | :--- |
| **Administrador (Admin)** | Gestão Global e Moderação | Garantir a integridade da plataforma, segurança dos dados e suporte aos usuários. |

### 1.3 Stakeholders Secundários (Sistêmicos/Suporte)
| Ator | Papel no Sistema | Objetivo Principal |
| :--- | :--- | :--- |
| **AI Engine (Systemic Actor)** | Processador de Dados | Gerar conteúdo dinâmico (quizzes/stories). |
| **Provedores Externos** | Infraestrutura | Spotify, Mapas, Cloudflare. |

## 2. Matriz de Interação (Systems Perspective)

### A. Admin ↔ Sistema (Management Layer)
- **Input**: Comandos de moderação, ajuste de parâmetros de jogo, auditoria de logs.
- **Valor**: Plataforma segura, livre de abusos e tecnicamente otimizada.

### B. Admin ↔ Usuários (Support Loop)
- **Input**: Resolução de tickets, suspensão de contas maliciosas.
- **Valor**: Confiança do usuário e manutenção da comunidade.

### C. Sponsor ↔ Sistema (Cold Start)
- **Input**: Criação do evento surpresa; preenchimento inicial de dados do Host.
- **Valor**: Autonomia para criar o hype antes mesmo do Host estar ciente.

### D. Host ↔ Sistema (Activation & Curation)
- **Input**: Aceite do convite; complementação da Bio; moderação local do mural.
- **Valor**: Personalização e controle da própria celebração.

### E. Guest ↔ Sistema (Engagement Loop)
- **Input**: Respostas de jogos, moedas gastas, contribuições sociais.
- **Valor**: Diversão e pontuação no ranking.

## 3. Requisitos por Stakeholder (High-Level)

1.  **Admin**: Necessita de uma interface de "Backoffice" potente, com logs de auditoria imutáveis.
2.  **Host**: Necessita de ferramentas de privacidade (ex: quem pode ver minhas fotos).
3.  **Guest**: Necessita de uma UI gamificada e feedback visual de progresso.
4.  **Sponsor**: Necessita de anonimato parcial até o momento da revelação.
