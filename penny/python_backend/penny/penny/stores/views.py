from django.shortcuts import render
from rest_framework import status
from rest_framework.generics import CreateAPIView, ListAPIView, RetrieveUpdateAPIView
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from .models import Item
from stores.models import Store
from .serializers import StoreSerializer
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


class ItemUpdateView(RetrieveUpdateAPIView):
    queryset = Store.objects.all()
    serializer_class = StoreSerializer
    pagination_class = StandardResultsSetPagination
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['name']  # Search by name or store
    permission_classes = [AllowAny]

    def update(self, request, *args, **kwargs):
        item_id = kwargs.get('pk')
        store_name = request.data.get('store_name', '')

        if not item_id:
            return Response(
                {'detail': 'Item ID (pk) not provided in the request.'},
                status=status.HTTP_400_BAD_REQUEST
            )

        store = get_object_or_404(Store, name=store_name)
        item = store.items.filter(id=item_id).first()

        if item is not None:
            new_price = request.data.get('price', '')
            item.price = new_price
            item.save()

            # Success
            return Response(
                self.get_serializer(store).data,
                status=status.HTTP_200_OK
            )
        else:
            return Response(
                {'detail': 'Item not found in the store.'},
                status=status.HTTP_404_NOT_FOUND
            )


class StoreView(ListAPIView):
    serializer_class = StoreSerializer
    pagination_class = StandardResultsSetPagination
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['name']  # Search by name or store
    permission_classes = [AllowAny]

    def get_queryset(self):
        search_term = self.request.query_params.get('name')
        queryset = Store.objects.all()

        # Filter by name if a search term is provided
        if search_term:
            queryset = queryset.filter(name__icontains=search_term)

        return queryset
