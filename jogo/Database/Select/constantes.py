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
        CASE
            WHEN c.id_consumivel IS NOT NULL THEN 'consumivel'
            WHEN e.id_equipamento IS NOT NULL THEN 'equipamento'
            ELSE 'outro'
        END AS categoria_item
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
