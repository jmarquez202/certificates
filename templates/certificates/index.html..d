{% load static %}

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Certificados</title>

    <!-- Cargar Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">

    <!-- Cargar los iconos de Bootstrap -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css" />

    <!-- Cargar DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.21/css/jquery.dataTables.min.css" />
    
    <!-- Cargar el tema de DataTables con Bootstrap 4 -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.21/css/dataTables.bootstrap4.min.css" />

    <style>
        /* Estilo general */
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
            color: #333;
        }

        #institution {
            text-align: center;
            padding: 5% 0;
            background-color: #ffffff;
            margin-bottom: 30px;
        }

        #institution img {
            max-width: 200px;
            margin-bottom: 15px;
        }

        .entry-title {
            font-size: 2.5em;
            margin-bottom: 15px;
        }

        /* Estilos para la tabla */
        .dataTables_wrapper {
            margin-top: 30px;
        }

        table.dataTable thead th {
            background-color: #3498db;
            color: white;
        }

        table.dataTable tbody tr:hover {
            background-color: #f1f1f1;
        }

        /* Ajustes responsivos */
        @media (max-width: 768px) {
            .dataTables_wrapper .dataTables_filter {
                float: none;
                text-align: center;
            }

            .dataTables_wrapper .dataTables_length {
                text-align: center;
                margin-bottom: 20px;
            }
        }

        /* Estilo para el buscador personalizado */
        .search-container {
            margin-bottom: 20px;
        }

        .search-container input {
            background-color: #e8f0fe;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            width: 250px;
        }

        /* Estilo para los botones */
        .button-container {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .details-row {
            display: none;
            background-color: #f9f9f9;
        }

        .shown {
            background-color: #d9edf7;
        }
    </style>
</head>
<body>

<div class="container mt-5">
    <div id="institution" class="text-center mb-5">
        <h1 class="display-4">Certificados</h1>
        <img id="logo" src="{% static 'logo_2024.png' %}" alt="logo_2024" class="mb-3" style="max-width: 200px;">
        <p class="lead">Valida <strong>curso</strong> o <strong>capacitación</strong> en el siguiente apartado 
            <em>(Busca por nombres, apellidos, número de cédula, nombre del curso o por código de verificación)</em>
        </p>
    </div>

    <div class="d-flex justify-content-between mb-3">
        <form method="GET" action="" id="searchForm" class="search-container">
            <input type="text" name="q" id="searchInput" placeholder="buscar..." autocomplete="off">
        </form>

        <div class="button-container">
            <input type="button" id="Elimina" value="Eliminar" class="btn btn-danger">
            <input type="button" id="Limpiar" value="Limpiar" class="btn btn-secondary">
        </div>
    </div>
    
    <!-- Tabla de resultados con Bootstrap -->
    <table id="myTable" class="table table-striped table-bordered dataTable" cellspacing="0" width="100%">
        <thead class="thead-dark">
            <tr>
                <th>CI</th>
                <th>Apellidos</th>
                <th>Nombres</th>
                <th>Curso</th>
            </tr>
        </thead>
        <tbody>
            {% for certificate in certificates %}
            <tr data-id="{{ certificate.national_id }}">
                <td>{{ certificate.national_id }}</td>
                <td>{{ certificate.holder_last_name }}</td>
                <td class="details-toggle">{{ certificate.holder_first_name }}</td>
                <td>{{ certificate.course }}</td>
            </tr>
            <!-- Submenú oculto -->
            <tr class="details-row" data-id="{{ certificate.national_id }}">
                <td colspan="4">
                    <ul>
                        <li><strong>Horas Académicas:</strong> {{ certificate.hours }}</li>
                        <li><strong>Fecha Inicio:</strong> {{ certificate.start_date }}</li>
                        <li><strong>Fecha Fin:</strong> {{ certificate.end_date }}</li>
                        <li><strong>Código Interno:</strong> {{ certificate.internal_code }}</li>
                    </ul>
                </td>
            </tr>
            {% endfor %}
        </tbody>
    </table>
</div>

<!-- Cargar los scripts necesarios -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.10.21/js/dataTables.bootstrap4.min.js"></script>

<script>
    $(document).ready(function() {
        // Inicializar DataTable
        var table = $('#myTable').DataTable({
            "processing": true,
            "serverSide": false,  // Usamos client-side, ya que todos los datos están en la página
            "searching": true,    // Habilitar la búsqueda
            "paging": true,       // Habilitar la paginación
            "order": [[ 0, 'asc' ]],  // Ordenar por CI de forma ascendente
            "language": {
                "search": "Buscar:",
                "lengthMenu": "Mostrar _MENU_ registros ",
                "info": "Mostrando _START_ a _END_ de _TOTAL_ registros",
                "infoEmpty": "No se encontraron registros",
                "infoFiltered": "(filtrado de _MAX_ registros totales)"
            }
        });

        // Sincronizar el campo de búsqueda con el buscador de DataTables
        $('#searchInput').on('keyup', function() {
            table.search(this.value).draw(); // Filtra los resultados al escribir
        });

        // Acción al hacer clic sobre una fila para mostrar los detalles
        $('#myTable tbody').on('click', 'td.details-toggle', function () {
            var tr = $(this).closest('tr');
            var row = table.row(tr);

            // Si los detalles están visibles, los ocultamos
            if (tr.next('.details-row').is(':visible')) {
                tr.next('.details-row').slideUp();
                tr.removeClass('shown');
            } else {
                // Si los detalles están ocultos, los mostramos
                tr.next('.details-row').slideDown();
                tr.addClass('shown');
            }
        });
    });
</script>

</body>
</html>
