import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';
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
  GooglePlayServicesAvailability _availability = GooglePlayServicesAvailability.unknown;

  @override
  void initState() {
    if(Platform.isIOS){
      _isIos = true;
      _loading = false;
    } else {
      checkGoogleServicesAvailability();
    }
    super.initState();
  }

  void checkGoogleServicesAvailability() async {
    _availability = await GoogleApiAvailability.instance.checkGooglePlayServicesAvailability(true);
    _loading = false;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Mapa", style: TextStyle(color: Colors.black, fontSize: 20)),
            if(_loading) const CircularProgressIndicator.adaptive(),
            if (_availability == GooglePlayServicesAvailability.success || _isIos)
              const CustomPlatformMap()
            else
              const IFrameMap(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CustomPlatformMap extends StatelessWidget {
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
}

class IFrameMap extends StatefulWidget {
  const IFrameMap({Key? key}) : super(key: key);

  @override
  State<IFrameMap> createState() => _IFrameMapState();
}

class _IFrameMapState extends State<IFrameMap> {
  final initialContent = '<h4> Cargando <h4>';
  late WebViewXController webViewController;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WebViewAware(
      debug: true,
      child: WebViewX(
        key: const ValueKey('webviewx'),
        initialContent: initialContent,
        initialSourceType: SourceType.html,
        height: size.height / 2,
        width: min(size.width * 0.8, 1024),
        onWebViewCreated: (controller) {
          webViewController = controller;
          webViewController.loadContent(
            'https://www.google.com/maps/d/u/0/edit?mid=1LWCD6Ehrlfo-U1tv0BMFRkNizUxlsFs&usp=sharing',
            SourceType.url,
          );
        },
        onPageStarted: (src) =>
            debugPrint('A new page has started loading: $src\n'),
        onPageFinished: (src) =>
            debugPrint('The page has finished loading: $src\n'),
        jsContent: const {
          EmbeddedJsContent(
            js: "function testPlatformIndependentMethod() { console.log('Hi from JS') }",
          ),
          EmbeddedJsContent(
            webJs:
            "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",
            mobileJs:
            "function testPlatformSpecificMethod(msg) { TestDartCallback.postMessage('Mobile callback says: ' + msg) }",
          ),
        },
        dartCallBacks: {
          DartCallback(
            name: 'TestDartCallback',
            callBack: (msg) =>
                showSnackBar(msg.toString(), context),
          )
        },
        webSpecificParams: const WebSpecificParams(
          printDebugInfo: true,
        ),
        mobileSpecificParams: const MobileSpecificParams(
          androidEnableHybridComposition: true,
        ),
        navigationDelegate: (navigation) {
          debugPrint(navigation.content.sourceType.toString());
          return NavigationDecision.navigate;
        },
      ),
    );
  }
  showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

 Set<Marker> getMarkers() {
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
 }