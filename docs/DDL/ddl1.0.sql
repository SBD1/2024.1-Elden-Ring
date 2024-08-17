CREATE TYPE funcao_p AS ENUM ('Inimigo', 'Ferreiro', 'Chefe', 'Mercador', 'Campones');

CREATE TYPE tipo_atk AS ENUM ('Fogo', 'Raio', 'Magia', 'Cortante', 'Contusao');

CREATE TYPE tipo_p AS ENUM ('Jogavel', 'Njogavel');

CREATE TYPE tipo_equipamento AS ENUM ('Escudo', 'Arma', 'Armadura');

CREATE TYPE tipo_item AS ENUM ('Consumivel', 'Equipamento');

CREATE TYPE tipo_proeficiencia AS ENUM ('E', 'D', 'C', 'B', 'A', 'S');

CREATE TYPE tipo_efeitos AS ENUM ('RestauraHp', 'AumentaVida', 'AumentaAtaque', 'AumentaDefesa', 'GanhaRunas');

create type tipo_seccoes AS ENUM('Arma', 'Equipamento', 'Consumivel', '', 'GanhaRunas')

CREATE TABLE IF NOT EXISTS personagem (
    id_personagem SERIAL PRIMARY KEY,
    tipo tipo_p NOT NULL
);

CREATE TABLE IF NOT EXISTS funcao_npc (
    id_npc INTEGER,
    funcao funcao_p,
    PRIMARY KEY(id_npc, funcao),
    CONSTRAINT fk_npc_funcao FOREIGN KEY(id_npc) REFERENCES personagem(id_personagem)
);

CREATE TABLE IF NOT EXISTS npc (
    id_npc INTEGER PRIMARY KEY REFERENCES personagem(id_personagem),
    nome CHAR(25) NOT NULL,
    hp INTEGER NOT NULL,
    funcao funcao_p NOT NULL,
    esta_hostil BOOLEAN NOT NULL,
    resistencia INTEGER NOT NULL,
    fraquezas tipo_atk,
    drop_runas INTEGER NOT NULL,
    CONSTRAINT chk_hp CHECK (hp >= 1),
    CONSTRAINT chk_drop_runas CHECK (drop_runas >= 0),
    CONSTRAINT fk_npc_funcao FOREIGN KEY(id_npc, funcao) REFERENCES funcao_npc(id_npc, funcao)
);

CREATE TABLE IF NOT EXISTS inimigo (
    id_inimigo INTEGER PRIMARY KEY REFERENCES npc(id_npc),
    nome CHAR(25) NOT NULL,
    hp INTEGER NOT NULL,
    dano_base INTEGER NOT NULL,
    CONSTRAINT chk_hp CHECK (hp >= 1),
    CONSTRAINT chk_dano_base CHECK (dano_base >= 0)
);

CREATE TABLE IF NOT EXISTS chefe (
    id_chefe INTEGER PRIMARY KEY REFERENCES npc(id_npc),
    nome CHAR(25) NOT NULL,
    hp INTEGER NOT NULL,
    dano_base INTEGER NOT NULL,
    lembranca CHAR(25) NOT NULL,
    desperate_move INTEGER NOT NULL,
    CONSTRAINT chk_hp CHECK (hp >= 1),
    CONSTRAINT chk_dano_base_chefe CHECK (dano_base >= 0)
);

