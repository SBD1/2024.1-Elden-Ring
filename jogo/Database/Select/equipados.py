
from Database.Select.constantes import EQUIPADOS_JOGADOR

def info_equipados(conn, id_jogador):
    if conn is None:
        return None

    try:
        cur = conn.cursor()
        cur.execute(EQUIPADOS_JOGADOR, (id_jogador,))
        jogador = cur.fetchone()  
        cur.close()
        return jogador
    except Exception as e:
        print(f"Erro ao buscar equipados: {e}")
        return None