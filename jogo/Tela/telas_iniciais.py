from uteis import clear_screen
import psycopg2
from psycopg2 import OperationalError
from Database.Select.jogador import info_jogador
from Classes.jogador import Jogador
from Tela.andar import Andar
from Tela.combate import iniciar_combate

def escolher_jogador(characters):
    if not characters:
        print("Nenhum personagem encontrado.")
        return

    print("Selecione um personagem:")
    for index, (id, nome) in enumerate(characters):
        print(f"{index + 1}. {nome}")

def selecionar_acao(conn, jogador_selecionado):
    while True:
        clear_screen()
        jogador_info = info_jogador(conn, jogador_selecionado[0])
        if jogador_info:
            jogador = Jogador.from_data_base(jogador_info)

        print(f"Você está com o personagem: {jogador.nome_jogador}")  
        print(f"Localização: {jogador.area_nome} ({jogador.regiao_nome})")  
        print("1. Menu")
        print("2. Andar")
        print("3. Iniciar Combate")
        print("4. Descansar")
        print("0. Voltar a seleção de personagem")
        opcao = input("Digite a ação desejada:")

        if opcao == '1':
            print("Opção 'Menu' selecionada.")
            menu(conn, jogador)
        elif opcao == '2':
            print("Opção 'Andar' selecionada.")
            Andar(conn, jogador.id_jogador, jogador.id_area)
        elif opcao == '3':
            print("Opção 'Iniciar Combate' selecionada.")
            iniciar_combate(conn, jogador)
        elif opcao == '4':
            print("Você descansou. Seus pontos de vida foram recuperados e seus Frascos de Lágrimas Carmesins foram restaurados.")
            cur = conn.cursor()
            cur.execute("UPDATE jogador SET hp_atual = hp WHERE id_jogador = %s;", (jogador.id_jogador,))
            print("Todos os inimigos comuns derrotados surgiram novamente.")
            cur.execute("DELETE FROM npc_morto WHERE id_jogador = %s;", (jogador.id_jogador,))
            
            conn.commit()
            cur.close()
            input("Pressione qualquer tecla para continuar...")

        elif opcao == '0':
            break  # Volta à seleção de personagem
        else:
            print("Opção inválida. Tente novamente.")

def menu(conn, jogador):
    while True:
        clear_screen()
        print(f"Personagem: {jogador.nome_jogador}")  
        print(f"Localização: {jogador.area_nome} ({jogador.regiao_nome})")   
        print("1. Inventario")
        print("2. Status")
        print("0. Voltar as opções de ação")
        opcao = input("Digite à ação desejada:")

        if opcao == '1':
            print("Opção 'Inventario' selecionada.")
        elif opcao == '2':
            print("Opção 'Status' selecionada.")
        elif opcao == '0':
            break  # Volta à selecionar ação
        else:
            print("Opção inválida. Tente novamente.")