import 'package:flutter/material.dart';
import 'package:penny/screens/home_page.dart';
import 'package:penny/screens/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<LocationData?> locationFuture = getCurrentLocation();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Penny',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      // routes: {"/": (context) => LoginPage()},
      routes: {
        "/": (context) => FutureBuilder<LocationData?>(
              future: locationFuture,
              builder: (context, snapshot) {
                // Check if the future is complete and has data
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  return HomePage(locationData: snapshot.data);
                }
                // Return HomePage with null locationData if the future is not complete or has no data
                return HomePage(locationData: null);
              },
            )
      },
    );
  }
}

Future<LocationData?> getCurrentLocation() async {
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

// You can uncomment and modify this function to send the location data to your backend
// Future<void> sendLocationToBackend(LocationData locationData) async {
//   // Your implementation to send location data to backend
// }
