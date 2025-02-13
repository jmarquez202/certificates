from django.db import models

class Certificate(models.Model):
    n = models.CharField(max_length=20, primary_key=True)  # Cambié el nombre para que siga las convenciones de Python
    ci = models.CharField(max_length=50, null=True, blank=True)  # Cambié el nombre para seguir la convención
    nombres = models.CharField(max_length=50)  # Cambié el nombre a minúsculas
    apellidos = models.CharField(max_length=50)
    curso = models.CharField(max_length=200)
    horas_academicas = models.IntegerField()  # Usé guiones bajos para consistencia
    fecha_inicio = models.CharField(max_length=20)  # Puedes ajustar el max_length según sea necesario
    fecha_fin = models.CharField(max_length=255)  # Aumenta el max_length según sea necesario
    codigo_interno = models.CharField(max_length=50)
    aval = models.CharField(max_length=200)

    def __str__(self):
        # Cambié a usar campos existentes
        return f"{self.codigo_interno} - {self.nombres} {self.apellidos}"
