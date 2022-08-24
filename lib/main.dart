import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:maps_launcher/maps_launcher.dart';
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
        .checkGooglePlayServicesAvailability(false);
    _loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(children: const [Expanded(child: MapLocal())]),
    );
  }
}

class MapLocal extends StatefulWidget {
  const MapLocal({Key? key}) : super(key: key);

  @override
  State<MapLocal> createState() => _MapLocalState();
}

class _MapLocalState extends State<MapLocal> {
  MapboxMapController? mapController;
  double latitude = -25.3084198, longitude = -57.6104458;
  GooglePlayServicesAvailability _availability = GooglePlayServicesAvailability.unknown;
  bool showMap = true;

  @override
  void initState() {
    if (Platform.isAndroid) {
      checkGoogleServicesAvailability();
    }
    super.initState();
  }

  void checkGoogleServicesAvailability() async {
    _availability = await GoogleApiAvailability.instance
        .checkGooglePlayServicesAvailability(false);
    setState(() {});
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
    List<LatLng> markersLatLng = getLatLngList();
    for (var element in markersLatLng) {
      mapBoxController.addSymbol(
        SymbolOptions(
          geometry: LatLng(element.latitude, element.longitude),
          iconImage: "assets/images/Marker.png",
          iconSize: 1.2,
        ),
      );
    }

    mapBoxController.onSymbolTapped.add((argument) {
      LatLng latLng = argument.options.geometry!;
      _launchMap(lat: latLng.latitude, lon: latLng.longitude);
    });
  }

  _launchMap({required double lat, required double lon}) async {
    /*if (Platform.isIOS) {
      var installedMaps = MapLauncher.installedMaps;
      installedMaps.then((value) => print(value));
    }*/
    var installedMaps = MapLauncher.installedMaps;
    installedMaps.then((value) async {
      print(value);
      showMap = false;
      setState(() {});
      await showModalBottomSheet(
          clipBehavior: Clip.hardEdge,
          context: context,
          builder: (_context) {
            return Wrap(
              children: [
                for (var item in value)
                  InkWell(
                    onTap: () {
                      MapLauncher.showMarker(
                          mapType: item.mapType,
                          coords: Coords(lat, lon),
                          title: "title",
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 150,
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(item.mapName),
                      ),
                    ),
                  ),
              ],
            );
          });
      showMap = true;
      setState((){});
    });

    // MapsLauncher.launchCoordinates(lat, lon);
  }

  @override
  Widget build(BuildContext context) {
    return showMap ? MapboxMap(
      accessToken: 'pk.eyJ1IjoiYmFzc2xpbmU1MjgiLCJhIjoiY2w0bHJ5b2lpMDEzazNqcnlsMHR0cXBsOCJ9.TavVMlzmqMwhAnwZZkP_lQ',
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: () => addSymbol(mapController!),
      initialCameraPosition: CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 12.0,
      ),
    ) : const SizedBox();
  }

  List<LatLng> getLatLngList() {
    return const [
      LatLng(-25.28478088337046, -57.56342023086017),
      LatLng(-25.28871928855482, -57.5710379742296),
      LatLng(-25.295014964202693, -57.60258569622273),
      LatLng(-25.296942081089593, -57.57992117416207),
      LatLng(-25.283944785636074, -57.567152738686566),
      LatLng(-25.304114478417496, -57.61058117236018),
      LatLng(-25.302629687990915, -57.64098817093529),
      LatLng(-25.291493639666992, -57.619502530955614),
      LatLng(-25.291933089215505, -57.60257001073464),
      LatLng(-25.29259128610859, -57.597107832448344),
      LatLng(-25.287267663373203, -57.58794419443268),
      LatLng(-25.3017543633767, -57.581752309410156),
      LatLng(-25.287212932309792, -57.56791584095462),
      LatLng(-25.275580438998546, -57.5764131235925),
      LatLng(-25.289518423062724, -57.59498316173665),
    ];
  }
}
