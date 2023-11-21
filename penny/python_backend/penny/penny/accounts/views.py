from django.shortcuts import render
from rest_framework import status
from rest_framework.generics import CreateAPIView, ListAPIView, RetrieveUpdateAPIView, RetrieveAPIView
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.request import Request
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from .models import Account
from .serializers import AccountSerializer, AccountUpdateSerializer
from rest_framework.pagination import PageNumberPagination
from rest_framework.filters import OrderingFilter
from django_filters.rest_framework import DjangoFilterBackend


class StandardResultsSetPagination(PageNumberPagination):
    page_size = 10
    page_size_query_param = "page_size"
    max_page_size = 10

# creating an account
class CreateAccountView(CreateAPIView):
    serializer_class = AccountSerializer
    permission_classes = [AllowAny]
    
    def post(self,request:Request):
        data = request.data

        serializer=self.serializer_class(data=data)

        if serializer.is_valid():
            serializer.save()

            response={
                "message": "User Created Successfully",
                "data":serializer.data
            }
            return Response(data=response, status=status.HTTP_201_CREATED)
        
        return Response(data=serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UpdateAccountView(RetrieveUpdateAPIView):
    serializer_class = AccountUpdateSerializer
    queryset = Account.objects.all()
    # permission_classes = [IsAuthenticated]

    # def put(self, request:Request):
    #     data = request.data

    def get_object(self):
        return self.request.user


class AccountProfileView(ListAPIView):
    serializer_class = AccountSerializer
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        user = self.get_object()
        return Response(
                    self.get_serializer(user).data,
                    status=status.HTTP_200_OK
        )

class AccountInfoView(RetrieveAPIView):
    serializer_class = AccountSerializer
    permission_classes = [IsAuthenticated]

    def get_object(self):
        return self.request.user