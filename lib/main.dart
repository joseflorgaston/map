import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'package:webviewx/webviewx.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Mapa'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _loading = true;
  bool _isIos = false;
  GooglePlayServicesAvailability _availability =
      GooglePlayServicesAvailability.unknown;

  @override
  void initState() {
    if (Platform.isIOS) {
      _isIos = true;
      _loading = false;
    } else {
      checkGoogleServicesAvailability();
    }
    super.initState();
  }

  void checkGoogleServicesAvailability() async {
    _availability = await GoogleApiAvailability.instance
        .checkGooglePlayServicesAvailability(true);
    _loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: MapLocal());
  }
}

/*class CustomPlatformMap extends StatelessWidget {
  const CustomPlatformMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height / 2,
      width: min(size.width * 0.8, 1024),
      child: PlatformMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(-25.32206, -57.52255),
          zoom: 16.0,
        ),
        mapType: MapType.normal,
        markers: getMarkers(),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onTap: (location) => print('onTap: $location'),
        onCameraMove: (cameraUpdate) => print('onCameraMove: $cameraUpdate'),
        compassEnabled: true,
        onMapCreated: (controller) {
          Future.delayed(const Duration(seconds: 2)).then(
            (_) {
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  const CameraPosition(
                    bearing: 270.0,
                    target: LatLng(-25.32206, -57.52255),
                    tilt: 30.0,
                    zoom: 12,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}*/

/*Set<Marker> getMarkers() {
  return <Marker>{
    Marker(
      position: const LatLng(-25.29894, -57.57182),
      markerId: MarkerId("1"),
    ),
    Marker(
      position: const LatLng(-25.2949, -57.54727),
      markerId: MarkerId("2"),
    ),
    Marker(
      position: const LatLng(-25.31073, -57.58641),
      markerId: MarkerId("3"),
    ),
    Marker(
      position: const LatLng(-25.31399, -57.55602),
      markerId: MarkerId("4"),
    ),
    Marker(
      position: const LatLng(-25.31166, -57.57061),
      markerId: MarkerId("5"),
    ),
    Marker(
      position: const LatLng(-25.32206, -57.52255),
      markerId: MarkerId("6"),
    ),
  };
}*/

class MapLocal extends StatefulWidget {
  MapLocal({Key? key}) : super(key: key);

  @override
  State<MapLocal> createState() => _MapLocalState();
}

class _MapLocalState extends State<MapLocal> {
  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(-25.32206, -57.52255),
        zoom: 16.0,
      ),
      accessToken:
          'pk.eyJ1IjoiYmFzc2xpbmU1MjgiLCJhIjoiY2w0bHJ5b2lpMDEzazNqcnlsMHR0cXBsOCJ9.TavVMlzmqMwhAnwZZkP_lQ',
    );
  }
}