CREATE TABLE IF NOT EXISTS regiao (
    id_regiao SERIAL PRIMARY KEY,
    nome CHAR(25) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS area (
    id_area SERIAL PRIMARY KEY,
    nome CHAR(25) UNIQUE NOT NULL,
    id_regiao INTEGER REFERENCES regiao(id_regiao)
);

CREATE TABLE IF NOT EXISTS ferreiro (
    id_ferreiro INTEGER PRIMARY KEY REFERENCES npc(id_npc),
    nome CHAR(25) NOT NULL,
    hp INTEGER NOT NULL,
    CONSTRAINT chk_hp CHECK (hp >= 1)
);

CREATE TABLE IF NOT EXISTS classe (
    nome CHAR(14) PRIMARY KEY,
    base_vit INTEGER NOT NULL,
    base_vig INTEGER NOT NULL,
    base_int INTEGER NOT NULL,
    base_fe INTEGER NOT NULL,
    base_dex INTEGER NOT NULL,
    base_str INTEGER NOT NULL,
    CONSTRAINT chk_base_vit CHECK (base_vit >= 0),
    CONSTRAINT chk_base_vig CHECK (base_vig >= 0),
    CONSTRAINT chk_base_int CHECK (base_int >= 0),
    CONSTRAINT chk_base_fe CHECK (base_fe >= 0),
    CONSTRAINT chk_base_dex CHECK (base_dex >= 0),
    CONSTRAINT chk_base_str CHECK (base_str >= 0)
);

CREATE TABLE IF NOT EXISTS nivel (
    id_nivel SERIAL PRIMARY KEY,
    nro_nivel INTEGER NOT NULL,
    runas INTEGER NOT NULL,
    CONSTRAINT chk_nro_nivel CHECK (nro_nivel >= 0),
    CONSTRAINT chk_runas CHECK (runas >= 0)
);

CREATE TABLE IF NOT EXISTS jogador (
    id_jogador INTEGER PRIMARY KEY REFERENCES personagem(id_personagem),
    nome CHAR(25) NOT NULL,
    hp INTEGER NOT NULL,
    id_nivel INTEGER REFERENCES nivel(id_nivel),
    id_classe CHAR(14) REFERENCES classe(nome),
    id_area INTEGER REFERENCES area(id_area),
    vigor INTEGER NOT NULL,
    vitalidade INTEGER NOT NULL,
    intel INTEGER NOT NULL,
    fe INTEGER NOT NULL,
    destreza INTEGER NOT NULL,
    forca INTEGER NOT NULL,
    peso_max INTEGER NOT NULL,
    stamina INTEGER NOT NULL,
    mp INTEGER NOT NULL,
    nivel_atual INTEGER NOT NULL,
    CONSTRAINT chk_hp CHECK (hp >= 1),
    CONSTRAINT chk_nivel_atual CHECK (nivel_atual >= 1),
    CONSTRAINT chk_vigor CHECK (vigor >= 1),
    CONSTRAINT chk_vitalidade CHECK (vitalidade >= 1),
    CONSTRAINT chk_intel CHECK (intel >= 1),
    CONSTRAINT chk_fe CHECK (fe >= 1),
    CONSTRAINT chk_destreza CHECK (destreza >= 1),
    CONSTRAINT chk_forca CHECK (forca >= 1),
    CONSTRAINT chk_peso_max CHECK (peso_max >= 1),
    CONSTRAINT chk_mp CHECK (mp >= 1),
    CONSTRAINT chk_stamina CHECK (stamina >= 1)
);

CREATE TABLE IF NOT EXISTS area_de_morte (
    id_area_de_morte SERIAL PRIMARY KEY,
    id_jogador INTEGER REFERENCES jogador(id_jogador),
    id_area INTEGER REFERENCES area(id_area),
    runas_dropadas INTEGER NOT NULL,
    CONSTRAINT chk_runas_dropadas CHECK (runas_dropadas >= 0)
);

CREATE TABLE IF NOT EXISTS conecta_area (
    id_origem INTEGER REFERENCES area(id_area),
    id_destino INTEGER REFERENCES area(id_area),
    PRIMARY KEY (id_origem, id_destino)
);

CREATE TABLE IF NOT EXISTS realiza (
    id_golpes SERIAL PRIMARY KEY,
    id_npc INTEGER REFERENCES npc(id_npc),
    multiplicador INTEGER NOT NULL,
    dano_final INTEGER NOT NULL,
    CONSTRAINT chk_multiplicador CHECK (multiplicador >= 1),
    CONSTRAINT chk_dano_final CHECK (dano_final >= 1)
);

-- PARTE DOS ITENS E INVENTÁRIO
CREATE TABLE IF NOT EXISTS item (
    id_item SERIAL PRIMARY KEY,
    eh_chave BOOLEAN NOT NULL,
    raridade INTEGER NOT NULL,
    nome CHAR(25) NOT NULL,
    valor INTEGER,
    tipo tipo_item,
    CHECK (
    	(eh_chave = TRUE AND tipo IS NULL) OR 
    	(eh_chave = FALSE AND tipo IS NOT NULL) or 
    	(eh_chave = FALSE AND tipo is NULL)
    )
);

CREATE TABLE IF NOT EXISTS consumivel (
    id_consumivel INTEGER PRIMARY KEY REFERENCES item(id_item),
    efeito tipo_efeitos NOT NULL,
    qtd_do_efeito INTEGER NOT NULL,
    descricao VARCHAR(200) NOT NULL,
    duracao INTEGER NOT NULL,
    CONSTRAINT chk_qtd_do_efeito CHECK (qtd_do_efeito >= 1),
    CONSTRAINT chk_duracao CHECK (duracao >= 1)
);


CREATE TABLE IF NOT EXISTS instancia_de_item (
    id_instancia SERIAL PRIMARY KEY,
    id_item INTEGER REFERENCES item(id_item),
    id_area INTEGER REFERENCES area(id_area),
    id_inventario INTEGER REFERENCES inventario(id_usuario),
    CHECK (
        (id_area IS NOT NULL AND id_inventario IS NULL) OR 
        (id_inventario IS NOT NULL AND id_area IS NULL) OR
        (id_inventario IS NOT NULL AND id_area IS NOT NULL)
    )
);

--CREATE TABLE IF NOT EXISTS inventario (
--    id_usuario INTEGER PRIMARY KEY REFERENCES personagem(id_personagem)
--);

CREATE TABLE IF NOT EXISTS inventario (
    id_inventario INTEGER REFERENCES personagem(id_personagem),
    id_item INTEGER REFERENCES item(id_item),
    quantidade INTEGER NOT NULL,
    PRIMARY KEY(id_inventario, id_instancia_item)
);

-- PARTE DO EQUIPAMENTO
CREATE TABLE IF NOT EXISTS equipamento (
    id_equipamento INTEGER PRIMARY KEY REFERENCES item(id_item),
    tipo tipo_equipamento NOT NULL
);

CREATE TABLE IF NOT EXISTS escudo (
    id_escudo INTEGER PRIMARY KEY REFERENCES equipamento(id_equipamento),
    requisitos INTEGER[],
    melhoria INTEGER NOT NULL,
    peso INTEGER NOT NULL,
    custo_melhoria INTEGER NOT NULL,
    habilidade INTEGER NOT NULL,
    defesa INTEGER NOT NULL,
    CONSTRAINT chk_melhoria CHECK (melhoria >= 0),
    CONSTRAINT chk_peso CHECK (peso >= 0),
    CONSTRAINT chk_custo_melhoria CHECK (custo_melhoria >= 1),
    CONSTRAINT chk_requisitos CHECK (array_length(requisitos, 1) = 4),
    CONSTRAINT chk_defesa CHECK (defesa >= 1)
);

CREATE TABLE IF NOT EXISTS armadura (
    id_armadura INTEGER PRIMARY KEY REFERENCES equipamento(id_equipamento),
    requisitos INTEGER[],
    melhoria INTEGER NOT NULL,
    peso INTEGER NOT NULL,
    custo_melhoria INTEGER NOT NULL,
    resistencia INTEGER NOT NULL,
    CONSTRAINT chk_melhoria CHECK (melhoria >= 0),
    CONSTRAINT chk_peso CHECK (peso >= 0),
    CONSTRAINT chk_custo_melhoria CHECK (custo_melhoria >= 1),
    CONSTRAINT chk_requisitos CHECK (array_length(requisitos, 1) = 4),
    CONSTRAINT chk_resistencia CHECK (resistencia >= 1)
);

CREATE TABLE IF NOT EXISTS arma_pesada (
    id_arma_pesada INTEGER PRIMARY KEY REFERENCES equipamento(id_equipamento),
    requisitos INTEGER[],
    melhoria INTEGER NOT NULL,
    peso INTEGER NOT NULL,
    custo_melhoria INTEGER NOT NULL,
    habilidade INTEGER NOT NULL,
    dano INTEGER NOT NULL,
    critico INTEGER,
    forca INTEGER NOT NULL,
    CONSTRAINT chk_melhoria CHECK (melhoria >= 0),
    CONSTRAINT chk_peso CHECK (peso >= 0),
    CONSTRAINT chk_custo_melhoria CHECK (custo_melhoria >= 1),
    CONSTRAINT chk_requisitos CHECK (array_length(requisitos, 1) = 4),
    CONSTRAINT chk_dano CHECK (dano >= 1),
    CONSTRAINT chk_critico CHECK (critico >= 1),
    CONSTRAINT chk_forca CHECK (forca >= 1)
);

CREATE TABLE IF NOT EXISTS arma_leve (
    id_arma_leve INTEGER PRIMARY KEY REFERENCES equipamento(id_equipamento),
    melhoria INTEGER NOT NULL,
    peso INTEGER NOT NULL,
    custo_melhoria INTEGER NOT NULL,
    requisitos INTEGER[],
    habilidade INTEGER NOT NULL,
    dano INTEGER NOT NULL,
    critico INTEGER,
    destreza INTEGER NOT NULL,
    CONSTRAINT chk_melhoria CHECK (melhoria >= 0),
    CONSTRAINT chk_peso CHECK (peso >= 0),
    CONSTRAINT chk_custo_melhoria CHECK (custo_melhoria >= 1),
    CONSTRAINT chk_requisitos CHECK (array_length(requisitos, 1) = 4),
    CONSTRAINT chk_destreza CHECK (destreza >= 1)
);

CREATE TABLE IF NOT EXISTS cajado (
    id_cajado INTEGER PRIMARY KEY REFERENCES equipamento(id_equipamento),
    melhoria INTEGER NOT NULL,
    peso INTEGER NOT NULL,
    custo_melhoria INTEGER NOT NULL,
    requisitos INTEGER[],
    habilidade INTEGER NOT NULL,
    dano INTEGER NOT NULL,
    critico INTEGER,
    proficiencia tipo_proeficiencia NOT null,
    CONSTRAINT chk_melhoria CHECK (melhoria >= 0),
    CONSTRAINT chk_peso CHECK (peso >= 0),
    CONSTRAINT chk_custo_melhoria CHECK (custo_melhoria >= 1),
    CONSTRAINT chk_requisitos CHECK (array_length(requisitos, 1) = 4)
);

CREATE TABLE IF NOT EXISTS selo (
    id_selo INTEGER PRIMARY KEY REFERENCES equipamento(id_equipamento),
    melhoria INTEGER NOT NULL,
    peso INTEGER NOT NULL,
    custo_melhoria INTEGER NOT NULL,
    requisitos INTEGER[],
    habilidade INTEGER NOT NULL,
    dano INTEGER NOT NULL,
    critico INTEGER,
    milagre INTEGER NOT NULL,
    CONSTRAINT chk_melhoria CHECK (melhoria >= 0),
    CONSTRAINT chk_peso CHECK (peso >= 0),
    CONSTRAINT chk_custo_melhoria CHECK (custo_melhoria >= 1),
    CONSTRAINT chk_requisitos CHECK (array_length(requisitos, 1) = 4),
    CONSTRAINT chk_milagre CHECK (milagre >= 1)
);

CREATE TABLE IF NOT EXISTS engaste (
    id_engaste SERIAL PRIMARY KEY,
    id_arma INTEGER REFERENCES equipamento(id_equipamento),
    atributo_extra INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS equipados (
    id_jogador INTEGER PRIMARY KEY REFERENCES jogador(id_jogador),
    mao_direita INTEGER REFERENCES equipamento(id_equipamento),
	mao_esquerda INTEGER REFERENCES equipamento(id_equipamento),
	armadura INTEGER REFERENCES equipamento(id_equipamento),
);

CREATE TABLE IF NOT EXISTS instancia_npc (
    id_instancia SERIAL PRIMARY KEY,
    id_npc INTEGER NOT NULL,
    id_area INTEGER NOT NULL,
    CONSTRAINT fk_npc FOREIGN KEY(id_npc) REFERENCES npc(id_npc),
    CONSTRAINT fk_area FOREIGN KEY(id_area) REFERENCES area(id_area)
);

CREATE TABLE IF NOT EXISTS dialogo (
    id_dialogo SERIAL PRIMARY KEY,
    id_npc INTEGER,
    texto VARCHAR(300) NOT NULL,
    e_unico BOOLEAN NOT NULL,
    CONSTRAINT fk_npc FOREIGN KEY(id_npc) REFERENCES npc(id_npc)
);

CREATE TABLE IF NOT EXISTS chefes_derrotados (
    id_chefe INTEGER REFERENCES chefe(id_chefe),
    id_jogador INTEGER REFERENCES jogador(id_jogador),
    PRIMARY KEY (id_chefe, id_jogador)
);
