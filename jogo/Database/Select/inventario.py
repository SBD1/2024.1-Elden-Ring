from Database.Select.constantes import INFO_ITENS_JOGADOR

def info_inventario(conn, id_jogador):
    if conn is None:
        return None

    try:
        cur = conn.cursor()
        cur.execute(INFO_ITENS_JOGADOR, (id_jogador,))
        jogador = cur.fetchall()  
        cur.close()
        return jogador
    except Exception as e:
        print(f"Erro ao buscar itens: {e}")
        return None
    
def detalhes_item(conn, id_instancia_item, categoria):
    try:
        cur = conn.cursor()

        if categoria == 'Consumivel':
            query = """
                SELECT 
                    c.descricao, c.efeito, c.qtd_do_efeito 
                FROM 
                    consumivel c
                JOIN 
                    instancia_de_item i ON c.id_consumivel = i.id_item
                WHERE 
                    i.id_instancia_item = %s;
            """
        elif categoria == 'Equipamento':
            # Consulta para determinar o tipo de equipamento
            tipo_query = """
                SELECT 
                    e.tipo::tipo_equipamento
                FROM 
                    equipamento e
                JOIN 
                    instancia_de_item i ON e.id_equipamento = i.id_item
                WHERE 
                    i.id_instancia_item = %s;
            """
            cur.execute(tipo_query, (id_instancia_item,))
            tipo_equipamento = cur.fetchone()
            print(tipo_equipamento)
            if tipo_equipamento:
                tipo_equipamento = tipo_equipamento[0]  
                if tipo_equipamento == 'Escudo':
                    query = """
                        SELECT 
                            eq.tipo, e.req_int, e.req_forca, e.req_fe, e.req_dex, 
                            e.melhoria, e.peso, e.custo_melhoria, e.habilidade, e.defesa
                        FROM 
                            escudo e
                        JOIN 
                            instancia_de_item i ON e.id_escudo = i.id_item
                        JOIN
                            equipamento eq ON eq.id_equipamento = i.id_item
                        WHERE 
                            i.id_instancia_item = %s;
                    """
                elif tipo_equipamento == 'Armadura':
                    print("entrou")
                    query = """
                        SELECT 
                            eq.tipo, a.req_int, a.req_forca, a.req_fe, a.req_dex, 
                            a.melhoria, a.peso, a.custo_melhoria, a.resistencia
                        FROM 
                            armadura a
                        JOIN 
                            instancia_de_item i ON a.id_armadura = i.id_item
                        JOIN 
                            equipamento eq ON eq.id_equipamento = i.id_item
                        WHERE 
                            i.id_instancia_item = %s;
                    """
                elif tipo_equipamento == 'Leve':
                    query = """
                        SELECT 
                            eq.tipo, al.req_int, al.req_forca, al.req_fe, al.req_dex, 
                            al.melhoria, al.peso, al.custo_melhoria, al.habilidade, 
                            al.dano, al.critico, al.destreza
                        FROM 
                            arma_leve al
                        JOIN 
                            instancia_de_item i ON al.id_arma_leve = i.id_item
                        JOIN 
                            equipamento eq ON eq.id_equipamento = i.id_item
                        WHERE 
                            i.id_instancia_item = %s;
                    """
                else:
                    return "Tipo de equipamento desconhecido."

            else:
                return "Tipo de equipamento não encontrado."

        else:
            return "Sem detalhes adicionais para este tipo de item."

        # Executa a consulta apropriada com base no tipo
        cur.execute(query, (id_instancia_item,))
        detalhes = cur.fetchone()
        cur.close()
        return detalhes

    except Exception as e:
        print(f"Erro ao buscar detalhes do item: {e}")
        return None
