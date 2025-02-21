from django.contrib.auth import authenticate, login
from django.shortcuts import render, redirect 
from django.http import HttpResponse
from django.db.models import Q
from record.models import Certificate
from django.contrib import messages
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from io import BytesIO

def data(request):
    # Obtiene todos los certificados para mostrarlos en la plantilla
    data = Certificate.objects.all()
    return render(request, 'certificates/index.html', {'data': data})

def search_certificates(request):
    # Captura el término de búsqueda desde un input llamado 'q'
    query = request.GET.get('q')
    
    if query:
        certificates = Certificate.objects.filter(
            Q(n__icontains=query) |
            Q(apellidos__icontains=query) |
            Q(codigo_interno__icontains=query)
        ).distinct()
    else:
        certificates = Certificate.objects.all().distinct()
    
    return render(request, 'certificates/index.html', {'certificates': certificates})

def generate_pdf_view(request):
    # Obtener todos los certificados
    certificates = Certificate.objects.all()

    # Verificar si hay certificados
    if not certificates:
        messages.error(request, "No hay certificados disponibles para generar el PDF.")
        return redirect('data')

    # Crear un objeto BytesIO para guardar el PDF en memoria
    buffer = BytesIO()
    p = canvas.Canvas(buffer, pagesize=letter)

    # Establecer posiciones y otros detalles
    y_position = 750  # Posición inicial en la página

    for certificate in certificates:
        if certificate.nombres and certificate.apellidos and certificate.curso:
            p.drawString(100, y_position, "CERTIFICADO ")
            y_position -= 20
            p.drawString(100, y_position, f"Otorgado a: {certificate.nombres} {certificate.apellidos}")
            y_position -= 20
            p.drawString(100, y_position, f"Por haber asistido satisfactoriamente al curso: {certificate.curso}")
            y_position -= 20
            p.drawString(100, y_position, f"durante el periodo comprendido entre {certificate.fecha_inicio} y {certificate.fecha_fin}.")
            y_position -= 20
            p.drawString(100, y_position, f"Con duración de: {certificate.horas_academicas} horas.")
            y_position -= 40
            
            # Si la posición y es demasiado baja, inicia una nueva página
            if y_position < 50:
                p.showPage()
                y_position = 750
        else:
            print(f"Datos faltantes para el certificado: {certificate}")

    p.showPage()
    p.save()

    buffer.seek(0)
    
    return HttpResponse(buffer, content_type='application/pdf')