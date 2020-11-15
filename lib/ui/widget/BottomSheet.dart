import 'package:flutter/material.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';

Future showCustomBottomSheet(BuildContext context,
    {double height, Widget child, void Function() onPressed}) {
  return showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// swipe icon
                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: setHeight(10),
                        width: setWidth(100),
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: grayColor.withOpacity(0.8),
                        ),
                      ),
                    ),

                    child,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buttonStyle(
                          "Batal",
                          color: Colors.grey.withOpacity(0.07),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        buttonStyle("Daftar",
                            color: primaryColor,
                            onPressed: onPressed,
                            textColor: Colors.white),
                      ],
                    )
                  ],
                )),
          ),
        );
      });
}

SizedBox buttonStyle(String text,
    {Color color, Color textColor, void Function() onPressed}) {
  return SizedBox(
      height: setHeight(140),
      width: setWidth(450),
      child: FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: color,
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          )));
}
