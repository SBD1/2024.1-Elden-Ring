from uteis import clear_screen
import psycopg2
from psycopg2 import OperationalError
from Database.Select.jogador import info_jogador
from Classes.jogador import Jogador

def subir_nivel(conn, jogador: Jogador):
    while True:
        clear_screen()

        cur = conn.cursor()
        cur.execute("""
            SELECT j.nivel_atual, j.runas_atuais, n.runas 
            FROM jogador j 
            JOIN nivel n ON n.nro_nivel = j.nivel_atual + 1
            WHERE j.id_jogador = %s
        """, (jogador.id_jogador,))
        jogador_info = cur.fetchone()

        if not jogador_info:
            print("Você já está no nível máximo ou os dados do jogador estão incorretos.")
            input("Pressione qualquer tecla para continuar...")
            cur.close()
            break

        nivel_atual, runas_atuais, runas_necessarias = jogador_info

        # Mostrar detalhes do nível e as runas necessárias
        print(f"Nível atual: {nivel_atual}")
        print(f"Runas atuais: {runas_atuais}")
        print(f"Runas necessárias para subir de nível: {runas_necessarias}")

        # Verificar se o jogador tem runas suficientes
        if runas_atuais < runas_necessarias:
            print(f"Você precisa de {runas_necessarias - runas_atuais} runas a mais para subir de nível.")
            input("Pressione qualquer tecla para continuar...")
            cur.close()
            break

        # Perguntar ao jogador se deseja subir de nível
        print("1. Subir de nível")
        print("0. Voltar")
        opcao = input("Digite a ação desejada: ")

        if opcao == '0':
            cur.close()
            break  # Voltar ao menu anterior
        elif opcao == '1':
            clear_screen()
            print("Escolha o atributo para aumentar:")
            print("1. Vigor")
            print("2. Vitalidade")
            print("3. Inteligência")
            print("4. Fé")
            print("5. Destreza")
            print("6. Força")
            atributo_opcao = input("Digite o número do atributo que deseja aumentar: ")

            # Mapear a escolha para a coluna correspondente no banco de dados
            atributo_coluna = None
            if atributo_opcao == '1':
                atributo_coluna = 'vigor'
            elif atributo_opcao == '2':
                atributo_coluna = 'vitalidade'
            elif atributo_opcao == '3':
                atributo_coluna = 'intel'
            elif atributo_opcao == '4':
                atributo_coluna = 'fe'
            elif atributo_opcao == '5':
                atributo_coluna = 'destreza'
            elif atributo_opcao == '6':
                atributo_coluna = 'forca'
            else:
                print("Opção inválida. Tente novamente.")
                input("Pressione qualquer tecla para continuar...")
                continue

            try:
                # Atualizar o nível e o atributo do jogador
                cur.execute(f"""
                    UPDATE jogador 
                    SET nivel_atual = nivel_atual + 1, 
                        {atributo_coluna} = {atributo_coluna} + 1 
                    WHERE id_jogador = %s
                """, (jogador.id_jogador,))
                conn.commit()
                print(f"Parabéns! Você subiu para o nível {nivel_atual + 1} e aumentou {atributo_coluna} em 1 ponto.")
                input("Pressione qualquer tecla para continuar...")

            except Exception as e:
                conn.rollback()
                print(f"Erro ao subir de nível: {e}")
                input("Pressione qualquer tecla para continuar...")

            finally:
                cur.close()
                break
        else:
            print("Opção inválida. Tente novamente.")