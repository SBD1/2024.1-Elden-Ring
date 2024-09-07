def introducao():
    return """
    ________________________________________________________________________________________________________________
    |    As folhas caídas contam uma história.                                                                      |
    |    O grande Elden Ring foi destruído.                                                                         |
    |    Em nossa terra, além da névoa, as Terras Intermédias.                                                      |
    |    A loucura causada por sua nova força desencadeou a Fragmentação.                                           |
    |    Uma guerra da qual nenhum senhor se ergueu.                                                                |
    |    Oh, levantem-se agora, ó Maculados.                                                                        |
    |    Vós, mortos que ainda vivem.                                                                               |
    |    O chamado da graça há muito perdida nos fala a todos.                                                      |
    |    Um Maculado sem renome. Atravesse a névoa, até as Terras Intermédias, para se colocar diante do Elden Ring.|
    |    E tornar-se o Elden Lord.                                                                                  |
    ________________________________________________________________________________________________________________
    """

def margitDialogo():
    return """
    ________________________________________________________________________________________________________________
    |    "Maculado vil, em busca do Elden Ring...                                                                   |
    |    Encorajado pela chama da ambição.                                                                          |
    |    Alguém deve extinguir tua chama, que seja Margit, o Caído!"                                                |
    ________________________________________________________________________________________________________________
    """

def rennalaDialogo():
    return """
    ________________________________________________________________________________________________________________
    |    "Silêncio, pequena pomba.                                                                                 |
    |    Em breve te darei à luz de novo, um doce ser, fresco e puro..."                                           |
    |                                                                                                              |
    ________________________________________________________________________________________________________________
    """

def maleniaDialogo():
    return """
    ________________________________________________________________________________________________________________
    |    "Sonhei por tanto tempo.                                                                                   |
    |    Minha carne era ouro opaco... e meu sangue, podre.                                                         |
    |    Cadáver após cadáver, deixado em meu rastro...                                                             |
    |    Enquanto aguardava... seu retorno.                                                                        |
    |    ... Ouça minhas palavras.                                                                                 |
    |    Eu sou Malenia. Lâmina de Miquella.                                                                        |
    |    E nunca conheci a derrota."                                                                               |
    ________________________________________________________________________________________________________________
    """

def main():
    # print(introducao())
    # Aqui viria a lógica do jogo
    # input("\nPressione Enter para continuar...\n")  # Pausa entre os diálogos
    print(rennalaDialogo())
    input("\nPressione Enter para continuar...\n")  # Pausa entre os diálogos
    print(maleniaDialogo())

if __name__ == "__main__":
    main()

