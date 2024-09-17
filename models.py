# coding: utf-8
from sqlalchemy import ARRAY, Column, ForeignKeyConstraint, Integer, String, Boolean, ForeignKey, CheckConstraint, PrimaryKeyConstraint, UniqueConstraint
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.dialects import postgresql
from sqlalchemy.dialects.postgresql import ENUM
import sqlalchemy as sa

Base = declarative_base()
metadata = Base.metadata

# Define os enums no Python
funcao_p_enum = ENUM('Inimigo', 'Ferreiro', 'Chefe', 'Mercador', 'Campones', name='funcao_p', create_type=False)
tipo_atk_enum = ENUM('Fogo', 'Raio', 'Magia', 'Cortante', 'Contusao', name='tipo_atk', create_type=False)
tipo_p_enum = ENUM('Jogavel', 'Njogavel', name='tipo_p', create_type=False)
tipo_equipamento_enum = ENUM('Escudo', 'Arma', 'Armadura', name='tipo_equipamento', create_type=False)
tipo_item_enum = ENUM('Consumivel', 'Equipamento', name='tipo_item', create_type=False)
tipo_proeficiencia_enum = ENUM('E', 'D', 'C', 'B', 'A', 'S', name='tipo_proeficiencia', create_type=False)
tipo_efeitos_enum = ENUM('RestauraHp', 'AumentaAtaque', 'AumentaDefesa', 'GanhaRunas', name='tipo_efeitos', create_type=False)

class Personagem(Base):
    __tablename__ = 'personagem'

    id_personagem = Column(
        Integer,
        primary_key=True,
        server_default=sa.text("nextval('personagem_id_personagem_seq'::regclass)"),
        autoincrement=True,
        nullable=False
    )
    tipo = Column(
        postgresql.ENUM('Jogavel', 'Njogavel', name='tipo_p'),
        nullable=False
    )

class FuncaoNpc(Base):
    __tablename__ = 'funcao_npc'

    id_npc = Column(
        Integer,
        ForeignKey('personagem.id_personagem'),
        primary_key=True,
        nullable=False
    )
    funcao = Column(
        postgresql.ENUM('Inimigo', 'Ferreiro', 'Chefe', 'Mercador', 'Campones', name='funcao_p'),
        primary_key=True,
        nullable=False
)
    

class Npc(Base):
    __tablename__ = 'npc'

    id_npc = Column(
        Integer,
        ForeignKey('personagem.id_personagem'),
        primary_key=True,
        nullable=False
    )
    nome = Column(
        String(length=25),
        nullable=False
    )
    hp = Column(
        Integer,
        nullable=False
    )
    funcao = Column(
        postgresql.ENUM('Inimigo', 'Ferreiro', 'Chefe', 'Mercador', 'Campones', name='funcao_p'),
        nullable=False
    )
    esta_hostil = Column(
        Boolean,
        nullable=False
    )
    resistencia = Column(
        Integer,
        nullable=False
    )
    fraquezas = Column(
        postgresql.ENUM('Fogo', 'Raio', 'Magia', 'Cortante', 'Contusao', name='tipo_atk'),
        nullable=True
    )
    drop_runas = Column(
        Integer,
        nullable=False
    )

    __table_args__ = (
        CheckConstraint('drop_runas >= 0', name='chk_drop_runas'),
        CheckConstraint('hp >= 1', name='chk_hp'),
        PrimaryKeyConstraint('id_npc', name='npc_pkey')
    )

class Inimigo(Base):
    __tablename__ = 'inimigo'

    id_inimigo = Column(
        Integer,
        ForeignKey('npc.id_npc'),
        primary_key=True,
        nullable=False
    )
    nome = Column(
        String(length=25),
        nullable=False
    )
    hp = Column(
        Integer,
        nullable=False
    )
    dano_base = Column(
        Integer,
        nullable=False
    )

    __table_args__ = (
        CheckConstraint('dano_base >= 0', name='chk_dano_base'),
        CheckConstraint('hp >= 1', name='chk_hp'),
        PrimaryKeyConstraint('id_inimigo', name='inimigo_pkey')
    )


