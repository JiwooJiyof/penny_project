from django.db import models
from django.contrib.auth.models import AbstractUser


class Account(AbstractUser):
    username = models.CharField(max_length=50)
    password = models.CharField(max_length=50)
    # ShoppingCart = models.ForeignKey(ShoppingCart, on_delete=models.CASCADE)
    address = models.CharField(max_length=100)

    longitude = models.DecimalField(max_digits=22, decimal_places=16, blank=True, null=True)
    latitude = models.DecimalField(max_digits=22, decimal_places=16, blank=True, null=True)

    def __str__(self):
        return self.username
