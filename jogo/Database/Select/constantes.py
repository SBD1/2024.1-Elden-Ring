INFO_JOGADOR = """
    SELECT 
        jogador.id_jogador,
        jogador.nome AS nome_jogador,
        jogador.hp,
        jogador.vigor,
        jogador.vitalidade,
        jogador.intel,
        jogador.fe,
        jogador.destreza,
        jogador.forca,
        jogador.peso_max,
        jogador.stamina,
        jogador.mp,
        jogador.nivel_atual,
        jogador.id_nivel,
        nivel.nro_nivel,
        nivel.runas,
        classe.nome AS classe_nome,
        jogador.id_area,
        area.nome AS area_nome,
        regiao.nome AS regiao_nome
    FROM 
        jogador
    LEFT JOIN 
        nivel ON jogador.id_nivel = nivel.id_nivel
    LEFT JOIN 
        classe ON jogador.id_classe = classe.nome
    LEFT JOIN 
        area ON jogador.id_area = area.id_area
    LEFT JOIN 
        regiao ON area.id_regiao = regiao.id_regiao
    WHERE
        jogador.id_jogador = %s
    """

AREAS_CONECTADAS = """
    SELECT 
        conecta_area.id_origem,
        conecta_area.id_destino,
        area.nome as destino_nome
    from
        conecta_area
    left join
        area on conecta_area.id_destino = area.id_area 
    where 
        id_origem = %s;
    """

INFO_ITENS_JOGADOR = """
    SELECT 
        i.id_instancia_item,
        it.nome AS nome_item,
        it.tipo as tipo_item,
        e.tipo as tipo_equipamento
    FROM 
        instancia_de_item i
    JOIN 
        item it ON i.id_item = it.id_item
    LEFT JOIN 
        consumivel c ON it.id_item = c.id_consumivel
    LEFT JOIN 
        equipamento e ON it.id_item = e.id_equipamento
    JOIN 
        localização_da_instancia_de_item l ON i.id_instancia_item = l.id_instancia_item
    WHERE 
        l.inventario_jogador = %s;
"""

EQUIPADOS_JOGADOR = """
    SELECT
        e.id_jogador,
        COALESCE(i_mao_direita.nome, 'Nenhum') AS mao_direita,
        COALESCE(i_mao_esquerda.nome, 'Nenhum') AS mao_esquerda,
        COALESCE(i_armadura.nome, 'Nenhum') AS armadura,
        eq_mao_direita.id_equipamento AS id_mao_direita,
        eq_mao_esquerda.id_equipamento AS id_mao_esquerda,
        eq_armadura.id_equipamento AS id_armadura
    FROM
        equipados e
    LEFT JOIN
        equipamento eq_mao_direita ON e.mao_direita = eq_mao_direita.id_equipamento
    LEFT JOIN
        equipamento eq_mao_esquerda ON e.mao_esquerda = eq_mao_esquerda.id_equipamento
    LEFT JOIN
        equipamento eq_armadura ON e.armadura = eq_armadura.id_equipamento
    LEFT JOIN
        item i_mao_direita ON eq_mao_direita.id_equipamento = i_mao_direita.id_item
    LEFT JOIN
        item i_mao_esquerda ON eq_mao_esquerda.id_equipamento = i_mao_esquerda.id_item
    LEFT JOIN
        item i_armadura ON eq_armadura.id_equipamento = i_armadura.id_item
    where id_jogador = %s;
 """

ARMADURAS_DO_JOGADOR = """
SELECT 
    i.id_instancia_item,
    it.nome AS nome_item,
    e.tipo as tipo_equipamento,
    a.resistencia, 
    a.req_int, 
    a.req_forca, 
    a.req_fe, 
    a.req_dex,
    e.id_equipamento
FROM 
    instancia_de_item i
JOIN 
    item it ON i.id_item = it.id_item
LEFT JOIN 
    equipamento e ON it.id_item = e.id_equipamento
left join
	armadura a on e.id_equipamento = a.id_armadura
JOIN 
    localização_da_instancia_de_item l ON i.id_instancia_item = l.id_instancia_item
WHERE 
    l.inventario_jogador = %s and e.tipo = 'Armadura';
"""

EQUIPAMENTO_ARMA = """
SELECT 
    i.id_instancia_item,
    it.nome AS nome_item,
    e.tipo AS tipo_equipamento,
    COALESCE(al.req_int, ap.req_int, ca.req_int, se.req_int) AS req_int,
    COALESCE(al.req_forca, ap.req_forca, ca.req_forca, se.req_forca) AS req_forca,
    COALESCE(al.req_fe, ap.req_fe, ca.req_fe, se.req_fe) AS req_fe,
    COALESCE(al.req_dex, ap.req_dex, ca.req_dex, se.req_dex) AS req_dex,
    COALESCE(al.dano, ap.dano, ca.dano, se.dano) AS atributo_primario,
    COALESCE(al.habilidade, ap.habilidade, ca.habilidade, se.habilidade) AS habilidade,
    e.id_equipamento
FROM 
    instancia_de_item i
JOIN 
    item it ON i.id_item = it.id_item
LEFT JOIN 
    equipamento e ON it.id_item = e.id_equipamento
LEFT JOIN 
    arma_leve al ON e.id_equipamento = al.id_arma_leve
LEFT JOIN 
    arma_pesada ap ON e.id_equipamento = ap.id_arma_pesada
LEFT JOIN 
    cajado ca ON e.id_equipamento = ca.id_cajado
LEFT JOIN 
    selo se ON e.id_equipamento = se.id_selo
JOIN 
    localização_da_instancia_de_item l ON i.id_instancia_item = l.id_instancia_item
WHERE 
    l.inventario_jogador = %s
    AND e.tipo IN ('Leve', 'Pesada', 'Cajado', 'Selo');
"""

EQUIPAMENTO_ESCUDO = """
SELECT 
    i.id_instancia_item,
    it.nome AS nome_item,
    e.tipo AS tipo_equipamento,
    es.req_int AS req_int,
    es.req_forca AS req_forca,
    es.req_fe AS req_fe,
    es.req_dex AS req_dex,
    es.defesa AS atributo_primario,
    es.habilidade AS habilidade,
    e.id_equipamento
FROM 
    instancia_de_item i
JOIN 
    item it ON i.id_item = it.id_item
LEFT JOIN 
    equipamento e ON it.id_item = e.id_equipamento
LEFT JOIN 
    escudo es ON e.id_equipamento = es.id_escudo
JOIN 
    localização_da_instancia_de_item l ON i.id_instancia_item = l.id_instancia_item
WHERE 
    l.inventario_jogador = %s AND e.tipo = 'Escudo';
"""

