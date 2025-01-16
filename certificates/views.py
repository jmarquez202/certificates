from django.contrib.auth import authenticate, login
from django.shortcuts import render, redirect
from record.models import Certificate
from django.contrib import messages
from django.db.models import Q


def data(request):
    data = Certificate.objects.all()
    return render(request, 'certificates/index.html', {'data': data})

def search_certificates(request):
    certificates = Certificate.objects.all()
    query = request.GET.get('q')  # Captura el término de búsqueda desde un input llamado 'q'
    
    if query:
        certificates = Certificate.objects.filter(
            Q(NONBRES__icontains=query) |
            Q(APELLIDOS__icontains=query) |
            Q(CODIGO_INTERNO__icontains=query)
        ).distinct()  # Asegura que no haya registros duplicados
    else:
        certificates = Certificate.objects.all().distinct()  # Si no hay búsqueda, evitar duplicados
    
    return render(request, 'certificates/index.html', {'certificates': certificates})

