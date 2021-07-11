from django import conf
from django.views.decorators import csrf
from api.models import User, UserTests
from rest_framework import viewsets
from rest_framework import permissions
from api.serializers import UserSerializer, GroupSerializer
from django.conf import settings
from django.http import JsonResponse, response
from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import render
from api.frame import FrameCapture
from rest_framework import status
from rest_framework.response import Response
import json
from api.code import exeCode
import os
import numpy as np

class UserViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows users to be viewed or edited.
    """
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]


class GroupViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows groups to be viewed or edited.
    """
    queryset = UserTests.objects.all()
    serializer_class = GroupSerializer
    permission_classes = [permissions.IsAuthenticated]

@csrf_exempt
def processVideo(request):
    if request.method == "POST":
        json_data = json.loads(request.body)
        video_url = json_data['URL']
        age = json_data['AGE']
        gender = json_data['GENDER']
        # count = FrameCapture(video_url)
        # exeCode(count)
        if(os.path.exists('api/frames/all_feat.csv')):
            X = np.loadtxt("api/frames/all_feat.csv", delimiter=",")
            # print(X.shape)
            gender = int(gender)
            age = int(age)
            x = np.array([gender,age])
            a = np.concatenate((x,X),axis=0)
            # print(a.shape)
            prediction = settings.MODEL_OBJ.predict(a.reshape(1, -1))
            # print(prediction)

    return JsonResponse({"val":prediction[0]},safe=False)