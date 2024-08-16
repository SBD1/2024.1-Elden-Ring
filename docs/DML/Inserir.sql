
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