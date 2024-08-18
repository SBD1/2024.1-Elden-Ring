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

-- Atualiza Area
UPDATE jogador
SET id_area = %area%
WHERE id_jogador = %player%

-- Atualiza HP do Jogador
UPDATE jogador
SET hp = %v_hp%
WHERE id_jogador = %v_id%

-- Atualiza nível do jogador
UPDATE jogador
SET 
    id_nivel = %new_id_lvl%, 
    nivel_atual = %new_lvl%,   
    hp = %new_hp%,              
    stamina = %new_stamina%,    
    mp = %new_mp%,            
    vigor = %new_vigor%,           
    vitalidade = %new_vit%, 
    intel = %new_int%,         
    fe = %new_fe%,            
    destreza = %new_dex%,   
    forca = %new_str%,          
    peso_max = %new_p% 
WHERE 
    id_jogador = %player_id%;

-- Atualiza area de morte
UPDATE area_de_morte
SET 
    id_area = %area%,
    runas_dropadas = %runas%
WHERE 
    id_jogador = %player_id%
    AND id_area_de_morte = %area_m%;