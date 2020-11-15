import 'package:flutter/material.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';

Widget bottomButton(BuildContext context,{String title,void Function() onTap}) {
    return Container(
      padding: EdgeInsets.fromLTRB(18, 12, 18, 12),
      height: setHeight(190),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: grayColor.withOpacity(0.3),
          blurRadius: 7,
          offset: Offset(0, -1),
        )
      ]),
      child: FlatButton(
        color: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Text(
         title,
          style: titleStyle.copyWith(
              color: Colors.white, fontSize: setFontSize(45)),
        ),
        onPressed: onTap,
      ),
    );
  }