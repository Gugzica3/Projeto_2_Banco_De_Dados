import random
from faker import Faker
import psycopg2
from datetime import date

# ── CONFIGURAÇÕES DE CONEXÃO (preencha com seus dados) ─────────────────
USER     = "postgres.hbuganlaacxergxpzjfr"
PASSWORD = "Proj2"
HOST     = "aws-0-sa-east-1.pooler.supabase.com"
PORT     = "6543"
DBNAME   = "postgres"
SSLMODE  = "require"

# ── CONEXÃO AO BANCO ─────────────────────────────────────────────────
conn = psycopg2.connect(
    user=USER,
    password=PASSWORD,
    host=HOST,
    port=PORT,
    dbname=DBNAME,
    sslmode=SSLMODE
)
cur = conn.cursor()

# ── INSTÂNCIA PARA GERAÇÃO ────────────────────────────────────────────
fake = Faker('pt_BR')
random.seed(42)

# ── PARÂMETROS ────────────────────────────────────────────────────────
TOTAL_JOGADORES = 30
TOTAL_PARTIDAS  = 50

MAPAS_FIXOS = [
    ("Bind",    "Standard"),
    ("Haven",   "Standard"),
    ("Split",   "Standard"),
    ("Ascent",  "Standard"),
    ("Icebox",  "Standard"),
    ("Breeze",  "Standard"),
    ("Fracture","Standard"),
    ("Pearl",   "Standard"),
    ("Lotus",   "Standard")
]

AGENTES_FIXOS = [
    ("Brimstone", "Controller"),
    ("Omen",      "Controller"),
    ("Viper",     "Controller"),
    ("Sova",      "Initiator"),
    ("Killjoy",   "Sentinel"),
    ("Cypher",    "Sentinel"),
    ("Sage",      "Sentinel"),
    ("Phoenix",   "Duelist"),
    ("Jett",      "Duelist"),
    ("Raze",      "Duelist")
]

EQUIPES_FIXAS = [
    "TCKLOUD9",
    "MIBR",
    "FURIA",
    "KRU",
    "Sentinels",
    "LOUD"
]

RANKS = [
    "Ascendente", "Imortal", "Radiante"
]

MODOS = ["Sem Classificacao", "Ranqueada", "Frenetica", "Mata-Mata"]
SEASONS = ["VCT Playoffs", "VCT", "Masters", "Champions"]

# ── GERA MAPAS ────────────────────────────────────────────────────────
for mid, (nome, tipo) in enumerate(MAPAS_FIXOS, start=1):
    cur.execute(
        "INSERT INTO Mapa(id_mapa, nome, tipo) VALUES (%s, %s, %s)",
        (mid, nome, tipo)
    )

# ── GERA AGENTES ─────────────────────────────────────────────────────
for aid, (nome, papel) in enumerate(AGENTES_FIXOS, start=1):
    data_lanc = fake.date_between(
        start_date=date(2020, 6, 2),
        end_date=date(2025, 5, 20)
    )
    cur.execute(
        "INSERT INTO Agente(id_agente, nome, papel, data_lancamento) VALUES (%s, %s, %s, %s)",
        (aid, nome, papel, data_lanc)
    )

# ── GERA EQUIPES ────────────────────────────────────────────────────
for eid, nome in enumerate(EQUIPES_FIXAS, start=1):
    regiao = fake.country()
    cur.execute(
        "INSERT INTO Equipe(id_equipe, nome, regiao) VALUES (%s, %s, %s)",
        (eid, nome, regiao)
    )

# ── GERA JOGADORES com atribuição de EQUIPE (5 por equipe) ──────────
players_per_team = {eid: [] for eid in range(1, len(EQUIPES_FIXAS) + 1)}
for jid in range(1, TOTAL_JOGADORES + 1):
    nome = fake.name()
    rank = random.choice(RANKS)
    nac  = fake.country()
    equipe_id = ((jid - 1) // 5) + 1  # exatamente 5 jogadores por equipe
    players_per_team[equipe_id].append(jid)
    cur.execute(
        "INSERT INTO Jogador(id_jogador, nome, rank, nacionalidade, equipe_id) "
        "VALUES (%s, %s, %s, %s, %s)",
        (jid, nome, rank, nac, equipe_id)
    )

# ── GERA PARTIDAS, ESTATÍSTICAS, USO_DE_AGENTE e EQUIPE_PARTIDA ─────
for pid in range(1, TOTAL_PARTIDAS + 1):
    # Dados básicos da partida
    dt         = fake.date_time_between(start_date="-1y", end_date="now")
    modo       = random.choice(MODOS)
    mapa_id    = random.randint(1, len(MAPAS_FIXOS))
    temporada  = random.choice(SEASONS)

    # Seleciona 2 equipes e define vencedora
    equipes    = random.sample(list(players_per_team.keys()), 2)
    vencedora  = random.choice(equipes)

    # Insere Partida com temporada e vencedora
    cur.execute(
        "INSERT INTO Partida(id_partida, data_hora, modo, id_mapa, temporada, vencedora_id) "
        "VALUES (%s, %s, %s, %s, %s, %s)",
        (pid, dt, modo, mapa_id, temporada, vencedora)
    )

    # Prepara acumuladores de kills por equipe
    kills_por_time = {equipes[0]: 0, equipes[1]: 0}

    # Insere Estatistica e Uso_Agente para cada jogador participante (10 por partida)
    for equipe in equipes:
        for jid in players_per_team[equipe]:
            kills   = random.randint(0, 30)
            mortes  = random.randint(0, 30)
            assists = random.randint(0, 20)

            # Estatística geral do jogador na partida
            cur.execute(
                "INSERT INTO Estatistica(jogador_id, partida_id, kills, mortes, assistencias) "
                "VALUES (%s, %s, %s, %s, %s)",
                (jid, pid, kills, mortes, assists)
            )

            # Uso do agente pelo jogador na partida
            agente_id = random.randint(1, len(AGENTES_FIXOS))
            tempo     = random.randint(0, 1500)
            cur.execute(
                "INSERT INTO Uso_Agente(partida_id, jogador_id, agente_id, tempo_de_uso, kills) "
                "VALUES (%s, %s, %s, %s, %s)",
                (pid, jid, agente_id, tempo, kills)
            )

            kills_por_time[equipe] += kills

    # Insere dados de Equipe_Partida para cada equipe
    sides = random.sample(["Atacante", "Defensor"], 2)
    for idx, equipe in enumerate(equipes):
        lado        = sides[idx]
        venceu      = (equipe == vencedora)
        total_kills = kills_por_time[equipe]
        cur.execute(
            "INSERT INTO Equipe_Partida(partida_id, equipe_id, lado, venceu, kills_totais) "
            "VALUES (%s, %s, %s, %s, %s)",
            (pid, equipe, lado, venceu, total_kills)
        )

# ── FINALIZA INSERÇÕES ───────────────────────────────────────────────
conn.commit()
cur.close()
conn.close()
print("Dados de Valorant inseridos com sucesso!")
