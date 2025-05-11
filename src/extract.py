# src/extract.py

import pandas as pd
from pathlib import Path

#funcion para cargar archivos
def load_archive(filename: str) -> pd.DataFrame:
    base_path = Path(__file__).resolve().parent.parent
    file_path = base_path / "data" / "raw" / filename
    return pd.read_csv(file_path)