class Chefe(Base):
    __tablename__ = 'chefe'

    id_chefe = Column(
        Integer,
        ForeignKey('npc.id_npc'),
        primary_key=True,
        nullable=False
    )
    nome = Column(
        String(length=25),
        nullable=False
    )
    hp = Column(
        Integer,
        nullable=False
    )
    dano_base = Column(
        Integer,
        nullable=False
    )
    lembranca = Column(
        String(length=25),
        nullable=False
    )
    desperate_move = Column(
        Integer,
        nullable=False
    )

    __table_args__ = (
        CheckConstraint('dano_base >= 0', name='chk_dano_base_chefe'),
        CheckConstraint('hp >= 1', name='chk_hp'),
        PrimaryKeyConstraint('id_chefe', name='chefe_pkey')
    )

class Regiao(Base):
    __tablename__ = 'regiao'

    id_regiao = Column(
        Integer,
        primary_key=True,
        autoincrement=True,
        nullable=False
    )
    nome = Column(
        String(length=25),
        nullable=False
    )

    __table_args__ = (
        UniqueConstraint('nome', name='regiao_nome_key'),
        PrimaryKeyConstraint('id_regiao', name='regiao_pkey')
    )

class Area(Base):
    __tablename__ = 'area'

    id_area = Column(
        Integer,
        primary_key=True,
        autoincrement=True,
        nullable=False
    )
    nome = Column(
        String(length=25),
        nullable=False
    )
    id_regiao = Column(
        Integer,
        ForeignKey('regiao.id_regiao'),
        nullable=True
    )

class Ferreiro(Base):
    __tablename__ = 'ferreiro'

    id_ferreiro = Column(
        Integer,
        ForeignKey('npc.id_npc'),
        primary_key=True,
        nullable=False
    )
    nome = Column(
        String(length=25),
        nullable=False
    )
    hp = Column(
        Integer,
        nullable=False
    )

    __table_args__ = (
        CheckConstraint('hp >= 1', name='chk_hp'),
        PrimaryKeyConstraint('id_ferreiro', name='ferreiro_pkey')
    )

class Classe(Base):
    __tablename__ = 'classe'

    nome = Column(
        String(length=14),
        primary_key=True,
        nullable=False
    )
    base_vit = Column(
        Integer,
        nullable=False
    )
    base_vig = Column(
        Integer,
        nullable=False
    )
    base_int = Column(
        Integer,
        nullable=False
    )
    base_fe = Column(
        Integer,
        nullable=False
    )
    base_dex = Column(
        Integer,
        nullable=False
    )
    base_str = Column(
        Integer,
        nullable=False
    )

    __table_args__ = (
        CheckConstraint('base_dex >= 0', name='chk_base_dex'),
        CheckConstraint('base_fe >= 0', name='chk_base_fe'),
        CheckConstraint('base_int >= 0', name='chk_base_int'),
        CheckConstraint('base_str >= 0', name='chk_base_str'),
        CheckConstraint('base_vig >= 0', name='chk_base_vig'),
        CheckConstraint('base_vit >= 0', name='chk_base_vit'),
        PrimaryKeyConstraint('nome', name='classe_pkey')
    )

class Nivel(Base):
    __tablename__ = 'nivel'

    id_nivel = Column(
        Integer,
        primary_key=True,
        autoincrement=True,
        nullable=False
    )
    nro_nivel = Column(
        Integer,
        nullable=False
    )
    runas = Column(
        Integer,
        nullable=False
    )

    __table_args__ = (
        CheckConstraint('nro_nivel >= 0', name='chk_nro_nivel'),
        CheckConstraint('runas >= 0', name='chk_runas'),
        PrimaryKeyConstraint('id_nivel', name='nivel_pkey')
    )


