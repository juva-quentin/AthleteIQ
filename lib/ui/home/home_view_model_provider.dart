import 'dart:async';
import 'dart:ui';
import 'package:athlete_iq/data/network/parcoursRepository.dart';
import 'package:athlete_iq/ui/home/providers/timer_provider.dart';
import 'package:athlete_iq/ui/providers/position_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import 'package:unicons/unicons.dart';
import 'package:wakelock/wakelock.dart';

import '../../data/network/userRepository.dart';
import '../../generated/assets.dart';
import '../../model/Parcour.dart';
import '../../utils/calculate_distance.dart';
import '../../utils/map_utils.dart';
import '../parcour-detail/parcour_details_screen.dart';
import '../parcour-detail/parcours_details_overlay_screen.dart';
import '../providers/loading_provider.dart';
import 'dart:io' show Platform;
import 'cluster/parcours_cluster_item.dart';

final homeViewModelProvider = ChangeNotifierProvider.autoDispose<HomeViewModel>(
  (ref) => HomeViewModel(ref),
);

typedef OnClusterTap = void Function(Set<ParcoursClusterItem> clusterItems);

class HomeViewModel extends ChangeNotifier {
  final Ref _reader;

  HomeViewModel(this._reader) {
    clusterManager = ClusterManager<ParcoursClusterItem>(
      [],
      _updateMarkers,
      markerBuilder: _markerBuilder
    );
  }

  Loading get _loading => _reader.read(loadingProvider);

  TimerClassProvider get _chrono => _reader.read(timerProvider);

  PositionModel get _position => _reader.read(positionProvider);
  final UserRepository _userRepo = UserRepository();

  ParcourRepository get _parcourRepo => _reader.read(parcourRepositoryProvider);

  bool _courseStart = false;
  bool get courseStart => _courseStart;

  set courseStart(bool courseStart) {
    _courseStart = courseStart;
    notifyListeners();
  }

  String? _selectedParcourId;
  String? get selectedParcourId => _selectedParcourId;
  set selectedParcourId(String? id) {
    _selectedParcourId = id;
    notifyListeners();
  }

  bool _traffic = false;
  bool get traffic => _traffic;
  set traffic(bool traffic) {
    _traffic = traffic;
    notifyListeners();
  }

  String _visibilityFilter = '';
  String get visibilityFilter => _visibilityFilter;
  set visibilityFilter(String visibilityFilter) {
    _visibilityFilter = visibilityFilter;
    notifyListeners();
  }

  String _typeFilter = 'public';
  String get typeFilter => _typeFilter;
  set typeFilter(String typeFilter) {
    _typeFilter = typeFilter;
    notifyListeners();
  }

  MapType _defaultMapType = MapType.normal;
  MapType get defaultMapType => _defaultMapType;
  set defaultMapType(MapType defaultMapType) {
    _defaultMapType = defaultMapType;
    notifyListeners();
  }

  CameraPosition _initialPosition =
      const CameraPosition(target: LatLng(0, 0), zoom: 10);
  CameraPosition get initialPosition => _initialPosition;
  set initialPosition(CameraPosition initialPosition) {
    _initialPosition = initialPosition;
    notifyListeners();
  }

  CameraPosition? _currentPosition;
  CameraPosition? get currentPosition => _currentPosition;
  set currentPosition(CameraPosition? currentPosition) {
    _currentPosition = currentPosition;
    notifyListeners();
  }

  Set<Polyline> _polylines = <Polyline>{};
  Set<Polyline> get polylines => _polylines;
  set polylines(Set<Polyline> polylines) {
    _polylines = polylines;
    notifyListeners();
  }

  Set<Marker> _markers = <Marker>{};
  Set<Marker> get markers => _markers;
  set markers(Set<Marker> markers) {
    _markers = markers;
    notifyListeners();
  }

  Set<Polyline> _tempPolylines = {};
  Set<Polyline> get tempPolylines => _tempPolylines;
  set tempPolylines(Set<Polyline> tempPolylines) {
    _tempPolylines = tempPolylines;
    notifyListeners();
  }

  Stream<List<Parcours>>? _parcours;
  Stream<List<Parcours>>? get parcours => _parcours;
  set parcours(Stream<List<Parcours>>? parcours) {
    _parcours = parcours;
    notifyListeners();
  }

