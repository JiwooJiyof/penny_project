from django.urls import path
from . import views


urlpatterns = [
    path('addItem/<str:item_name>/', views.AddItemToCartView.as_view(), name='addItem'),
    path('removeItem/<str:item_name>/', views.RemoveItemFromCartView.as_view(), name='removeItem'),
    path('check/<str:item_name>/', views.CheckOffItemView.as_view(), name='check'),
    path('uncheck/<str:item_name>/', views.UncheckItemView.as_view(), name='uncheck'),
    path('view/', views.ViewItems.as_view(), name='view'),
]