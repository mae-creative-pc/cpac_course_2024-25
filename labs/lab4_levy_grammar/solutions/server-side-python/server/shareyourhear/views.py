from django.http import JsonResponse
from django.shortcuts import render

def index(request):
    if request.method == 'POST' and request.is_ajax():
        # Get the form data
        user_input = request.POST.get('userInput', '')

        # Process the data (you can do anything with it here, e.g., save to database)
        result = f'You entered: {user_input}'

        # Return a JSON response
        return JsonResponse({'result': result})

    # If GET request, render the form
    return render(request, 'index.html')