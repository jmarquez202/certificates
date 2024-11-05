from django.contrib.auth import authenticate, login
from django.http import JsonResponse
from django.shortcuts import render, redirect
from django.db.models import Q
from record.models import Certificate
from users.models import CustomUser
from django.contrib import messages

def search_certificates(request):
    query = request.GET.get('q', '')
    
    if request.headers.get('x-requested-with') == 'XMLHttpRequest':
        if len(query) > 2:
            results = Certificate.objects.filter(
                Q(national_id__icontains=query) |
                Q(holder_first_name__icontains=query) |
                Q(holder_last_name__icontains=query) |
                Q(certificate_code__icontains=query)
            )
            
            results_list = list(results.values(
                'national_id',
                'holder_first_name',
                'holder_last_name',
                'course',
                'hours',
                'start_date',
                'end_date',
                'certificate_code',
                'institution'
            ))
            return JsonResponse({'results': results_list})
    
    return render(request, 'certificates/index.html', {'query': query})

def panel_view(request):
    customuser = CustomUser.objects.all()
    certificate = Certificate.objects.all()
#    cargos = Cargo.objects.count()
#    encargados = Encargado.objects.count()
#    equipos = Equipo.objects.count()
#    mantenimientos = Mantenimiento.objects.count()
    return render(request, 'certificates/login.html', {'customuser': customuser, 'certificate': certificate,})

