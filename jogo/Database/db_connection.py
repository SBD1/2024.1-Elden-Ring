import psycopg2
from psycopg2 import OperationalError

def create_connection():
    
    try:
        conn = psycopg2.connect(
            host="localhost",         # Substitua com o endereço do seu servidor
            port="5432",              # Substitua com a porta do seu servidor
            dbname="bd1_elden_ring",  # Substitua com o nome do seu banco de dados
            user="postgres",          # Substitua com o nome do usuário do banco de dados
            password="123456"         # Substitua com a senha do usuário
        )
        print("Conexão com o banco de dados estabelecida com sucesso!")
        return conn
    except OperationalError as e:
        print(f"Erro ao conectar ao banco de dados: {e}")
        return None
