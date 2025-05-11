# pipeline/pipeline_transaction.py

from src.extract import load_archive
from src.transform import clean_transactions, clean_hotels, clean_channels, corregir_pais_mexico
from src.load import save_csv, load_to_sql
from sqlalchemy import create_engine, text
from pathlib import Path

def get_engine():
    user = "sa"
    password = "Leo1234"
    server = "localhost"
    database = "barcelo-02"
    driver = "ODBC+Driver+17+for+SQL+Server"

    return create_engine(
        f"mssql+pyodbc://{user}:{password}@{server}/{database}?driver={driver}"
    )

def ejecutar_query(engine, filename):
    base_path = Path(__file__).resolve().parent.parent
    filepath = base_path / "queries" / filename

    with open(filepath, 'r', encoding='utf-8') as f:
        query = f.read()

    with engine.connect() as conn:
        conn.execute(text(query))
        conn.commit()
        print(f"📄 Ejecutada vista desde {filepath}")

def run_pipeline():
    print("🚀 Iniciando pipeline ETL...")

    # 1. Extraer datos
    df_transactions = load_archive("daily_transactions.csv")
    df_hotels = load_archive("hotels.csv")
    df_channels = load_archive("channels.csv")

    # 2. Transformar
    df_transactions = clean_transactions(df_transactions)
    df_transactions = corregir_pais_mexico(df_transactions)
    df_hotels = clean_hotels(df_hotels)
    df_channels = clean_channels(df_channels)

    # 3. Guardar en /data/processed/
    save_csv(df_transactions, "daily_transactions.csv")
    save_csv(df_hotels, "hotels.csv")
    save_csv(df_channels, "channels.csv")

    # 4. Cargar en SQL Server
    engine = get_engine()
    load_to_sql(df_transactions, "transactions", engine)
    load_to_sql(df_hotels, "hotels", engine)
    load_to_sql(df_channels, "channels", engine)

    # 5. Crear vistas desde /queries/
    ejecutar_query(engine, "vw_hotel_sales.sql")
    ejecutar_query(engine, "vw_country_transactions.sql")
    ejecutar_query(engine, "vw_daily_analysis.sql")
    ejecutar_query(engine, "vw_marketing_analysis.sql")
    ejecutar_query(engine, "vw_channel_daily.sql")

    print("✅ Pipeline completado correctamente.")