class Jogador(Base):
    __tablename__ = 'jogador'

    id_jogador = Column(
        Integer,
        primary_key=True,
        autoincrement=False,
        nullable=False
    )
    nome = Column(
        String(length=25),
        nullable=False
    )
    hp = Column(
        Integer,
        nullable=False
    )
    id_nivel = Column(
        Integer,
        ForeignKey('nivel.id_nivel'),
        nullable=True
    )
    id_classe = Column(
        String(length=14),
        ForeignKey('classe.nome'),
        nullable=True
    )
    id_area = Column(
        Integer,
        ForeignKey('area.id_area'),
        nullable=True
    )
    vigor = Column(
        Integer,
        nullable=False
    )
    vitalidade = Column(
        Integer,
        nullable=False
    )
    intel = Column(
        Integer,
        nullable=False
    )
    fe = Column(
        Integer,
        nullable=False
    )
    destreza = Column(
        Integer,
        nullable=False
    )
    forca = Column(
        Integer,
        nullable=False
    )
    peso_max = Column(
        Integer,
        nullable=False
    )
    stamina = Column(
        Integer,
        nullable=False
    )
    mp = Column(
        Integer,
        nullable=False
    )
    nivel_atual = Column(
        Integer,
        nullable=False
    )

    __table_args__ = (
        CheckConstraint('destreza >= 1', name='chk_destreza'),
        CheckConstraint('fe >= 1', name='chk_fe'),
        CheckConstraint('forca >= 1', name='chk_forca'),
        CheckConstraint('hp >= 1', name='chk_hp'),
        CheckConstraint('intel >= 1', name='chk_intel'),
        CheckConstraint('mp >= 1', name='chk_mp'),
        CheckConstraint('nivel_atual >= 1', name='chk_nivel_atual'),
        CheckConstraint('peso_max >= 1', name='chk_peso_max'),
        CheckConstraint('stamina >= 1', name='chk_stamina'),
        CheckConstraint('vigor >= 1', name='chk_vigor'),
        CheckConstraint('vitalidade >= 1', name='chk_vitalidade'),
        PrimaryKeyConstraint('id_jogador', name='jogador_pkey')
    )

class AreaDeMorte(Base):
    __tablename__ = 'area_de_morte'

    id_area_de_morte = Column(
        Integer,
        primary_key=True,
        autoincrement=True,
        nullable=False
    )
    id_jogador = Column(
        Integer,
        ForeignKey('jogador.id_jogador'),
        nullable=True
    )
    id_area = Column(
        Integer,
        ForeignKey('area.id_area'),
        nullable=True
    )
    runas_dropadas = Column(
        Integer,
        nullable=False
    )

    __table_args__ = (
        CheckConstraint('runas_dropadas >= 0', name='chk_runas_dropadas'),
        PrimaryKeyConstraint('id_area_de_morte', name='area_de_morte_pkey')
    )

class ConectaArea(Base):
    __tablename__ = 'conecta_area'

    id_origem = Column(
        Integer,
        ForeignKey('area.id_area'),
        nullable=False
    )
    id_destino = Column(
        Integer,
        ForeignKey('area.id_area'),
        nullable=False
    )

    __table_args__ = (
        PrimaryKeyConstraint('id_origem', 'id_destino', name='conecta_area_pkey'),
    )

class Realiza(Base):
    __tablename__ = 'realiza'

    id_golpes = Column(
        Integer,
        primary_key=True,
        autoincrement=True,
        nullable=False
    )
    id_npc = Column(
        Integer,
        ForeignKey('npc.id_npc'),
        nullable=True
    )
    multiplicador = Column(
        Integer,
        nullable=False
    )
    dano_final = Column(
        Integer,
        nullable=False
    )

    __table_args__ = (
        CheckConstraint('dano_final >= 1', name='chk_dano_final'),
        CheckConstraint('multiplicador >= 1', name='chk_multiplicador'),
        PrimaryKeyConstraint('id_golpes', name='realiza_pkey'),
    )

