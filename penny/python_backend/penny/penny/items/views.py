from django.shortcuts import render
from rest_framework import status
from rest_framework.generics import CreateAPIView, ListAPIView, RetrieveUpdateAPIView
from rest_framework.permissions import IsAuthenticated
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
    filterset_fields = ['name']  # Search by name or store
    # permission_classes = [IsAuthenticated]

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
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    ordering_fields = ['price', 'location']  # Sort by Price and Location
    # permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        item = get_object_or_404(Item, pk=kwargs['pk'])
        stores = Store.objects.filter(items=item)

        # Initialize a dictionary to store store names and prices
        store_data = {}

        for store in stores:
            price_for_store = store.items.get(pk=item.pk).price
            store_data[store.name] = {'price': price_for_store}

        return JsonResponse({'stores_with_item': store_data}, status=status.HTTP_200_OK)
