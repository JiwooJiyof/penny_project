from django.urls import path
from .views import ItemView, ItemDetailView, ItemUpdateView

urlpatterns = [
    path('', ItemView.as_view(), name='ItemView'),
    path('<int:pk>/', ItemDetailView.as_view(), name='details'),
    path('<int:pk>/update/', ItemUpdateView.as_view(), name='update')
]
