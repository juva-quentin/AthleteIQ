import 'dart:async';
import 'package:athlete_iq/model/Parcour.dart';
import 'package:athlete_iq/ui/parcour-detail/parcour_details_screen.dart';
import 'package:athlete_iq/utils/stringCapitalize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../utils/map_utils.dart';

Widget parcourTile(Parcours parcour, BuildContext context, WidgetRef ref) {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Color getColorForType(String type) {
    switch (type) {
      case "Public":
        return Colors.green;
      case "Protected":
        return Colors.orange;
      case "Private":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String visibilityText(String type) {
    switch (type) {
      case "Public":
        return "Publique";
      case "Protected":
        return "Protégée";
      case "Private":
        return "Privée";
      default:
        return "Inconnue";
    }
  }

  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, ParcourDetails.route, arguments: parcour);
    },
    child: Container(
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(8.h),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                height: 80.h,
                width: 80.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: GoogleMap(
                    polylines: {
                      Polyline(
                        polylineId: PolylineId(parcour.title),
                        points: parcour.allPoints
                            .map((e) => LatLng(e.latitude!, e.longitude!))
                            .toList(),
                        width: 4,
                        color: Colors.blue,
                      )
                    },
                    compassEnabled: false,
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: false,
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(0, 0),
                      zoom: 11,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      controller.animateCamera(CameraUpdate.newLatLngBounds(
                          MapUtils.boundsFromLatLngList(parcour.allPoints
                              .map((e) => LatLng(e.latitude!, e.longitude!))
                              .toList()),
                          25.w));
                    },
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parcour.title.capitalize(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Visibilité: ${visibilityText(parcour.type)}",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: getColorForType(parcour.type)),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${parcour.totalDistance.toStringAsFixed(2)} Km",
                          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                        ),
                        Text(
                          "${parcour.timer.hours.toString().padLeft(2, '0')}:${parcour.timer.minutes.toString().padLeft(2, '0')}:${parcour.timer.seconds.toString().padLeft(2, '0')}",
                          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      DateFormat('dd/MM/yyyy').format(parcour.createdAt),
                      style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
