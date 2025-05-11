# src/transform.py

import pandas as pd
from pathlib import Path
from sqlalchemy import text
from sqlalchemy.engine import Engine

#funcion para limpiar  Limpia el DataFrame de transacciones
def clean_transactions(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    df['booking_date'] = pd.to_datetime(df['booking_date'])
    df['number_of_nights_booked'] = df['number_of_nights_booked'].astype(int)
    df['number_of_guests'] = df['number_of_guests'].astype(int)
    df['rooms_booked'] = df['rooms_booked'].astype(int)
    df['total_revenue_in_euros'] = df['total_revenue_in_euros'].astype(float)

    if 'hotel_country' in df.columns and 'customer_country' not in df.columns:
        df.rename(columns={'hotel_country': 'customer_country'}, inplace=True)

    df.drop_duplicates(inplace=True)

    return df

# funcion para limpiar el DataFrame de hoteles
def clean_hotels(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    df.drop_duplicates(inplace=True)
    df.dropna(subset=['ID', 'Name', 'Location'], inplace=True)
    return df

def corregir_pais_mexico(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    df.loc[df['hotel_id'] == 5, 'customer_country'] = 'Mexico'
    return df



# Limpia el DataFrame de canales
def clean_channels(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    df = df[~((df["Channel_Name"] == "Facebook") & (df["Channel_Type"] == "Non-Paid"))]
    df.reset_index(drop=True, inplace=True)
    return df

#Ejecuta una query SQL desde un archivo en la carpeta /queries.
def ejecutar_query(engine: Engine, filename: str):
    base_path = Path(__file__).resolve().parent.parent
    ruta_sql = base_path / "queries" / filename

    with open(ruta_sql, 'r', encoding='utf-8') as f:
        query = f.read()

    with engine.connect() as conn:
        conn.execute(text(query))
        conn.commit()
        print(f"📄 Ejecutada vista desde {ruta_sql}")
