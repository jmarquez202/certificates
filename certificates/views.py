from django.http import JsonResponse
from django.shortcuts import render
from django.db.models import Q
from record.models import Certificate

def search_certificates(request):
    query = request.GET.get('q', '')
    
    if request.headers.get('x-requested-with') == 'XMLHttpRequest':
        if len(query) > 3:
            results = Certificate.objects.filter(
                Q(national_id__icontains=query) |
                Q(holder_first_name__icontains=query) |
                Q(holder_last_name__icontains=query) |
                Q(certificate_code__icontains=query)
            )
            
            results_list = list(results.values(
                'national_id',
                'holder_first_name',
                'holder_last_name',
                'course',
                'hours',
                'start_date',
                'end_date',
                'certificate_code',
                'institution'
            ))
            
            return JsonResponse({'results': results_list})
    
    return render(request, 'certificates/index.html', {'query': query})
