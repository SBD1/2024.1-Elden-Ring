from Database.Dml.equipados import atualizar_equipamento
from Database.Select.jogador import info_jogador
from Classes.jogador import Jogador
from uteis import clear_screen
from Database.Select.equipados import equipaveis, info_equipados

def equipados(conn, id_jogador):
    while True:
        clear_screen()
        equipados = info_equipados(conn, id_jogador)

        if equipados is None:
            armadura = "Nenhuma"
            mao_direita = "Nenhuma"
            mao_esquerda = "Nenhuma"
        else:
            armadura = equipados[3] if len(equipados) > 3 and equipados[3] else "Nenhuma"
            mao_direita = equipados[1] if len(equipados) > 1 and equipados[1] else "Nenhuma"
            mao_esquerda = equipados[2] if len(equipados) > 2 and equipados[2] else "Nenhuma"

        print(f'1. Armadura: {armadura}')
        print(f'2. Mão direita: {mao_direita}')
        print(f'3. Mão esquerda: {mao_esquerda}')
        print("0. Voltar ao menu")

        opcao = input("Digite o número de um equipamento para mudá-lo: ")

        if opcao == "0":
            break
        else:
            try:
                opcao = int(opcao)
                if opcao == 1:
                    listar_equipaveis(conn, id_jogador, 'Armadura', equipados)
                elif opcao == 2:
                    listar_equipaveis(conn, id_jogador, 'MaoD', equipados)
                elif opcao == 3:
                    listar_equipaveis(conn, id_jogador, 'MaoE', equipados)
                else:
                    print("Opção inválida.")
            except ValueError:
                print("Por favor, insira um número válido.")

# listar possiveis equipamentos
def listar_equipaveis(conn, id_jogador, tipo_equipamento, equipados):
    while True:
        # clear_screen()
        jogador_info = info_jogador(conn, id_jogador)
        if jogador_info:
            jogador = Jogador.from_data_base(jogador_info)

        print(f"---------------------------------")
        print(f"Seus atributos: Inteligencia: {jogador.intel} Força: {jogador.forca} Fé: {jogador.fe} Destreza: {jogador.destreza}")
        listar_equipaveis = equipaveis(conn, id_jogador, tipo_equipamento)
        if tipo_equipamento == 'Armadura':
            for i, itens in enumerate(listar_equipaveis, start=1):
                print(f"{i}. {itens[1]} "
                    f"{f'(Resistência = {itens[3]}) ' if itens[3] else ''}"
                    f"Requisitos: INT: {itens[4]}, FORÇA: {itens[5]}, FÉ: {itens[6]}, DEX: {itens[7]}"
                    f"{' --Equipado--' if itens[8] == equipados[6] else ''}")
        elif tipo_equipamento == 'MaoE':
            for i, itens in enumerate(listar_equipaveis, start=1):
                print(f"{i}. {itens[1]} "
                    f"{f'(Defesa = {itens[7]}) ' if itens[3] else ''}"
                    f"Requisitos: INT: {itens[3]}, FORÇA: {itens[4]}, FÉ: {itens[5]}, DEX: {itens[6]}"
                    f"{' --Equipado--' if itens[9] == equipados[5] else ''}")
        elif tipo_equipamento == 'MaoD':
            for i, itens in enumerate(listar_equipaveis, start=1):
                print(f"{i}. {itens[1]} "
                    f"{f'(Dano = {itens[7]}) ' if itens[7] else ''}"  
                    f"Requisitos: INT: {itens[3]}, FORÇA: {itens[4]}, FÉ: {itens[5]}, DEX: {itens[6]} "
                    f"(Habilidade Dano = {itens[8]})"
                    f"{' --Equipado--' if itens[9] == equipados[4] else ''}")
        else:
            print("Tipo de equipamento inválido.")

        print("0. Voltar")
        opcao = input("Digite o número para equipar: ")
        
        if opcao == "0":
            break
        else:
            if verifica_se_pode_usar(jogador, opcao, listar_equipaveis, tipo_equipamento): 
                if atualiza_equipamento(conn, id_jogador, tipo_equipamento, opcao, listar_equipaveis): break
            else: print("Você não pode usar esse equipamento. Verifique se você atende aos requisitos.")

def atualiza_equipamento(conn, id_jogador, tipo_equipamento, opcao, listar_equipaveis):
    try:
        opcao = int(opcao)
        if 1 <= opcao <= len(listar_equipaveis):
            equipamento_selecionado = listar_equipaveis[opcao - 1]  
            if tipo_equipamento == "Armadura": id_equipamento = equipamento_selecionado[8]
            else: id_equipamento = equipamento_selecionado[9]

            if atualizar_equipamento(conn, id_jogador, tipo_equipamento, id_equipamento):
                print("Equipamento atualizado com sucesso.")
                input("Precione qualquer tecla para continuar ...")
                return True  
            else:
                print("Falha ao atualizar equipamento.")
        else:
            print("Opção inválida.")
    except ValueError:
        print("Por favor, insira um número válido.")

def verifica_se_pode_usar(jogador, opcao, listar_equipaveis, tipo_equipamento):
    try:
        opcao = int(opcao)
        if 1 <= opcao <= len(listar_equipaveis):
            equipamento_selecionado = listar_equipaveis[opcao - 1]
            if tipo_equipamento == "Armadura" and (jogador.intel >= equipamento_selecionado[4] and jogador.forca >= equipamento_selecionado[5] and jogador.fe >= equipamento_selecionado[6] and jogador.destreza >= equipamento_selecionado[7]):
                return True
            elif tipo_equipamento != "Armadura" and (jogador.intel >= equipamento_selecionado[3] and jogador.forca >= equipamento_selecionado[4] and jogador.fe >= equipamento_selecionado[5] and jogador.destreza >= equipamento_selecionado[6]):
                return True
            else:    
                return False
        else:
            print("Opção inválida.")
    except ValueError:
        print("Por favor, insira um número válido.")
    return False