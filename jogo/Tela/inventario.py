from uteis import clear_screen
from Database.Select.inventario import detalhes_item, info_inventario

def inventario(conn, id_jogador):
    while True:
        clear_screen()
        listar_itens = info_inventario(conn, id_jogador)
        
        for i, itens in enumerate(listar_itens, start=1):
          print(f"{i}. {itens[1]} ({itens[2] if itens[2] else 'N/A'}{f' - {itens[3]}' if itens[3] else ''})")
        
        print("0. Voltar ao menu")
        opcao = input("Digite o número de um item para ver detalhes: ")
        
        if opcao == "0":
            break
        else:
            try:
                opcao = int(opcao)
                if 1 <= opcao <= len(listar_itens):
                    item_selecionado = listar_itens[opcao - 1]
                    exibir_detalhes_item(conn, item_selecionado) 
                else:
                    print("Opção inválida.")
            except ValueError:
                print("Por favor, insira um número válido.")


def exibir_detalhes_item(conn, item_selecionado):
    # Acessando os elementos da tupla usando índices numéricos
    id_instancia_item = item_selecionado[0]  
    tipo_item = item_selecionado[2]          

    # Pega os detalhes do item
    detalhes = detalhes_item(conn, id_instancia_item, tipo_item)
    # print(detalhes)
    if detalhes is None:
        print("Nenhum detalhe encontrado para este item.")
    elif tipo_item == 'Consumivel':
        print(f"Item: {item_selecionado[1]}")  
        print(f"Descrição: {detalhes[0]}")
        print(f"Efeito: {detalhes[1]}")
        print(f"Quantidade de Efeito: {detalhes[2]}")
    elif tipo_item == 'Equipamento':
        tipo_equipamento = detalhes[0]  # Pegando o tipo de equipamento do resultado do banco
        # print(f"testeeeee: {tipo_equipamento}")
        if tipo_equipamento == 'Escudo':
            print(f"Escudo: {item_selecionado[1]}")
            print(f"Requisitos: INT: {detalhes[1]}, FORÇA: {detalhes[2]}, FÉ: {detalhes[3]}, DEX: {detalhes[4]}")
            print(f"Melhoria: {detalhes[5]}")
            print(f"Peso: {detalhes[6]}")
            print(f"Custo de Melhoria: {detalhes[7]}")
            print(f"Habilidade: {detalhes[8]}")
            print(f"Defesa: {detalhes[9]}")
        elif tipo_equipamento == 'Armadura':
            print(f"Armadura: {item_selecionado[1]}")
            print(f"Requisitos: INT: {detalhes[1]}, FORÇA: {detalhes[2]}, FÉ: {detalhes[3]}, DEX: {detalhes[4]}")
            print(f"Melhoria: {detalhes[5]}")
            print(f"Peso: {detalhes[6]}")
            print(f"Custo de Melhoria: {detalhes[7]}")
            print(f"Resistência: {detalhes[8]}")
        elif tipo_equipamento == 'Leve':
            print(f"Arma Leve: {item_selecionado[1]}")
            print(f"Requisitos: INT: {detalhes[1]}, FORÇA: {detalhes[2]}, FÉ: {detalhes[3]}, DEX: {detalhes[4]}")
            print(f"Melhoria: {detalhes[5]}")
            print(f"Peso: {detalhes[6]}")
            print(f"Custo de Melhoria: {detalhes[7]}")
            print(f"Habilidade: {detalhes[8]}")
            print(f"Dano: {detalhes[9]}")
            print(f"Crítico: {detalhes[10]}")
            print(f"Proficiência Destreza: {detalhes[11]}")
        elif tipo_equipamento == 'Pesada':
            print(f"Arma Pesada: {item_selecionado[1]}")
            print(f"Requisitos: INT: {detalhes[1]}, FORÇA: {detalhes[2]}, FÉ: {detalhes[3]}, DEX: {detalhes[4]}")
            print(f"Melhoria: {detalhes[5]}")
            print(f"Peso: {detalhes[6]}")
            print(f"Custo de Melhoria: {detalhes[7]}")
            print(f"Habilidade: {detalhes[8]}")
            print(f"Dano: {detalhes[9]}")
            print(f"Crítico: {detalhes[10]}")
            print(f"Proficiência Força: {detalhes[11]}")
        elif tipo_equipamento == 'Cajado':
            print(f"Cajado: {item_selecionado[1]}")
            print(f"Requisitos: INT: {detalhes[1]}, FORÇA: {detalhes[2]}, FÉ: {detalhes[3]}, DEX: {detalhes[4]}")
            print(f"Melhoria: {detalhes[5]}")
            print(f"Peso: {detalhes[6]}")
            print(f"Custo de Melhoria: {detalhes[7]}")
            print(f"Habilidade: {detalhes[8]}")
            print(f"Dano: {detalhes[9]}")
            print(f"Crítico: {detalhes[10]}")
            print(f"Proficiência Inteligencia: {detalhes[11]}")
        elif tipo_equipamento == 'Selo':
            print(f"Selo: {item_selecionado[1]}")
            print(f"Requisitos: INT: {detalhes[1]}, FORÇA: {detalhes[2]}, FÉ: {detalhes[3]}, DEX: {detalhes[4]}")
            print(f"Melhoria: {detalhes[5]}")
            print(f"Peso: {detalhes[6]}")
            print(f"Custo de Melhoria: {detalhes[7]}")
            print(f"Habilidade: {detalhes[8]}")
            print(f"Dano: {detalhes[9]}")
            print(f"Crítico: {detalhes[10]}")
            print(f"Proficiência Milagre: {detalhes[11]}")
        else:
            print(f"Equipamento: {item_selecionado[1]}")
            print("Detalhes específicos não foram encontrados para este tipo de equipamento.")
    else:
        print(f"Item: {item_selecionado[1]}")
        print("Nenhum detalhe adicional disponível.")

    input("Pressione Enter para continuar...")

