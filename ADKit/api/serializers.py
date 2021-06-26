from django.contrib.auth.models import User, UserTests
from rest_framework import serializers


class UserSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'name']


class GroupSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = UserTests
        fields = ['username', 'test_date', 'video_url', 'feature_S']