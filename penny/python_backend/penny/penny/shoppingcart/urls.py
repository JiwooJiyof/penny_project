from django.urls import path
from . import views


urlpatterns = [
    path('addItem/<str:item_name>/', views.AddItemToCartView.as_view(), name='addItem'),
    path('removeItem/<str:item_name>/', views.RemoveItemFromCartView.as_view(), name='removeItem'),
    path('togglecheck/<str:item_name>/', views.ToggleCheckItemView.as_view(), name='togglecheck'),
    path('view/', views.ViewItems.as_view(), name='view'),
]