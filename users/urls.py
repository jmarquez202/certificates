# mi_app/urls.py

from django.urls import path
from . import views

urlpatterns = [
    path('search_certificates/', views.search_certificates, name='search_certificates'),  # Ruta de búsqueda de certificados
]
