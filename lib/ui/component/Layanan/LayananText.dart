import 'package:flutter/material.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';

class TextLayanan extends StatelessWidget {
  const TextLayanan({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Text(
        "Layanan",
        style: titleStyle.copyWith(fontSize: setFontSize(80)),
      ),
    );
  }
}
