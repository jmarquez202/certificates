from django.db import models

# Create your models here.
class Certificate(models.Model):
    N = models.CharField(max_length=20, primary_key=True)
    CI = models.CharField(max_length=50, null=True, blank=True)
    NONBRES = models.CharField(max_length=100) 
    APELLIDOS = models.CharField(max_length=100)
    CURSO = models.CharField(max_length=20)
    HORAS_ACADEMICAS = models.PositiveIntegerField()
    FECHA_INICIO = models.DateField()
    FECHA_FIN = models.DateField()
    CODIGO_INTERNO = models.CharField(max_length=50, unique=True)
    AVAL = models.CharField(max_length=200)

    def __str__(self):
        return f"{self.certificate_number} - {self.holder_first_name} {self.holder_last_name}"