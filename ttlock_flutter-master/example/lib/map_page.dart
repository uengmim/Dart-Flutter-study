import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ttlock_flutter_example/models/tile_providers.dart';
import 'package:latlong2/latlong.dart';

typedef HitValue = ({String title, String subtitle});

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool counterRotate = false;

  //위치 정보
  final _polylinesRaw = <Polyline<HitValue>>[
    Polyline(
      points: [
        const LatLng(37.484418, 127.416639),
        const LatLng(37.784418, 127.316639),
        const LatLng(37.684418, 127.216639),
        const LatLng(37.284418, 127.116639),
        const LatLng(37.884418, 127.016639),
      ],
      strokeWidth: 500,
      color: Colors.black54,
      useStrokeWidthInMeter: true,
    ),
  ];
  //pin 정보
  late final customMarkers = <Marker>[
    // DB에서 가져온 정보로 pin 생성
    buildPin(LatLng(37.484418, 127.416639), '봉인해제', "2025-10-17 13:31:31"),
    buildPin(LatLng(37.784418, 127.316639), '봉인', "2025-10-17 13:31:31"),
    buildPin(LatLng(37.684418, 127.216639), '상차', "2025-10-17 13:31:31"),
    buildPin(LatLng(37.284418, 127.116639), '하차', "2025-10-17 13:31:31"),
    buildPin(LatLng(37.884418, 127.016639), '파쇄', "2025-10-17 13:31:31"),
  ];
  // pin 생성
  Marker buildPin(LatLng point, String action, String time) => Marker(
        point: point,
        width: 50,
        height: 50,
        child: GestureDetector(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$time 기준\n$action 작업 진행하였습니다.'),
              duration: Duration(seconds: 2),
              showCloseIcon: true,
            ),
          ),
          child: const Icon(Icons.location_pin, size: 40, color: Colors.red),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('운송 경로 조회'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              // 지도 회전 금지 설정
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom,
              ),
              // 지도 초기 위치 설정
              initialCenter: LatLng(37.484418, 127.116639),
              // 지도 초기 줌 설정
              initialZoom: 10,
            ),
            children: [
              openStreetMapTileLayer,
              //멋있잖아
              const Scalebar(
                textStyle: TextStyle(color: Colors.black, fontSize: 14),
                padding: EdgeInsets.only(right: 10, left: 10, bottom: 40),
                alignment: Alignment.bottomLeft,
              ),
              const Scalebar(
                textStyle: TextStyle(color: Colors.black, fontSize: 14),
                padding: EdgeInsets.only(right: 10, left: 10, bottom: 80),
                alignment: Alignment.bottomLeft,
                length: ScalebarLength.s,
              ),
              const Scalebar(
                textStyle: TextStyle(color: Colors.black, fontSize: 14),
                alignment: Alignment.bottomCenter,
                length: ScalebarLength.s,
              ),
              const Scalebar(
                textStyle: TextStyle(color: Colors.black, fontSize: 14),
                length: ScalebarLength.xxl,
              ),
              const Scalebar(
                textStyle: TextStyle(color: Colors.black, fontSize: 14),
                padding: EdgeInsets.only(right: 10, left: 10, top: 40),
              ),
              const Scalebar(
                textStyle: TextStyle(color: Colors.black, fontSize: 14),
                padding: EdgeInsets.only(right: 10, left: 10, top: 80),
                length: ScalebarLength.s,
              ),
              // polyline 생성
              MouseRegion(
                child: GestureDetector(
                  child: PolylineLayer(
                    simplificationTolerance: 0,
                    polylines: [..._polylinesRaw],
                  ),
                ),
              ),
              // pin 생성
              MarkerLayer(
                markers: customMarkers,
                rotate: counterRotate,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
