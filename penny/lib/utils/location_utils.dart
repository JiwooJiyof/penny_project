import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationUtils {
  static const String googleApiKey = 'AIzaSyDpIWKiBj1P0x5buBX2losmBknSRYn1HVI';

  static Future<List<String>> fetchSuggestions(String input) async {
    if (input.isEmpty) return [];
    final String request =
        'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$googleApiKey&types=address';

    try {
      final response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        final predictions = json.decode(response.body)['predictions'];
        return List<String>.from(predictions.map((p) => p['description']));
      } else {
        print('HTTP Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load suggestions');
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
      return [];
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