  IconData _filterParcourIcon = UniconsLine.globe;
  IconData get filterParcourIcon => _filterParcourIcon;
  set filterParcourIcon(IconData filterParcourIcon) {
    _filterParcourIcon = filterParcourIcon;
    notifyListeners();
  }

  OverlayEntry? _overlayEntry;

  late GoogleMapController _controller;

  BitmapDescriptor? _customMarkerIcon;

  OnClusterTap? _onClusterTap;

  List<Parcours> _currentParcoursList = [];
  List<Parcours> get currentParcoursList => _currentParcoursList;


  void setOnClusterTapCallback(OnClusterTap onClusterTap) {
    _onClusterTap = onClusterTap;
  }

  late ClusterManager<ParcoursClusterItem> clusterManager;

  void _updateMarkers(Set<Marker> markers) {
    this.markers = markers;
    notifyListeners();
  }

  Future<Marker> _markerBuilder(Cluster<ParcoursClusterItem> cluster) async {
    if (!cluster.isMultiple) {
      ParcoursClusterItem item = cluster.items.first; // Récupérer le seul élément
      return Marker(
        markerId: MarkerId(item.id),
        position: item.location,
        icon: _customMarkerIcon!, // Utiliser la fonction pour charger l'icône personnalisée
        onTap: () => highlightAndZoomToParcour(item.id),
      );
    } else {
      // Pour les clusters avec plusieurs éléments
      BitmapDescriptor clusterIcon = await _getClusterIcon(cluster.count);
      return Marker(
        markerId: MarkerId(cluster.getId()),
        position: cluster.location,
        icon: clusterIcon, // Utiliser l'icône générée pour les clusters
        onTap: () {
          if (_onClusterTap != null) {
            _onClusterTap!(cluster.items.toSet());
          }
        },
      );
    }
  }

