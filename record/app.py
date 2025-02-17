from flask import Flask, jsonify, request, Response
import pandas as pd
import requests
import io
from threading import Timer
from dotenv import load_dotenv
import os
from flask_cors import CORS

# Cargar variables de entorno
load_dotenv()

app = Flask(__name__)
CORS(app)

# URL base del Google Sheets (debe ser público)
spreadsheet_url = "https://docs.google.com/spreadsheets/d/1FMu69C76kY1NFTOCBVBk2QA8yH8ImCGAprW4RDjdk6M/gviz/tq?tqx=out:csv&sheet={}"

# Credenciales
USERNAME = os.getenv("USER")
PASSWORD = os.getenv("PASSWORD")

# Hojas a consultar
sheets = ["Hoja1", "Hoja4"]

# Columnas esperadas
expected_columns = ['id', 'ci', 'apellidos', 'nombres', 'curso', 'horas_academicas', 'fecha_inicio', 'fecha_fin', 'cod_interno', 'aval']

def fetch_data():
    """Obtiene y combina datos desde Google Sheets asegurando que todo sea tratado como texto."""
    try:
        data_frames = []
        
        for sheet in sheets:
            sheet_url = spreadsheet_url.format(sheet)
            response = requests.get(sheet_url)
            response.raise_for_status()
            
            df = pd.read_csv(io.StringIO(response.text), dtype=str)  # Leer todo como texto
            
            df.columns = [col.strip().lower() for col in df.columns]  # Normalizar nombres de columnas
            
            # Mantener solo columnas esperadas
            df = df[[col for col in expected_columns if col in df.columns]]
            
            # Agregar columnas faltantes
            for col in expected_columns:
                if col not in df.columns:
                    df[col] = ""

            df = df[expected_columns]  # Reordenar columnas
            
            # Convertir NaT y NaN a ""
            df = df.fillna("")
            
            data_frames.append(df)
        
        # Combinar datos
        combined_data = pd.concat(data_frames, ignore_index=True)
        return combined_data
    
    except Exception as e:
        print(f"Error al obtener datos: {e}")
        return None

# Actualización automática de datos cada 5 minutos
def schedule_data_fetch():
    global data
    data = fetch_data()
    Timer(300, schedule_data_fetch).start()

schedule_data_fetch()

# Autenticación
def check_auth(username, password):
    return username == USERNAME and password == PASSWORD

def authenticate():
    return Response('Acceso denegado', 401, {'WWW-Authenticate': 'Basic realm="Login Required"'})

# API
@app.route("/api/data", methods=["GET"])
def api_data():
    auth = request.authorization
    if not auth or not check_auth(auth.username, auth.password):
        return authenticate()
    
    if data is not None:
        return jsonify(data.to_dict(orient="records"))
    else:
        return jsonify({"error": "Datos no disponibles."}), 500

if __name__ == "__main__":
    app.run(debug=True)