
-- item (ok)
-- consumivel (ok)
-- inventario (ok -> Falta testar)
-- instancia_de_item (ok -> Falta testar)
-- equipamento (tem que fazer todos equipamentos para dar ok)
-- escudo (ok)
-- armadura (ok)
-- arma (tem que fazer todos tipos de arma para dar ok)
-- arma_pesada (ok)
-- arma_leve (ok)
-- cajado (ok)
-- selo (ok)
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
    'Inimigo'::funcao_p, TRUE, 75, 'Cortante'::tipo_atk, 100
);

SELECT add_inimigo(
    'Soldado', 200, 30, 
    'Soldado', 200, 
    'Inimigo'::funcao_p, TRUE, 80, 'Cortante'::tipo_atk, 50
);

SELECT add_inimigo(
    'Cavaleiro de Godrick', 500, 100, 
    'Cavaleiro de Godrick', 500, 
    'Inimigo'::funcao_p, TRUE, 90, 'Cortante'::tipo_atk, 200
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
    'Godrick, o Senhor', 3500, 150,
    'Lembrança de Godrick', 6000,
    'Godrick, o Senhor', 3500,
    'Chefe'::funcao_p, TRUE, 100, 'Fogo'::tipo_atk, 6000
);

SELECT add_chefe(
    'Margit, o Caído', 3000, 160,
    'Lembrança de Margit', 4000,
    'Margit, o Caído', 3000,
    'Chefe'::funcao_p, TRUE, 110, 'Fogo'::tipo_atk, 4000
);

SELECT add_chefe(
    'Rennala', 5000, 170,
    'Lembrança de Rennala', 5000,
    'Rennala', 5000,
    'Chefe'::funcao_p, TRUE, 120, 'Magia'::tipo_atk, 5000
);

SELECT add_chefe(
    'Starscourge Radahn', 8000, 180,
    'Lembrança de Radahn', 7000,
    'Starscourge Radahn', 8000,
    'Chefe'::funcao_p, TRUE, 130, 'Cortante'::tipo_atk, 7000
);

