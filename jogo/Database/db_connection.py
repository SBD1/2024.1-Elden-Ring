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
            user="chifrudo",          # Substitua com o nome do usuário do banco de dados
            password="1234"           # Substitua com a senha do usuário
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