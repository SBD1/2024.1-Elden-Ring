# alembic/env.py
import os
import sys
from sqlalchemy import create_engine, MetaData
from sqlalchemy.ext.declarative import declarative_base
from alembic import context

# Adiciona o diretório do seu projeto ao PYTHONPATH
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from models import Base  # Importa a base do SQLAlchemy e os modelos

# Configurações do Alembic
config = context.config
config.set_main_option('sqlalchemy.url', 'postgresql+psycopg2://carla:abacate@localhost:5432/db_1')

# Obtém o MetaData do SQLAlchemy
target_metadata = Base.metadata

def run_migrations_offline():
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()

def run_migrations_online():
    connectable = create_engine(config.get_main_option("sqlalchemy.url"))

    with connectable.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=target_metadata,
        )

        with context.begin_transaction():
            context.run_migrations()

if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