  Future<BitmapDescriptor> _getClusterIcon(int clusterSize) async {
    // Définir la taille du cercle en fonction de clusterSize si nécessaire
    final int size = (clusterSize < 10) ? 100 : (clusterSize < 100) ? 120 : 140;

    // Créer un Canvas pour dessiner l'icône du cluster
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.blue;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: '$clusterSize',
        style: TextStyle(
          fontSize: size / 3,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    // Dessiner le cercle
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, paint);

    // Dessiner le texte
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size - textPainter.width) / 2, (size - textPainter.height) / 2),
    );

    // Convertir le Canvas en image
    final image = await pictureRecorder.endRecording().toImage(size, size);
    final data = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<void> loadCustomMarkerIcon() async {
    try {
      _customMarkerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(
          size: Size(48, 48),
        ),
        Platform.isIOS ? Assets.marker2Ios : Assets.marker2,
      );
    } catch (e) {
      _customMarkerIcon = BitmapDescriptor.defaultMarker;
    }
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    await loadCustomMarkerIcon();
    clusterManager.setMapId(_controller.mapId);
    try {
      getParcour();
    } catch (e) {
      rethrow;
    }
    setLocation();
    clusterManager.updateMap();
    notifyListeners();
  }

  Future<void> changeFilterParcour() async {
    final provVal = _typeFilter;
    if (_typeFilter == "public") {
      _filterParcourIcon = Icons.shield;
      _typeFilter = "protected";
    } else if (_typeFilter == "protected") {
      _filterParcourIcon = UniconsLine.lock;
      _typeFilter = "private";
    } else {
      _filterParcourIcon = UniconsLine.globe;
      _typeFilter = "public";
    }
    try {
      getParcour();
    } catch (e) {
      _typeFilter = provVal;
      switch (provVal) {
        case "public":
          _filterParcourIcon = UniconsLine.globe;
          break;
        case "private":
          _filterParcourIcon = UniconsLine.lock;
          break;
        case "protected":
          _filterParcourIcon = Icons.shield;
          break;
        default:
          _filterParcourIcon = UniconsLine.globe;
          break;
      }
      return Future.error(e);
    }
  }

  void getParcour() async {
    switch (typeFilter) {
      case "public":
        try {
          parcours = _parcourRepo.parcoursPublicStream;
          polylines.clear();
          markers.clear();
          streamParcours();
        } catch (e) {
          rethrow;
        }
        break;
      case "protected":
        try {
          parcours = _parcourRepo.parcoursProtectedStream();
          polylines.clear();
          markers.clear();
          streamParcours();
        } catch (e) {
          rethrow;
        }
        break;
      case "private":
        try {
          parcours = _parcourRepo.parcoursPrivateStream;
          polylines.clear();
          markers.clear();
          streamParcours();
        } catch (e) {
          rethrow;
        }
        break;
      default:
        try {
          parcours = await _parcourRepo.parcoursPublicStream;
          polylines.clear();
          markers.clear();
          streamParcours();
        } catch (e) {
          rethrow;
        }
        break;
    }
  }

  void streamParcours() async {
    _parcours?.listen((List<Parcours> parcoursList) {
      _currentParcoursList = parcoursList;
      buildPolylinesAndMarkers(parcoursList);
      notifyListeners();
    });
  }

  Future<void> onParcourSelected(String parcourId) async {
    selectedParcourId = parcourId;

    Set<Polyline> updatedPolylines = {};
    for (var polyline in _polylines) {
      if (polyline.polylineId.value == parcourId) {
        updatedPolylines.add(Polyline(
          polylineId: polyline.polylineId,
          points: polyline.points,
          width: 8,
          color: Colors.blue,
        ));
      } else {
        updatedPolylines.add(polyline);
      }
    }
    _polylines = updatedPolylines;

    ParcoursClusterItem? selectedParcourItem;
    for (var item in clusterManager.items) {
      if (item.id == parcourId) {
        selectedParcourItem = item;
        break;
      }
    }
    if (selectedParcourItem != null) {
      _controller.animateCamera(CameraUpdate.newLatLngBounds(
          MapUtils.boundsFromLatLngList(
              selectedParcourItem.allPoints.map((e) => LatLng(e.latitude, e.longitude)).toList()),
        50,
      ));
    }
    notifyListeners();
  }

  Future<void> buildPolylinesAndMarkers(List<Parcours> parcoursList) async {
    Set<Polyline> updatedPolylines = {};
    List<ParcoursClusterItem> parcoursItems = [];

    if (_customMarkerIcon == null) {
      await loadCustomMarkerIcon();
    }

    for (var parcours in parcoursList) {
      final polylinePoints = parcours.allPoints.map((e) => LatLng(e.latitude!, e.longitude!)).toList();
      final newPolyline = Polyline(
        polylineId: PolylineId(parcours.id),
        points: polylinePoints,
        width: 5,
        color: typeFilter == "public"
            ? const Color(0xC005FF0C)
            : typeFilter == "protected"
            ? const Color(0xFFFFF200)
            : const Color(0xFFFF2100));
      updatedPolylines.add(newPolyline);

      // Créer et ajouter les éléments de cluster
      if (parcours.allPoints.isNotEmpty) {
        // Créer et ajouter les éléments de cluster
        final parcourItem = ParcoursClusterItem(
          id: parcours.id,
          position: LatLng(parcours.allPoints.first.latitude!, parcours.allPoints.first.longitude!),
          icon: _customMarkerIcon ?? BitmapDescriptor.defaultMarker,
          title: parcours.title,
          snippet: "Par : ${await _userRepo.getUserWithId(userId: parcours.owner).then((value) => value.pseudo)}",
          allPoints: polylinePoints,
        );
        parcoursItems.add(parcourItem);

    // Mise à jour des Polylines et des Clusters
    polylines = updatedPolylines;
    clusterManager.setItems(parcoursItems);
    clusterManager.updateMap();
    notifyListeners();
  }
    }
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> showParcourDetailsOverlay(String parcourId) async {
    final selectedParcour = _currentParcoursList.firstWhere((parcour) => parcour.id == parcourId);

    if (selectedParcour != null) {
      final ownerName = await _userRepo.getUserWithId(userId: selectedParcour.owner).then((value) => value.pseudo);
      final screenHeight = navigatorKey.currentState!.context.size!.height;
      const overlayHeight = 250; // Hauteur estimée de votre Overlay
      const bottomElementsHeight = 100; // Hauteur estimée des éléments en bas de l'écran, comme le bouton Go
      final topPosition = screenHeight - overlayHeight - bottomElementsHeight; // Calcule la position top de l'Overlay
      _overlayEntry?.remove();

      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: topPosition, // Utilisez la position calculée
          left: 0,
          right: 0,
          child: ParcourDetailsOverlay(
            parcourId: selectedParcour.id,
            title: selectedParcour.title,
            ownerName: ownerName,
            onViewDetails: () {
              // Fermer l'overlay
              _overlayEntry?.remove();
              _overlayEntry = null;

              // Naviguer vers la page de détails du parcours
              Navigator.pushNamed(context, ParcourDetails.route, arguments: selectedParcour);
            },
          ),
        ),
      );
      navigatorKey.currentState!.overlay!.insert(_overlayEntry!);
    }
  }

  void handleCameraMove(CameraPosition position) async {
    if (_selectedParcourId != null) {
      final selectedParcour = _currentParcoursList.firstWhere(
              (p) => p.id == _selectedParcourId);

      if (selectedParcour.allPoints.isNotEmpty) {
        int medianIndex = (selectedParcour.allPoints.length / 2).floor();
        medianIndex = medianIndex.clamp(0, selectedParcour.allPoints.length - 1);

        final LatLng parcourLatLng = LatLng(
          selectedParcour.allPoints[medianIndex].latitude!,
          selectedParcour.allPoints[medianIndex].longitude!,
        );

        final double distance = calculateDistance(position.target, parcourLatLng);

        if (distance > 7000) {
          selectedParcourId = null;
          buildPolylinesAndMarkers(_currentParcoursList);
          // Fermer l'overlay ici si l'utilisateur s'éloigne
          _overlayEntry?.remove();
          _overlayEntry = null;
          notifyListeners();
        }
      }
    }
  }

  void highlightAndZoomToParcour(String parcourId) {
    selectedParcourId = parcourId;

    final selectedParcour = currentParcoursList.firstWhere((p) => p.id == parcourId);

    if (selectedParcour != null) {
      Set<Polyline> updatedPolylines = {};
      for (var polyline in _polylines) {
        final isHighlighted = polyline.polylineId.value == selectedParcourId;
        updatedPolylines.add(Polyline(
          polylineId: polyline.polylineId,
          points: polyline.points,
          color: isHighlighted ? Colors.blue : Colors.transparent,
          width: isHighlighted ? 8 : 5,
        ));
      }
      _polylines = updatedPolylines;

      _controller.animateCamera(CameraUpdate.newLatLngBounds(
        MapUtils.boundsFromLatLngList(selectedParcour.allPoints.map((e) => LatLng(e.latitude!, e.longitude!)).toList()),
        90.0,
      ));
    }
    showParcourDetailsOverlay(parcourId);
    notifyListeners();
  }

  void setLocation() async {
    _loading.start();
    try {
      await _position.getPosition().then((value) async {
        _currentPosition = CameraPosition(
          target: LatLng(value.latitude!, value.longitude!),
          zoom: 18,
        );
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(_currentPosition!),
        );
      });
      _loading.end();
      notifyListeners();
    } catch (e) {
      _loading.end();
      notifyListeners();
    }
  }

  void setLocationDuringCours(LocationData location) {
    _currentPosition = CameraPosition(
        target: LatLng(location.latitude!, location.longitude!),
        zoom: location.speed! * 3.6 > 50 ? 16 : 18,
        bearing: location.heading!,
        tilt: 50);
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(_currentPosition!),
    );
  }

  Future<bool> register() async {
    if (_courseStart) {
      _courseStart = false;
      _chrono.stopTimer();
      await _position.stopCourse();
      List<LatLng> points = <LatLng>[];
      final latLng = _position.allPostion
          .map((position) => LatLng(position.latitude!, position.longitude!));
      points.addAll(latLng);
      tempPolylines.add(
        Polyline(
          polylineId: const PolylineId("running"),
          points: points,
          width: 4,
          color: Colors.blue,
        ),
      );
      notifyListeners();
      Wakelock.disable();
      return false;
    } else {
      _courseStart = true;
      Wakelock.enable();
      tempPolylines.clear();
      _chrono.startTimer();
      try {
        _position.startCourse();
      } catch (e) {
        _courseStart = false;
        _chrono.stopTimer();
        rethrow;
      }
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));
      while (_courseStart) {
        await Future.delayed(const Duration(milliseconds: 5));
      }
      return true;
    }
  }
}
