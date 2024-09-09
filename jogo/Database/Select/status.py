def atributos_jogador(conn, id_jogador):
    """
    Retorna todos os atributos de um jogador específico.
    
    Args:
        conn: Conexão com o banco de dados.
        id_jogador: ID do jogador cujos atributos devem ser retornados.
    
    Returns:
        Um dicionário contendo todos os atributos do jogador ou None se ocorrer um erro.
    """
    if conn is None:
        return None

    try:
        cur = conn.cursor()

        # Selecionando todos os atributos do jogador
        cur.execute("SELECT * FROM jogador WHERE id_jogador = %s", (id_jogador,))
        jogador_data = cur.fetchone()

        # Verificando se o jogador foi encontrado
        if jogador_data is None:
            print(f"Jogador com id {id_jogador} não encontrado.")
            return None

        # Pegando os nomes das colunas da tabela
        colnames = [desc[0] for desc in cur.description]

        # Fechando o cursor
        cur.close()

        # Retornando um dicio
        jogador_atributos = dict(zip(colnames, jogador_data))

        return jogador_atributos

    except Exception as e:
        print(f"Erro ao buscar atributos do jogador: {e}")
        return None


def obter_dano_arma_mao_direita(conn, id_jogador):
    """
    Obtém o dano da arma equipada na mão direita do jogador.

    :param conn: Objeto de conexão com o banco de dados.
    :param id_jogador: ID do jogador.
    :return: Dano da arma equipada na mão direita.
    """
    query = """
    SELECT 
        COALESCE(arma_dano.dano, 0) AS dano_arma_mao_direita
    FROM 
        equipados AS e
    LEFT JOIN 
        arma_pesada AS ap ON e.mao_direita = ap.id_arma_pesada
    LEFT JOIN 
        arma_leve AS al ON e.mao_direita = al.id_arma_leve
    LEFT JOIN 
        cajado AS c ON e.mao_direita = c.id_cajado
    LEFT JOIN 
        selo AS s ON e.mao_direita = s.id_selo
    LEFT JOIN 
        (SELECT id_arma_pesada AS id_arma, dano FROM arma_pesada
         UNION ALL
         SELECT id_arma_leve AS id_arma, dano FROM arma_leve
         UNION ALL
         SELECT id_cajado AS id_arma, dano FROM cajado
         UNION ALL
         SELECT id_selo AS id_arma, dano FROM selo) AS arma_dano
    ON e.mao_direita = arma_dano.id_arma
    WHERE 
        e.id_jogador = %s;
    """
    
    try:
        with conn.cursor() as cursor:
            cursor.execute(query, (id_jogador,))
            resultado = cursor.fetchone()
            if resultado:
                return resultado[0]
            else:
                return 0
    except Exception as e:
        print(f"Erro ao obter dano da arma: {e}")
        return 

def obter_defesa_escudo_mao_esquerda(conn, id_jogador):
    """
    Obtém a defesa do escudo equipado na mão esquerda do jogador.

    :param conn: Objeto de conexão com o banco de dados.
    :param id_jogador: ID do jogador.
    :return: Defesa do escudo equipado na mão esquerda.
    """
    query = """
    SELECT 
        COALESCE(es.defesa, 0) AS defesa_escudo_mao_esquerda
    FROM 
        equipados AS e
    LEFT JOIN 
        escudo AS es ON e.mao_esquerda = es.id_escudo
    WHERE 
        e.id_jogador = %s;
    """
    
    try:
        with conn.cursor() as cursor:
            cursor.execute(query, (id_jogador,))
            resultado = cursor.fetchone()
            if resultado:
                return resultado[0]
            else:
                return 0
    except Exception as e:
        print(f"Erro ao obter defesa do escudo: {e}")
        return 0
    
def obter_resistencia_armadura(conn, id_jogador):
    """
    Obtém a resistência da armadura equipada pelo jogador.

    :param conn: Objeto de conexão com o banco de dados.
    :param id_jogador: ID do jogador.
    :return: Resistência da armadura equipada.
    """
    query = """
    SELECT 
        COALESCE(a.resistencia, 0) AS resistencia_armadura
    FROM 
        equipados AS e
    LEFT JOIN 
        armadura AS a ON e.armadura = a.id_armadura
    WHERE 
        e.id_jogador = %s;
    """
    
    try:
        with conn.cursor() as cursor:
            cursor.execute(query, (id_jogador,))
            resultado = cursor.fetchone()
            if resultado:
                return resultado[0]
            else:
                return 0
    except Exception as e:
        print(f"Erro ao obter resistência da armadura: {e}")
        return 0
