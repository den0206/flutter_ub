import 'package:flutter/material.dart';
import 'package:flutter_ub/app/extension/brand_colors.dart';
import 'package:flutter_ub/app/ui/Driver/tabs/EarningsTab.dart';
import 'package:flutter_ub/app/ui/Driver/tabs/HomeTab.dart';
import 'package:flutter_ub/app/ui/Driver/tabs/ProfileTab.dart';
import 'package:flutter_ub/app/ui/Driver/tabs/RatingTab.dart';

class MainTabPage extends StatefulWidget {
  MainTabPage({Key key}) : super(key: key);

  @override
  _MainTabPageState createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int selectedIndex = 0;

  void selectedItem(int index) {
    setState(() {
      selectedIndex = index;
      _tabController.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          HomeTab(),
          EarningsTab(),
          RatingTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: "Earning",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Rating",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        currentIndex: selectedIndex,
        unselectedItemColor: BrandColors.colorIcon,
        selectedItemColor: BrandColors.colorOrange,
        showSelectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
        ),
        type: BottomNavigationBarType.fixed,
        onTap: selectedItem,
      ),
    );
  }
}
