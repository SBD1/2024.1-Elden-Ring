from Database.Select.collect_item import obter_area_jogador, obter_itens_na_area, adicionar_item_inventario
from uteis import clear_screen

def coletar_itens_na_area(conn, id_jogador):
    """
    Permite ao jogador coletar itens na área onde ele está localizado.

    :param conn: Objeto de conexão com o banco de dados.
    :param id_jogador: ID do jogador.
    :return: None
    """
    while True:
        clear_screen()

        # Obter a área do jogador
        id_area = obter_area_jogador(conn, id_jogador)
        if id_area is None:
            print(f"Jogador não encontrado.")
            return

        # Obter os itens na área
        itens = obter_itens_na_area(conn, id_area)
        if not itens:
            print("Não há itens disponíveis nessa área.")
            input("Aperte '0' para voltar ao menu.")
            break

        # Exibir os itens encontrados
        print("Itens encontrados na área:")
        for idx, item in enumerate(itens, start=1):
            print(f"{idx}. Nome: {item[1]}")

        # Permitir que o jogador escolha um item
        escolha = input("Digite o número do item que deseja pegar ou '0' para cancelar: ")
        try:
            escolha = int(escolha)
            if escolha == 0:
                print("Operação cancelada. Voltando ao menu.")
                break

            if escolha < 1 or escolha > len(itens):
                print("Escolha inválida.")
                continue

            id_item_escolhido = itens[escolha - 1][0]

            # Adicionar o item ao inventário do jogador
            adicionar_item_inventario(conn, id_jogador, id_item_escolhido)
            print(f"Item {id_item_escolhido} adicionado ao inventário do jogador.")

        except ValueError:
            print("Entrada inválida. Por favor, digite um número.")