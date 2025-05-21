-- 1) Cada equipe deve ter exatamente 5 jogadores
SELECT equipe_id, COUNT(*) AS num_jogadores
  FROM Jogador
 GROUP BY equipe_id
HAVING COUNT(*) <> 5;

-- 2) Cada partida deve ter exatamente 2 equipes registradas
SELECT partida_id, COUNT(*) AS num_equipes
  FROM Equipe_Partida
 GROUP BY partida_id
HAVING COUNT(*) <> 2;

-- 3) A equipe vencedora deve participar da partida
SELECT p.id_partida
  FROM Partida p
  LEFT JOIN Equipe_Partida ep
    ON p.id_partida = ep.partida_id
   AND p.vencedora_id = ep.equipe_id
 WHERE p.vencedora_id IS NOT NULL
   AND ep.equipe_id IS NULL;

-- 4) kills_totais em Equipe_Partida deve igualar soma de kills de Estatistica para os jogadores daquela equipe
SELECT ep.partida_id,
       ep.equipe_id,
       ep.kills_totais AS registrado,
       SUM(e.kills)    AS calculado
  FROM Equipe_Partida ep
  JOIN Jogador j
    ON j.equipe_id = ep.equipe_id
  JOIN Estatistica e
    ON e.partida_id = ep.partida_id
   AND e.jogador_id = j.id_jogador
 GROUP BY ep.partida_id, ep.equipe_id, ep.kills_totais
HAVING ep.kills_totais <> SUM(e.kills);

-- 5) Uso_Agente.kills não pode exceder kills totais do jogador na partida
SELECT ua.partida_id,
       ua.jogador_id,
       ua.kills   AS uso_kills,
       est.kills  AS total_kills
  FROM Uso_Agente ua
  JOIN Estatistica est
    ON est.partida_id = ua.partida_id
   AND est.jogador_id = ua.jogador_id
 WHERE ua.kills > est.kills;

-- 6) Nenhum Uso_Agente para jogador que não estava na equipe naquela partida
SELECT ua.partida_id,
       ua.jogador_id
  FROM Uso_Agente ua
  JOIN Jogador j
    ON j.id_jogador = ua.jogador_id
  LEFT JOIN Equipe_Partida ep
    ON ep.partida_id = ua.partida_id
   AND ep.equipe_id = j.equipe_id
 WHERE ep.partida_id IS NULL;

-- 7) Cada partida deve ter temporada preenchida
SELECT COUNT(*) AS sem_temporada
  FROM Partida
 WHERE temporada IS NULL;

-- 8) Modos inválidos em Partida
SELECT DISTINCT modo
  FROM Partida
 WHERE modo NOT IN ('Sem Classificacao', 'Ranqueada', 'Frenetica', 'Mata-Mata');

-- 9) Nenhuma Estatistica de jogador que não estava na equipe daquela partida
SELECT e.partida_id,
       e.jogador_id
  FROM Estatistica e
  JOIN Jogador j
    ON j.id_jogador = e.jogador_id
  LEFT JOIN Equipe_Partida ep
    ON ep.partida_id = e.partida_id
   AND ep.equipe_id = j.equipe_id
 WHERE ep.partida_id IS NULL;

-- 10) Cada Uso_Agente deve ter uma estatística correspondente
SELECT ua.partida_id,
       ua.jogador_id
  FROM Uso_Agente ua
  LEFT JOIN Estatistica e
    ON e.partida_id = ua.partida_id
   AND e.jogador_id = ua.jogador_id
 WHERE e.partida_id IS NULL;
