import 'package:flutter/material.dart';
import 'package:penny/screens/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures proper initialization of Flutter

  LocationData? currentLocation = await getCurrentLocation();
  if (currentLocation != null) {
    await sendLocationToBackend(currentLocation);
  }

  runApp(MyApp(locationData: currentLocation));
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

Future<void> sendLocationToBackend(LocationData locationData) async {
  print(locationData);
  // var url = Uri.parse(
  //     'https://yourbackend.api/location'); // api endpoing
  // var response = await http.post(url,
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({
  //       'latitude': locationData.latitude,
  //       'longitude': locationData.longitude
  //     }));

  // if (response.statusCode == 200) {
  //   print('Location sent to backend successfully');
  // } else {
  //   print('Failed to send location to backend');
  //   print(locationData);
  // }
}

class MyApp extends StatelessWidget {
  final LocationData? locationData;

  MyApp({this.locationData});

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
      routes: {"/": (context) => HomePage(locationData: locationData)},
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:penny/screens/home_page.dart';
// import 'package:google_fonts/google_fonts.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Penny',
//       theme: ThemeData(
//         scaffoldBackgroundColor: Colors.white,
//         textTheme: GoogleFonts.interTextTheme(
//           Theme.of(context).textTheme,
//         ),
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a blue toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         // useMaterial3: true,
//       ),
//       routes: {"/": (context) => HomePage()},
//       // home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
