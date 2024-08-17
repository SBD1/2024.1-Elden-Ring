
-- item (ok)
-- consumivel
-- inventario (ok -> Falta testar)
-- instancia_de_item (ok -> Falta testar)
-- equipamento (tem que fazer todos equipamentos para dar ok)
-- escudo (ok)
-- armadura
-- arma (tem que fazer todos tipos de arma para dar ok)
-- arma_pesada
-- arma_leve (ok)
-- cajado
-- selo
-- engaste
-- equipados (ok -> Falta testar)

-- funcao_npc ok
-- inimigo ok
-- chefe ok
-- regiao ok
-- area ok
-- ferreiro ok
-- classe ok
-- nivel ok
-- jogador +/- ok
-- area_de_morte ok
-- conecta_area ok
-- realiza - ok
-- instancia_npc - ok
-- dialogo - ok
-- chefes_derrotados - ok

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

-- REGIOES
INSERT INTO regiao (nome) VALUES ('Limgrave');
INSERT INTO regiao (nome) VALUES ('Liurnia');
INSERT INTO regiao (nome) VALUES ('Caelid');
INSERT INTO regiao (nome) VALUES ('Altus'); 

-- ÁREAS DE LIMGRAVE
INSERT INTO area (nome, id_regiao) VALUES 
('Ruinas Entrada', 17),
('Colina Tempestuosa', 17),
('Peninsula Lamentosa', 17),
('Bosque Nebuloso', 17),
('Masmorra Solitario', 17),
('Castelo Morne', 17),
('Terceira Igreja', 17),
('Fortaleza Haight', 17),
('Caverna Lado Cova', 17),
('Caverna Murkwater', 17);

-- ÁREAS DE LIURNIA
INSERT INTO area (nome, id_regiao) VALUES 
('Lago de Liurnia', 18),
('Ruinas Torre Arvore', 18),
('Academia Raya Lucaria', 18),
('Fortaleza Magisterio', 18),
('Pantano Magos', 18),
('Jardins Encantamentos', 18),
('Ilha Coração Perdido', 18),
('Ruinas Cidade Perdida', 18),
('Salão Sabores', 18),
('Campo Marés', 18);

-- ÁREAS DE CAELID
INSERT INTO area (nome, id_regiao) VALUES 
('Ruinas Sombra', 19),
('Campo Morte', 19),
('Calçada Caelid', 19),
('Fortaleza Sanguinario', 19),
('Área Lava', 19),
('Ruinas Caelid', 19),
('Caverna Coração Pedra', 19),
('Salão Morte', 19),
('Pantano Caelid', 19),
('Fortaleza Condenados', 19);

-- ÁREAS DE ALTUS
INSERT INTO area (nome, id_regiao) VALUES 
('Planicie Altus', 20),
('Fortaleza Altus', 20),
('Ruinas Cidade Alta', 20),
('Pico Altus', 20),
('Salão Guerrilheiros', 20),
('Fortaleza Vento', 20),
('Campo Ruinas', 20),
('Encruzilhada Altus', 20),
('Caverna Sombras', 20),
('Jardins Montanhas', 20);

-- CONECTA AREA
INSERT INTO conecta_area (id_origem, id_destino)
VALUES (71, 72);

INSERT INTO conecta_area (id_origem, id_destino)
VALUES (72, 71);

INSERT INTO conecta_area (id_origem, id_destino)
VALUES (72, 73);

INSERT INTO conecta_area (id_origem, id_destino)
VALUES (73, 72);

INSERT INTO conecta_area (id_origem, id_destino)
VALUES (73, 74);

INSERT INTO conecta_area (id_origem, id_destino)
VALUES (74, 73);

-- INSTANCIA NPC 
INSERT INTO instancia_npc (id_npc, id_area)
VALUES (35, 73);

INSERT INTO instancia_npc (id_npc, id_area)
VALUES (35, 73);

INSERT INTO instancia_npc (id_npc, id_area)
VALUES (34, 73);


-- CLASSE
---- classes
INSERT INTO classe (nome, base_vit, base_vig, base_int, base_fe, base_dex, base_str)
VALUES ('Guerreiro', 12, 11, 7, 8, 16, 10);

INSERT INTO classe (nome, base_vit, base_vig, base_int, base_fe, base_dex, base_str)
VALUES ('Samurai', 12, 12, 9, 8, 15, 12);

