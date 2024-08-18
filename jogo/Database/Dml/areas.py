def atualizar_area_jogador(conn, id_jogador, id_nova_area):
    try:
        cur = conn.cursor()
        cur.execute(
            """
            UPDATE jogador
            SET id_area = %s
            WHERE id_jogador = %s
            """,
            (id_nova_area, id_jogador)
        )
        conn.commit()  
        if cur.rowcount > 0:
            return True
        else: 
            return False
    except Exception as e:
        print(f"Erro ao atualizar a área do jogador: {e}")
    finally:
        cur.close()
