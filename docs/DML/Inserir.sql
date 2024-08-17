
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

-- personagem ok
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
    v_id_personagem INTEGER;
    v_id_npc INTEGER;
    v_id_inimigo INTEGER;
BEGIN
	WITH new_personagem AS (
        INSERT INTO personagem (tipo)
        VALUES ('Njogavel'::tipo_p)
        RETURNING id_personagem
    )
    , new_funcao_npc AS (
        INSERT INTO funcao_npc (id_npc, funcao)
        SELECT id_personagem, p_funcao_npc
        FROM new_personagem
        RETURNING id_npc
    )
    , new_npc AS (
        INSERT INTO npc (id_npc, nome, hp, funcao, esta_hostil, resistencia, fraquezas, drop_runas)
        SELECT id_npc, p_nome_npc, p_hp_npc, p_funcao_npc, p_esta_hostil, p_resistencia, p_fraquezas, p_drop_runas
        FROM new_funcao_npc
        RETURNING id_npc
    )
    INSERT INTO inimigo (id_inimigo, nome, hp, dano_base)
    SELECT id_npc, p_nome_inimigo, p_hp_inimigo, p_dano_base
    FROM new_npc
    RETURNING id_inimigo INTO v_id_inimigo;

    RETURN v_id_inimigo;
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
    p_nome_chefe VARCHAR,
    p_hp_chefe INTEGER,
    p_dano_base INTEGER,
    p_lembranca VARCHAR,
    p_desperate_move INTEGER,
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
    v_id_personagem INTEGER;
    v_id_npc INTEGER;
    v_id_chefe INTEGER;
BEGIN
	WITH new_personagem AS (
        INSERT INTO personagem (tipo)
        VALUES ('Njogavel'::tipo_p)
        RETURNING id_personagem
    )
    , new_funcao_npc AS (
        INSERT INTO funcao_npc (id_npc, funcao)
        SELECT id_personagem, p_funcao_npc
        FROM new_personagem
        RETURNING id_npc
    )
    , new_npc AS (
        INSERT INTO npc (id_npc, nome, hp, funcao, esta_hostil, resistencia, fraquezas, drop_runas)
        SELECT id_npc, p_nome_npc, p_hp_npc, p_funcao_npc, p_esta_hostil, p_resistencia, p_fraquezas, p_drop_runas
        FROM new_funcao_npc
        RETURNING id_npc
    )
    INSERT INTO chefe (id_chefe, nome, hp, dano_base, lembranca, desperate_move)
    SELECT id_npc, p_nome_chefe, p_hp_chefe, p_dano_base, p_lembranca, p_desperate_move
    FROM new_npc
    RETURNING id_chefe INTO v_id_chefe;

    RETURN v_id_chefe;
END;
$$;

SELECT add_chefe(
    'Godrick, o Senhor', 3500, 500,
    'Lembrança de Godrick', 6000,
    'Godrick, o Senhor', 3500,
    'Chefe'::funcao_p, TRUE, 300, 'Fogo'::tipo_atk, 6000
);

SELECT add_chefe(
    'Margit, o Caído', 3000, 350,
    'Lembrança de Margit', 4000,
    'Margit, o Caído', 3000,
    'Chefe'::funcao_p, TRUE, 300, 'Fogo'::tipo_atk, 4000
);

SELECT add_chefe(
    'Rennala', 5000, 250,
    'Lembrança de Rennala', 5000,
    'Rennala', 5000,
    'Chefe'::funcao_p, TRUE, 250, 'Magia'::tipo_atk, 5000
);

SELECT add_chefe(
    'Starscourge Radahn', 8000, 600,
    'Lembrança de Radahn', 7000,
    'Starscourge Radahn', 8000,
    'Chefe'::funcao_p, TRUE, 600, 'Cortante'::tipo_atk, 7000
);

SELECT add_chefe(
    'Malenia', 7000, 500,
    'Lembrança de Malenia', 6500,
    'Malenia', 7000,
    'Chefe'::funcao_p, TRUE, 500, 'Cortante'::tipo_atk, 6500
);

-- FERREIRO
CREATE OR REPLACE FUNCTION add_ferreiro(
    p_nome_ferreiro VARCHAR,
    p_hp_ferreiro INTEGER,
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
    v_id_personagem INTEGER;
    v_id_npc INTEGER;
    v_id_ferreiro INTEGER;
BEGIN
	WITH new_personagem AS (
        INSERT INTO personagem (tipo)
        VALUES ('Njogavel'::tipo_p)
        RETURNING id_personagem
    )
    , new_funcao_npc AS (
        INSERT INTO funcao_npc (id_npc, funcao)
        SELECT id_personagem, p_funcao_npc
        FROM new_personagem
        RETURNING id_npc
    )
    , new_npc AS (
        INSERT INTO npc (id_npc, nome, hp, funcao, esta_hostil, resistencia, fraquezas, drop_runas)
        SELECT id_npc, p_nome_npc, p_hp_npc, p_funcao_npc, p_esta_hostil, p_resistencia, p_fraquezas, p_drop_runas
        FROM new_funcao_npc
        RETURNING id_npc
    )
    INSERT INTO ferreiro (id_ferreiro, nome, hp)
    SELECT id_npc, p_nome_ferreiro, p_hp_ferreiro
    FROM new_npc
    RETURNING id_ferreiro INTO v_id_ferreiro;

    RETURN v_id_ferreiro;
END;
$$;

SELECT add_ferreiro(
    'Hewg', 1000, 
    'Hewg', 1000, 
    'Ferreiro'::funcao_p, FALSE, 50, 'Cortante'::tipo_atk, 0
);

SELECT add_ferreiro(
    'Iji', 1200, 
    'Iji', 1200, 
    'Ferreiro'::funcao_p, FALSE, 60, 'Cortante'::tipo_atk, 0
);

SELECT add_ferreiro(
    'Smith', 800, 
    'Smith', 800, 
    'Ferreiro'::funcao_p, FALSE, 40, 'Cortante'::tipo_atk, 0
);

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