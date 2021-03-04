import os
import shutil
from tempfile import NamedTemporaryFile

import psycopg2
import requests

from log import logger

DATA_URL = "https://data.cityofnewyork.us/api/views/43nn-pn8j/rows.csv?accessType=DOWNLOAD"
SQL_FILE = "ingestion.sql"

POSTGRES_HOST = os.getenv("POSTGRES_HOST", "localhost")
POSTGRES_PORT = os.getenv("POSTGRES_PORT", "5432")
POSTGRES_USERNAME = os.getenv("POSTGRES_USERNAME", "postgres")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD", "postgres")
POSTGRES_DATABASE = os.getenv("POSTGRES_DATABASE", "postgres")


def main():
    with NamedTemporaryFile() as file:
        logger.debug("Temporary file: %s", file.name)

        extract(file)
        load(file)
        transform()

    logger.info("Done")


def extract(file):
    logger.info("Extracting data")

    with requests.get(DATA_URL, stream=True) as response:
        response.raise_for_status()
        response.raw.decode_content = True

        shutil.copyfileobj(response.raw, file)

    # Rewinds file
    file.seek(0)


def load(file):
    logger.info("Loading data")

    connection_params = {
        "host": POSTGRES_HOST,
        "port": POSTGRES_PORT,
        "user": POSTGRES_USERNAME,
        "password": POSTGRES_PASSWORD,
        "dbname": POSTGRES_DATABASE
    }

    src_dir = os.path.dirname(os.path.abspath(__file__))
    sql_dir = os.path.join(src_dir, "..", "sql")
    sql_file_path = os.path.join(sql_dir, SQL_FILE)

    with psycopg2.connect(**connection_params) as connection:
        with connection.cursor() as cursor:
            with open(sql_file_path, "r") as sql_file:
                cursor.copy_expert(sql_file.read(), file)


def transform():
    logger.info("Transforming data")

    src_dir = os.path.dirname(os.path.abspath(__file__))
    dbt_dir = os.path.join(src_dir, "..", "dbt")

    command = "dbt run --project-dir {project_dir} --profiles-dir {profiles_dir}".format(
        project_dir=dbt_dir,
        profiles_dir=dbt_dir
    )

    # dbt doesn't yet support direct Python API usage, so
    # it's recommended to invoke it from the command line
    # https://docs.getdbt.com/docs/running-a-dbt-project/dbt-api
    os.system(command)


if __name__ == "__main__":
    main()
