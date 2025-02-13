import re
from datetime import datetime

# Función para convertir fechas del formato DD/MM/YYYY a YYYY-MM-DD
def convertir_fecha(fecha_str):
    try:
        # Intentar convertir la fecha al formato adecuado
        fecha_obj = datetime.strptime(fecha_str, "%d/%m/%Y")
        return fecha_obj.strftime("%Y-%m-%d")
    except ValueError:
        # Si la fecha no es válida, devolver la fecha original
        return fecha_str

# Función para extraer los valores y corregir las fechas
def corregir_valores(sql_query):
    # Expresión regular para extraer los valores de la cláusula VALUES
    values_pattern = r"VALUES \((.*?)\);"
    match = re.search(values_pattern, sql_query, re.DOTALL)
    
    if match:
        # Extraer los valores y dividirlos por comas
        valores = match.group(1)
        valores = valores.split("','")

        # Corregir las fechas
        for i in range(len(valores)):
            # Si es una fecha (de 10 caracteres como 'DD/MM/YYYY')
            if len(valores[i]) == 10 and valores[i].count("/") == 2:
                valores[i] = convertir_fecha(valores[i])
        
        # Unir los valores nuevamente
        valores_corregidos = "','".join(valores)
        return f"VALUES ('{valores_corregidos}');"
    
    return sql_query

# Función para procesar el archivo y corregir los valores
def procesar_archivo(input_file, output_file):
    # Abrir y leer el archivo de entrada
    with open(input_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    # Abrir el archivo de salida en modo escritura
    with open(output_file, 'w', encoding='utf-8') as f_out:
        for line in lines:
            # Corregir cada línea de la consulta SQL
            query_corregida = corregir_valores(line)
            # Escribir la consulta corregida en el archivo de salida
            f_out.write(query_corregida + "\n")
    
    print(f"Archivo corregido guardado como: {output_file}")

# Ruta del archivo de entrada y salida
input_file = r'respaldo.sql'  # Cambia esta ruta al archivo de entrada
output_file = r'registros_corregidos.sql'  # Cambia esta ruta al archivo de salida

# Ejecutar la corrección de las fechas en el archivo
procesar_archivo(input_file, output_file)