INSERT INTO classe (nome, base_vit, base_vig, base_int, base_fe, base_dex, base_str)
VALUES ('Astrólogo', 9, 9, 16, 7, 12, 8);

INSERT INTO classe (nome, base_vit, base_vig, base_int, base_fe, base_dex, base_str)
VALUES ('Profeta', 10, 10, 7, 16, 10, 11);

-- NIVEL
CREATE OR REPLACE FUNCTION add_nivel(
    num_nivel INTEGER,
    runas_necessarias INTEGER
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    new_id_nivel INTEGER;
BEGIN 
    INSERT INTO nivel (nro_nivel, runas)
    VALUES (num_nivel, runas_necessarias)
    RETURNING id_nivel INTO new_id_nivel;

    RETURN new_id_nivel;
END;
$$;

SELECT add_nivel(1, 673);
SELECT add_nivel(2, 689);
SELECT add_nivel(3, 706);
SELECT add_nivel(4, 722);
SELECT add_nivel(5, 739);
SELECT add_nivel(6, 756);
SELECT add_nivel(7, 773);
SELECT add_nivel(8, 790);
SELECT add_nivel(9, 807);
SELECT add_nivel(10, 824);
SELECT add_nivel(11, 841);
SELECT add_nivel(12, 858);
SELECT add_nivel(13, 875);
SELECT add_nivel(14, 892);
SELECT add_nivel(15, 909);
SELECT add_nivel(16, 926);
SELECT add_nivel(17, 943);
SELECT add_nivel(18, 960);
SELECT add_nivel(19, 977);
SELECT add_nivel(20, 994);
SELECT add_nivel(21, 1011);
SELECT add_nivel(22, 1028);
SELECT add_nivel(23, 1045);
SELECT add_nivel(24, 1062);
SELECT add_nivel(25, 1079);
SELECT add_nivel(26, 1096);
SELECT add_nivel(27, 1113);
SELECT add_nivel(28, 1130);
SELECT add_nivel(29, 1147);
SELECT add_nivel(30, 1164);
SELECT add_nivel(31, 1181);
SELECT add_nivel(32, 1198);
SELECT add_nivel(33, 1215);
SELECT add_nivel(34, 1232);
SELECT add_nivel(35, 1249);
SELECT add_nivel(36, 1266);
SELECT add_nivel(37, 1283);
SELECT add_nivel(38, 1300);
SELECT add_nivel(39, 1317);
SELECT add_nivel(40, 1334);

-- DIALOGO
INSERT INTO dialogo (id_npc, texto, e_unico)
VALUES (38, 'Ah... finalmente, você chegou. O destino o trouxe até aqui, mas não sem um propósito.', TRUE);

INSERT INTO dialogo (id_npc, texto, e_unico)
VALUES (38, 'Você é um Tarnished, alguém que já caminhou nas sombras da glória perdida. Mas não se deixe enganar por seu estado... a Chama do Destino ainda arde em seu coração.', TRUE);

INSERT INTO dialogo (id_npc, texto, e_unico)
VALUES (38, 'Veja, o mundo está em ruínas, desfigurado pela corrupção e pela ambição sem fim dos deuses. O ciclo se repete, como sempre, mas há uma pequena esperança... e essa esperança é você.' , TRUE);

INSERT INTO dialogo (id_npc, texto, e_unico)
VALUES (38, 'Agora vá... siga o brilho pálido da luz e lembre-se: o caminho é seu para forjar, mas o preço a pagar será sua própria essência. Que a graça guie seu caminho... ou condene sua alma.' , TRUE);

-- REALIZA
INSERT INTO realiza (id_npc, multiplicador, dano_final)
VALUES (35, 25, 25);

INSERT INTO realiza (id_npc, multiplicador, dano_final)
VALUES (37, 50, 50);

INSERT INTO realiza (id_npc, multiplicador, dano_final)
VALUES (38, 75, 75);

-- JOGADOR
CREATE OR REPLACE FUNCTION add_jogador(
    p_nome_jogador VARCHAR,
    p_hp INTEGER,
    p_id_nivel INTEGER,
    p_id_classe VARCHAR,
    p_id_area INTEGER,
    p_vigor INTEGER,
    p_vitalidade INTEGER,
    p_intel INTEGER,
    p_fe INTEGER,
    p_destreza INTEGER,
    p_forca INTEGER,
    p_peso_max INTEGER,
    p_stamina INTEGER,
    p_mp INTEGER,
    p_nivel_atual INTEGER
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_personagem INTEGER;
    v_id_jogador INTEGER;
BEGIN
    INSERT INTO personagem (tipo)
    VALUES ('Jogavel'::tipo_p)
    RETURNING id_personagem INTO v_id_personagem;

    INSERT INTO jogador (
        id_jogador, nome, hp, id_nivel, id_classe, id_area,
        vigor, vitalidade, intel, fe, destreza, forca,
        peso_max, stamina, mp, nivel_atual
    )
    VALUES (
        v_id_personagem, p_nome_jogador, p_hp, p_id_nivel, p_id_classe, p_id_area,
        p_vigor, p_vitalidade, p_intel, p_fe, p_destreza, p_forca,
        p_peso_max, p_stamina, p_mp, p_nivel_atual
    )
    RETURNING id_jogador INTO v_id_jogador;

    RETURN v_id_jogador;
END;
$$;

SELECT add_jogador(
    'Aragorn', 1200, 10, 'Guerreiro', 71, 15, 14, 8, 9, 18, 12, 150, 120, 60, 12
);

SELECT add_jogador(
    'Sekiro', 1100, 15, 'Samurai', 71, 17, 16, 10, 8, 20, 14, 160, 130, 70, 15
);

SELECT add_jogador(
    'Gandalf', 900, 20, 'Astrólogo', 71, 12, 11, 18, 14, 14, 10, 140, 110, 80, 20
);

SELECT add_jogador(
    'Chifrudo', 800, 15, 'Profeta', 71, 12, 11, 16, 10, 8, 20, 122, 95, 80, 30
);

-- CHEFES DERROTADOS
INSERT INTO chefes_derrotados (id_chefe, id_jogador)
VALUES (37, 48);

INSERT INTO chefes_derrotados (id_chefe, id_jogador)
VALUES (38, 48);

INSERT INTO chefes_derrotados (id_chefe, id_jogador)
VALUES (39, 48);


-- AREA DA MORTE
INSERT INTO area_de_morte (id_jogador, id_area, runas_dropadas)
VALUES (46, 74, 2500);

INSERT INTO area_de_morte (id_jogador, id_area, runas_dropadas)
VALUES (47, 76, 15300);

INSERT INTO area_de_morte (id_jogador, id_area, runas_dropadas)
VALUES (48, 78, 30762);

-- ITEM
INSERT INTO item (eh_chave, raridade, nome, valor, tipo)
VALUES (false, 2, 'Pedra de Forja', 200, NULL);

INSERT INTO item (eh_chave, raridade, nome, valor, tipo)
VALUES (true, 2, 'Grande Runa - 1', NULL, NULL);

INSERT INTO item (eh_chave, raridade, nome, valor, tipo)
VALUES (true, 2, 'Grande Runa - 2', NULL, NULL);

-- Instancia Item -> TESTAR DEPOIS QUE FIZEREM A PARTE DE AREA

INSERT INTO instancia_de_item (id_item, id_area, id_inventario)
VALUES (1, 1, null);  

INSERT INTO instancia_de_item (id_item, id_area, id_inventario)
VALUES (1, null, 1);  

INSERT INTO instancia_de_item (id_item, id_area, id_inventario)
VALUES (2, null, 1);  

-- Inventario -> TESTAR DEPOIS QUE FIZEREM A PARTE DE AREA E PERSONAGEM

-- Obs: o inventario ele so é atualizado caso haja uma adição de uma instancia item em um id_iventario
CREATE OR REPLACE FUNCTION add_item_inventario()
RETURNS TRIGGER AS $$
BEGIN
    -- Se id_area não for nulo, não faz nada
    IF NEW.id_area IS NOT NULL THEN
        RETURN NEW;
    END IF;

    -- Insere um registro na tabela item_inventario
    INSERT INTO inventario (id_inventario, id_instancia_item, quantidade)
    VALUES (NEW.id_inventario, NEW.id_item, 1)
    ON CONFLICT (id_inventario, id_instancia_item) 
    DO UPDATE SET quantidade = inventario.quantidade + 1; -- Atualiza a quantidade se já existir

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger que chama a função após inserir ou atualizar em instancia_de_item
CREATE TRIGGER trigger_criar_instancia_item
AFTER INSERT OR UPDATE ON instancia_de_item
FOR EACH ROW
EXECUTE FUNCTION add_item_inventario();

INSERT INTO instancia_de_item (id_item, id_area, id_inventario)
VALUES (1, null, 1);  

INSERT INTO instancia_de_item (id_item, id_area, id_inventario)
VALUES (3, null, 1);

INSERT INTO instancia_de_item (id_item, id_area, id_inventario)
VALUES (3, null, 1);

-- Trigger que chama a função após inserir ou atualizar em item_inventario
CREATE TRIGGER trigger_criar_instancia_item
AFTER INSERT OR UPDATE ON item_inventario
FOR EACH ROW
EXECUTE FUNCTION add_item_inventario();

-- Escudo
CREATE OR REPLACE FUNCTION add_escudo(
    p_nome VARCHAR,
    p_raridade INTEGER,
    p_valor NUMERIC,
    p_tipo_item tipo_item,
    p_tipo_equipamento tipo_equipamento,
    p_requisitos INTEGER[],
    p_melhoria INTEGER,
    p_peso INTEGER,
    p_custo_melhoria INTEGER,
    p_habilidade INTEGER,
    p_defesa INTEGER
) 
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_escudo INTEGER;
BEGIN
    -- Inserção na tabela item e captura do id_item
    WITH new_item AS (
        INSERT INTO item (eh_chave, raridade, nome, valor, tipo)
        VALUES (FALSE, p_raridade, p_nome, p_valor, p_tipo_item)
        RETURNING id_item
    )
    -- Inserção na tabela equipamento com id_item
    , new_equipamento AS (
        INSERT INTO equipamento (id_equipamento, tipo)
        SELECT id_item, p_tipo_equipamento
        FROM new_item
        RETURNING id_equipamento
    )
    INSERT INTO escudo (id_escudo, habilidade, requisitos, defesa, melhoria, peso, custo_melhoria)
    SELECT id_equipamento, p_habilidade, p_requisitos, p_defesa, p_melhoria, p_peso, p_custo_melhoria
    FROM new_equipamento
    RETURNING id_escudo INTO v_id_escudo;

    -- Retorna o id da arma leve inserida
    RETURN v_id_escudo;
END;
$$;

SELECT add_escudo (
    'Escudo de Ferro', 1, 200, 'Equipamento'::tipo_item, 'Escudo'::tipo_equipamento,
    ARRAY[1, 1, 1, 14], 0, 5, 2, 40, 100
) AS id_escudo;

SELECT add_escudo (
    'Escudo Fumegante', 3, 1000, 'Equipamento'::tipo_item, 'Escudo'::tipo_equipamento,
    ARRAY[1, 3, 10, 9], 0, 5, 2, 50, 140
) AS id_escudo;

SELECT add_escudo (
    'Escudo do Lorde', 2, 800, 'Equipamento'::tipo_item, 'Escudo'::tipo_equipamento,
    ARRAY[1, 1, 1, 16], 0, 5, 2, 30, 120
) AS id_escudo;

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
        INSERT INTO equipamento (id_equipamento, tipo)
        SELECT id_item, p_tipo_equipamento
        FROM new_item
        RETURNING id_equipamento
    )
    -- Inserção na tabela arma_leve com id_equipamento e captura do id_arma_leve
    INSERT INTO arma_leve (id_arma_leve, habilidade, dano, critico, requisitos, melhoria, peso, custo_melhoria, destreza)
    SELECT id_equipamento, p_habilidade, p_dano, p_critico, p_requisitos, p_melhoria, p_peso, p_custo_melhoria, p_destreza
    FROM new_equipamento
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

-- EQUIPADOS -> SO PODE SER TESTADO DEPOIS DE COLOCAR O JOGADORES E TODOS EQUIPAMENTOS
INSERT INTO equipados (id_jogador, mao_direita, mao_esquerda, armadura)
VALUES (1, 10, 20, 30);

INSERT INTO equipados (id_jogador, mao_direita, mao_esquerda, armadura)
VALUES (2, 40, NULL, 60);

INSERT INTO equipados (id_jogador, mao_direita, mao_esquerda, armadura)
VALUES (3, NULL, 50, 30);