from django.urls import path
from .views import ViewCartItems, UpdateCartItems

urlpatterns = [
    path('view/', ViewCartItems.as_view(), name='view-cart-items'),
    path('update/', UpdateCartItems.as_view(), name='update-cart-items'),
]