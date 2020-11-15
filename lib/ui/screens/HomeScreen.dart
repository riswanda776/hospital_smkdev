import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:rumahsakit_smkdev/ui/screens/Booking/BookingPage.dart';
import 'package:rumahsakit_smkdev/ui/screens/Layanan/LayananPage.dart';
import 'package:rumahsakit_smkdev/ui/screens/More/MorePage.dart';
import 'package:rumahsakit_smkdev/ui/screens/Profile/ProfilePage.dart';
import 'package:rumahsakit_smkdev/ui/screens/home/HomePage.dart';

class HomeScreen extends StatefulWidget {
  final int pageIndex;
  HomeScreen({this.pageIndex = 0});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// index of page
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentIndex = widget.pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    setupScreenUtil(context);

    /// list page
    List<Widget> _listPage = [
      HomePage(),
      LayananPage(),
      BookingPage(),
      ProfilePage(),
      MorePage(),
    ];

    return Scaffold(
        bottomNavigationBar: _navigationBar(),
        body: IndexedStack(
          index: _currentIndex,
          children: _listPage,
        ));
  }

  /// Navigation bar
  Container _navigationBar() {
    return Container(
      height: setHeight(180),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navbarItem(index: 0, icon: FeatherIcons.home, label: "Home"),
          _navbarItem(index: 1, icon: Icons.medical_services, label: "Layanan"),
          _navbarItem(index: 2, icon: FeatherIcons.calendar, label: "Booking"),
          _navbarItem(index: 3, icon: FeatherIcons.user, label: "Profile"),
          _navbarItem(index: 4, icon: FeatherIcons.moreVertical, label: "More"),
        ],
      ),
    );
  }

  /// Navigation Bar Item
  Widget _navbarItem({int index, IconData icon, String label}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                icon,
                size: setFontSize(75),
                color: index == _currentIndex
                    ? primaryColor
                    : grayColor.withOpacity(0.7),
              ),
              Text(
                label,
                style: TextStyle(
                    fontSize: setFontSize(40),
                    color: index == _currentIndex
                        ? primaryColor
                        : grayColor.withOpacity(0.7)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
