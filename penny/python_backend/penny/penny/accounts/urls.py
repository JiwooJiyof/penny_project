from django.urls import path
from . import views

urlpatterns = [
    path('signup/', views.CreateAccountView.as_view(), name='signup'),
    path('update/<int:pk>/', views.UpdateAccountView.as_view(), name='update-account'),
]

