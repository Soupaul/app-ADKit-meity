from django.contrib.auth.base_user import AbstractBaseUser
from django.db import models

class User(AbstractBaseUser):
    username = models.CharField(max_length=40, unique=True)
    name = models.CharField(max_length=100)

class UserTests(models.Model):
    username = models.ForeignKey(
        User, on_delete=models.SET_NULL, null=True, blank=True
    )
    test_date = models.DateTimeField(verbose_name="Test Date", auto_now=True)
    video_url = models.URLField(max_length=1000, null=True, blank=True)
    feature_S = models.FloatField()