-- 1) Top 5 jogadores com maior média de kills por partida
SELECT j.nome,
       ROUND(AVG(e.kills)::numeric,2) AS media_Kills
FROM Estatistica e
JOIN Jogador j ON e.jogador_id = j.id_jogador
GROUP BY j.nome
ORDER BY media_Kills DESC
LIMIT 5;

-- 2) Top 5 jogadores com maior relação kill/death (KDR)
SELECT j.nome,
       ROUND(SUM(e.kills)::numeric / NULLIF(SUM(e.mortes),0),2) AS KDA
FROM Estatistica e
JOIN Jogador j ON e.jogador_id = j.id_jogador
GROUP BY j.nome
ORDER BY KDA DESC
LIMIT 5;

-- 3) Top 5 jogadores com maior média de assistências por partida
SELECT j.nome,
       ROUND(AVG(e.assistencias)::numeric,2) AS Media_assist
FROM Estatistica e
JOIN Jogador j ON e.jogador_id = j.id_jogador
GROUP BY j.nome
ORDER BY Media_assist DESC
LIMIT 5;

-- 4) Total e média de kills por agente
SELECT a.nome,
       SUM(ua.kills)                  AS total_kills,
       ROUND(AVG(ua.kills)::numeric,2) AS Med_Kill_agnt
FROM Uso_Agente ua
JOIN Agente a ON ua.agente_id = a.id_agente
GROUP BY a.nome
ORDER BY total_kills DESC;

-- 5) Frequência de seleção de cada agente
SELECT a.nome,
       COUNT(*) AS Vezes_Pick
FROM Uso_Agente ua
JOIN Agente a ON ua.agente_id = a.id_agente
GROUP BY a.nome
ORDER BY Vezes_Pick DESC;

-- 6) Total de vitórias por equipe em cada temporada
SELECT p.temporada,
       e.nome    AS equipe,
       COUNT(*)  AS wins
FROM Partida p
JOIN Equipe e ON p.vencedora_id = e.id_equipe
GROUP BY p.temporada, e.nome
ORDER BY p.temporada, wins DESC;

-- 7) Taxa de vitória por lado (Atacante/Defensor) para cada equipe
SELECT e.nome   AS equipe,
       ep.lado,
       ROUND(100.0 * SUM(CASE WHEN ep.venceu THEN 1 ELSE 0 END) / COUNT(*),2)
         AS Chance_Vitoria
FROM Equipe_Partida ep
JOIN Equipe e ON ep.equipe_id = e.id_equipe
GROUP BY e.nome, ep.lado
ORDER BY Chance_Vitoria DESC;

-- 8) Média de kills totais por equipe em cada mapa
SELECT m.nome              AS mapa,
       ROUND(AVG(ep.kills_totais)::numeric,2) AS Media_de_Kills
FROM Equipe_Partida ep
JOIN Partida p ON ep.partida_id = p.id_partida
JOIN Mapa m     ON p.id_mapa   = m.id_mapa
GROUP BY m.nome
ORDER BY Media_de_Kills DESC;

-- 9) Taxa de vitória do lado Atacante por mapa
SELECT m.nome              AS mapa,
       ROUND(100.0 * SUM(CASE WHEN ep.venceu AND ep.lado = 'Atacante' THEN 1 ELSE 0 END) /
             NULLIF(SUM(CASE WHEN ep.lado = 'Atacante' THEN 1 ELSE 0 END),0),2)
         AS Med_atk_vit
FROM Equipe_Partida ep
JOIN Partida p ON ep.partida_id = p.id_partida
JOIN Mapa m     ON p.id_mapa   = m.id_mapa
GROUP BY m.nome
ORDER BY Med_atk_vit DESC;

-- 10) Número de agentes únicos usados por jogador (variedade de picks)
SELECT j.nome,
       COUNT(DISTINCT ua.agente_id) AS Picks_por_Player
FROM Uso_Agente ua
JOIN Jogador j ON ua.jogador_id = j.id_jogador
GROUP BY j.nome
ORDER BY Picks_por_Player DESC;

