import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hackjamraion/components/colors.dart';
import 'package:hackjamraion/pages/user/anggaran_page.dart';
import 'package:hackjamraion/pages/user/home_page.dart';
import 'package:hackjamraion/pages/user/scan_page.dart';
import 'package:hackjamraion/pages/user/scan_page_demo.dart';

class BottomNavbar extends StatefulWidget {
  final int selectedItem;
  const BottomNavbar({super.key, required this.selectedItem});

  @override
  State<BottomNavbar> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNavbar> {
  int _currentIndex = 0;

  void changeSelectedNavBar(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AnggaranPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ScanPageDemo()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: grey,
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/navbar/home_icon.svg',
                  width: 25,
                  height: 25,
                ),
                SizedBox(height: 5),
              ],
            ),
            label: 'Home',
            activeIcon: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/navbar/home_icon.svg',
                  width: 25,
                  height: 25,
                  colorFilter: const ColorFilter.mode(
                    primaryBlue,
                    BlendMode.srcIn,
                  ), // selected
                ),
                SizedBox(height: 5),
              ],
            ),
          ),

          BottomNavigationBarItem(
            icon: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/navbar/anggaran.svg',
                  width: 20,
                  height: 20,
                ),
                SizedBox(height: 5),
              ],
            ),
            label: 'Anggaran',
            activeIcon: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/navbar/anggaran.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    primaryBlue,
                    BlendMode.srcIn,
                  ), // selected
                ),
                SizedBox(height: 5),
              ],
            ),
          ),

          BottomNavigationBarItem(
            icon: Transform.translate(
              offset: const Offset(0, -30),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: primaryBlue,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    ),
                ),
              )
            ),
            label: '',
          ),

          BottomNavigationBarItem(
            icon: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/navbar/edukasi_icon.svg',
                  width: 20,
                  height: 20,
                ),
                SizedBox(height: 5),
              ],
            ),
            label: 'Edukasi',
            activeIcon: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/navbar/edukasi_icon.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    primaryBlue,
                    BlendMode.srcIn,
                  ), // selected
                ),
                SizedBox(height: 5),
              ],
            ),
          ),

          BottomNavigationBarItem(
            icon: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/navbar/profile_icon.svg',
                  width: 20,
                  height: 20,
                ),
                SizedBox(height: 5),
              ],
            ),
            label: 'Profile',
            activeIcon: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/navbar/profile_icon.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    primaryBlue,
                    BlendMode.srcIn,
                  ), // selected
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ],
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Color(0xFF888888),
        currentIndex: widget.selectedItem,
        onTap: changeSelectedNavBar,
      ),
    );
  }
}
