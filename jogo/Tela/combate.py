import random
from uteis import clear_screen
from Database.Select.instancia_npc import npcs_na_area, npc_foi_derrotado, realizar_ataque
from Database.Select.jogador import atualizar_stamina, ataca_com_equipamento
from Classes.jogador import Jogador
from Database.Select.jogador import info_jogador
from Database.db_connection import print_notices

def iniciar_combate(conn, jogador: Jogador):
    while True:
        clear_screen()
        
        # Atualiza as informações do jogador do banco de dados
        jogador_atualizado = info_jogador(conn, jogador.id_jogador)
        if jogador_atualizado:
            jogador = Jogador.from_data_base(jogador_atualizado)
        else:
            print("Erro ao atualizar informações do jogador.")
            break
        cur = conn.cursor()
        cur.execute("SELECT mao_direita FROM equipados WHERE id_jogador = %s;", (jogador.id_jogador,))
        id_arma = cur.fetchone()

        if id_arma is None or id_arma[0] is None:
            input("Você não pode lutar sem uma arma equipada na mão direita.")
            cur.close()
            break
        
        print("------------------")
        print(f"HP Atual: {jogador.hp_atual}")
        print(f"Stamina Atual: {jogador.st_atual}")
        print("------------------")
        
        npcs_disponiveis = npcs_na_area(conn, jogador.id_area, jogador.id_jogador)
        
        if not npcs_disponiveis:
            print("Não há inimigos ou chefes disponíveis para combate nesta área.")
        else:
            print("Inimigos encontrados na área:")
            for idx, (id_instancia, nome_npc, hp_atual, funcao) in enumerate(npcs_disponiveis, 1):
                print(f"{idx}. {nome_npc} (HP: {hp_atual}, Função: {funcao})")
            
            escolha = input("Escolha o inimigo para atacar (número) ou 0 para voltar: ")
            if escolha == '0':
                break

            try:
                escolha = int(escolha)
                if 1 <= escolha <= len(npcs_disponiveis):
                    npc_selecionado = npcs_disponiveis[escolha - 1]
                    v_id_instancia_npc, nome_npc, hp_atual, funcao = npc_selecionado
                    print(f"Iniciando combate contra {nome_npc}...")

                    if npc_foi_derrotado(conn, jogador.id_jogador, v_id_instancia_npc):
                        print(f"{nome_npc} já foi derrotado. Você não pode atacar novamente.")
                        input()
                        continue
                    
                    while True:
                        # Atualiza as informações do jogador do banco de dados
                        atualizar_stamina(conn, jogador, 20)
                        hp_antes = jogador.hp_atual
                        print("------------------")
                        print(f"HP Atual: {jogador.hp_atual}")
                        print(f"Stamina Atual: {jogador.st_atual}")
                        print("------------------")
                        print("Escolha sua ação:")
                        print("1. Atacar")
                        print("2. Esquivar")
                        print("3. Recuperar stamina")
                        print("4. Fugir")
                        opcao = input("Digite a ação: ")

                        if opcao == '1':
                            tipo_ataque = input("Ataque forte? (s/n): ").lower() == 's'
                            ataca_com_equipamento(conn, jogador.id_jogador, v_id_instancia_npc, id_arma, tipo_ataque)  # PC ataca
                            if npc_foi_derrotado(conn, jogador.id_jogador, v_id_instancia_npc):
                                print(f"{nome_npc} já foi derrotado. Você não pode atacar novamente.")
                                input()
                                break
                            realizar_ataque(conn, v_id_instancia_npc, jogador.id_jogador, tipo_ataque)
                        elif opcao == '2':
                            if jogador.st_atual < 30:
                                print("Stamina insuficiente para esquivar.")
                            else:
                                jogador.st_atual -= 30
                                atualizar_stamina(conn, jogador, -30) 
                                if random.random() <= 0.8:
                                    print("Você conseguiu esquivar do ataque!")
                                    continue
                                else:
                                    print("Falha ao esquivar. O NPC atacará!")
                                    realizar_ataque(conn, v_id_instancia_npc, jogador.id_jogador, True)
                        elif opcao == '3':
                            atualizar_stamina(conn, jogador, 30) 
                            realizar_ataque(conn, v_id_instancia_npc, jogador.id_jogador, True)
                        elif opcao == '4':
                            print("Você fugiu do combate.")
                            break
                        else:
                            print("Opção inválida.")
                        jogador_atualizado = info_jogador(conn, jogador.id_jogador)
                        if jogador_atualizado:
                            jogador = Jogador.from_data_base(jogador_atualizado)
                            
                        if jogador.hp_atual > hp_antes:
                            print("Você renasceu no começo do jogo. Todas suas runas foram perdidas, para recuperá-las, siga para a área onde morreu.")
                            break
                        input()
                else:
                    print("Escolha inválida.")
            except ValueError:
                print("Opção inválida. Tente novamente.")

        input("Pressione qualquer tecla para continuar...")
        if not npcs_disponiveis:
            return