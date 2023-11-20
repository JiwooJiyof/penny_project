from django.db import models


class Account(models.Model):
    username = models.CharField(max_length=50)
    password = models.CharField(max_length=50)
    # ShoppingCart = models.ForeignKey(ShoppingCart, on_delete=models.CASCADE)

    # Use pointfield?
    location = models.CharField(max_length=255)

    def __str__(self):
        return self.username
