from Database.Select.constantes import INFO_JOGADOR
import psycopg2
from psycopg2 import OperationalError
from Database.db_connection import print_notices
from Classes.jogador import Jogador

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

def atualizar_stamina(conn, jogador: Jogador, valor):
    try:
        # Atualiza a stamina do jogador no banco de dados
        nova_stamina = jogador.st_atual + valor
        with conn.cursor() as cur:
            cur.execute("UPDATE jogador SET st_atual = %s WHERE id_jogador = %s;", (nova_stamina, jogador.id_jogador))
            conn.commit()
            print_notices(conn)
        jogador.st_atual = nova_stamina
    except psycopg2.DatabaseError as e:
        print(f"Erro ao atualizar a stamina: {e}")
        conn.rollback()  # Rollback em caso de erro
    except psycopg2.Warning as w:
        print(f"Aviso: {w}")

def ataca_com_equipamento(conn, id_jogador, id_instancia_npc, id_equipamento, tipo_ataque):
    try:
        with conn.cursor() as cur:
            tipo_ataque = True if tipo_ataque else False
            cur.execute("CALL ATACA_COM_EQUIPAMENTO_NPC(%s, %s, %s, %s);", (id_jogador, id_instancia_npc, id_equipamento, tipo_ataque))
            conn.commit()
            print_notices(conn)
    except psycopg2.DatabaseError as e:
        print(f"Erro ao atacar com equipamento: {e}")
        conn.rollback()  # Rollback em caso de erro
    except psycopg2.Warning as w:
        print(f"Aviso: {w}")
    
def classes_disponiveis(conn): 
    if conn is None:
        return []

    try:
        cur = conn.cursor()
        cur.execute("SELECT * FROM classe") 
        classes = cur.fetchall()
        cur.close()
        return classes
    except Exception as e:
        print(f"Erro ao buscar classes: {e}")
        return []
