-- Aqui em select nós colocamos os updates que possivelmente vamos usar dentro do jogo


SELECT * FROM item WHERE id_item = %var%;

SELECT * FROM instancia_de_item WHERE id_item = %var%;

SELECT * FROM equipados WHERE id_jogador = %id_jogador%;