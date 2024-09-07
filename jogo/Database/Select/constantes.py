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
        regiao.nome AS regiao_nome,
        jogador.st_atual,
        jogador.hp_atual,
        jogador.runas_atuais
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

NPCS_NA_AREA = """
    SELECT DISTINCT
        instancia_npc.id_instancia, 
        npc.nome AS nome_npc,
        instancia_npc.hp_atual,
        funcao_npc.funcao
    FROM 
        instancia_npc
    JOIN 
        npc ON instancia_npc.id_npc = npc.id_npc
    JOIN 
        funcao_npc ON npc.funcao = funcao_npc.funcao
    WHERE 
        instancia_npc.id_area = %s
        AND instancia_npc.hp_atual > 0 
        AND NOT EXISTS (
            SELECT 1 
            FROM npc_morto 
            WHERE npc_morto.id_instancia_npc = instancia_npc.id_instancia 
            AND npc_morto.id_jogador = %s
        )
        AND NOT EXISTS (
            SELECT 1 
            FROM chefes_derrotados 
            WHERE chefes_derrotados.id_chefe = npc.id_npc 
            AND chefes_derrotados.id_jogador = %s
        );
"""