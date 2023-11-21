from django.urls import path
from .views import ItemView, ItemDetailView

urlpatterns = [
    path('', ItemView.as_view(), name='ItemView'),
    path('detail/', ItemDetailView.as_view(), name='details'),
]
