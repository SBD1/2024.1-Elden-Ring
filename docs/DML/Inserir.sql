
-- item (ok)
-- consumivel
-- inventario
-- instancia_de_item
-- item_inventario
-- equipamento
-- escudo
-- armadura
-- arma (tem que fazer todos tipos de arma para dar ok)
-- arma_pesada
-- arma_leve (ok)
-- cajado
-- selo
-- engaste
-- equipados

-- personagem
-- funcao_npc ok
-- npc ok
-- inimigo ok
-- chefe ok
-- regiao
-- area
-- ferreiro ok
-- classe
-- nivel
-- jogador
-- area_de_morte
-- conecta_area
-- realiza
-- instancia_npc
-- dialogo
-- chefes_derrotados

-- NPC
CREATE OR REPLACE FUNCTION add_npc(
    p_nome VARCHAR,
    p_hp INTEGER,
    p_funcao funcao_p, 
    p_esta_hostil BOOLEAN,
    p_resistencia INTEGER,
    p_fraquezas tipo_atk,
    p_drop_runas INTEGER
)
RETURNS INTEGER 
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_personagem INTEGER;
    v_id_npc INTEGER;
BEGIN INSERT INTO personagem (tipo)
    VALUES ('Njogavel') 
    RETURNING id_personagem INTO v_id_personagem;

    INSERT INTO funcao_npc (id_npc, funcao)
    VALUES (v_id_personagem, p_funcao);

    INSERT INTO npc (
        id_npc, nome, hp, funcao, esta_hostil, resistencia, fraquezas, drop_runas
    )
    VALUES (
        v_id_personagem, p_nome, p_hp, p_funcao, p_esta_hostil, p_resistencia, p_fraquezas, p_drop_runas
    )
    RETURNING id_npc INTO v_id_npc;

    RETURN v_id_npc;
END;
$$;
SELECT add_npc('Mercante Kale', 250, 'Mercador'::funcao_p, FALSE, 20, 'Fogo'::tipo_atk, 300);
SELECT add_npc('Ferreiro Mestre HEWG', 400, 'Ferreiro'::funcao_p, FALSE, 60, 'Cortante'::tipo_atk, 1000);
SELECT add_npc('Roderika', 200, 'Campones'::funcao_p, FALSE, 50, 'Raio'::tipo_atk, 350);
SELECT add_npc('Margit, o Mau Presságio', 2500, 'Chefe'::funcao_p, TRUE, 200, 'Magia'::tipo_atk, 5000);

-- INIMIGO
CREATE OR REPLACE FUNCTION add_inimigo(
    p_nome_inimigo VARCHAR,
    p_hp_inimigo INTEGER,
    p_dano_base INTEGER,
    p_nome_npc VARCHAR,
    p_hp_npc INTEGER,
    p_funcao_npc funcao_p,
    p_esta_hostil BOOLEAN,
    p_resistencia INTEGER,
    p_fraquezas tipo_atk,
    p_drop_runas INTEGER
)
RETURNS INTEGER 
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_npc INTEGER;
BEGIN SELECT id_npc INTO v_id_npc
    FROM npc
    WHERE nome = p_nome_npc;

    IF v_id_npc IS NULL THEN INSERT INTO npc (nome, hp, funcao, esta_hostil, resistencia, fraquezas, drop_runas)
        VALUES (p_nome_npc, p_hp_npc, p_funcao_npc, p_esta_hostil, p_resistencia, p_fraquezas, p_drop_runas)
        RETURNING id_npc INTO v_id_npc;

        INSERT INTO funcao_npc (id_npc, funcao)
        VALUES (v_id_npc, p_funcao_npc);
    END IF;

    INSERT INTO inimigo (id_inimigo, nome, hp, dano_base)
    VALUES (v_id_npc, p_nome_inimigo, p_hp_inimigo, p_dano_base);

    RETURN v_id_npc;
END;
$$;
SELECT add_inimigo(
    'Soldado de Godrick', 250, 40, 
    'Soldado de Godrick', 250, 
    'Inimigo'::funcao_p, TRUE, 40, 'Cortante'::tipo_atk, 100
);

SELECT add_inimigo(
    'Soldado', 200, 30, 
    'Soldado', 200, 
    'Inimigo'::funcao_p, TRUE, 30, 'Cortante'::tipo_atk, 50
);

SELECT add_inimigo(
    'Cavaleiro de Godrick', 500, 100, 
    'Cavaleiro de Godrick', 500, 
    'Inimigo'::funcao_p, TRUE, 100, 'Cortante'::tipo_atk, 200
);

-- CHEFE
CREATE OR REPLACE FUNCTION add_chefe(
    p_nome VARCHAR,
    p_hp INTEGER,
    p_dano_base INTEGER,
    p_lembranca VARCHAR,
    p_desperate_move INTEGER
) 
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    new_id_chefe INTEGER;
BEGIN
    INSERT INTO chefe (nome, hp, dano_base, lembranca, desperate_move)
    VALUES (p_nome, p_hp, p_dano_base, p_lembranca, p_desperate_move)
    RETURNING id_chefe INTO new_id_chefe;

    RETURN new_id_chefe;
END;
$$;


-- FERREIRO
CREATE OR REPLACE FUNCTION add_ferreiro(
    p_nome VARCHAR,
    p_hp INTEGER
) 
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    new_id_ferreiro INTEGER;
BEGIN
    INSERT INTO ferreiro (nome, hp)
    VALUES (p_nome, p_hp)
    RETURNING id_ferreiro INTO new_id_ferreiro;

    RETURN new_id_ferreiro;
