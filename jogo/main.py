import os
import sys
from Database.db_connection import create_connection
from Database.Select.jogador import listar_jogadores
from Tela.telas_iniciais import escolher_jogador, selecionar_acao
from uteis import clear_screen
from Tela.historia import introducao, margitDialogo, rennalaDialogo, maleniaDialogo

global jogador_selecionado

def main():
    conn = create_connection()
    if conn is None:
        print("Não foi possível conectar ao banco de dados.")
        return
    try:
        print(introducao())
        input("\nPressione Enter para continuar...\n")

        while True:
            jogadores = listar_jogadores(conn)
            escolher_jogador(jogadores)

            try:
                escolha = int(input("Digite o número do personagem escolhido (ou 0 para sair): ")) - 1
                if escolha == -1:
                    break
                if 0 <= escolha < len(jogadores):
                    jogador_selecionado = jogadores[escolha]
                    selecionar_acao(conn, jogador_selecionado)
                else:
                    print("Escolha inválida.")
            except ValueError:
                print("Entrada inválida. Por favor, digite um número.")
    finally:
        conn.close()
        print("Conexão com o banco de dados fechada.")

if __name__ == "__main__":
    main()