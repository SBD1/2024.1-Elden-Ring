
from Database.Select.constantes import ARMADURAS_DO_JOGADOR, EQUIPADOS_JOGADOR, EQUIPAMENTO_ARMA, EQUIPAMENTO_ESCUDO

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

def equipaveis(conn, id_jogador, tipo_equipamento):
    if conn is None:
        return None

    try:
        cur = conn.cursor()

        if tipo_equipamento == 'Armadura':
            query = ARMADURAS_DO_JOGADOR;
        elif tipo_equipamento == 'MaoD': 
            query = EQUIPAMENTO_ARMA;
        elif tipo_equipamento == 'MaoE':
            query = EQUIPAMENTO_ESCUDO;
        else:
            query = None


        cur.execute(query, (id_jogador,))
        jogador = cur.fetchall()  
        cur.close()
        return jogador
    except Exception as e:
        print(f"Erro ao buscar equipados: {e}")
        return None