from Database.Select.constantes import NPCS_NA_AREA

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