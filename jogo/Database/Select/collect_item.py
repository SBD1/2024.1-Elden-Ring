def obter_area_jogador(conn, id_jogador):
    """
    Obtém o ID da área onde o jogador está localizado.

    :param conn: Objeto de conexão com o banco de dados.
    :param id_jogador: ID do jogador.
    :return: ID da área ou None se o jogador não for encontrado.
    """
    query = """
    SELECT id_area
    FROM jogador
    WHERE id_jogador = %s;
    """
    
    try:
        with conn.cursor() as cursor:
            cursor.execute(query, (id_jogador,))
            resultado_area = cursor.fetchone()
            return resultado_area[0] if resultado_area else None
    except Exception as e:
        print(f"Erro ao obter a área do jogador: {e}")
        return None


def obter_itens_na_area(conn, id_area):
    """
    Obtém todos os itens localizados em uma área específica.

    :param conn: Objeto de conexão com o banco de dados.
    :param id_area: ID da área.
    :return: Lista de itens ou None se ocorrer um erro ou não houver itens.
    """
    query = """
    SELECT 
        i.id_item,
        i.nome,
        i.valor,
        i.tipo
    FROM 
        localizacao_da_instancia_de_item l
    JOIN 
        instancia_de_item ii ON l.id_instancia_item = ii.id_instancia_item
    JOIN 
        item i ON ii.id_item = i.id_item
    WHERE 
        l.area = %s;
    """
    
    try:
        with conn.cursor() as cursor:
            cursor.execute(query, (id_area,))
            resultados = cursor.fetchall()
            return resultados if resultados else None
    except Exception as e:
        print(f"Erro ao obter itens na área: {e}")
        return None


def adicionar_item_inventario(conn, id_jogador, id_item):
    """
    Adiciona um item ao inventário do jogador e remove o item da área.

    :param conn: Objeto de conexão com o banco de dados.
    :param id_jogador: ID do jogador.
    :param id_item: ID do item a ser adicionado ao inventário.
    :return: None
    """
    query = """
    UPDATE localizacao_da_instancia_de_item
    SET inventario_jogador = %s, area = NULL
    WHERE id_instancia_item = (
        SELECT l.id_instancia_item
        FROM localizacao_da_instancia_de_item l
        JOIN instancia_de_item ii ON l.id_instancia_item = ii.id_instancia_item
        WHERE ii.id_item = %s AND l.area = (
            SELECT id_area
            FROM jogador
            WHERE id_jogador = %s
        )
        LIMIT 1
    );
    """
    
    try:
        with conn.cursor() as cursor:
            cursor.execute(query, (id_jogador, id_item, id_jogador))
            conn.commit()
    except Exception as e:
        print(f"Erro ao adicionar item ao inventário do jogador: {e}")
