from rest_framework import serializers
from rest_framework.validators import ValidationError
from .models import Account


class AccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        fields = ['name', 'email', 'username', 'password', 'confirm_password', 'address', 'longitude', 'latitude']
        # extra_kwargs = {'password': {'write_only': True}}
    
    def validate(self, attrs):
        
        email_exists=Account.objects.filter(email=attrs['email']).exists()

        if email_exists:
            raise ValidationError("Email already in use")

        if attrs.get('password') != attrs.get('confirm_password'):
            raise ValidationError("Passwords do not match")

        return super().validate(attrs)

class AccountUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        fields = ['name', 'email', 'username', 'password', 'confirm_password', 'address', 'longitude', 'latitude']
        # extra_kwargs = {'password': {'write_only': True}}

    
    def update(self, instance, validated_data):
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        # if 'username' in validated_data:
        #     instance.username = validated_data['username']
        # if 'password' in validated_data:
        #     instance.password = validated_data['password']
        # if 'address' in validated_data:
        #     instance.address = validated_data['address']
        # if 'latitude' in validated_data:
        #     instance.latitude = validated_data['latitude']
        # if 'longitude' in validated_data:
        #     instance.longitude = validated_data['longitude']

        instance.save()
        return instance