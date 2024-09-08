CREATE OR REPLACE PROCEDURE ATACA_COM_EQUIPAMENTO_NPC(
    v_id_jogador INTEGER, 
    v_id_instancia_npc INTEGER, 
    v_id_equipamento INTEGER, 
    v_tipo_ataque BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_dano_base INTEGER;
    v_hp_atual INTEGER;
    v_hp_original INTEGER;
    v_resistencia_npc INTEGER;
    v_dano_total INTEGER;
    v_tipo_equipamento tipo_equipamento;
    v_atributo_scaling INTEGER;
    v_proficiencia tipo_proficiencia;
    v_scaling_factor INTEGER;
    v_nivel_p INTEGER;
    v_nome VARCHAR(35);
    v_critico INTEGER;
    v_critical_hit BOOLEAN;
    v_id INTEGER;
    v_stamina_atual INTEGER;
    v_funcao_npc funcao_p;
    v_multiplicador REAL := 1.0;
    v_drop_runas INTEGER;
BEGIN
    SELECT e.tipo INTO v_tipo_equipamento
    FROM equipamento e
    WHERE e.id_equipamento = v_id_equipamento;

    CASE v_tipo_equipamento
        WHEN 'Pesada' THEN
            SELECT a.dano, a.forca, a.critico INTO v_dano_base, v_proficiencia, v_critico
            FROM arma_pesada a
            WHERE a.id_arma_pesada = v_id_equipamento;
            SELECT j.forca INTO v_atributo_scaling
            FROM jogador j
            WHERE j.id_jogador = v_id_jogador;

        WHEN 'Leve' THEN
            SELECT a.dano, a.destreza INTO v_dano_base, v_proficiencia
            FROM arma_leve a
            WHERE a.id_arma_leve = v_id_equipamento;
            SELECT j.destreza INTO v_atributo_scaling
            FROM jogador j
            WHERE j.id_jogador = v_id_jogador;

        WHEN 'Cajado' THEN
            SELECT a.dano, a.proficiencia INTO v_dano_base, v_proficiencia
            FROM cajado a
            WHERE a.id_cajado = v_id_equipamento;
            SELECT j.intel INTO v_atributo_scaling
            FROM jogador j
            WHERE j.id_jogador = v_id_jogador;

        WHEN 'Selo' THEN
            SELECT a.dano, a.milagre INTO v_dano_base, v_proficiencia
            FROM selo a
            WHERE a.id_selo = v_id_equipamento;
            SELECT j.fe INTO v_atributo_scaling
            FROM jogador j
            WHERE j.id_jogador = v_id_jogador;
        ELSE
            RAISE EXCEPTION 'Tipo de equipamento não suporta ataque.';
    END CASE;

    CASE v_proficiencia
        WHEN 'E' THEN v_scaling_factor := v_atributo_scaling / 2;
        WHEN 'D' THEN v_scaling_factor := v_atributo_scaling;
        WHEN 'C' THEN v_scaling_factor := v_atributo_scaling;
        WHEN 'B' THEN v_scaling_factor := v_atributo_scaling * 2;
        WHEN 'A' THEN v_scaling_factor := v_atributo_scaling * 2;
        WHEN 'S' THEN v_scaling_factor := v_atributo_scaling * 3;
        ELSE
            v_scaling_factor := 0;
    END CASE;

    SELECT i.hp_atual, n.resistencia, n.hp, n.nome, n.drop_runas, i.id_npc INTO v_hp_atual, v_resistencia_npc, v_hp_original, v_nome, v_drop_runas, v_id
    FROM instancia_npc i
    JOIN npc n ON i.id_npc = n.id_npc
    WHERE i.id_instancia = v_id_instancia_npc;

    SELECT j.nivel_atual, j.st_atual INTO v_nivel_p, v_stamina_atual
    FROM jogador j
    WHERE j.id_jogador = v_id_jogador;

    IF v_stamina_atual < 20 THEN
        RAISE EXCEPTION 'Stamina insuficiente para realizar o ataque.';
    END IF;

    IF v_tipo_ataque = TRUE THEN
        v_multiplicador := 1.3;
    ELSE
        v_multiplicador := 0.9;
    END IF;

    v_dano_total := (v_dano_base * v_atributo_scaling * 7 + v_scaling_factor) * v_multiplicador / (v_resistencia_npc / 3);

    v_critical_hit := (random() < 0.05);

    IF v_critical_hit THEN
        v_dano_total := v_dano_total * 2;
        RAISE NOTICE 'Ataque crítico! O inimigo sofreu % de dano.', v_dano_total;
    ELSE
        RAISE NOTICE 'O inimigo sofreu % de dano.', v_dano_total;
    END IF;

    v_hp_atual := v_hp_atual - v_dano_total;

    SELECT funcao INTO v_funcao_npc
    FROM funcao_npc
    WHERE id_npc = v_id;

    IF v_hp_atual <= 0 THEN
        IF v_funcao_npc = 'Chefe' THEN
            RAISE NOTICE '% foi conquistada.', (SELECT lembranca FROM chefe WHERE v_id = chefe.id_chefe);
			RAISE NOTICE 'Você já adquiriu mais um fragmento do Medalhão de Dectos.';
			RAISE NOTICE 'Você recebeu +% runas extras por derrotar um chefe.', v_drop_runas*0.8;
			v_drop_runas := v_drop_runas*1.8;
            INSERT INTO chefes_derrotados (id_chefe, id_jogador) 
            VALUES (v_id, v_id_jogador);
			IF (SELECT COUNT(*) FROM chefes_derrotados WHERE id_jogador = v_id_jogador) >= 3 THEN
				RAISE NOTICE 'Você adquiriu todos os fragmentos, dirija-se ao elevador para prosseguir.';
			END IF;
        END IF;

        UPDATE instancia_npc 
        SET hp_atual = v_hp_original
        WHERE id_instancia = v_id_instancia_npc;

        RAISE NOTICE 'O inimigo % foi derrotado.', v_nome;
        INSERT INTO npc_morto (id_jogador, id_instancia_npc)
        VALUES (v_id_jogador, v_id_instancia_npc);

        RAISE NOTICE 'Você recebeu um total de +% runas.', v_drop_runas;
        UPDATE jogador
        SET runas_atuais = runas_atuais + v_drop_runas
        WHERE id_jogador = v_id_jogador;
    ELSE
        RAISE NOTICE 'A vida atual do inimigo é de %.', v_hp_atual;
        UPDATE instancia_npc 
        SET hp_atual = v_hp_atual 
        WHERE id_instancia = v_id_instancia_npc;
    END IF;

    UPDATE jogador
    SET st_atual = st_atual - 20
    WHERE id_jogador = v_id_jogador;
END;
$$;


-- CALL ATACA_COM_EQUIPAMENTO_NPC(15, 12, 30, FALSE);


CREATE OR REPLACE PROCEDURE realizar_ataque(instancia INTEGER, alvo INTEGER, ataque_forte BOOLEAN)
LANGUAGE plpgsql AS $$
DECLARE
    v_funcao funcao_p;
    v_dano_base INTEGER;
    v_dano_total INTEGER;
    v_nivel_jogador INTEGER;
    v_hp_atual_jogador INTEGER;
    v_hp_atual_npc INTEGER;
    v_nome_jogador VARCHAR(30);
    v_nome_npc VARCHAR(30);
    v_id_npc INTEGER;
    v_chance_erro NUMERIC;
	v_balanceamento BOOLEAN := FALSE;
BEGIN
    SELECT id_npc, hp_atual INTO v_id_npc, v_hp_atual_npc 
    FROM instancia_npc 
    WHERE instancia_npc.id_instancia = instancia;

    SELECT funcao INTO v_funcao FROM funcao_npc WHERE id_npc = v_id_npc;

    IF v_funcao NOT IN ('Inimigo', 'Chefe') THEN
        RAISE EXCEPTION 'O NPC com id % não pode atacar, função: %', v_id_npc, v_funcao;
    END IF;

    IF v_funcao = 'Inimigo' THEN
        SELECT dano_base, nome INTO v_dano_base, v_nome_npc FROM inimigo WHERE id_inimigo = v_id_npc;
    ELSIF v_funcao = 'Chefe' THEN
		v_balanceamento := TRUE;
        SELECT dano_base, nome INTO v_dano_base, v_nome_npc FROM chefe WHERE id_chefe = v_id_npc;
    END IF;

    SELECT nivel_atual, hp_atual, nome INTO v_nivel_jogador, v_hp_atual_jogador, v_nome_jogador FROM jogador WHERE id_jogador = alvo;

    v_chance_erro := random();
    IF v_chance_erro <= 0.2 THEN
        RAISE NOTICE 'O ataque falhou!';
        RETURN;
    END IF;

	
    IF ataque_forte THEN
        v_dano_total := (v_dano_base * 40.3) / (v_nivel_jogador); 
    ELSE
        v_dano_total := (v_dano_base * 33.9) / (v_nivel_jogador); 
    END IF;
	IF v_balanceamento=TRUE THEN
		v_dano_total := v_dano_total*0.8;
	END IF;
    v_hp_atual_jogador := v_hp_atual_jogador - v_dano_total;

    UPDATE jogador SET hp_atual = v_hp_atual_jogador WHERE id_jogador = alvo;
    RAISE NOTICE 'O jogador % sofreu % de dano.', v_nome_jogador, v_dano_total;
    IF v_hp_atual_jogador <= 0 THEN
        RAISE NOTICE 'O jogador % foi derrotado.', v_nome_jogador;
    ELSE
        RAISE NOTICE 'A vida atual do jogador é de %.', v_hp_atual_jogador;
    END IF;

END;
$$;

-- CALL realizar_ataque(5, 12, FALSE);

CREATE OR REPLACE FUNCTION update_jogador() RETURNS trigger AS $update_jogador$
BEGIN
	PERFORM * FROM jogador WHERE jogador.id_jogador = OLD.id_jogador;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'Este jogador não existe.';
	END IF;
    IF (OLD.id_jogador <> NEW.id_jogador) THEN
        RAISE EXCEPTION 'Não pode alterar o id.';
    END IF;
    IF (OLD.hp_atual <> NEW.hp_atual) THEN
        IF(OLD.hp_atual < NEW.hp_atual) THEN
            NEW.hp_atual := LEAST(OLD.hp, NEW.hp_atual);
        ELSE
            IF NEW.hp_atual <= 0 THEN
                IF (SELECT COUNT(*) FROM area_de_morte WHERE id_jogador = NEW.id_jogador) > 0 THEN
                    DELETE FROM area_de_morte WHERE id_jogador = NEW.id_jogador;
                END IF;
                INSERT INTO area_de_morte (id_jogador, id_area, runas_dropadas) VALUES (NEW.id_jogador, NEW.id_area, NEW.runas_atuais);
                NEW.runas_atuais := 0;
				 NEW.hp_atual := OLD.hp;
				 NEW.id_area := 1;
            END IF;
        END IF;
    END IF;
	IF (OLD.st_atual <> NEW.st_atual) THEN
		IF(NEW.st_atual<OLD.st_atual) THEN
			NEW.st_atual = GREATEST(NEW.st_atual, 0);
		ELSE
			NEW.st_atual = LEAST(NEW.st_atual, OLD.stamina);
		END IF;
	END IF;
	RETURN NEW;
END;
$update_jogador$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_jogador
BEFORE UPDATE ON jogador
FOR EACH ROW EXECUTE PROCEDURE update_jogador();
