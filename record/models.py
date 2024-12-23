from django.db import models

# Create your models here.
class Certificate(models.Model):
    certificate_number = models.CharField(max_length=20, unique=True)
    national_id = models.CharField(max_length=50, null=True, blank=True)
    holder_first_name = models.CharField(max_length=100) 
    holder_last_name = models.CharField(max_length=100)
    course = models.CharField(max_length=20)
    hours = models.PositiveIntegerField()
    start_date = models.DateField()
    end_date = models.DateField()
    certificate_code = models.CharField(max_length=50, unique=True)
    institution = models.CharField(max_length=200)

    def __str__(self):
        return f"{self.certificate_number} - {self.holder_first_name} {self.holder_last_name}"