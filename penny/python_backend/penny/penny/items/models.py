from django.db import models


# class Store(models.Model):
#     name = models.CharField(max_length=100)
#     location = models.CharField(max_length=255)

#     def __str__(self):
#         return self.name


class Item(models.Model):
    name = models.CharField(max_length=100)
    price = models.IntegerField()
    store_name = models.CharField(max_length=255)
    location = models.CharField(max_length=255)

    def __str__(self):
        return self.name + self.store_name