SELECT add_chefe(
    'Malenia', 7000, 190,
    'Lembrança de Malenia', 6500,
    'Malenia', 7000,
    'Chefe'::funcao_p, TRUE, 140, 'Cortante'::tipo_atk, 6500
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
('Ruinas Entrada', 1),
('Colina Tempestuosa', 1),
('Peninsula Lamentosa', 1),
('Bosque Nebuloso', 1),
('Masmorra Solitario', 1),
('Castelo Morne', 1),
('Terceira Igreja', 1),
('Fortaleza Haight', 1),
('Caverna Lado Cova', 1),
('Caverna Murkwater', 1);

-- ÁREAS DE LIURNIA
INSERT INTO area (nome, id_regiao) VALUES 
('Lago de Liurnia', 2),
('Ruinas Torre Arvore', 2),
('Academia Raya Lucaria', 2),
('Fortaleza Magisterio', 2),
('Pantano Magos', 2),
('Jardins Encantamentos', 2),
('Ilha Coração Perdido', 2),
('Ruinas Cidade Perdida', 2),
('Salão Sabores', 2),
('Campo Marés', 2);

-- ÁREAS DE CAELID
INSERT INTO area (nome, id_regiao) VALUES 
('Ruinas Sombra', 3),
('Campo Morte', 3),
('Calçada Caelid', 3),
('Fortaleza Sanguinario', 3),
('Área Lava', 3),
('Ruinas Caelid', 3),
('Caverna Coração Pedra', 3),
('Salão Morte', 3),
('Pantano Caelid', 3),
('Fortaleza Condenados', 3);

-- ÁREAS DE ALTUS
INSERT INTO area (nome, id_regiao) VALUES 
('Planicie Altus', 4),
('Fortaleza Altus', 4),
('Ruinas Cidade Alta', 4),
('Pico Altus', 4),
('Salão Guerrilheiros', 4),
('Fortaleza Vento', 4),
('Campo Ruinas', 4),
('Encruzilhada Altus', 4),
('Caverna Sombras', 4),
('Jardins Montanhas', 4);

-- CONECTA AREA
INSERT INTO conecta_area (id_origem, id_destino)
VALUES (1, 2);

INSERT INTO conecta_area (id_origem, id_destino)
VALUES (2, 1);

INSERT INTO conecta_area (id_origem, id_destino)
VALUES (2, 3);

INSERT INTO conecta_area (id_origem, id_destino)
VALUES (3, 2);

INSERT INTO conecta_area (id_origem, id_destino)
VALUES (3, 4);

INSERT INTO conecta_area (id_origem, id_destino)
VALUES (4, 3);

-- INSTANCIA NPC 
INSERT INTO instancia_npc (id_npc, id_area, hp_atual)
SELECT 1, 3, hp
FROM npc
WHERE id_npc = 1;

INSERT INTO instancia_npc (id_npc, id_area, hp_atual)
SELECT 1, 4, hp
FROM npc
WHERE id_npc = 1;

INSERT INTO instancia_npc (id_npc, id_area, hp_atual)
SELECT 2, 5, hp
FROM npc
WHERE id_npc = 2;


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
VALUES (5, 'Ah... finalmente, você chegou. O destino o trouxe até aqui, mas não sem um propósito.', TRUE);

INSERT INTO dialogo (id_npc, texto, e_unico)
VALUES (5, 'Você é um Tarnished, alguém que já caminhou nas sombras da glória perdida. Mas não se deixe enganar por seu estado... a Chama do Destino ainda arde em seu coração.', TRUE);

INSERT INTO dialogo (id_npc, texto, e_unico)
VALUES (5, 'Veja, o mundo está em ruínas, desfigurado pela corrupção e pela ambição sem fim dos deuses. O ciclo se repete, como sempre, mas há uma pequena esperança... e essa esperança é você.' , TRUE);

INSERT INTO dialogo (id_npc, texto, e_unico)
VALUES (5, 'Agora vá... siga o brilho pálido da luz e lembre-se: o caminho é seu para forjar, mas o preço a pagar será sua própria essência. Que a graça guie seu caminho... ou condene sua alma.' , TRUE);

-- REALIZA
INSERT INTO realiza (id_npc, multiplicador, dano_final)
VALUES (5, 25, 25);

INSERT INTO realiza (id_npc, multiplicador, dano_final)
VALUES (4, 50, 50);

INSERT INTO realiza (id_npc, multiplicador, dano_final)
VALUES (5, 75, 75);

CREATE OR REPLACE FUNCTION add_jogador(
    p_nome_jogador CHAR(25),
    p_hp INTEGER,
    p_id_nivel INTEGER,
    p_id_classe CHAR(14),
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
    p_nivel_atual INTEGER,
    p_runas INTEGER
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
        peso_max, stamina, mp, nivel_atual, st_atual, hp_atual, runas_atuais
    )
    VALUES (
        v_id_personagem, p_nome_jogador, p_hp, p_id_nivel, p_id_classe, p_id_area,
        p_vigor, p_vitalidade, p_intel, p_fe, p_destreza, p_forca,
        p_peso_max, p_stamina, p_mp, p_nivel_atual, p_stamina, p_hp, p_runas
    )
    RETURNING id_jogador INTO v_id_jogador;

    RETURN v_id_jogador;
END;
$$;

SELECT add_jogador(
    'Aragorn', 1200, 10, 'Guerreiro', 1, 15, 14, 8, 9, 18, 12, 150, 120, 60, 12, 2469
);

SELECT add_jogador(
    'Sekiro', 1100, 15, 'Samurai', 1, 17, 16, 10, 8, 20, 14, 160, 130, 70, 15, 666
);

SELECT add_jogador(
    'Gandalf', 900, 20, 'Astrólogo', 1, 12, 11, 18, 14, 14, 10, 140, 110, 80, 20, 5123
);

SELECT add_jogador(
    'Chifrudo', 800, 15, 'Profeta', 1, 12, 11, 16, 10, 8, 20, 122, 95, 80, 30, 3213
);

-- CHEFES DERROTADOS
INSERT INTO chefes_derrotados (id_chefe, id_jogador)
VALUES (4, 12);

INSERT INTO chefes_derrotados (id_chefe, id_jogador)
VALUES (5, 12);

INSERT INTO chefes_derrotados (id_chefe, id_jogador)
VALUES (6, 12);


-- AREA DA MORTE
INSERT INTO area_de_morte (id_jogador, id_area, runas_dropadas)
VALUES (13, 4, 2500);

INSERT INTO area_de_morte (id_jogador, id_area, runas_dropadas)
VALUES (14, 6, 15300);

INSERT INTO area_de_morte (id_jogador, id_area, runas_dropadas)
VALUES (15, 8, 30762);

-- ITEM
INSERT INTO item (eh_chave, raridade, nome, valor, tipo)
VALUES (false, 2, 'Pedra de Forja', 200, NULL);

INSERT INTO item (eh_chave, raridade, nome, valor, tipo)
VALUES (true, 2, 'Grande Runa - 1', NULL, NULL);

INSERT INTO item (eh_chave, raridade, nome, valor, tipo)
VALUES (true, 2, 'Grande Runa - 2', NULL, NULL);

-- Instancia Item -> TESTAR DEPOIS QUE FIZEREM A PARTE DE AREA

INSERT INTO instancia_de_item (id_item)
VALUES (1);  

INSERT INTO instancia_de_item (id_item)
VALUES (1);  

INSERT INTO instancia_de_item (id_item)
VALUES (2);  

-- Instancia item está em -> 

INSERT INTO localização_da_instancia_de_item(id_instancia_item, area, inventario_jogador)
VALUES (1, null, 12);  

INSERT INTO localização_da_instancia_de_item(id_instancia_item, area, inventario_jogador)
VALUES (2, null, 12); 

INSERT INTO localização_da_instancia_de_item(id_instancia_item, area, inventario_jogador)
VALUES (3, 5, null); 

-- Escudo
CREATE OR REPLACE FUNCTION add_escudo(
    p_nome VARCHAR,
    p_raridade INTEGER,
    p_valor NUMERIC,
    p_tipo_item tipo_item,
    p_tipo_equipamento tipo_equipamento,
    p_req_int INTEGER,
    p_req_forca INTEGER,
    p_req_fe INTEGER,
    p_req_dex INTEGER,
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
    INSERT INTO escudo (id_escudo, habilidade, req_int, req_forca, req_fe, req_dex, defesa, melhoria, peso, custo_melhoria)
    SELECT id_equipamento, p_habilidade, p_req_int, p_req_forca, p_req_fe, p_req_dex, p_defesa, p_melhoria, p_peso, p_custo_melhoria
    FROM new_equipamento
    RETURNING id_escudo INTO v_id_escudo;

    -- Retorna o id da arma leve inserida
    RETURN v_id_escudo;
END;
$$;

SELECT add_escudo (
    'Escudo de Ferro', 1, 200, 'Equipamento'::tipo_item, 'Escudo'::tipo_equipamento,
    1, 14, 1, 14 , 0, 5, 2, 40, 100
) AS id_escudo;

SELECT add_escudo (
    'Escudo Fumegante', 3, 1000, 'Equipamento'::tipo_item, 'Escudo'::tipo_equipamento, 1, 10, 3, 5, 0, 5, 2, 50, 140
) AS id_escudo;

SELECT add_escudo (
    'Escudo do Lorde', 2, 800, 'Equipamento'::tipo_item, 'Escudo'::tipo_equipamento,
    1, 16, 1, 1, 0, 5, 2, 30, 120
) AS id_escudo;

-- ARMA LEVE
CREATE OR REPLACE FUNCTION add_arma_leve(
    p_nome VARCHAR,
    p_raridade INTEGER,
    p_valor NUMERIC,
    p_tipo_item tipo_item,
    p_tipo_equipamento tipo_equipamento,
    p_req_int INTEGER,
    p_req_forca INTEGER,
    p_req_fe INTEGER,
    p_req_dex INTEGER,
    p_melhoria INTEGER,
    p_peso NUMERIC,
    p_custo_melhoria NUMERIC,
    p_habilidade INTEGER,
    p_dano INTEGER,
    p_critico INTEGER,
    p_destreza tipo_proficiencia
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
    INSERT INTO arma_leve (id_arma_leve, habilidade, dano, critico, req_int, req_forca, req_fe, req_dex, melhoria, peso, custo_melhoria, destreza)
    SELECT id_equipamento, p_habilidade, p_dano, p_critico, p_req_int, p_req_forca, p_req_fe, p_req_dex, p_melhoria, p_peso, p_custo_melhoria, p_destreza
    FROM new_equipamento
    RETURNING id_arma_leve INTO v_id_arma_leve;

    -- Retorna o id da arma leve inserida
    RETURN v_id_arma_leve;
END;
$$;

SELECT add_arma_leve(
    'Rios de Sangue', 5, 1000, 'Equipamento'::tipo_item, 'Leve'::tipo_equipamento,
    8, 14, 8, 12 , 0, 6.5, 8, 120, 76, 100, 'S'::tipo_proficiencia
) AS id_arma_leve;

SELECT add_arma_leve(
    'Uchigatana', 4, 1500, 'Equipamento'::tipo_item, 'Leve'::tipo_equipamento,
    1, 11, 1, 15, 0, 5.5, 9, 100, 115, 100, 'A'::tipo_proficiencia
) AS id_arma_leve;

SELECT add_arma_leve(
    'Esp. Amaldi. de Morgott', 5, 1200, 'Equipamento'::tipo_item, 'Leve'::tipo_equipamento,
    1, 15, 1, 16, 0, 6.5, 8, 140, 120, 100, 'B'::tipo_proficiencia
) AS id_arma_leve;

-- EQUIPADOS -> SO PODE SER TESTADO DEPOIS DE COLOCAR O JOGADORES E TODOS EQUIPAMENTOS
INSERT INTO equipados (id_jogador, mao_direita, mao_esquerda, armadura)
VALUES (12, 7, 4, null);

INSERT INTO equipados (id_jogador, mao_direita, mao_esquerda, armadura)
VALUES (13, 8, NULL, null);

INSERT INTO equipados (id_jogador, mao_direita, mao_esquerda, armadura)
VALUES (14, NULL, 5, null);

-- CONSUMIVEIS

CREATE OR REPLACE FUNCTION add_consumivel(
    p_nome VARCHAR,
    p_raridade INTEGER,
    p_valor NUMERIC,
    p_tipo_item tipo_item,
    p_efeito tipo_efeitos,
    p_qtd_do_efeito INTEGER,
    p_descricao VARCHAR
) 
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_item INTEGER;
    v_id_consumivel INTEGER;
BEGIN
    -- Inserção na tabela item e captura do id_item
    WITH new_item AS (
        INSERT INTO item (eh_chave, raridade, nome, valor, tipo)
        VALUES (FALSE, p_raridade, p_nome, p_valor, p_tipo_item)
        RETURNING id_item
    )
    -- Inserção na tabela consumivel com id_item e captura do id_consumivel
    INSERT INTO consumivel (id_consumivel, efeito, qtd_do_efeito, descricao)
    SELECT id_item, p_efeito, p_qtd_do_efeito, p_descricao
    FROM new_item
    RETURNING id_consumivel INTO v_id_consumivel;

    -- Retorna o id do consumível inserido
    RETURN v_id_consumivel;
END;
$$;

SELECT add_consumivel(
    p_nome := 'Bênção de Marika',            
    p_raridade := 3,                         
    p_valor := 500,                           
    p_tipo_item := 'Consumivel'::tipo_item,
    p_efeito := 'RestauraHp'::tipo_efeitos,
    p_qtd_do_efeito := 100,
    p_descricao := 'Aumenta a vida máxima do jogador em 20 pontos.'
);

SELECT add_consumivel(
    p_nome := 'Carne Sagrada Sangrenta',
    p_raridade := 4,
    p_valor := 700,
    p_tipo_item := 'Consumivel'::tipo_item,
    p_efeito := 'AumentaAtaque'::tipo_efeitos,
    p_qtd_do_efeito := 15,
    p_descricao := 'Aumenta o dano causado em 15 pontos por um tempo limitado.'
);

SELECT add_consumivel(
    p_nome := 'Fígado em conserva à prova de feitiços',
    p_raridade := 2,
    p_valor := 150,
    p_tipo_item := 'Consumivel'::tipo_item,
    p_efeito := 'AumentaDefesa'::tipo_efeitos,
    p_qtd_do_efeito := 25,
    p_descricao := 'Aumenta a defesa do jogador em 25 pontos por um tempo limitado.'
);

SELECT add_consumivel(
    p_nome := 'Fígado em conserva à prova de feitiços',
    p_raridade := 2,
    p_valor := 150,
    p_tipo_item := 'Consumivel'::tipo_item,
    p_efeito := 'AumentaDefesa'::tipo_efeitos,
    p_qtd_do_efeito := 25,
    p_descricao := 'Aumenta a defesa do jogador em 25 pontos por um tempo limitado.'
);
SELECT add_consumivel(
    p_nome := 'Fígado em conserva à prova de feitiços',
    p_raridade := 2,
    p_valor := 150,
    p_tipo_item := 'Consumivel'::tipo_item,
    p_efeito := 'GanhaRunas'::tipo_efeitos,
    p_qtd_do_efeito := 25,
    p_descricao := 'Aumenta a defesa do jogador em 25 pontos por um tempo limitado.'
);


CREATE OR REPLACE FUNCTION add_armadura(
    p_nome VARCHAR,
    p_raridade INTEGER,
    p_valor NUMERIC,
    p_tipo_item tipo_item,
    p_tipo_equipamento tipo_equipamento,
    p_req_int INTEGER,
    p_req_forca INTEGER,
    p_req_fe INTEGER,
    p_req_dex INTEGER,
    p_melhoria INTEGER,
    p_peso NUMERIC,
    p_custo_melhoria NUMERIC,
    p_resistencia INTEGER,
     p_atributo_extra INTEGER
) 
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_armadura INTEGER;
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
    -- Inserção na tabela armadura com id_equipamento e captura do id_armadura
    INSERT INTO armadura (id_armadura, req_int, req_forca, req_fe, req_dex, melhoria, peso, custo_melhoria, resistencia)
    SELECT id_equipamento, p_req_int, p_req_forca, p_req_fe, p_req_dex, p_melhoria, p_peso, p_custo_melhoria, p_resistencia
    FROM new_equipamento
    RETURNING id_armadura INTO v_id_armadura;

    -- Inserção na tabela engaste com id_arma sendo o id da armadura
    INSERT INTO engaste (id_arma, atributo_extra)
    VALUES (v_id_armadura, p_atributo_extra);

    -- Retorna o id da armadura inserida
    RETURN v_id_armadura;
END;
$$;

SELECT add_armadura(
    p_nome := 'Armadura de Bode-Touro',
    p_raridade := 4,
    p_valor := 150,
    p_tipo_item := 'Equipamento'::tipo_item,
    p_tipo_equipamento := 'Armadura'::tipo_equipamento,
    p_peso := 4,
    p_req_int := 5,
    p_req_forca := 10,
    p_req_fe := 6,
    p_req_dex := 12,
	p_melhoria := 50,
    p_custo_melhoria:= 100,
    p_resistencia := 50,
    p_atributo_extra := 5 
);

SELECT add_armadura(
    p_nome := 'Conjunto de Cavaleiro Banido',
    p_raridade := 2,
    p_valor := 50,
    p_tipo_item := 'Equipamento'::tipo_item,
    p_tipo_equipamento := 'Armadura'::tipo_equipamento,
    p_peso := 4,
    p_req_int := 6,
    p_req_forca := 7,
    p_req_fe := 6,
    p_req_dex := 6,
	p_melhoria := 10,
    p_custo_melhoria:= 30,
    p_resistencia := 10,
    p_atributo_extra := 4
);

CREATE OR REPLACE FUNCTION add_arma_pesada(
    p_nome VARCHAR,
    p_raridade INTEGER,
    p_valor NUMERIC,
    p_tipo_item tipo_item,
    p_tipo_equipamento tipo_equipamento,
    p_req_int INTEGER,
    p_req_forca INTEGER,
    p_req_fe INTEGER,
    p_req_dex INTEGER,
    p_melhoria INTEGER,
    p_peso NUMERIC,
    p_custo_melhoria NUMERIC,
    p_habilidade INTEGER,
	p_dano INTEGER,
	p_critico INTEGER,
	p_forca tipo_proficiencia,
    p_atributo_extra INTEGER
) 
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_arma_pesada INTEGER;
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
    -- Inserção na tabela arma pesada com id_equipamento e captura do id_arma_pesada
    INSERT INTO arma_pesada (id_arma_pesada, req_int, req_forca, req_fe, req_dex, melhoria, peso, custo_melhoria, habilidade, dano, critico, forca)
    SELECT id_equipamento, p_req_int, p_req_forca, p_req_fe, p_req_dex, p_melhoria, p_peso, p_custo_melhoria, p_habilidade, p_dano, p_critico, p_forca
    FROM new_equipamento
    RETURNING id_arma_pesada INTO v_id_arma_pesada;

    -- Inserção na tabela engaste com id_arma sendo o id da arma pesada
    INSERT INTO engaste (id_arma, atributo_extra)
    VALUES (v_id_arma_pesada, p_atributo_extra);

    -- Retorna o id da arma pesada inserida
    RETURN v_id_arma_pesada;
END;
$$;

SELECT add_arma_pesada (
    p_nome := 'Velvet Sword of St. Trina',
    p_raridade := 3,
    p_valor := 70,
    p_tipo_item := 'Equipamento',
    p_tipo_equipamento := 'Pesada',
    p_req_int := 2,
    p_req_forca := 8,
    p_req_fe := 3,
    p_req_dex := 6,
    p_melhoria := 8,
    p_peso := 3,
    p_custo_melhoria := 20,
    p_habilidade := 30,
	p_dano := 180,
	p_critico := 50,
	p_forca := 'C'::tipo_proficiencia,
    p_atributo_extra := 5 
);

SELECT add_arma_pesada (
    p_nome := 'Sword of Darkness',
    p_raridade := 4,
    p_valor := 100,
    p_tipo_item := 'Equipamento',
    p_tipo_equipamento := 'Pesada',
    p_req_int := 4,
    p_req_forca := 12,
    p_req_fe := 4,
    p_req_dex := 6,
    p_melhoria := 10,
    p_peso := 4,
    p_custo_melhoria := 30,
    p_habilidade := 40,
	p_dano := 200,
	p_critico := 60,
	p_forca := 'A'::tipo_proficiencia,
    p_atributo_extra := 2
);

CREATE OR REPLACE FUNCTION add_cajado(
    p_nome VARCHAR,
    p_raridade INTEGER,
    p_valor NUMERIC,
    p_tipo_item tipo_item,
    p_tipo_equipamento tipo_equipamento,
    p_req_int INTEGER,
    p_req_forca INTEGER,
    p_req_fe INTEGER,
    p_req_dex INTEGER,
    p_melhoria INTEGER, 
    p_peso NUMERIC,
    p_custo_melhoria NUMERIC,
    p_habilidade INTEGER,
	p_dano INTEGER,
	p_critico INTEGER,
	p_proficiencia tipo_proficiencia,
    p_atributo_extra INTEGER
) 
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_cajado INTEGER;
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
    -- Inserção na tabela cajado com id_equipamento e captura do id_cajado
    INSERT INTO cajado (id_cajado, req_int, req_forca, req_fe, req_dex, melhoria, peso, custo_melhoria, habilidade, dano, critico, proficiencia)
    SELECT id_equipamento, p_req_int, p_req_forca, p_req_fe, p_req_dex, p_melhoria, p_peso, p_custo_melhoria, p_habilidade, p_dano, p_critico, p_proficiencia
    FROM new_equipamento
    RETURNING id_cajado INTO v_id_cajado;

    -- Inserção na tabela engaste com id_arma sendo o id do cajado
    INSERT INTO engaste (id_arma, atributo_extra)
    VALUES (v_id_cajado, p_atributo_extra);

    -- Retorna o id do cajado inserida
    RETURN v_id_cajado;
END;
$$;

SELECT add_cajado (
    p_nome := 'Lusats Glintstone Staff',
    p_raridade := 4,
    p_valor := 100,
    p_tipo_item := 'Equipamento',
    p_tipo_equipamento := 'Cajado',
    p_req_int := 9,
    p_req_forca := 7,
    p_req_fe := 6,
    p_req_dex := 5,
    p_melhoria := 10,
    p_peso := 4,
    p_custo_melhoria := 30,
    p_habilidade := 40,
	p_dano := 105,
	p_critico := 60,
	p_proficiencia := 'C',
    p_atributo_extra := 5 
);

SELECT add_cajado (
    p_nome := 'Prince of Deaths Staff',
    p_raridade := 5,
    p_valor := 130,
    p_tipo_item := 'Equipamento',
    p_tipo_equipamento := 'Cajado',
    p_req_int := 9,
    p_req_forca := 7,
    p_req_fe := 6,
    p_req_dex := 5,
    p_melhoria := 5,
    p_peso := 2,
    p_custo_melhoria := 20,
    p_habilidade := 20,
	p_dano := 80,
	p_critico := 30,
	p_proficiencia := 'E',
    p_atributo_extra := 2
);

CREATE OR REPLACE FUNCTION add_selo(
    p_nome VARCHAR,
    p_raridade INTEGER,
    p_valor NUMERIC,
    p_tipo_item tipo_item,
    p_tipo_equipamento tipo_equipamento,
    p_req_int INTEGER,
    p_req_forca INTEGER,
    p_req_fe INTEGER,
    p_req_dex INTEGER,
    p_melhoria INTEGER, 
    p_peso NUMERIC,
    p_custo_melhoria NUMERIC,
    p_habilidade INTEGER,
	p_dano INTEGER,
	p_critico INTEGER,
	p_milagre tipo_proficiencia,
    p_atributo_extra INTEGER

) 
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_selo INTEGER;
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
    -- Inserção na tabela cajado com id_equipamento e captura do selo
    INSERT INTO selo (id_selo, req_int, req_forca, req_fe, req_dex, melhoria, peso, custo_melhoria, habilidade, dano, critico, milagre)
    SELECT id_equipamento, p_req_int, p_req_forca, p_req_fe, p_req_dex, p_melhoria, p_peso, p_custo_melhoria, p_habilidade, p_dano, p_critico, p_milagre
    FROM new_equipamento
    RETURNING id_selo INTO v_id_selo;

    -- Inserção na tabela engaste com id_arma sendo o id do selo
    INSERT INTO engaste (id_arma, atributo_extra)
    VALUES (v_id_selo, p_atributo_extra);

    -- Retorna o id do cajado inserida
    RETURN v_id_selo;
END;
$$;

SELECT add_selo (
    p_nome := 'Radagons Soreseal',
    p_raridade := 5,
    p_valor := 130,
    p_tipo_item := 'Equipamento',
    p_tipo_equipamento := 'Selo',
    p_req_int := 5,
    p_req_forca := 3,
    p_req_fe := 8,
    p_req_dex := 5,
    p_melhoria := 5,
    p_peso := 2,
    p_custo_melhoria := 20,
    p_habilidade := 20,
	p_dano := 95,
	p_critico := 30,
	p_milagre := 'C'::tipo_proficiencia,
    p_atributo_extra := 1
);

SELECT add_selo (
    p_nome := 'Dragon Communion Seal',
    p_raridade := 4,
    p_valor := 80,
    p_tipo_item := 'Equipamento',
    p_tipo_equipamento := 'Selo',
    p_req_int := 6,
    p_req_forca := 2,
    p_req_fe := 10,
    p_req_dex := 7,
    p_melhoria := 4,
    p_peso := 1,
    p_custo_melhoria := 10,
    p_habilidade := 25,
	p_dano := 135,
	p_critico := 40,
	p_milagre := 'A'::tipo_proficiencia,
    p_atributo_extra := 3 
);

-- PARA USAR NO TRIGGER - EQUIPADOS INICIAIS
SELECT add_arma_leve(
    'Espada Longa', 1, 200, 'Equipamento'::tipo_item, 'Leve'::tipo_equipamento,
    5, 5, 5, 5, 0, 5, 6, 110, 70, 100, 'D'::tipo_proficiencia
) AS id_arma_leve;

SELECT add_armadura(
    p_nome := 'Armadura Vagabunda',
    p_raridade := 1,
    p_valor := 200,
    p_tipo_item := 'Equipamento'::tipo_item,
    p_tipo_equipamento := 'Armadura'::tipo_equipamento,
    p_peso := 4,
    p_req_int := 5,
    p_req_forca := 5,
    p_req_fe := 5,
    p_req_dex := 5,
	p_melhoria := 50,
    p_custo_melhoria:= 100,
    p_resistencia := 50,
    p_atributo_extra := 5 
);

-- TRIGGER - Adiciona equipamento inicial no jogador
CREATE OR REPLACE FUNCTION equipamento_inicial()
RETURNS TRIGGER AS $$
DECLARE
    instancia_nova_id INTEGER;
    instancia_nova_id2 INTEGER;
BEGIN
    -- Insere os itens na tabela instancia_de_item
    INSERT INTO instancia_de_item (id_item) VALUES (23);
    INSERT INTO instancia_de_item (id_item) VALUES (24);

    -- Obtém os IDs das novas instâncias de item
    SELECT id_instancia_item INTO instancia_nova_id FROM instancia_de_item WHERE id_item = 23 ORDER BY id_instancia_item DESC LIMIT 1;
    SELECT id_instancia_item INTO instancia_nova_id2 FROM instancia_de_item WHERE id_item = 24 ORDER BY id_instancia_item DESC LIMIT 1;

    -- Insere as localizações na tabela localização_da_instancia_de_item
    INSERT INTO localização_da_instancia_de_item (id_instancia_item, area, inventario_jogador)
    VALUES (instancia_nova_id, NULL, NEW.id_jogador);

    INSERT INTO localização_da_instancia_de_item (id_instancia_item, area, inventario_jogador)
    VALUES (instancia_nova_id2, NULL, NEW.id_jogador);

    -- Insere os dados na tabela equipados
    INSERT INTO equipados (id_jogador, mao_direita, mao_esquerda, armadura)
    VALUES (NEW.id_jogador, 23, NULL, 24);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_equipamento_inicial ON jogador;
CREATE TRIGGER trigger_equipamento_inicial
AFTER INSERT ON jogador
FOR EACH ROW
EXECUTE FUNCTION equipamento_inicial();

-- TRIGGER Verificar se equipamento existe no inventario do jogador
CREATE OR REPLACE FUNCTION validar_equipamentos()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se a instância do item da mão direita está associada ao jogador
    IF NEW.mao_direita IS NOT NULL AND NOT EXISTS (
        SELECT 1
        FROM localização_da_instancia_de_item
        WHERE id_instancia_item = NEW.mao_direita
          AND inventario_jogador = NEW.id_jogador
    ) THEN
        RAISE EXCEPTION 'Instância do item % (mão direita) não está associada ao jogador %', NEW.mao_direita, NEW.id_jogador;
    END IF;

    -- Verifica se a instância do item da mão esquerda está associada ao jogador
    IF NEW.mao_esquerda IS NOT NULL AND NOT EXISTS (
        SELECT 1
        FROM localização_da_instancia_de_item
        WHERE id_instancia_item = NEW.mao_esquerda
          AND inventario_jogador = NEW.id_jogador
    ) THEN
        RAISE EXCEPTION 'Instância do item % (mão esquerda) não está associada ao jogador %', NEW.mao_esquerda, NEW.id_jogador;
    END IF;

    -- Verifica se a instância do item de armadura está associada ao jogador
    IF NEW.armadura IS NOT NULL AND NOT EXISTS (
        SELECT 1
        FROM localização_da_instancia_de_item
        WHERE id_instancia_item = NEW.armadura
          AND inventario_jogador = NEW.id_jogador
    ) THEN
        RAISE EXCEPTION 'Instância do item % (armadura) não está associada ao jogador %', NEW.armadura, NEW.id_jogador;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_validar_equipamentos ON equipados;
CREATE TRIGGER trigger_validar_equipamentos
BEFORE UPDATE ON equipados
FOR EACH ROW
EXECUTE FUNCTION validar_equipamentos();
