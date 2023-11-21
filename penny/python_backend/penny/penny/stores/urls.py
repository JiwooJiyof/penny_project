from django.urls import path
from .views import StoreView, ItemUpdateView

urlpatterns = [
    path('', StoreView.as_view(), name='store-view'),
    path('<int:pk>/',
         ItemUpdateView.as_view(), name='item-update'),
]
