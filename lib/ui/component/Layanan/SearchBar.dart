import 'package:flutter/material.dart';
import 'package:rumahsakit_smkdev/ui/component/Layanan/SearchPage.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SizedBox(
        height: setHeight(120),
        child: GestureDetector(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchPage())),
          child: TextField(
            decoration: InputDecoration(
              enabled: false,
              contentPadding: EdgeInsets.all(8),
              prefixIcon: Icon(Icons.search),
              hintText: "Search Fasilitas",
              hintStyle: TextStyle(fontSize: setFontSize(40)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1)),
            ),
          ),
        ),
      ),
    );
  }
}
