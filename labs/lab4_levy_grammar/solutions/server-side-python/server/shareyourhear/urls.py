from django.contrib import admin
from django.urls import path
from shareyourheart import views
from shareyourheart import functions
urlpatterns = [
    path('admin/', admin.site.urls),
    path('', views.index, name="index"),
    path('send_msg', functions.send_msg, name="send_msg"),
    path('get_msgs', functions.get_msgs, name="get_msgs"),
    # delete all?
]