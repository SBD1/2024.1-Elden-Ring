from uteis import clear_screen
from Database.Select.equipados import equipaveis, info_equipados

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
                    listar_equipaveis(conn, id_jogador, 'Armadura', equipados)
                    print("Opção 'Armadura' selecionada.")
                elif opcao == 2 or opcao == 3:
                    listar_equipaveis(conn, id_jogador, 'Mao', equipados)
                    print("Opção 'Mão' selecionada.")
                else:
                    print("Opção inválida.")
            except ValueError:
                print("Por favor, insira um número válido.")

# listar possiveis equipamentos
def listar_equipaveis(conn, id_jogador, tipo_equipamento, equipados):
    while True:
        # clear_screen()
        listar_equipaveis = equipaveis(conn, id_jogador, tipo_equipamento)
        if tipo_equipamento == 'Armadura':
            for i, itens in enumerate(listar_equipaveis, start=1):
                print(f"{i}. {itens[1]} "
                    f"{f'(Resistência = {itens[3]}) ' if itens[3] else ''}"
                    f"Requisitos: INT: {itens[4]}, FORÇA: {itens[5]}, FÉ: {itens[6]}, DEX: {itens[7]}")
                if itens[8] == equipados[6]: print(" Equipado")
        elif tipo_equipamento == 'Mao':
            for i, itens in enumerate(listar_equipaveis, start=1):
                if itens[2] == 'Escudo':
                    print(f"{i}. {itens[1]} "
                        f"{f'(Defesa = {itens[7]}) ' if itens[3] else ''}"
                        f"Requisitos: INT: {itens[3]}, FORÇA: {itens[4]}, FÉ: {itens[5]}, DEX: {itens[6]}")
                    if itens[9] == equipados[4]: print("Equ - D")
                    if itens[9] == equipados[5]: print("Equ - E")
                else:
                    print(f"{i}. {itens[1]} "
                        f"{f'(Dano = {itens[7]}) ' if itens[7] else ''}"  
                        f"Requisitos: INT: {itens[3]}, FORÇA: {itens[4]}, FÉ: {itens[5]}, DEX: {itens[6]} "
                        f"(Habilidade Dano = {itens[8]})"
                        f"{' Equipado - D' if itens[9] == equipados[4] else ''}"  
                        f"{' Equipado - E' if itens[9] == equipados[5] else ''}")  
        else:
            print("Tipo de equipamento inválido.")

        print("0. Voltar")
        opcao = input("Digite o número para equipar: ")
        
        if opcao == "0":
            break
        else:
            try:
                opcao = int(opcao)
                if 1 <= opcao <= len(listar_equipaveis):
                    equipamento_selecionado = listar_equipaveis[opcao - 1]
                    # atualizar_equipamento(conn, equipamento_selecionado) 
                else:
                    print("Opção inválida.")
            except ValueError:
                print("Por favor, insira um número válido.")

# atualizar equipamentos