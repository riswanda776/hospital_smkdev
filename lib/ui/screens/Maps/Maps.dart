import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    setPin();
  }

  void setPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), "assets/marker.png");
  }

  @override
  Widget build(BuildContext context) {
    LatLng pinPosition = LatLng(-6.8815893, 109.6674984);

    CameraPosition initialLocation =
        CameraPosition(zoom: 16, bearing: 30, target: pinPosition);
    return Scaffold(
      appBar: AppBar(
        title: Text("Lokasi"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            markers: _markers,
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            initialCameraPosition: initialLocation,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              setState(() {
                _markers.add(Marker(
                    markerId: MarkerId("<MARKER_ID>"),
                    position: pinPosition,
                    icon: pinLocationIcon));
              });
            },
          ),
          locationInfo(pinPosition)
        ],
      ),
    );
  }

  Align locationInfo(LatLng position) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: setHeight(200),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {

              CameraUpdate.newCameraPosition(CameraPosition(target: position));
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(4, 8, 8, 8),
                height: setHeight(200),
                width: setWidth(300),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://asset.kompas.com/crops/mOKFrYHlSTM6SEt4aD9PIXZnJE0=/0x5:593x400/750x500/data/photo/2020/03/16/5e6ee88f78835.jpg"))),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "RS.SMKDEV",
                    style: titleStyle.copyWith(fontSize: setFontSize(45)),
                  ),
                  Text(
                    "Jl. Margacinta No. 69, \nBuah Batu Bandung",
                    style:
                        TextStyle(fontSize: setFontSize(35), color: grayColor),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
