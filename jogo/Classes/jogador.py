class Jogador:
    def __init__(self, 
                 id_jogador, 
                 nome_jogador, 
                 hp, 
                 vigor, 
                 vitalidade, 
                 intel, 
                 fe, 
                 destreza, 
                 forca, 
                 peso_max, 
                 stamina, 
                 mp, 
                 nivel_atual, 
                 id_nivel, 
                 nro_nivel, 
                 runas, 
                 classe_nome, 
                 id_area, 
                 area_nome, 
                 regiao_nome,
                 st_atual, 
                 hp_atual, 
                 runas_atuais):
        self.id_jogador = id_jogador
        self.nome_jogador = nome_jogador
        self.hp = hp
        self.vigor = vigor
        self.vitalidade = vitalidade
        self.intel = intel
        self.fe = fe
        self.destreza = destreza
        self.forca = forca
        self.peso_max = peso_max
        self.stamina = stamina
        self.mp = mp
        self.nivel_atual = nivel_atual
        self.id_nivel = id_nivel
        self.nro_nivel = nro_nivel
        self.runas = runas
        self.classe_nome = classe_nome
        self.id_area = id_area
        self.area_nome = area_nome
        self.regiao_nome = regiao_nome
        self.st_atual = st_atual
        self.hp_atual = hp_atual
        self.runas_atuais = runas_atuais

    @classmethod
    def from_data_base(cls, row):
        return cls(
            id_jogador=row[0],
            nome_jogador=row[1],
            hp=row[2],
            vigor=row[3],
            vitalidade=row[4],
            intel=row[5],
            fe=row[6],
            destreza=row[7],
            forca=row[8],
            peso_max=row[9],
            stamina=row[10],
            mp=row[11],
            nivel_atual=row[12],
            id_nivel=row[13],
            nro_nivel=row[14],
            runas=row[15],
            classe_nome=row[16],
            id_area=row[17],
            area_nome=row[18],
            regiao_nome=row[19],
            st_atual=row[20],
            hp_atual=row[21],
            runas_atuais=row[22]
        )