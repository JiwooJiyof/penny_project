from django.db import models
from django.contrib.auth.models import AbstractUser, Group, Permission


class Account(AbstractUser):
    # username = models.CharField(max_length=50)
    # password = models.CharField(max_length=50)
    # ShoppingCart = models.ForeignKey(ShoppingCart, on_delete=models.CASCADE)
    address = models.CharField(max_length=100)

    longitude = models.DecimalField(max_digits=22, decimal_places=16, blank=True, null=True)
    latitude = models.DecimalField(max_digits=22, decimal_places=16, blank=True, null=True)

    
    groups = models.ManyToManyField(
        Group,
        verbose_name='groups',
        blank=True,
        help_text='The groups this user belongs to. A user will get all permissions granted to each of their groups.',
        related_name="account_set",  
        related_query_name="account",
    )

    user_permissions = models.ManyToManyField(
        Permission,
        verbose_name='user permissions',
        blank=True,
        help_text='Specific permissions for this user.',
        related_name="account_set",  
        related_query_name="account",
    )

    def __str__(self):
        return self.username
