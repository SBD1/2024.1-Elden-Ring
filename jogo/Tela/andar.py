from uteis import clear_screen
from Database.Select.area import areas_conectadas
from Database.Dml.areas import atualizar_area_jogador

def Andar(conn, id_jogador, id_area):
    while True:
        clear_screen()

        areas_conectadas_list = areas_conectadas(conn, id_area)
        
        # Mostrar as areas conectadas
        for i, area in enumerate(areas_conectadas_list, start=1):
            print(f"{i}. Ir para {area[2]}")

        print("0. Voltar as opções de ação")
        opcao = input("Digite a área desejada: ")

        # Saber qual a opção escolhida
        if opcao == '0':
            break  
        elif opcao.isdigit() and 1 <= int(opcao) <= len(areas_conectadas_list):
            index = int(opcao) - 1
            nova_area = areas_conectadas_list[index]
            print(f"Movendo-se para {nova_area[2]}")
            id_area_destino = nova_area[1]
            
            if atualizar_area_jogador(conn, id_jogador, id_area_destino):
                print("Jogador andou com sucesso.")
                id_area = id_area_destino  
                input("Precione qualquer tecla para continuar ...")
                break  # Volta à selecionar ação
            else:
                print("Falha ao andar. (Talvez você quebrou a perna =D).")

        else:
            print("Opção inválida. Tente novamente.")
        
  