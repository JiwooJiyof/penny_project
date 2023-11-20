from django.shortcuts import render
from rest_framework import status
from rest_framework.generics import CreateAPIView, ListAPIView, RetrieveUpdateAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from .models import Item
from .serializers import ItemSerializer
from rest_framework.pagination import PageNumberPagination
from rest_framework.filters import OrderingFilter
from django_filters.rest_framework import DjangoFilterBackend


class StandardResultsSetPagination(PageNumberPagination):
    page_size = 10
    page_size_query_param = "page_size"
    max_page_size = 10


class ItemView(ListAPIView):
    serializer_class = ItemSerializer
    pagination_class = StandardResultsSetPagination
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['name']  # Search by name
    ordering_fields = ['price', 'location']  # Sort by Price and Location
    # permission_classes = [IsAuthenticated]

    def get_queryset(self):
        search_term = self.request.query_params.get('name')
        queryset = Item.objects.all()

        # Filter by name if a search term is provided
        if search_term:
            queryset = queryset.filter(name__icontains=search_term)

        return queryset
