
# Gran Marqués– Proyecto ETL de análisis de ingresos hoteleros

`Gran Marqués` es un proyecto de análisis de ingresos, reservas y marketing hotelero desarrollado como prueba técnica para el rol de Analista de Datos. Implementa un pipeline ETL modular en Python, carga los datos en SQL Server, genera vistas y prepara visualizaciones en Power BI.

---

## 📁 Estructura del proyecto

```
Hotel_02/
│
├── data/
│   ├── raw/               # Archivos originales (.csv)
│   ├── processed/         # Archivos limpios listos para análisis y carga
│
├── src/                   # Módulos Python
│   ├── extract.py         # Funciones de carga desde CSV
│   ├── transform.py       # Limpieza, transformación y creación de métricas
│   ├── load.py            # Carga de datos en SQL Server
│
├── pipeline/
│   └── pipeline_transaction.py  # Pipeline principal del proyecto
│
├── queries/               # Consultas SQL para vistas (Power BI)
│   ├── vw_hotel_sales.sql
│   ├── vw_country_transactions.sql
│   ├── vw_marketing_analysis.sql
│   ├── vw_daily_analysis.sql
│   └── vw_channel_daily.sql
│
├── notebooks/             # Notebooks usados en exploración, visualización y desarrollo
│   └── main_analysis.ipynb
│
├── reports/  # Power BI y entregables en PDF         
│   ├── preview informe.pdf
│
├── main.py                # Ejecuta el pipeline completo
├── requirements.txt       # Librerías necesarias
└── README.md              # Este archivo
```

---

## 🔄 Flujo del proyecto

1. **Extracción (Extract)**  
   - Se cargan archivos desde `/data/raw/` (`daily_transactions.csv`, `channels.csv`, `hotels.csv`).

2. **Transformación (Transform)**  
   - Validación y renombrado de columnas
   - Conversión de fechas y tipos numéricos
   - Corrección de países incorrectos en las transacciones
   - Unificación de IDs duplicados en canales (caso Facebook)
   - Cálculo de media móvil de 7 días y versiones sin outliers
   - Detección de anomalías (picos de ingreso)

3. **Carga (Load)**  
   - Se guardan archivos limpios en `/data/processed/`
   - Se cargan a SQL Server en la BBDD 
   - Se ejecutan vistas SQL desde `/queries/` para análisis

---

## 📊 Power BI – Dashboards

Los datos cargados en SQL Server se usan en Power BI para construir 4 pantallas principales:

- **Ingresos y reservas por hotel**
- **Análisis geográfico por país**
- **Evolución diaria de ingresos y detección de picos**
- **Desempeño por canal de marketing**

Las visualizaciones incluyen:
- Gráficos de líneas con media móvil
- Barras comparativas por canal
- Mapas y segmentaciones por país
- Medidas  personalizadas (media móvil, tickets, ranking)


---

## ▶ Cómo ejecutar

```bash
# Instala dependencias
pip install -r requirements.txt
```

Confgurar una BBDD donde se guardaran los datos transformados,en este caso se ha utilizado una BBDD local de SQL Server
cambiar los datos de conexión en pipeline_transaction.py 
- user = ""
- password = ""
- server = ""
- database = ""
- driver = " "

```bash
# Ejecuta el pipeline completo
python main.py
```

> Esto cargará los archivos desde `data/raw/`, los procesará y actualizará la base de datos en SQL Server, incluyendo las vistas.



## 👤 Autor

Leonel Martinez  
Contacto: lic.leonelmartinez@gmail.com
