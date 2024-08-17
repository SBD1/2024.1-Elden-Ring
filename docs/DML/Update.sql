-- Aqui em update nós colocamos os updates que possivelmente vamos usar dentro do jogo
-- Exempo: Um item, não é atualizado dentro do jogo apenas nos como devs atualizamos ele, agora a instancia de item pode ter alterações de quem é seu dono

--Instancia Item
UPDATE instancia_de_item
SET id_inventario = %var1%, id_area = NULL
WHERE id_instancia = %var2% AND id_area = %var3%;

UPDATE instancia_de_item
SET id_area = %var1%, id_inventario = NULL
WHERE id_instancia = %var2% AND id_inventario = %var3%;

-- Equipados
UPDATE equipados
SET 
    mao_direita = CASE 
        WHEN %var_mao_direita% IS NOT NULL THEN %var_mao_direita%
        ELSE mao_direita
    END,
    mao_esquerda = CASE 
        WHEN %var_mao_esquerda% IS NOT NULL THEN %var_mao_esquerda%
        ELSE mao_esquerda
    END,
    armadura = CASE 
        WHEN %var_armadura% IS NOT NULL THEN %var_armadura%
        ELSE armadura
    END
WHERE id_jogador = %var_id_jogador%;
