<p align="center">
  <img src="https://img.shields.io/badge/SQL-PostgreSQL-blue?logo=postgresql&logoColor=white" alt="PostgreSQL Badge"/>
  <img src="https://img.shields.io/badge/Python-3.10+-yellow?logo=python&logoColor=white" alt="Python Badge"/>
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License Badge"/>
</p>

# 🎮 Banco de Dados Valorant – Gerenciamento de Partidas e Estatísticas

Um projeto acadêmico para modelar e analisar partidas de **Valorant**, registrando jogadores, agentes, mapas, equipes, estatísticas e resultados de cada jogo usando **PostgreSQL** e **Python**.

---

## 👥 Integrantes  
| Nome                                   | RA            |
|----------------------------------------|---------------|
| **Gustavo Bertoluzzi Cardoso**         | 22.123.016-2  |
| **Isabella Vieira Silva Rosseto**      | 22.222.036-0  |

---

## 🗺️ Visão Geral  
> **Objetivo:** Criar um banco relacional em **3FN** que permita:
> - Cadastrar **Jogadores**, **Equipes**, **Partidas**, **Mapas** e **Agentes**  
> - Registrar estatísticas individuais (kills, mortes, assistências) por jogador em cada partida  
> - Armazenar tempo de uso e kills por agente usado por cada jogador  
> - Definir vencedora, lado e kills totais por equipe em cada partida  
> - Consultar insights como “agente com maior taxa de vitória”, “média de kills por jogador” e “equipes campeãs por temporada”  

---

## 🧭 Índice  
1. [Pré-requisitos](#pré-requisitos)  
2. [Configuração Rápida](#configuração-rápida)  
3. [Scripts Essenciais](#scripts-essenciais)  
4. [Modelos](#modelos)  
5. [Consultas SQL](#consultas-sql)  
6. [Licença](#licença)  

---

## 📦 Pré-requisitos  
- Conta gratuita no **Supabase** (ou acesso a PostgreSQL)  
- **Python 3.10+**  
- **pip**  
- Acesso ao **SQL Editor**  

---

## ⚡ Configuração Rápida  
<details>
<summary><strong>Passo-a-passo detalhado</strong></summary>

1. ### 🚀 Criar projeto no Supabase  
   - Acesse <https://supabase.com> → **New Project** → configure nome, senha e região.

2. ### 🗄️ Executar DDL  
   - No dashboard → **Database ▸ SQL Editor** → cole o conteúdo de <kbd>criar.sql</kbd> → **Run**.

3. ### 🐍 Popular dados fictícios  
   - No terminal local, instale dependências:
     ```bash
     pip install faker psycopg2-binary
     ```
   - Abra <kbd>gerador.py</kbd>, ajuste credenciais de conexão e execute:
     ```bash
     python gerador.py
     ```

4. ### 🔍 Validar consistência  
   - No SQL Editor, execute <kbd>verificador.sql</kbd> para checar regras de negócio.

5. ### 📊 Consultar informações  
   - Abra <kbd>queries.sql</kbd> no Editor e rode suas 10 queries para extrair insights.

</details>

---

## 🛠️ Scripts Essenciais  
| Arquivo          | Descrição                                                        |
|------------------|------------------------------------------------------------------|
| `criar.sql`      | DDL: cria tabelas, chaves primárias, estrangeiras e constraints. |
| `gerador.py`     | Gera dados aleatórios (jogadores, partidas, estatísticas etc.).  |
| `verificador.sql`| Validadores de consistência (5 jogadores/equipe, 2 equipes/partida, etc.). |
| `queries.sql`    | 10 queries que retornam insights de performance e resultados.    |

---

## 🗂️ Modelos

### Modelo Entidade-Relacionamento (MER)
![image](https://github.com/user-attachments/assets/11a1ed9f-7f3d-4992-a51f-9457a7ffc272)

### Modelo Relacional em 3FN (MR)
![image](https://github.com/user-attachments/assets/84b02f63-a43c-4492-a982-26390e46b90f)
---

## 📊 Consultas SQL  
Todas as queries obrigatórias e extras estão em [`Queries.sql`](./Queries.sql).  

---

## 📝 Licença  
Este projeto está sob a licença **MIT** – sinta-se livre para estudar, modificar e distribuir.
