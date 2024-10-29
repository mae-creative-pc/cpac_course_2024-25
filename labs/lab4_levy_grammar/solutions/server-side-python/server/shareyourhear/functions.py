from urllib.parse import parse_qs
from shareyourheart.models import Text
from django.http import JsonResponse

def get_msgs(request):
  texts=Text.objects.all()
  response={"msgs":[]}
  for text in texts:
    response["msgs"].append(text.text)
  return JsonResponse(response)

def send_msg(request):
  try:
    query = parse_qs(request.META["QUERY_STRING"])
    obj=Text.objects.create(text=query["text"][0])
    obj.save()
    response={"status":"ok", "message":"ok"}
  except Exception as exc:
    response={"status":"fail", "message":str(exc)}
  return JsonResponse(response)
