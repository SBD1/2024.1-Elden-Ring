from Database.Select.constantes import INFO_JOGADOR

def listar_jogadores(conn):
    if conn is None:
        return []

    try:
        cur = conn.cursor()
        cur.execute("SELECT id_jogador, nome FROM jogador") 
        jogadores = cur.fetchall()
        cur.close()
        return jogadores
    except Exception as e:
        print(f"Erro ao buscar jogadores: {e}")
        return []

def info_jogador(conn, id_jogador):
    if conn is None:
        return None

    try:
        cur = conn.cursor()
        cur.execute(INFO_JOGADOR, (id_jogador,)) 
        jogador = cur.fetchone()
        cur.close()
        return jogador
    except Exception as e:
        print(f"Erro ao buscar jogador: {e}")
        return None