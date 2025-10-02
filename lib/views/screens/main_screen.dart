import 'package:finance/views/screens/Sales.dart';
import 'package:finance/views/screens/expenses.dart';
import 'package:finance/views/screens/home.dart';
import 'package:finance/views/screens/receipts.dart';
import 'package:finance/views/screens/reports.dart';
import 'package:finance/views/usedwidget/bottom_navigator.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex; 

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; 
    _pageController = PageController(initialPage: _currentIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomeScreen(),
          Sales(),
          Receipts(),
          Expenses(),
          Reports(),
        ],
      ),
      bottomNavigationBar: BottomNavigator(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
