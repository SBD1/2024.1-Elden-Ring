CREATE OR REPLACE PROCEDURE ATACA_COM_EQUIPAMENTO_NPC(
    v_id_jogador INTEGER, 
    v_id_instancia_npc INTEGER, 
    v_id_equipamento INTEGER
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

    SELECT i.hp_atual, n.resistencia, n.hp, n.nome, i.id_npc INTO v_hp_atual, v_resistencia_npc, v_hp_original, v_nome, v_id
    FROM instancia_npc i
    JOIN npc n ON i.id_npc = n.id_npc
    WHERE i.id_instancia = v_id_instancia_npc;
    SELECT j.nivel_atual, j.st_atual INTO v_nivel_p, v_stamina_atual
    FROM jogador j
    WHERE j.id_jogador = v_id_jogador;

    IF v_stamina_atual < 20 THEN
        RAISE EXCEPTION 'Stamina insuficiente para realizar o ataque.';
    END IF;

    v_dano_total := (v_dano_base * v_atributo_scaling * 7 + v_scaling_factor) / (v_resistencia_npc / 3);

    v_critical_hit := (random() < 0.05);

    IF v_critical_hit THEN
        v_dano_total := v_dano_total * 2;
        RAISE NOTICE 'Ataque crítico! O inimigo sofreu % de dano.', v_dano_total;
    ELSE
        RAISE NOTICE 'O inimigo sofreu % de dano.', v_dano_total;
    END IF;

    v_hp_atual := v_hp_atual - v_dano_total;

    IF v_hp_atual <= 0 THEN
        UPDATE instancia_npc 
        SET hp_atual = v_hp_original
        WHERE id_instancia = v_id_instancia_npc;
        RAISE NOTICE 'O inimigo % foi derrotado.', v_nome;
        INSERT INTO npc_morto (id_jogador, id_instancia_npc)
        VALUES (v_id_jogador, v_id_instancia_npc);
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

-- CALL ATACA_COM_EQUIPAMENTO_NPC(14, 2, 21);
