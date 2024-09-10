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

3. Alimente e ajuste as tabelas do seu banco de dados

    Para isso, execute o script `docs/DML/Inserir.sql` e depois  `docs/Triggers-SPs/trigger-sps.sql`.

### Parte 2 - Configurando o Arquivo de Conexão com o Banco de Dados

1. Crie o arquivo `Database/db_connection.py` e configure-o conforme suas informações esse trecho do código:


```
    import psycopg2
    from psycopg2 import OperationalError
    import logging

    # Configuração do logger
    logging.basicConfig(level=logging.INFO, format='%(message)s')
    logger = logging.getLogger(__name__)

    def create_connection():
        try:
            conn = psycopg2.connect(
                host="localhost",         # Substitua com o endereço do seu servidor
                port="5432",              # Substitua com a porta do seu servidor
                dbname="bd1_elden_ring",  # Substitua com o nome do seu banco de dados
                user="USER",          # Substitua com o nome do usuário do banco de dados
                password="PASSWORD"         # Substitua com a senha do usuário
            )
            conn.set_session(autocommit=True)
            # Configura o nível de mensagens do cliente para NOTICE
            with conn.cursor() as cur:
                cur.execute("SET client_min_messages TO NOTICE;")
            
            print("Conexão com o banco de dados estabelecida com sucesso!")
            return conn
        except OperationalError as e:
            print(f"Erro ao conectar ao banco de dados: {e}")
            return None

    def print_notices(conn):
        if conn is None:
            print("Conexão não estabelecida. Nenhuma mensagem NOTICE para exibir.")
            return
        
        # Captura e imprime mensagens NOTICE
        notices_seen = set()
        with conn.cursor() as cur:
            cur.execute("SELECT current_setting('client_min_messages');")
            # Armazena as mensagens NOTICE em uma lista
            notices = conn.notices[:]
            conn.notices.clear()
            for notice in notices:
                notice_clean = notice.strip().replace("NOTICE:", "")
                if notice_clean not in notices_seen:
                    notices_seen.add(notice_clean)
                    logger.info(notice_clean)
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
