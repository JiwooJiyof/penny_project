import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationUtils {
  static const String googleApiKey = 'AIzaSyDpIWKiBj1P0x5buBX2losmBknSRYn1HVI';

  static Future<List<String>> fetchSuggestions(String input) async {
    final String backendUrl = 'https://boolean-boos.onrender.com/accounts/autocomplete/';

    try {
      final response = await http.get(Uri.parse('$backendUrl?input=$input'));
      if (response.statusCode == 200) {
        final List<dynamic> suggestions = json.decode(response.body);
        return suggestions.cast<String>();
      } else {
        print('Failed to load suggestions: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
      return [];
    }
  }

   static Future<Map<String, double>> getCoordinatesFromAddress(String address) async {
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].length > 0) {
          final location = data['results'][0]['geometry']['location'];
          return {'latitude': location['lat'], 'longitude': location['lng']};
        }
      }
      return {'latitude': 0.0, 'longitude': 0.0};
    } catch (e) {
      return {'latitude': 0.0, 'longitude': 0.0};
    }
  }

  static Future<LocationData?> getCurrentLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  static Future<String> getReadableAddress(
      double latitude, double longitude) async {
    final apiKey =
        'AIzaSyDpIWKiBj1P0x5buBX2losmBknSRYn1HVI'; // Replace with your Google API Key
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].length > 0) {
          return data['results'][0]['formatted_address'];
        }
      }
      return 'No address available';
    } catch (e) {
      return 'Failed to get address';
    }
  }
}
