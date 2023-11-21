from rest_framework import serializers
from .models import Item, Account


class Item(serializers.ModelSerializer):
    class Meta:
        model = Item
        fields = '__all__'

class AccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        fields = '__all__'
        # extra_kwargs = {'password': {'write_only': True}}