class Item(Base):
    __tablename__ = 'item'

    id_item = Column(
        Integer,
        primary_key=True,
        server_default='nextval(\'item_id_item_seq\'::regclass)',
        autoincrement=True,
        nullable=False
    )
    eh_chave = Column(
        Boolean,
        nullable=False
    )
    raridade = Column(
        Integer,
        nullable=False
    )
    nome = Column(
        String(length=50),
        nullable=False
    )
    valor = Column(
        Integer,
        nullable=True
    )
    tipo = Column(
        tipo_item_enum,
        nullable=True
    )

    __table_args__ = (
        CheckConstraint(
            'eh_chave = true AND tipo IS NULL OR eh_chave = false AND tipo IS NOT NULL OR eh_chave = false AND tipo IS NULL',
            name='item_check'
        ),
        CheckConstraint(
            'raridade >= 1 AND raridade <= 5',
            name='chk_raridade'
        ),
        PrimaryKeyConstraint('id_item', name='item_pkey'),
    )

class Consumivel(Base):
    __tablename__ = 'consumivel'

    id_consumivel = Column(Integer, primary_key=True, autoincrement=False)
    efeito = Column(tipo_efeitos_enum, nullable=False)
    qtd_do_efeito = Column(Integer, nullable=False)
    descricao = Column(String(length=200), nullable=False)

    __table_args__ = (
        CheckConstraint('qtd_do_efeito >= 1', name='chk_qtd_do_efeito'),
        PrimaryKeyConstraint('id_consumivel', name='consumivel_pkey'),
    )

class InstanciaDeItem(Base):
    __tablename__ = 'instancia_de_item'

    id_instancia_item = Column(Integer, primary_key=True, autoincrement=True, nullable=False)
    id_item = Column(Integer, ForeignKey('item.id_item'), nullable=True)

    __table_args__ = (
        PrimaryKeyConstraint('id_instancia_item', name='instancia_de_item_pkey'),
    )

class LocalizacaoDaInstanciaDeItem(Base):
    __tablename__ = 'localizacao_da_instancia_de_item'

    id_instancia_item = Column(Integer, ForeignKey('instancia_de_item.id_instancia_item'), primary_key=True, nullable=False)
    area = Column(Integer, ForeignKey('area.id_area'), nullable=True)
    inventario_jogador = Column(Integer, ForeignKey('jogador.id_jogador'), nullable=True)

    __table_args__ = (
        CheckConstraint(
            'area IS NOT NULL AND inventario_jogador IS NULL OR inventario_jogador IS NOT NULL AND area IS NULL OR inventario_jogador IS NOT NULL AND area IS NOT NULL',
            name='localizacao_da_instancia_de_item_check'
        ),
        PrimaryKeyConstraint('id_instancia_item', name='localizacao_da_instancia_de_item_pkey'),
    )

class Equipamento(Base):
    __tablename__ = 'equipamento'

    id_equipamento = Column(Integer, ForeignKey('item.id_item'), primary_key=True, nullable=False)
    tipo = Column(ENUM('Escudo', 'Arma', 'Armadura', name='tipo_equipamento'), nullable=False)

    __table_args__ = (
        PrimaryKeyConstraint('id_equipamento', name='equipamento_pkey'),
    )

class Escudo(Base):
    __tablename__ = 'escudo'

    id_escudo = Column(Integer, ForeignKey('equipamento.id_equipamento'), primary_key=True, nullable=False)
    requisitos = Column(ARRAY(Integer), nullable=True)
    melhoria = Column(Integer, nullable=False)
    peso = Column(Integer, nullable=False)
    custo_melhoria = Column(Integer, nullable=False)
    habilidade = Column(Integer, nullable=False)
    defesa = Column(Integer, nullable=False)

    __table_args__ = (
        CheckConstraint('array_length(requisitos, 1) = 4', name='chk_requisitos'),
        CheckConstraint('custo_melhoria >= 1', name='chk_custo_melhoria'),
        CheckConstraint('defesa >= 1', name='chk_defesa'),
        CheckConstraint('melhoria >= 0', name='chk_melhoria'),
        CheckConstraint('peso >= 0', name='chk_peso'),
        PrimaryKeyConstraint('id_escudo', name='escudo_pkey'),
    )

