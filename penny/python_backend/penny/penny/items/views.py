from django.shortcuts import render
from rest_framework import status
from rest_framework.generics import CreateAPIView, ListAPIView, RetrieveUpdateAPIView
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from .models import Item
from stores.models import Store
from .serializers import ItemSerializer
from rest_framework.pagination import PageNumberPagination
from rest_framework.filters import OrderingFilter
from django_filters.rest_framework import DjangoFilterBackend
from django.shortcuts import get_object_or_404
from django.http import JsonResponse
from rest_framework import status


class StandardResultsSetPagination(PageNumberPagination):
    page_size = 10
    page_size_query_param = "page_size"
    max_page_size = 10


class ItemView(ListAPIView):
    serializer_class = ItemSerializer
    pagination_class = StandardResultsSetPagination
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    ordering_fields = ['price', 'location']  # Sort by Price and Location
    filterset_fields = ['name']  # Search by name or store
    permission_classes = [AllowAny]

    def get_queryset(self):
        search_term = self.request.query_params.get('name')
        queryset = Item.objects.all()

        # Filter by name if a search term is provided
        if search_term:
            queryset = queryset.filter(name__icontains=search_term)

        return queryset


class ItemDetailView(ListAPIView):
    serializer_class = ItemSerializer
    pagination_class = StandardResultsSetPagination
    filterset_fields = ['name']
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    # Sort by Price and Location
    ordering_fields = ['items__price', 'location']
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        search_term = self.request.query_params.get('name')

        # Filter stores based on items that contain the search input
        stores = Store.objects.filter(items__name__icontains=search_term)

        # Initialize a list to store store names and prices
        store_data = []

        for store in stores:
            # Fetch the price for the current item and store
            price_for_store = store.items.filter(
                name__icontains=search_term).values('price').first()

            # Check if the item exists in the store
            if price_for_store is not None:
                store_data.append(
                    {'store_name': store.name, 'price': price_for_store['price']})

        ordering_param = self.request.query_params.get(
            'ordering', 'items__price')
        reverse_order = ordering_param.startswith('-')

        if reverse_order:
            store_data = sorted(
                store_data, key=lambda x: x.get('price', 0), reverse=True)
        else:
            store_data = sorted(store_data, key=lambda x: x.get('price', 0))

        return JsonResponse({'stores_with_item': store_data}, status=status.HTTP_200_OK)
