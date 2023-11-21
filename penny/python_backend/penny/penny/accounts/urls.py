from django.urls import path
from . import views

urlpatterns = [
    path('signup/', views.CreateAccountView.as_view(), name='signup'),
    path('account/update/', views.UpdateAccountView.as_view(), name='update-account'),
]

