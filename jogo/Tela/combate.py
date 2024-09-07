import random
import psycopg2
from psycopg2 import OperationalError
from uteis import clear_screen
from Database.Select.instancia_npc import npcs_na_area
from Database.Select.jogador import info_jogador
from Database.Select.constantes import NPCS_NA_AREA
from Classes.jogador import Jogador
from Database.db_connection import print_notices

def ataca_com_equipamento_npc(conn, id_jogador, id_instancia_npc, id_equipamento, tipo_ataque):
    try:
        with conn.cursor() as cur:
            tipo_ataque = True if tipo_ataque else False
            cur.execute("CALL ATACA_COM_EQUIPAMENTO_NPC(%s, %s, %s, %s);", (id_jogador, id_instancia_npc, id_equipamento, tipo_ataque))
            conn.commit()
            print_notices(conn)
    except psycopg2.DatabaseError as e:
        print(f"Erro ao atacar com equipamento: {e}")
        conn.rollback()  # Rollback em caso de erro
    except psycopg2.Warning as w:
        print(f"Aviso: {w}")

def realizar_ataque(conn, instancia, alvo, ataque_forte):
    try:
        with conn.cursor() as cur:
            cur.execute("CALL realizar_ataque(%s, %s, %s);", (instancia, alvo, ataque_forte))
            conn.commit()
            print_notices(conn)
    except psycopg2.DatabaseError as e:
        print(f"Erro ao realizar ataque: {e}")
        conn.rollback()  # Rollback em caso de erro
    except psycopg2.Warning as w:
        print(f"Aviso: {w}")

def atualizar_stamina(conn, jogador: Jogador, valor):
    try:
        # Atualiza a stamina do jogador no banco de dados
        nova_stamina = jogador.st_atual + valor
        with conn.cursor() as cur:
            cur.execute("UPDATE jogador SET st_atual = %s WHERE id_jogador = %s;", (nova_stamina, jogador.id_jogador))
            conn.commit()
            print_notices(conn)
    except psycopg2.DatabaseError as e:
        print(f"Erro ao atualizar a stamina: {e}")
        conn.rollback()  # Rollback em caso de erro
    except psycopg2.Warning as w:
        print(f"Aviso: {w}")

def npc_foi_derrotado(conn, id_jogador, id_instancia_npc):
    try:
        with conn.cursor() as cur:
            # Verifica se o NPC está na tabela de chefes derrotados
            cur.execute("SELECT 1 FROM chefes_derrotados WHERE id_chefe = (SELECT id_npc FROM instancia_npc WHERE id_instancia = %s) AND id_jogador = %s;", (id_instancia_npc, id_jogador))
            if cur.fetchone():
                return True
            
            # Verifica se o NPC está na tabela de NPCs mortos
            cur.execute("SELECT 1 FROM npc_morto WHERE id_jogador = %s AND id_instancia_npc = %s;", (id_jogador, id_instancia_npc))
            if cur.fetchone():
                return True
            
            return False
    except psycopg2.DatabaseError as e:
        print(f"Erro ao verificar se o NPC foi derrotado: {e}")
        conn.rollback()  # Rollback em caso de erro
        return True
    except psycopg2.Warning as w:
        print(f"Aviso: {w}")
        return True

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
        
        # Atualiza a stamina do jogador no início de cada turno
        atualizar_stamina(conn, jogador, 20)
        
        # Exibe o HP atual e a stamina do jogador
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
                        input("Pressione qualquer tecla para continuar...")
                        continue
                    
                    while True:
                        # Atualiza as informações do jogador do banco de dados
                        hp_antes = jogador.hp_atual
                        print("------------------")
                        print(f"HP Atual: {jogador.hp_atual}")
                        print(f"Stamina Atual: {jogador.st_atual}")
                        print("------------------")
                        print("Escolha sua ação:")
                        print("1. Atacar com equipamento")
                        print("2. Esquivar")
                        print("3. Recuperar stamina (+40)")
                        print("4. Fugir")
                        opcao = input("Digite a ação: ")

                        if opcao == '1':
                            id_equipamento = int(input("Escolha o ID do equipamento: "))
                            tipo_ataque = input("Ataque forte? (s/n): ").lower() == 's'
                            ataca_com_equipamento_npc(conn, jogador.id_jogador, v_id_instancia_npc, id_equipamento, tipo_ataque)  # PC ataca
                            if npc_foi_derrotado(conn, jogador.id_jogador, v_id_instancia_npc):
                                print(f"{nome_npc} já foi derrotado. Você não pode atacar novamente.")
                                input("Pressione qualquer tecla para continuar...")
                                break
                            realizar_ataque(conn, v_id_instancia_npc, jogador.id_jogador, False)
                        elif opcao == '2':
                            if jogador.st_atual < 30:
                                print("Stamina insuficiente para esquivar.")
                            else:
                                jogador.st_atual -= 30
                                atualizar_stamina(conn, jogador, -30)  # Diminui a stamina no banco de dados
                                if random.random() <= 0.8:
                                    print("Você conseguiu esquivar do ataque!")
                                    continue  # Retorna ao início do loop, sem realizar o ataque do NPC
                                else:
                                    print("Falha ao esquivar. O NPC atacará!")
                                    realizar_ataque(conn, v_id_instancia_npc, jogador.id_jogador, True)
                        elif opcao == '3':
                            atualizar_stamina(conn, jogador, 40) 
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
                        input("Pressione qualquer tecla para continuar...")
                else:
                    print("Escolha inválida.")
            except ValueError:
                print("Opção inválida. Tente novamente.")

        input("Pressione qualquer tecla para continuar...")
        if not npcs_disponiveis:
            return