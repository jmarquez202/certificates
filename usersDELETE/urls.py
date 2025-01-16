# mi_app/urls.py

from django.urls import path
from . import views

urlpatterns = [
    path('search/', views.search_certificates, name='search_certificates'),
    path('login/', views.login_view, name='login'),
]