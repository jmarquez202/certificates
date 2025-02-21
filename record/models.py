from django.db import models

class Certificate(models.Model):
    n = models.CharField(max_length=20, primary_key=True)  # Campo n como clave primaria
    ci = models.CharField(max_length=50, null=True, blank=True)
    nombres = models.CharField(max_length=50)
    apellidos = models.CharField(max_length=50)
    curso = models.CharField(max_length=200)
    horas_academicas = models.IntegerField()
    fecha_inicio = models.CharField(max_length=20)
    fecha_fin = models.CharField(max_length=20)
    codigo_interno = models.CharField(max_length=50)
    aval = models.CharField(max_length=200)

    def __str__(self):
        return f"{self.codigo_interno} - {self.nombres} {self.apellidos}"
