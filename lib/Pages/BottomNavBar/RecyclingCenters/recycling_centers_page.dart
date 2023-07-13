import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:EcoSaver/Models/recycling_center_model.dart';
import 'package:EcoSaver/Theme/theme_provider.dart';
import 'package:EcoSaver/Widgets/toast_messages.dart';
import '../../../Widgets/primary_app_bar_widget.dart';
import 'recycling_centers_list.dart';
import 'recyling_centers_bottom_sheet.dart';

class RecyclingCenters extends StatefulWidget {
  @override
  _RecyclingCentersState createState() => _RecyclingCentersState();
}

class _RecyclingCentersState extends State<RecyclingCenters> {
  Widget? _childMap;
  GoogleMapController? _googleMapController;
  Position? _currentPosition;
  String? _currentAddress;
  BitmapDescriptor? currentUserMarkerIcon, mapRecyclingCenterMarkerIcon;
  List? eventLocations;
  Map<MarkerId, Marker> currentUserMarker = <MarkerId, Marker>{};
  Map<MarkerId, Marker> recyclingCentersMarkers = <MarkerId, Marker>{};
  Set<Marker> _displayMapMarkers = Set();

  @override
  void initState() {
    //checkLocationPermission();
    _getCurrentUserLocation();
    setCurrentUserMarkerIcon();
    setMapRecyclingCentersMarkerIcon();
    getRecyclingCentersLocation();
    _childMap = loadingMap("Loading Map...");
    super.initState();
  }

  // ---------------------------------- CURRENT USER ---------------------------------- \\

  _getCurrentUserLocation() {
    try {
      Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
              forceAndroidLocationManager: true)
          .then((Position position) {
        setState(() {
          _currentPosition = position;
          Marker currentUserMarker = Marker(
              markerId: MarkerId('MyCurrentLocation'),
              position: LatLng(
                  _currentPosition!.latitude, _currentPosition!.longitude),
              icon: currentUserMarkerIcon!,
              onTap: () {
                print('My Location');
              },
              infoWindow:
                  InfoWindow(title: 'My Location', snippet: _currentAddress));
          _displayMapMarkers.add(currentUserMarker);
          _childMap = mapWidget();
        });
        _getCurrentUserAddressFromLatLng();
        getRecyclingCentersLocation(); // Call this after setting current location.
      }).catchError((e) {
        print(e);
      });
    } catch (error) {
      ToastMessages().toastError(error.toString(), context);
    }
  }

  _getCurrentUserAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);
      Placemark place = p[0];
      setState(() {
        if (place != null) {
          _currentAddress = "${place.name}, "
              "${place.street}, "
              "${place.locality}, "
              "${place.country}";
        } else {
          _currentAddress = "No Address";
        }
        _childMap = mapWidget();
      });
    } catch (error) {
      ToastMessages().toastError(error.toString(), context);
    }
  }

  setCurrentUserMarkerIcon() async {
    currentUserMarkerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 5.0),
        'assets/icons/icon_home.png');
  }

  _setCurrentUserMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('MyCurrentLocation'),
          position:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          icon: currentUserMarkerIcon!,
          onTap: () {
            print('My Location');
          },
          infoWindow:
              InfoWindow(title: 'My Location', snippet: _currentAddress))
    ].toSet();
  }

  // ---------------------------------- Recycling Centers ---------------------------------- \\

  setMapRecyclingCentersMarkerIcon() async {
    mapRecyclingCenterMarkerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 50.0),
        'assets/icons/icon_recycling_center.png');
  }

  setRecyclingCentersMarkers(
    RecyclingCenterModel recyclingCenterModel,
    latitude,
    longitude,
  ) async {
    final MarkerId markerID = MarkerId(recyclingCenterModel.id);
    final Marker marker = Marker(
      markerId: markerID,
      icon: mapRecyclingCenterMarkerIcon!,
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
          title: recyclingCenterModel.name,
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return RecyclingCentersBottomSheet().showCentersDetails(
                    context, recyclingCenterModel, latitude, longitude);
              },
            );
            print("id: ${recyclingCenterModel.id}\n"
                "name:${recyclingCenterModel.name}\n"
                "latitude: $latitude\n"
                "longitude: $longitude");
          }),
    );
    setState(() {
      _displayMapMarkers.add(marker);
      _childMap = mapWidget();
    });
  }

  getRecyclingCentersLocation() {
    FirebaseFirestore.instance
        .collection("Recycling Centers")
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((result) {
          RecyclingCenterModel recyclingCenterModel =
              RecyclingCenterModel.fromDocument(result);
          print("--------------------- Recycling Center ---------------------\n"
              "id: ${recyclingCenterModel.id}\n"
              "name: ${recyclingCenterModel.name}\n"
              "latitude: ${recyclingCenterModel.location.latitude}\n"
              "longitude: ${recyclingCenterModel.location.longitude}");
          setRecyclingCentersMarkers(
            recyclingCenterModel,
            recyclingCenterModel.location.latitude,
            recyclingCenterModel.location.longitude,
          );
        });
      }
    });
  }

  // ---------------------------------- COMMON MAP ---------------------------------- \\

  loadingMap(String m) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 100.0),
        child: Text(
          m,
          style: TextStyle(fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  checkLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      await Geolocator.openLocationSettings();
    } else {
      _getCurrentUserLocation();
      //ToastMessages().toastInfo("Location Permission Granted!");
    }
  }

  Widget mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      markers: _displayMapMarkers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      initialCameraPosition: CameraPosition(
        target: LatLng(_currentPosition?.latitude ?? -1.6026560812174186,
            _currentPosition?.longitude ?? 103.6168988730687),
        zoom: 8.5,
      ),
      onMapCreated: (GoogleMapController controller) {
        _googleMapController = controller;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          automaticallyImplyLeading: false,
          title: Text(
            "Recycling Centers",
            style: Theme.of(context).textTheme.headline6,
          ),
          elevation: Theme.of(context).appBarTheme.elevation,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: Icon(
                Icons.transfer_within_a_station_rounded,
                color: AppThemeData().secondaryColor,
                size: 35.0,
              ),
            )
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Centers List",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Icon(
                      Icons.location_on_rounded,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Map View",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Icon(Icons.map_rounded,
                        color: Theme.of(context).iconTheme.color),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            RecyclingCentersList(),
            Container(
              child: _childMap,
            ),
          ],
        ),
      ),
    );
  }
}
