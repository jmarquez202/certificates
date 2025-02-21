from django.contrib import admin
from .models import Certificate
from django.http import HttpResponseRedirect
from django.urls import path
from .views import generate_pdf_view
from django.urls import reverse

@admin.register(Certificate)
class CertificateAdmin(admin.ModelAdmin):
    list_display = ('n', 'nombres', 'apellidos', 'curso', 'fecha_inicio', 'fecha_fin', 'horas_academicas')

    actions = ['print_certificates']

    def print_certificates(self, request, queryset):
        # Redirigir a la URL de generación de PDF
        ids = ','.join(str(c.n) for c in queryset)
        return HttpResponseRedirect(f"{reverse('admin:print_certificates')}?ids={ids}")

    print_certificates.short_description = "Imprimir certificados seleccionados"

    def get_urls(self):
        urls = super().get_urls()
        custom_urls = [
            path('print_certificates/', self.admin_site.admin_view(generate_pdf_view), name='print_certificates'),
        ]
        return custom_urls + urls
