import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:intl/intl.dart';
import 'package:rumahsakit_smkdev/ui/widget/Dash.dart';

class DetailsBooking extends StatefulWidget {
  final Map<String, dynamic> data;

  DetailsBooking(this.data);

  @override
  _DetailsBookingState createState() => _DetailsBookingState();
}

class _DetailsBookingState extends State<DetailsBooking> {
  @override
  Widget build(BuildContext context) {
    DateTime tanggalBookingDokter =
        widget.data['tanggalBookingDokter'].toDate();
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("Booking Detail"),
      ),
      body: Center(
        child: _ticketWidget(tanggalBookingDokter),
      ),
    );
  }

  Widget _ticketWidget(DateTime tanggalBookingDokter) {
    return FlutterTicketWidget(
        isCornerRounded: true,
        color: Colors.white,
        width: setHeight(880),
        height: deviceHeight() * 0.73,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dokterProfil(),
              Divider(),
              _detailPasien(),
              SizedBox(
                height: setHeight(250),
              ),
              Dash(
                height: 2,
                width: 5,
                color: Colors.grey[400],
              ),
              SizedBox(height: setHeight(50)),
              _tglKodeBooking(tanggalBookingDokter)
            ],
          ),
        ));
  }

  Widget _tglKodeBooking(DateTime tanggalBookingDokter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tanggal :",
              ),
              Text(
                DateFormat("d MMM, yyyy", "id_ID").format(tanggalBookingDokter),
                style: subTitleStyle.copyWith(color: primaryColor),
              ),
              SizedBox(
                height: setHeight(20),
              ),
              Text(
                "Kode Booking :",
              ),
              Text(
                widget.data['kodeBooking'],
                style: subTitleStyle.copyWith(color: primaryColor),
              ),
            ],
          ),
        ),
        QrImage(
          data: widget.data['kodeBooking'],
          version: 3,
          size: setWidth(340),
        )
      ],
    );
  }

  Widget _detailPasien() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nama Pasien :",
        ),
        Text(
          widget.data['namaPasien'],
          style: subTitleStyle.copyWith(color: primaryColor),
        ),
        Text("Jenis Kelamin :"),
        Text(
          widget.data['jenisKelamin'],
          style: subTitleStyle.copyWith(color: primaryColor),
        ),
        Text("Status :"),
        Text(
          widget.data['status'],
          style: subTitleStyle.copyWith(color: primaryColor),
        ),
      ],
    );
  }

  Widget _dokterProfil() {
    return Row(
      children: [
        CachedNetworkImage(
          imageUrl: widget.data['fotoDokter'],
          placeholder: (context, url) => CircularProgressIndicator(),
          imageBuilder: (context, imageProvider) => Container(
            height: setHeight(170),
            width: setHeight(170),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[400],
              image: DecorationImage(fit: BoxFit.cover, image: imageProvider),
            ),
          ),
        ),
        SizedBox(width: setWidth(50)),
        Flexible(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.data['namaDokter'],
                  style: titleStyle.copyWith(fontSize: setFontSize(50))),
              Text(
                widget.data['spesialis'],
                style: colorStyle,
              )
            ],
          ),
        )
      ],
    );
  }
}
