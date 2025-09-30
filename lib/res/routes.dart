import 'package:finance/views/screens/home.dart';
import 'package:flutter/material.dart';
class MyRoutes {
  static const String homeScreen = "homeScreen"; 
}
Map<String, Widget Function(BuildContext)> routes = {
  MyRoutes.homeScreen: (context) => const HomeScreen(),
 
};
