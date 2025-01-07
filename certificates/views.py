from django.contrib.auth import authenticate, login
from django.shortcuts import render, redirect
from record.models import Certificate
from django.contrib import messages

def search_certificates(request):
    # Obtener todos los certificados sin filtrarlos
    certificates = Certificate.objects.all()

    # Pasar todos los certificados a la plantilla
    return render(request, 'certificates/index.html', {'certificates': certificates})

def login_view(request):
    if request.method == 'POST':
        # Obtener los datos del formulario
        username = request.POST.get('username')
        password = request.POST.get('password')
        
        # Autenticar al usuario
        user = authenticate(request, username=username, password=password) # type: ignore
        
        if user is not None:
            # Iniciar sesión al usuario
            login(request, user)
            return redirect('home')  # Redirigir a la página de inicio u otra página protegida
        else:
            # Mostrar un mensaje de error si las credenciales son incorrectas
            messages.error(request, 'Usuario o contraseña incorrectos.')
    
    return render(request, 'login.html')

# Antes (puede causar error si 'id' no existe):
#certificates = Certificate.objects.filter(id=some_id)

# Después (usa un campo único existente como 'N' o 'CODIGO_INTERNO'):
#certificates = Certificate.objects.filter(N=some_n)

