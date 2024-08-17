-- Aqui em select nós que possivelmente vamos usar dentro do jogo.

-- Item
SELECT * FROM item WHERE id_item = %var%;
-- Instancia de Item
SELECT * FROM instancia_de_item WHERE id_item = %var%;
-- Equipados
SELECT * FROM equipados WHERE id_jogador = %id_jogador%;

-- Informações de arma_leve
SELECT 
    al.id_arma_leve,
    al.habilidade,
    al.dano,
    al.critico,
    al.requisitos,
    al.melhoria,
    al.peso,
    al.custo_melhoria,
    al.destreza,
    e.tipo as tipo_equipamento,
    i.eh_chave,
    i.raridade,
    i.nome as nome_arma,
    i.valor,
    i.tipo as tipo_item
FROM 
    arma_leve al
JOIN 
    equipamento e ON al.id_equipamento = e.id_equipamento
JOIN 
    item i ON e.id_item = i.id_item;

-- Informações do escudo
SELECT 
    s.id_escudo,
    s.habilidade,
    s.requisitos,
    s.defesa,
    s.melhoria,
    s.peso,
    s.custo_melhoria,
    i.eh_chave,
    i.raridade,
    i.nome AS nome_item,
    i.valor,
    i.tipo AS tipo_item,
    e.id_item AS id_item_equipamento
FROM 
    escudo s
JOIN 
    equipamento e ON s.id_equipamento = e.id_equipamento
JOIN 
    item i ON e.id_item = i.id_item;
   
-- Acessando itens do jogador
SELECT 
    i.id_instancia_item,
    it.nome AS nome_item
FROM 
    instancia_de_item i
JOIN 
    item it ON i.id_item = it.id_item
JOIN 
    localização_da_instancia_de_item l ON i.id_instancia_item = l.id_instancia_item
WHERE 
    l.inventario_jogador = %ID_DO_JOGADOR%;
   
   
-- Acessando itens da area
SELECT 
    i.id_instancia_item,
    it.nome AS nome_item
FROM 
    instancia_de_item i
JOIN 
    item it ON i.id_item = it.id_item
JOIN 
    localização_da_instancia_de_item l ON i.id_instancia_item = l.id_instancia_item
WHERE 
    l.area = %ID_DA_AREA%;
   

