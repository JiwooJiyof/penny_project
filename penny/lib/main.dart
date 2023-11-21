import 'package:flutter/material.dart';
import 'package:penny/screens/home_page.dart';
import 'package:penny/screens/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:penny/utils/location_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<LocationData?> locationFuture =
      LocationUtils.getCurrentLocation(); // Use the LocationUtils class

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
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return HomePage(locationData: snapshot.data);
                }
                return HomePage(locationData: null);
              },
            )
      },
    );
  }
}
