<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Certificados</title>

    <!-- Asegúrate de cargar jQuery antes de DataTables -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/2.1.8/css/dataTables.dataTables.css" />

    <style>
        /* General Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;  /* Fondo suave */
            color: #333;  /* Color de texto */
        }

        .entry-title {
            text-align: left;
            font-size: 2.5em;
            margin-bottom: 15px;
        }

        #institution {
            text-align: center;
            padding: 5% 0;
            background-color: #ffffff;
            margin-bottom: 30px;
        }

        #institution img {
            max-width: 200px;  /* Ajuste del tamaño del logo */
            margin-bottom: 15px;
        }

        #institution p {
            font-size: 1.2em;
            line-height: 1.6;
            margin-top: 10px;
            color: #555;
        }

        #searchForm {
            display: flex;
            justify-content: flex-end;
            margin: 20px;
            padding: 10px;
        }

        #searchInput {
            background-color: #e8f0fe;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            width: 250px;
            margin-right: 10px;
            font-size: 1em;
        }

        #Elimina, #Limpiar, #Borrar {
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
            margin-left: 5px;
        }
        
        /* Table Styles */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 30px;
            background-color: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #3498db;
            color: white;
            font-size: 1.1em;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        /* Responsive Styles */
        @media (max-width: 768px) {
            #searchForm {
                flex-direction: column;
                align-items: flex-end;
            }

            table {
                font-size: 0.9em;
            }

            th, td {
                padding: 8px;
            }
        }
    </style>
</head>
<body>

<div id="institution">
    <img id="logo" src="{% static 'logo_2024.png' %}" alt="logo_2024">
    <h1 class="entry-title" itemprop="headline">Certificados</h1>
    <p>Valida <strong>curso</strong> o <strong>capacitación</strong> en el siguiente apartado <em>(Busca por nombres, apellidos, número de cédula, nombre del curso o por código de verificación)</em></p>
</div>

<!-- Formulario de búsqueda -->
<div id="searchForm">
    <input type="text" id="searchInput" placeholder="Buscar...">
    <button id="Borrar">Borrar</button>
</div>

<!-- Tabla de resultados -->
<table id="myTable" class="display">
    <thead>
        <tr>
            <th></th> <!-- Columna para el ícono de expansión -->
            <th>CI</th>
            <th>Apellidos</th>
            <th>Nombres</th>
        </tr>
    </thead>
    <tbody>
        {% for certificate in certificates %}
        <tr>
            <td>{{ certificate.national_id }}</td>
            <td>{{ certificate.holder_first_name }}</td>
            <td>{{ certificate.holder_last_name }}</td>
            <td>{{ certificate.course }}</td>
            <td>{{ certificate.hours }}</td>
            <td>{{ certificate.start_date }}</td>
            <td>{{ certificate.end_date }}</td>
            <td>{{ certificate.certificate_code }}</td>
            <td>{{ certificate.institution }}</td>
        </tr>
        {% endfor %}
    </tbody>
</table>

<!-- Cargar el script de DataTables -->
<script src="https://cdn.datatables.net/2.1.8/js/dataTables.js"></script>

<script>
    $(document).ready(function() {
        // Inicializa DataTable
        var table = $('#myTable').DataTable({
            "processing": true,
            "serverSide": false,  // Usamos client-side, ya que todos los datos están en la página
            "searching": true,    // Habilitar la búsqueda
            "paging": true,       // Habilitar la paginación
            "order": [[ 0, 'asc' ]]  // Ordenar por CI de forma ascendente
        });

        // Evento para filtrar la tabla cuando se ingresa texto en el campo de búsqueda
        $('#searchInput').on('keyup', function() {
            table.search(this.value).draw();
        });

        // Acción del botón "Borrar" para limpiar el campo de búsqueda
        $('#Borrar').click(function() {
            $('#searchInput').val(''); // Limpia el campo de texto
            table.search('').draw();   // Vuelve a dibujar la tabla sin filtro
        });
    });
</script>

</body>
</html>
