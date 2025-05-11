# src/load.py

import pandas as pd
from sqlalchemy.engine import Engine
from pathlib import Path

# Funcion para Guarda un DataFrame como CSV en /data/processed/.
def save_csv(df: pd.DataFrame, filename: str) -> None:

    base_path = Path(__file__).resolve().parent.parent
    output_path = base_path / "data" / "processed" / filename

    df.to_csv(output_path, index=False)
    print(f"✅ Archivo guardado: {output_path}")

# funcion para Carga un DataFrame como tabla en SQL Server.
def load_to_sql(df: pd.DataFrame, table_name: str, engine: Engine) -> None:

    try:
        df.to_sql(name=table_name, con=engine, if_exists="replace", index=False)
        print(f"📤 Tabla '{table_name}' cargada en SQL Server")
    except Exception as e:
        print(f"❌ Error al cargar '{table_name}': {e}")
