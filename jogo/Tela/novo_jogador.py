from Database.Select.jogador import classes_disponiveis
from Database.Dml.jogador import add_jogador
from uteis import clear_screen

def criar_personagem(conn):
    while True:
        clear_screen()
        print("Tela de Criação de Personagem")
        nome = input("Digite o nome do jogador (até 25 caracteres): ")

        classe = classe_jogador(conn)
        print(classe[0])
        id_jogador = add_jogador(conn, nome, 250, 1, classe[0], 1, classe[2], classe[1], classe[3],
                classe[4], classe[5], classe[6], 100, 120, 200, 1, 250)

        if id_jogador:
            print(f"Personagem {nome} criado com sucesso")
            input("Pressione Enter para continuar...")
            clear_screen()
            break
        else:
            clear_screen()
            print("Erro ao criar personagem. Tente novamente.")
            input("Pressione Enter para continuar...")
            break

def classe_jogador(conn):
    classes = classes_disponiveis(conn)
    print("Classes disponíveis:")
    for index, classe in enumerate(classes):
        nome, base_vit, base_vig, base_int, base_fe, base_dex, base_str = classe
        print(f"{index + 1}. Nome: {nome}")
        print(f"   Vitalidade Base: {base_vit}")
        print(f"   Vigor Base: {base_vig}")
        print(f"   Inteligência Base: {base_int}")
        print(f"   Fé Base: {base_fe}")
        print(f"   Destreza Base: {base_dex}")
        print(f"   Força Base: {base_str}")
        print("-" * 25)
    while True:
        try:
            escolha = int(input("Digite o número da classe escolhida: ")) - 1
            if escolha < len(classes) and escolha > -1: return classes[escolha]
            else : print("Escolha inválida.")
        except ValueError:
            print("Entrada inválida. Por favor, digite um número.")
        