import random
from uteis import clear_screen
from Database.Select.instancia_npc import npcs_na_area, npc_foi_derrotado, realizar_ataque
from Database.Select.jogador import atualizar_stamina, ataca_com_equipamento
from Classes.jogador import Jogador
from Database.Select.jogador import info_jogador
from Database.db_connection import print_notices
from Tela.historia import godrickDialogo, rennalaDialogo, maleniaDialogo

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
        cur.execute("SELECT mao_direita, mao_esquerda FROM equipados WHERE id_jogador = %s;", (jogador.id_jogador,))
        resultado = cur.fetchone()
        if resultado is None:
            input("Nenhum equipamento foi encontrado para este jogador.")
            cur.close()
            break
        else:
            (id_arma, id_escudo) = resultado
            if id_arma is None:
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
                    nomecmp = nome_npc.replace(" ", "")
                    if nomecmp == "Godrick,oSenhor":
                        print(godrickDialogo())
                    if nomecmp == "Rennala":
                        print(rennalaDialogo())
                    if nomecmp == "Malenia":
                        print(maleniaDialogo())
                    print(f"Iniciando combate contra {nome_npc}")
                    cur.execute("SELECT id_npc, hp_atual FROM instancia_npc WHERE id_instancia = %s;", (v_id_instancia_npc,))
                    (v_id_npc, hp_atual) = cur.fetchone()
                    check=1
                    if npc_foi_derrotado(conn, jogador.id_jogador, v_id_instancia_npc):
                        print(f"{nome_npc} já foi derrotado. Você não pode atacar novamente.")
                        input()
                        continue
                    while True:
                        if check:
                            atualizar_stamina(conn, jogador, 10)
                        jogador_atualizado = info_jogador(conn, jogador.id_jogador)
                        if jogador_atualizado:
                            jogador = Jogador.from_data_base(jogador_atualizado)
                        cur.execute("SELECT hp_atual FROM instancia_npc WHERE id_instancia = %s", (v_id_instancia_npc,))
                        hp_atual = cur.fetchone()[0]
                        print("------------------")
                        print("Status do jogador")
                        print(f"HP do jogador: {jogador.hp_atual}/{jogador.hp}")
                        print(f"Stamina Atual: {jogador.st_atual}/{jogador.stamina}")
                        print("------------------")
                        print(f"Status do {nome_npc}")
                        print(f"HP: {hp_atual}")
                        print("------------------")
                        print("Escolha sua ação:")
                        print("1. Atacar (-30/-20)")
                        print("2. Esquivar (-30)")
                        print("3. Recuperar stamina (+30)")
                        print("4. Defender (-50)")
                        print("5. Curar (+30% hp)")
                        print("6. Fugir")
                        opcao = input("Digite a ação: ")

                        if opcao == '1':
                            tipo_ataque = input("Ataque forte? (s/n): ").lower() == 's'
                            ataca_com_equipamento(conn, jogador.id_jogador, v_id_instancia_npc, id_arma, tipo_ataque)
                            if npc_foi_derrotado(conn, jogador.id_jogador, v_id_instancia_npc):
                                print(f"{nome_npc} já foi derrotado. Você não pode atacar novamente.")
                                input()
                                break
                            realizar_ataque(conn, v_id_instancia_npc, jogador.id_jogador, tipo_ataque)
                        elif opcao == '2':
                            if jogador.st_atual < 30:
                                input("Stamina insuficiente para esquivar.")
                                continue
                            else:
                                atualizar_stamina(conn, jogador, -30) 
                                if random.random() <= 0.8:
                                    input("Você conseguiu esquivar do ataque!")
                                    continue
                                else:
                                    input("Falha ao esquivar. O NPC atacará!")
                                    realizar_ataque(conn, v_id_instancia_npc, jogador.id_jogador, True)
                        elif opcao == '3':
                            atualizar_stamina(conn, jogador, 30) 
                            realizar_ataque(conn, v_id_instancia_npc, jogador.id_jogador, True)
                        elif opcao == '4':
                            if id_escudo is None:
                                input("Não pode defender sem um escudo.")
                                continue
                            if jogador.st_atual < 50:
                                input("Stamina insuficiente para defender.")
                                continue
                            else:
                                atualizar_stamina(conn, jogador, -50)
                                cur.execute("SELECT defesa FROM escudo WHERE id_escudo = %s;", (id_escudo,))
                                defesa_escudo = cur.fetchone()[0]
                                if defesa_escudo[0]>=100 :
                                    input("Golpe defendido com sucesso.")
                                else:
                                    input("O inimigo quebrou sua guarda. Seu escudo não suporta o ataque.")
                                    realizar_ataque(conn, v_id_instancia_npc, jogador.id_jogador, True)
                        elif opcao == '5':
                                cur.execute("SELECT COUNT(*) FROM localização_da_instancia_de_item WHERE inventario_jogador = %s;", (jogador.id_jogador,))
                                contador = cur.fetchone()[0]
                                print(f"Quantidade de Fracos de Lágrimas Carmesins: {contador}/10")
                                if(contador<=0):
                                    input("Não há item de cura.")
                                    check=0
                                    continue
                                else:
                                    att_hp = jogador.hp_atual + 0.3*jogador.hp
                                    cur.execute("UPDATE jogador SET hp_atual=%s WHERE id_jogador = %s;", (att_hp, jogador.id_jogador))
                                    cur.execute("""
                                        SELECT id_instancia_item 
                                        FROM localização_da_instancia_de_item 
                                        WHERE inventario_jogador = %s 
                                        LIMIT 1;
                                    """, (jogador.id_jogador,))
                                    id_instancia_item = cur.fetchone()[0]
                                    cur.execute("DELETE FROM localização_da_instancia_de_item WHERE id_instancia_item = %s;", (id_instancia_item,))
                                    cur.execute("DELETE FROM instancia_de_item WHERE id_instancia_item = %s;", (id_instancia_item,))
                                    input("Um frasco de Lágrimas Carmesins foi consumido.")
                                    continue
                        elif opcao == '6':
                            if funcao == "Inimigo":
                                input("Você fugiu do combate.")
                                break
                            else:
                                input("Não há como fugir.")
                                continue
                        else:
                            print("Opção inválida.")
                            continue

                        jogador_atualizado = info_jogador(conn, jogador.id_jogador)
                        if jogador_atualizado:
                            jogador = Jogador.from_data_base(jogador_atualizado)
                            
                        if jogador.id_area == 1:
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