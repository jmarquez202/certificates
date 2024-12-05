from django.contrib.auth import authenticate, login
from django.http import JsonResponse
from django.shortcuts import render, redirect
from django.db.models import Q
from record.models import Certificate
from users.models import CustomUser
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

def panel_view(request):
    return render(request, 'panel.html')  # Usa el nombre de tu plantilla HTML