

def atualizar_equipamento(conn, jogador_id, onde, id_item):
    try:
        cur = conn.cursor()
        if onde == "MaoD":
            query_mao_direita = "UPDATE equipados SET mao_direita = %s WHERE id_jogador = %s"
            cur.execute(query_mao_direita, (id_item, jogador_id))
        
        if onde == "MaoE":
            query_mao_esquerda = "UPDATE equipados SET mao_esquerda = %s WHERE id_jogador = %s"
            cur.execute(query_mao_esquerda, (id_item, jogador_id))
        
        if onde == "Armadura":
            query_armadura = "UPDATE equipados SET armadura = %s WHERE id_jogador = %s"
            cur.execute(query_armadura, (id_item, jogador_id))
        
        # Confirmar as alterações
        conn.commit()
        if cur.rowcount > 0:
            return True
        else: 
            return False
    except Exception as e:
        print(f"Erro ao atualizar equipamento do jogador: {e}")
    finally:
        cur.close()  