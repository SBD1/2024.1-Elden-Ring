def add_jogador(conn, nome, hp, id_nivel, id_classe, id_area, vigor, vitalidade, intel,
                fe, destreza, forca, peso_max, stamina, mp, nivel_atual, runas):
    with conn.cursor() as cursor:
        cursor.execute("""
            SELECT add_jogador(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (nome, hp, id_nivel, id_classe, id_area, vigor, vitalidade, intel, fe, destreza, forca, peso_max, stamina, mp, nivel_atual, runas))
        result = cursor.fetchone()
        conn.commit()
        return result[0]