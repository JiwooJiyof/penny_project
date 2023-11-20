from django.urls import path
from .views import ItemView

urlpatterns = [
    path('', ItemView.as_view(), name='ItemView'),
    path('search/', ItemView.as_view(), name='search_items'),
]
