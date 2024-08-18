from Database.Select.constantes import AREAS_CONECTADAS

def areas_conectadas(conn, id_area): 
      if conn is None:
        return []

      try:
          cur = conn.cursor()
          cur.execute(AREAS_CONECTADAS, (id_area,)) 
          jogadores = cur.fetchall()
          cur.close()
          return jogadores
      except Exception as e:
          print(f"Erro ao tentar achar as areas conectadas: {e}")
          return []
      