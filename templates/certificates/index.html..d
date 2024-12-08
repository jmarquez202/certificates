{% load static %}

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Certificados</title>

    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">

    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.5/css/jquery.dataTables.min.css" />
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.5/css/dataTables.bootstrap4.min.css" />

    <!-- FontAwesome CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">

    <style>
        /* Estilo para la barra superior */
        .barra-superior {
            background-color: #050096; /* Azul oscuro */
            color: white;
            padding: 5px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .barra-superior a {
            color: white;
            margin-left: 15px;
            text-decoration: none;
        }

        .barra-superior a:hover {
            text-decoration: underline;
        }

        /* Estilo para la barra inferior */
        .barra-inferior {
            background-color: #678ccf; /* Azul intermedio */
            padding: 5px 10px;
            display: flex;
            align-items: center;
        }

        .barra-inferior img {
            max-height: 30px; /* Tamaño máximo del logotipo */
        }

        .barra-inferior .menu {
            margin-left: auto; /* Alinea el menú a la derecha */
            display: flex;
            gap: 20px; /* Espaciado entre las opciones del menú */
        }

        .barra-inferior .menu a {
            color: #d8e1f0;
            text-decoration: none;
            font-weight: bold;
        }

        .barra-inferior .menu a:hover {
            text-decoration: underline;
        }

        /* Estilo de la página */
        body {
            font-family: 'Arial', sans-serif;
            background-color: #dfe5ed;
        }

        #institution {
            text-align: center;
            margin-bottom: 30px;
        }

        #institution h1 {
            color: #67768e;
        }

        #institution p {
            color: #67768e;
        }

        #institution img {
            max-width: 200px;
            margin-bottom: 15px;
        }

        .btn-danger i {
            font-size: 16px; /* Tamaño del ícono */
        }

        /* Ocultar el cuadro de búsqueda interno de DataTables */
        .dataTables_filter {
            display: none;
        }

        table.dataTable tbody tr td.dt-control::before {
            content: "+";
            cursor: pointer;
        }

        table.dataTable tbody tr.shown td.dt-control::before {
            content: "-";
        }

        #searchInput {
            width: 150px; /* Tamaño de la barra de búsqueda */
            margin-right: 10px;
        }

        /* Estilo para que toda la fila sea clicable */
        #myTable tbody tr {
            cursor: pointer;
        }
    </style>
</head>
<body>
    <!-- Barra superior -->
    <div class="barra-superior">
        <div>
            <i class="fas fa-map-marker-alt"></i> SGA Estudiantes
        </div>
        <div>
            <a href="#"><i class="fas fa-broadcast-tower"></i> Radio</a>
            <a href="#"><i class="fas fa-tv"></i> TV</a>
            <a href="#"><i class="fas fa-book"></i> Revista</a>
            <a href="#"><i class="fas fa-images"></i> Galería</a>
            <a href="#"><i class="fab fa-facebook"></i></a>
            <a href="#"><i class="fab fa-twitter"></i></a>
        </div>
    </div>

    <!-- Barra inferior -->
    <div class="barra-inferior">
        <div>
            <img id="logo" src="{% static 'logo_2024.png' %}" alt="logo_2024">
        </div>
        <div class="menu">
            <a href="#">Inicio</a>
            <a href="#">Oferta Académica</a>
            <a href="#">Instituto</a>
            <a href="#">Repositorio</a>
        </div>
        <div>
            <a href="#"><i class="fas fa-search"></i></a>
        </div>
    </div>

    <!-- Contenido principal -->
    <div class="container mt-5">
        <div id="institution">
            <img src="{% static 'logo_2024.png' %}" alt="logo_2024">
            <h1 class="display-4">Certificados</h1>
            <p>Valida <strong>curso o capacitación</strong> en el siguiente apartado (Busca por nombres, apellidos, número de cédula, nombre del curso o por código de verificación).</p>        
        </div>

        <!-- Barra de búsqueda y botones -->
        <div class="d-flex justify-content-end align-items-center mb-3">
            <input type="text" id="searchInput" class="form-control" placeholder="Buscar...">
            <button type="button" id="Elimina" class="btn btn-danger btn-sm ml-2">
                <i class="fas fa-search"></i>
            </button>
            <button type="button" id="Elimina" class="btn btn-danger btn-sm ml-2">
                <i class="fas fa-search"></i>
            </button>      
        </div>

        <!-- Tabla con los resultados -->
        <table id="myTable" class="table table-striped table-bordered">
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
                <tr data-id="{{ certificate.id }}">
                    <td>{{ certificate.national_id }}</td>
                    <td>{{ certificate.holder_last_name }}</td>
                    <td>{{ certificate.holder_first_name }}</td>
                    <td>{{ certificate.course }}</td>
                </tr>
                {% endfor %}
            </tbody>
        </table>
    </div>

    <!-- Modal de detalles -->
    <div class="modal fade" id="detailsModal" tabindex="-1" aria-labelledby="detailsModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="detailsModalLabel">Detalles del Certificado</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p id="modalDetails">Cargando detalles...</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.5/js/dataTables.bootstrap4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        $(document).ready(function () {
            // Inicializar DataTable
            var table = $('#myTable').DataTable({
                language: {
                    search: "Buscar:",
                    lengthMenu: "Mostrar _MENU_ registros",
                    info: "Mostrando _START_ a _END_ de _TOTAL_ registros",
                    infoEmpty: "No se encontraron registros",
                    infoFiltered: "(filtrado de _MAX_ registros totales)"
                },
                columnDefs: [
                    { targets: [0, 3], visible: false } // Oculta las columnas CI (0) y Curso (3)
                ]
            });

            // Evento de búsqueda personalizado
            $('#searchInput').on('keyup', function () {
                table.search(this.value).draw(); // Filtra la tabla en tiempo real
            });

            // Evento click en la fila
            $('#myTable tbody').on('click', 'tr', function () {
                var rowData = table.row(this).data(); // Obtiene los datos de la fila clickeada
                var details = `
                    <p><strong>CI:</strong> ${rowData[0]}</p>
                    <p><strong>Apellidos:</strong> ${rowData[1]}</p>
                    <p><strong>Nombres:</strong> ${rowData[2]}</p>
                    <p><strong>Curso:</strong> ${rowData[3]}</p>
                    <p><strong>Horas Académicas:</strong> 20</p>
                    <p><strong>Fecha Inicio:</strong> 05/11/2022</p>
                    <p><strong>Fecha Fin:</strong> 05/13/2022</p>
                    <p><strong>Cod Interno:</strong> AULA-AF-1501-2022</p>
                    <p><strong>Aval:</strong> AULA MASTER</p>
                `;
                $('#modalDetails').html(details);
                $('#detailsModal').modal('show');
            });
        });
    </script>
</body>
</html>