END;
$$;

SELECT add_ferreiro('Ferreiro Mestre HEWG', 400, 'Ferreiro'::funcao_p, FALSE, 60, 'Cortante'::tipo_atk, 1000);
SELECT add_ferreiro('Gigante Iji', 1500, 'Ferreiro'::funcao_p, FALSE, 100, 'Contusao'::tipo_atk, 5000);
SELECT add_ferreiro('Ferreiro Kale', 400, 'Ferreiro'::funcao_p, FALSE, 50, 'Magia'::tipo_atk, 200);

-- JOGADOR
CREATE OR REPLACE FUNCTION add_jogador(
    p_nome
    P_hp
    p_vigor
    p_vitalidade
    p_intel
    p_fe
    p_destreza
    p_forca
    p_peso_max
    p_stamina
    p_pontos_mana
    p_nivel_atual
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    new_id_jogador INTEGER;
    new_id_nivel INTEGER;
    new_id_classe VARCHAR;
    new_id_area INTEGER;
BEGIN
    INSERT INTO jogador(nome, hp, vigor, vitalidade, intel, fe, destreza, forca, peso_max, stamina, mp, nivel_atual)
    VALUES
    RETURNING id_jogador INTO new_id_jogador;
    RETURNING id_nivel INTO new_id_nivel;
    RETURNING id_classe INTO new_id_classe;
    RETURNING id_area INTO new_id_area;

    RETURN new_id_jogador;
    RETURN new_id_nivel;
    RETURN new_id_classe;
    RETURN new_id_area;
END;
$$;

-- ITEM
CREATE OR REPLACE FUNCTION add_item(
    p_nome VARCHAR,
    p_raridade INTEGER,
    p_valor NUMERIC,
    p_tipo_item tipo_item,
    p_eh_chave BOOLEAN
) 
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    new_id_item INTEGER;
BEGIN
    INSERT INTO item (eh_chave, raridade, nome, valor, tipo)
    VALUES (p_eh_chave, p_raridade, p_nome, p_valor, p_tipo_item)
    RETURNING id_item INTO new_id_item;

    RETURN new_id_item;
END;
$$;

SELECT add_item('Pedra de Forja', 2, 200, NULL, false) AS pedraForja;

SELECT add_item('Grande Runa - 1', 2, null, NULL, true) AS grandeRuna1;

SELECT add_item('Grande Runa - 2', 2, null, NULL, true) AS grandeRuna2;


-- ARMA LEVE
CREATE OR REPLACE FUNCTION add_arma_leve(
    p_nome VARCHAR,
    p_raridade INTEGER,
    p_valor NUMERIC,
    p_tipo_item tipo_item,
    p_tipo_equipamento tipo_equipamento,
    p_requisitos INTEGER[],
    p_melhoria INTEGER,
    p_peso NUMERIC,
    p_custo_melhoria NUMERIC,
    p_habilidade INTEGER,
    p_dano INTEGER,
    p_critico INTEGER,
    p_destreza INTEGER
) 
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_arma_leve INTEGER;
BEGIN
    -- Inserção na tabela item e captura do id_item
    WITH new_item AS (
        INSERT INTO item (eh_chave, raridade, nome, valor, tipo)
        VALUES (FALSE, p_raridade, p_nome, p_valor, p_tipo_item)
        RETURNING id_item
    )
    -- Inserção na tabela equipamento com id_item
    , new_equipamento AS (
        INSERT INTO equipamento (id_equipamento, tipo, requisitos, melhoria, peso, custo_melhoria)
        SELECT id_item, p_tipo_equipamento, p_requisitos, p_melhoria, p_peso, p_custo_melhoria
        FROM new_item
        RETURNING id_equipamento
    )
    -- Inserção na tabela arma com id_equipamento
    , new_arma AS (
        INSERT INTO arma (id_arma, habilidade, dano, critico)
        SELECT id_equipamento, p_habilidade, p_dano, p_critico
        FROM new_equipamento
        RETURNING id_arma
    )
    -- Inserção na tabela arma_leve com id_arma e captura do id_arma_leve
    INSERT INTO arma_leve (id_arma_leve, destreza)
    SELECT id_arma, p_destreza
    FROM new_arma
    RETURNING id_arma_leve INTO v_id_arma_leve;

    -- Retorna o id da arma leve inserida
    RETURN v_id_arma_leve;
END;
$$;

SELECT add_arma_leve(
    'Rios de Sangue', 5, 1000, 'Equipamento'::tipo_item, 'Arma'::tipo_equipamento,
    ARRAY[1, 1, 18, 12], 0, 6.5, 8, 90, 76, 100, 18
) AS id_arma_leve;

SELECT add_arma_leve(
    'Uchigatana', 4, 1500, 'Equipamento'::tipo_item, 'Arma'::tipo_equipamento,
    ARRAY[1, 1, 15, 11], 0, 5.5, 9, 95, 115, 100, 15
) AS id_arma_leve;

SELECT add_arma_leve(
    'Esp. Amaldi. de Morgott', 5, 1200, 'Equipamento'::tipo_item, 'Arma'::tipo_equipamento,
    ARRAY[1, 1, 35, 14], 0, 6.5, 8, 100, 120, 100, 35
) AS id_arma_leve;