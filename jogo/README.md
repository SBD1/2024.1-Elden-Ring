# Rodando o Jogo

### Requisitos

1. Python 3
2. PostgreSQL

### Parte 1 - Configurando o Banco de Dados

1. Crie um banco de dados:

    ```sql
    CREATE DATABASE bd1_elden_ring;
    ```

2. Crie as tabelas no seu banco

    Para isso, execute o script `docs/DDL/ddl1.0.sql`.

3. Alimente as tabelas do seu banco de dados

    Para isso, execute o script `docs/DML/Inserir.sql`.

### Parte 2 - Configurando o Arquivo de Conexão com o Banco de Dados

1. Acesse o arquivo `Database/db_connection.py` e configure-o conforme suas informações esse trecho do código:

    ```python
    conn = psycopg2.connect(
        host="localhost",         # Substitua com o endereço do seu servidor
        port="5432",              # Substitua com a porta do seu servidor
        dbname="bd1_elden_ring",  # Substitua com o nome do seu banco de dados
        user="USER",          # Substitua com o nome do usuário do banco de dados
        password="PASSWORD"         # Substitua com a senha do usuário
    )
    ```

### Parte 3 - Rodando o Jogo

1. Antes de rodar pela primeira vez, instale as dependências:

    ```bash
    pip install -r requirements.txt
    ```

2. Agora é só rodar o jogo:

    ```bash
    python main.py
    ```
