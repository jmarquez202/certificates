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
        # Filtrar certificados según la consulta de búsqueda
        certificates = Certificate.objects.filter(
            Q(NONBRES__icontains=query) |
            Q(APELLIDOS__icontains=query) |
            Q(CODIGO_INTERNO__icontains=query)
        )
    else:
        # Si no hay búsqueda, devolver todos los certificados
        certificates = Certificate.objects.all()
    
    return render(request, 'certificates/index.html', {'certificates': certificates})

def login_view(request):
    if request.method == 'POST':
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            user = form.get_user()
            login(request, user)
            return redirect('home')  # Cambia 'home' por la vista protegida que desees
        else:
            messages.error(request, 'Usuario o contraseña incorrectos.')
    else:
        form = AuthenticationForm()

    return render(request, 'login.html', {'form': form})


# Antes (puede causar error si 'id' no existe):
#certificates = Certificate.objects.filter(id=some_id)

# Después (usa un campo único existente como 'N' o 'CODIGO_INTERNO'):
#certificates = Certificate.objects.filter(N=some_n)