class Armadura(Base):
    __tablename__ = 'armadura'

    id_armadura = Column(Integer, ForeignKey('equipamento.id_equipamento'), primary_key=True, nullable=False)
    requisitos = Column(ARRAY(Integer), nullable=True)
    melhoria = Column(Integer, nullable=False)
    peso = Column(Integer, nullable=False)
    custo_melhoria = Column(Integer, nullable=False)
    resistencia = Column(Integer, nullable=False)

    __table_args__ = (
        CheckConstraint('array_length(requisitos, 1) = 4', name='chk_requisitos'),
        CheckConstraint('custo_melhoria >= 1', name='chk_custo_melhoria'),
        CheckConstraint('melhoria >= 0', name='chk_melhoria'),
        CheckConstraint('peso >= 0', name='chk_peso'),
        CheckConstraint('resistencia >= 1', name='chk_resistencia'),
        PrimaryKeyConstraint('id_armadura', name='armadura_pkey'),
    )

class ArmaPesada(Base):
    __tablename__ = 'arma_pesada'

    id_arma_pesada = Column(Integer, ForeignKey('equipamento.id_equipamento'), primary_key=True, nullable=False)
    requisitos = Column(ARRAY(Integer), nullable=True)
    melhoria = Column(Integer, nullable=False)
    peso = Column(Integer, nullable=False)
    custo_melhoria = Column(Integer, nullable=False)
    habilidade = Column(Integer, nullable=False)
    dano = Column(Integer, nullable=False)
    critico = Column(Integer, nullable=True)
    forca = Column(Integer, nullable=False)

    __table_args__ = (
        CheckConstraint('array_length(requisitos, 1) = 4', name='chk_requisitos'),
        CheckConstraint('critico IS NULL OR critico >= 1', name='chk_critico'),
        CheckConstraint('custo_melhoria >= 1', name='chk_custo_melhoria'),
        CheckConstraint('dano >= 1', name='chk_dano'),
        CheckConstraint('forca >= 1', name='chk_forca'),
        CheckConstraint('melhoria >= 0', name='chk_melhoria'),
        CheckConstraint('peso >= 0', name='chk_peso'),
        PrimaryKeyConstraint('id_arma_pesada', name='arma_pesada_pkey'),
    )

class ArmaLeve(Base):
    __tablename__ = 'arma_leve'

    id_arma_leve = Column(Integer, ForeignKey('equipamento.id_equipamento'), primary_key=True, nullable=False)
    melhoria = Column(Integer, nullable=False)
    peso = Column(Integer, nullable=False)
    custo_melhoria = Column(Integer, nullable=False)
    requisitos = Column(ARRAY(Integer), nullable=True)
    habilidade = Column(Integer, nullable=False)
    dano = Column(Integer, nullable=False)
    critico = Column(Integer, nullable=True)
    destreza = Column(Integer, nullable=False)

    __table_args__ = (
        CheckConstraint('array_length(requisitos, 1) = 4', name='chk_requisitos'),
        CheckConstraint('custo_melhoria >= 1', name='chk_custo_melhoria'),
        CheckConstraint('destreza >= 1', name='chk_destreza'),
        CheckConstraint('melhoria >= 0', name='chk_melhoria'),
        CheckConstraint('peso >= 0', name='chk_peso'),
        CheckConstraint('dano >= 1', name='chk_dano'),
        CheckConstraint('critico IS NULL OR critico >= 1', name='chk_critico'),
        PrimaryKeyConstraint('id_arma_leve', name='arma_leve_pkey'),
    )

class Cajado(Base):
    __tablename__ = 'cajado'

    id_cajado = Column(Integer, ForeignKey('equipamento.id_equipamento'), primary_key=True, nullable=False)
    melhoria = Column(Integer, nullable=False)
    peso = Column(Integer, nullable=False)
    custo_melhoria = Column(Integer, nullable=False)
    requisitos = Column(ARRAY(Integer), nullable=True)
    habilidade = Column(Integer, nullable=False)
    dano = Column(Integer, nullable=False)
    critico = Column(Integer, nullable=True)
    proficiencia = Column(ENUM('E', 'D', 'C', 'B', 'A', 'S', name='tipo_proeficiencia'), nullable=False)

    __table_args__ = (
        CheckConstraint('array_length(requisitos, 1) = 4', name='chk_requisitos'),
        CheckConstraint('custo_melhoria >= 1', name='chk_custo_melhoria'),
        CheckConstraint('melhoria >= 0', name='chk_melhoria'),
        CheckConstraint('peso >= 0', name='chk_peso'),
        CheckConstraint('dano >= 1', name='chk_dano'),
        CheckConstraint('critico IS NULL OR critico >= 1', name='chk_critico'),
        PrimaryKeyConstraint('id_cajado', name='cajado_pkey'),
    )

