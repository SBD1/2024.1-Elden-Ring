from Database.Select.constantes import NPCS_NA_AREA
from Classes.jogador import Jogador
from Database.db_connection import print_notices
import psycopg2
from psycopg2 import OperationalError

def npc_foi_derrotado(conn, id_jogador, id_instancia_npc):
    try:
        with conn.cursor() as cur:
            # Verifica se o NPC está na tabela de chefes derrotados
            cur.execute("SELECT 1 FROM chefes_derrotados WHERE id_chefe = (SELECT id_npc FROM instancia_npc WHERE id_instancia = %s) AND id_jogador = %s;", (id_instancia_npc, id_jogador))
            if cur.fetchone():
                return True
            
            # Verifica se o NPC está na tabela de NPCs mortos
            cur.execute("SELECT 1 FROM npc_morto WHERE id_jogador = %s AND id_instancia_npc = %s;", (id_jogador, id_instancia_npc))
            if cur.fetchone():
                return True
            
            return False
    except psycopg2.DatabaseError as e:
        print(f"Erro ao verificar se o NPC foi derrotado: {e}")
        conn.rollback()  # Rollback em caso de erro
        return True
    except psycopg2.Warning as w:
        print(f"Aviso: {w}")
        return True

def npcs_na_area(conn, id_area, id_jogador):
    if conn is None:
        print("Conexão não fornecida.")
        return []

    try:
        with conn.cursor() as cur:
            cur.execute(NPCS_NA_AREA, (id_area, id_jogador, id_jogador))
            npcs = cur.fetchall()
            return npcs
    except Exception as e:
        print(f"Erro ao buscar NPCs na área: {e}")
        conn.rollback()  # Reverte a transação atual se ocorrer um erro
        return []

def realizar_ataque(conn, instancia, alvo, ataque_forte):
    try:
        with conn.cursor() as cur:
            cur.execute("CALL realizar_ataque(%s, %s, %s);", (instancia, alvo, ataque_forte))
            conn.commit()
            print_notices(conn)
    except psycopg2.DatabaseError as e:
        print(f"Erro ao realizar ataque: {e}")
        conn.rollback()  # Rollback em caso de erro
    except psycopg2.Warning as w:
        print(f"Aviso: {w}")