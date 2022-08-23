import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:url_launcher/url_launcher.dart';

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox(
        height: size.height,
        child: const MapLocal(),
      ),
    );
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
  const MapLocal({Key? key}) : super(key: key);

  @override
  State<MapLocal> createState() => _MapLocalState();
}

class _MapLocalState extends State<MapLocal> {
  MapboxMapController? mapController;
  double latitude = -25.32206, longitude = -57.52255;

  @override
  void initState() {
    latitude = -25.32206;
    longitude = -57.52255;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _onMapCreated(MapboxMapController mapboxMapController) {
    mapController = mapboxMapController;
  }

  void addSymbol(MapboxMapController mapBoxController) {
    mapBoxController.addSymbol(
      SymbolOptions(
        geometry: LatLng(latitude, longitude),
        iconImage: "assets/images/Marker.png",
        iconSize: 1,
      ),
    );
  }

  void launchGoogleMaps(
      {required double latitude, required double longitude}) async {
    LatLng from = const LatLng(-25.32406, -57.22255);

    final String googleMapsUrl = "https://www.google.com/maps/dir/?api=1&origin=43.7967876,-79.5331616&destination=43.5184049,-79.8473993&waypoints=43.1941283,-79.59179|43.7991083,-79.5339667|43.8387033,-79.3453417|43.836424,-79.3024487&travelmode=driving&dir_action=navigate";

    Uri googleUrl;
    if (Platform.isIOS) {
      googleUrl = Uri(
          scheme: 'https',
          host: "www.google.com",
          path: "maps/dir/",
          queryParameters: {
            "api": "1",
            "origin": "43.7967876,-79.5331616",
            "destination": "43.5184049,-79.8473993",
          }
          // queryParameters: {"api": '1', "query": "$latitude,$longitude"},
          );
    } else {
      googleUrl = Uri(
          scheme: 'https',
          host: "www.google.com",
          path: "maps/dir/",
          queryParameters: {
            "api": "1",
            "origin": "43.7967876,-79.5331616",
            "destination": "43.5184049,-79.8473993",
          }
        // queryParameters: {"api": '1', "query": "$latitude,$longitude"},
      );
    }

    // 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    // 'https://www.google.com/maps/dir/-25.32406,+-57.22255/-25.32206,-57.52255/@-25.3022023,-57.4411378,12z/data=!3m1!4b1!4m6!4m5!1m3!2m2!1d-57.22255!2d-25.32406!1m0'

    print("a");
    try {
      await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      accessToken:
          'pk.eyJ1IjoiYmFzc2xpbmU1MjgiLCJhIjoiY2w0bHJ5b2lpMDEzazNqcnlsMHR0cXBsOCJ9.TavVMlzmqMwhAnwZZkP_lQ',
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: () => addSymbol(mapController!),
      initialCameraPosition: CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 10.0,
      ),
      onMapClick: (point, latlng) {
        print(latlng.latitude);
        launchGoogleMaps(latitude: latitude, longitude: longitude);
        print(
            "From Map ${latlng.latitude} |${latlng.latitude} \nFrom Server $latitude||$longitude \n\n");
      },
    );
  }
}
