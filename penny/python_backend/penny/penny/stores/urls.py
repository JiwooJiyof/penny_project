from django.urls import path
from .views import StoreView, ItemUpdateView, get_stores_distance

urlpatterns = [
    path('', StoreView.as_view(), name='store-view'),
    path('<int:pk>/',
         ItemUpdateView.as_view(), name='item-update'),
    path('distance/', get_stores_distance, name='get_stores_distance')
]
