from uteis import clear_screen
from Database.Select.equipados import info_equipados

def equipados(conn, id_jogador):
    while True:
        clear_screen()
        equipados = info_equipados(conn, id_jogador)

        print(f'1. Armadura: {equipados[3]}')
        print(f'2. Mão direita: {equipados[1]}')
        print(f'3. Mão esquerda: {equipados[2]}')
        print("0. Voltar ao menu")
        opcao = input("Digite o número de um equipamento para muda-lo: ")
        
        if opcao == "0":
            break
        else:
            try:
                opcao = int(opcao)
                if opcao == 1:
                    print("Opção 'Armadura' selecionada.")
                elif opcao == 2:
                    print("Opção 'Mão direita' selecionada.")
                elif opcao == 3:
                    print("Opção 'Mão esquerda' selecionada.")
                else:
                    print("Opção inválida.")
            except ValueError:
                print("Por favor, insira um número válido.")