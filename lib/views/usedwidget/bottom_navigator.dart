import 'package:finance/res/color_app.dart';
import 'package:flutter/material.dart';

class BottomNavigator extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomNavigator({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final List<IconData> _icons = [
    Icons.home,
    Icons.point_of_sale,
    Icons.assignment, 
    Icons.receipt_long,
    Icons.assessment,
  ];

  final List<String> _labels = [
    'الرئيسية',
    'المبيعات',
    'سندات القبض',
    'المصروفات',
    'التقارير',
  ];

  @override
  Widget build(BuildContext context) {
    double wScreen = MediaQuery.of(context).size.width;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: List.generate(_icons.length, (index) {
        bool isSelected = currentIndex == index;
        return BottomNavigationBarItem(
          icon: Icon(
            _icons[index],
            color: isSelected ? MyColors.kmainColor : MyColors.appTextColorPrimary,
            size: isSelected ? wScreen * 0.06 : wScreen * 0.045,
          ),
          label: _labels[index],
        );
      }),
    );
  }
}
