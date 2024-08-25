<h1 align="center">⚜️ Elden Ring ⚜️</h1>

<div align="center">
  Rise, Tarnished.
  
![elden](https://github.com/user-attachments/assets/0476e059-be64-4f14-8dd8-413f8670187f)
</div>
___

## 🕹 Sobre o Jogo
Elden Ring é um jogo eletrônico de RPG de ação, jogado de uma perspectiva em terceira pessoa e apresenta elementos semelhantes aos encontrados em seus antecessores, a série Souls, com uma jogabilidade focada em combate e exploração. Os jogadores começam em um ambiente linear, mas eventualmente progridem para explorar livremente as Terras Intermédias, incluindo suas seis áreas principais, bem como castelos, fortalezas e catacumbas espalhadas pelo vasto mapa de mundo aberto. Essas áreas principais são interconectadas através de um ponto central no qual os jogadores podem acessar mais tarde conforme progridem no jogo e serão exploráveis ​​usando a montaria do personagem como o principal meio de transporte, embora um sistema de viagem rápida seja uma opção disponível. Ao longo do jogo, os jogadores encontram personagens não-jogáveis (NPCs) e inimigos, incluindo os semideuses que governam cada área principal e servirão como os chefes principais do jogo.
___

## 📜 Objetivo

Esse trabalho tem por objetivo reproduzir a lógica do banco de dados do jogo Elden Ring para a matéria de Sistema de Banco de Dados da Universidade de Brasília, ministrada pelo professor 
Maurício Serrano.

## 💎 Entregas
### 1ª Entrega 

* [DER](https://github.com/SBD1/2024.1-Elden-Ring/blob/main/docs/DER/DERv6-Final.png)
* [Mapeamento](https://github.com/SBD1/2024.1-Elden-Ring/blob/main/docs/Mapeamento/mapeamento_final.png)
* [Dicionário de Dados](https://github.com/SBD1/2024.1-Elden-Ring/blob/main/docs/DicionarioDados-EldenRing.pdf)
* [Apresentação](https://youtu.be/X5gtIR1n0aY)

#### Ferramentas Utilizadas:

<div style="display:flex;">
  <img src="https://github.com/user-attachments/assets/2e834e79-9d7c-45dc-9ea6-f93579a7e6fc" alt="images__1_-removebg-preview" style="width:10%; height:auto;">
  
### 2ª Entrega 
* [Atualização do DER](https://github.com/SBD1/2024.1-Elden-Ring/blob/main/docs/DER/DERv6-Final-Corrigido.drawio.png)
* [Atualização do Mapeamento](https://github.com/SBD1/2024.1-Elden-Ring/blob/main/docs/Mapeamento/mapeamento_final_corrigido.drawio.png)
* [Criação das Tabeças (DDL)](https://github.com/SBD1/2024.1-Elden-Ring/blob/main/docs/DDL/ddl1.0.sql)
* [Insert (DML)](https://github.com/SBD1/2024.1-Elden-Ring/blob/main/docs/DML/Inserir.sql)
* [Selects](https://github.com/SBD1/2024.1-Elden-Ring/blob/main/docs/Selects/Selects.sql)
* [Updates (DML)](https://github.com/SBD1/2024.1-Elden-Ring/blob/main/docs/DML/Update.sql)
* [Jogo Inicio (Andar pelo mapa)](https://github.com/SBD1/2024.1-Elden-Ring/tree/main/jogo)
* [Apresentação](https://youtu.be/8GZPNs6pBgc)


#### Ferramentas Utilizadas:

[![My Skills](https://skillicons.dev/icons?i=postgresql,python&theme=light)](https://skillicons.dev)

## Configurações do Banco

1. Instale o Alembic

```bash
# Atualizar a lista de pacotes
sudo apt update

# Instalar Python e pip
sudo apt install python3 python3-pip

# Instalar o Alembic usando pip
pip3 install alembic

# Verificar a instalação do Alembic
alembic --version
``` 

2. Atualize o arquivo env.py com suas credenciais do postgres

```bash
config.set_main_option('sqlalchemy.url', 'postgresql+psycopg2://username:password@localhost:5432/databe_name')
```

3. Atualize o arquivo env.py com suas credenciais do postgres

```bash
sqlalchemy.url = postgresql+psycopg2://username:password@localhost:5432/databe_name
```

## Para realizar novas migrações

1. Atualize o arquivo models de acordo com o que você precisa
2. Gere uma nova versão 

```bash
alembic revision --autogenerate -m "descricao"
```

3. Realize a migração

```bash
alembic upgrade head
```

</div>

## 👾 Contribuidores

<div align="center">
<table style="margin-left: auto; margin-right: auto;">
    <tr>
        <td align="center">
            <a href="https://github.com/arthurmlv">
                <img style="border-radius: 50%;" src="https://github.com/arthurmlv.png" width="150px;"/>
                <h5 class="text-center"> Arthur de Melo  </h5>
                <h5 class="text-center"> 211029147 </h5>
            </a>
        </td>
        <td align="center">
            <a href="https://github.com/Beatrizvn">
                <img style="border-radius: 50%;" src="https://github.com/Beatrizvn.png" width="150px;"/>
                <h5 class="text-center">Beatriz Nascimento <br> </h5>
                <h5 class="text-center"> 211031628 </h5>
            </a>
        </td>
       <td align="center">
            <a href="https://github.com/ccarlaa">
                <img style="border-radius: 50%;" src="https://github.com/ccarlaa.png" width="150px;"/>
                <h5 class="text-center">Carla de Araujo  <br></h5>
                <h5 class="text-center"> 180030736 </h5>
            </a>
        </td>
      <td align="center">
            <a href="https://github.com/manuziny">
                <img style="border-radius: 50%;" src="https://github.com/manuziny.png" width="150px;"/>
                <h5 class="text-center"> Geovanna Maciel <br> </h5>
                <h5 class="text-center"> 202016328 </h5>
            </a>
        </td>
    </tr>
</table>

