from django.shortcuts import render

# Create your views here.# record/views.py
from django.http import HttpResponse
from reportlab.pdfgen import canvas

def generate_pdf_view(request):
    # Crear el objeto HttpResponse con el contenido PDF
    response = HttpResponse(content_type='application/pdf')
    response['Content-Disposition'] = 'attachment; filename="certificado.pdf"'

    # Crear el PDF
    p = canvas.Canvas(response)
    p.drawString(100, 750, "Certificado de Finalización")
    p.showPage()
    p.save()

    return response

