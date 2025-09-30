import 'package:flutter/material.dart';

//Screen coordinates and the default size of the font
double wScreen = 0;
double hScreen = 0;
double fSize = 0;

initializeHWFSize(BuildContext context) {
  wScreen = MediaQuery.of(context).size.width;
  hScreen = MediaQuery.of(context).size.height;
  fSize = wScreen / 25;
}

double fontSize({required double size}) {
  double scaleFactor = getScaleFactor();
  double responsiveFontSize = size * scaleFactor;
  double lowerLimit = size * .8;
  double upperLimit = size * 1.2;
  return responsiveFontSize.clamp(lowerLimit, upperLimit);
}

double getScaleFactor() {
  if (wScreen < 600) {
    return wScreen / 400;
  } else if (wScreen < 900) {
    return wScreen / 700;
  } else {
    return wScreen / 1000;
  }
}