class Selo(Base):
    __tablename__ = 'selo'

    id_selo = Column(Integer, ForeignKey('equipamento.id_equipamento'), primary_key=True, nullable=False)
    melhoria = Column(Integer, nullable=False)
    peso = Column(Integer, nullable=False)
    custo_melhoria = Column(Integer, nullable=False)
    requisitos = Column(ARRAY(Integer), nullable=True)
    habilidade = Column(Integer, nullable=False)
    dano = Column(Integer, nullable=False)
    critico = Column(Integer, nullable=True)
    milagre = Column(Integer, nullable=False)

    __table_args__ = (
        CheckConstraint('array_length(requisitos, 1) = 4', name='chk_requisitos'),
        CheckConstraint('custo_melhoria >= 1', name='chk_custo_melhoria'),
        CheckConstraint('melhoria >= 0', name='chk_melhoria'),
        CheckConstraint('milagre >= 1', name='chk_milagre'),
        CheckConstraint('peso >= 0', name='chk_peso'),
        CheckConstraint('dano >= 1', name='chk_dano'),
        CheckConstraint('critico IS NULL OR critico >= 1', name='chk_critico'),
        PrimaryKeyConstraint('id_selo', name='selo_pkey'),
    )

class Engaste(Base):
    __tablename__ = 'engaste'

    id_engaste = Column(Integer, primary_key=True, autoincrement=True, nullable=False)
    id_arma = Column(Integer, ForeignKey('equipamento.id_equipamento'), nullable=True)
    atributo_extra = Column(Integer, nullable=False)

    __table_args__ = (
        PrimaryKeyConstraint('id_engaste', name='engaste_pkey'),
    )

class Equipados(Base):
    __tablename__ = 'equipados'

    id_jogador = Column(Integer, ForeignKey('jogador.id_jogador'), primary_key=True, nullable=False)
    mao_direita = Column(Integer, ForeignKey('equipamento.id_equipamento'), nullable=True)
    mao_esquerda = Column(Integer, ForeignKey('equipamento.id_equipamento'), nullable=True)
    armadura = Column(Integer, ForeignKey('equipamento.id_equipamento'), nullable=True)

    __table_args__ = (
        PrimaryKeyConstraint('id_jogador', name='equipados_pkey'),
    )

class InstanciaNPC(Base):
    __tablename__ = 'instancia_npc'

    id_instancia = Column(Integer, primary_key=True, autoincrement=True, nullable=False)
    id_npc = Column(Integer, ForeignKey('npc.id_npc'), nullable=False)
    id_area = Column(Integer, ForeignKey('area.id_area'), nullable=False)

    __table_args__ = (
        PrimaryKeyConstraint('id_instancia', name='instancia_npc_pkey'),
    )

class Dialogo(Base):
    __tablename__ = 'dialogo'

    id_dialogo = Column(Integer, primary_key=True, autoincrement=True, nullable=False)
    id_npc = Column(Integer, ForeignKey('npc.id_npc'), nullable=True)
    texto = Column(String(length=300), nullable=False)
    e_unico = Column(Boolean, nullable=False)

    __table_args__ = (
        PrimaryKeyConstraint('id_dialogo', name='dialogo_pkey'),
    )


class ChefesDerrotados(Base):
    __tablename__ = 'chefes_derrotados'

    id_chefe = Column(Integer, ForeignKey('chefe.id_chefe'), primary_key=True, nullable=False)
    id_jogador = Column(Integer, ForeignKey('jogador.id_jogador'), primary_key=True, nullable=False)

    __table_args__ = (
        PrimaryKeyConstraint('id_chefe', 'id_jogador', name='chefes_derrotados_pkey'),
    )