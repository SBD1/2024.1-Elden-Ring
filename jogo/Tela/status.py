from uteis import clear_screen
from Database.Select.status import atributos_jogador
from Database.Select.status import obter_dano_arma_mao_direita
from Database.Select.status import obter_defesa_escudo_mao_esquerda
from Database.Select.status import obter_resistencia_armadura

def status(conn, id_jogador):
    """
    Exibe todos os atributos de um jogador em um formato amigável.
    
    Args:
        conn: Conexão com o banco de dados.
        id_jogador: ID do jogador cujos atributos devem ser exibidos.
    """
    while True:
        clear_screen()
        
        jogador_atributos = atributos_jogador(conn, id_jogador)
        mao_direita = obter_dano_arma_mao_direita(conn, id_jogador)
        mao_esquerda = obter_defesa_escudo_mao_esquerda(conn, id_jogador)
        armadura = obter_resistencia_armadura(conn, id_jogador)


        if mao_direita == 0:
            dano_arma = 'O personagem não está equipado com uma arma.'
        else:
            dano_arma = f'{mao_direita}'

        if mao_esquerda == 0:
            defesa_escudo = 'O personagem não está equipado com um escudo.'
        else:
            defesa_escudo = f'{mao_esquerda}'

        if armadura == 0:
            defesa = 'O personagem não está equipado com uma armadura.'
        else:
            defesa = f'{armadura}'
                    
        if jogador_atributos:
            print(formatar_atributos_jogador(jogador_atributos, dano_arma, defesa_escudo, defesa))
        else:
            print(f"Jogador com id {id_jogador} não encontrado.")
        
        opcao = input("Digite '0' para voltar ao menu ou pressione Enter para visualizar novamente: ")
        
        if opcao == "0":
            break


def formatar_atributos_jogador(atributos, dano_arma, defesa_escudo, defesa):
    """
    Formata os atributos do jogador em um layout de tabela amigável.
    
    Args:
        atributos: Dicionário contendo os atributos do jogador.
    
    Returns:
        Uma string formatada contendo os atributos do jogador.
    """
    return f"""

    _____________________LEVEL________________________________

    |    Nível: {atributos['nivel_atual']}   
    |    Runas Atuais: {atributos['runas_atuais']}       

    _______________________ATRIBUTOS_____________________________

    |    Jogador: {atributos['nome']} Classe: {atributos['id_classe']}
    |    Nível: {atributos['nivel_atual']}  
    |    HP: {atributos['hp_atual']}/{atributos['hp']} 
    |    Stamina: {atributos['stamina']}/{atributos['st_atual']}
    |    MP: {atributos['mp']}   
    |    Vigor: {atributos['vigor']}                              
    |    Inteligencia: {atributos['intel']}                              
    |    Fé: {atributos['fe']}                              
    |    Destreza: {atributos['destreza']}                              
    |    Forca: {atributos['forca']}                                                                                                                                                         

    __________________________BODY_____________________________

    |    Vitalidade: {atributos['vitalidade']}
    |    Peso Máximo: {atributos['peso_max']}     

    __________________________DEFESA___________________________

    |    Defesa: {defesa}    

    __________________________ATAQUE___________________________

    |    Dano da arma: {dano_arma}
    |    Defesa do escudo: {defesa_escudo}                                                            

    """