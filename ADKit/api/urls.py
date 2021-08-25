from django.conf.urls import url
import api.views as v
# from api.views import *
from django.urls import path
urlpatterns = [
    path('processVideo',v.processVideo,name="Process Video"),
    path('isServerUp',v.isServerUp,name="Server State"),
]