import 'package:finance/res/color_app.dart';
import 'package:finance/res/images.dart';
import 'package:finance/res/routes.dart';
import 'package:finance/res/sizes.dart';
import 'package:finance/views/widget/custom/customButton.dart';
import 'package:finance/views/widget/custom/customTextFormField.dart';
import 'package:finance/views/widget/custom/custom_text.dart';
import 'package:flutter/material.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: hScreen * 0.07,
              right: wScreen * 0.05,
            ),
            child: Image.asset(MyImages.shaqadef, height: hScreen * 0.2),
          ),
          SizedBox(height: hScreen * .03),
          CustomText(
            text: "مرحبا بك ",
            color: MyColors.kmainColor,
            fontSize: fSize * 1.1,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: hScreen * .015),
          CustomText(
            text: "سجّل دخولك لإدارة ماليتك",
            color: MyColors.appTextColorPrimary,
            fontSize: fSize * 1,
            fontWeight: FontWeight.normal,
          ),
          Container(
            margin: EdgeInsets.only(
              right: wScreen * 0.04,
              left: wScreen * 0.04,
              bottom: hScreen * 0.02,
              top: hScreen * 0.03,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(hScreen * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: wScreen * 0.04),
                    child: CustomText(
                      text: "البريد الالكتروني",
                      color: MyColors.appTextColorPrimary,
                      fontSize: fSize * 0.8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: hScreen * 0.02),
                  CustomTextFormField(
                    hintText: "البريد الالكتروني ",
                    suffixIcon: Icons.person,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    enabledBorderColor: MyColors.appTextColorPrimary,
                    focusedBorderColor: MyColors.kmainColor,
                    controller: emailController,
                    width: 0,
                    showBorder: false,
                    fsize: fSize * 0.8,
                    onSaved: (value) {
                      print("البريد الإلكتروني: $value");
                    },
                  ),
                  SizedBox(height: hScreen * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: wScreen * 0.04),
                    child: CustomText(
                      text: "كلمة المرور",
                      color: MyColors.appTextColorPrimary,
                      fontSize: fSize * 0.8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: hScreen * 0.01),
                  CustomTextFormField(
                    fsize: fSize * 0.8,
                    showBorder: false,
                    hintText: "كلمة المرور",
                    suffixIcon: Icons.password_outlined,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    enabledBorderColor: MyColors.appTextColorPrimary,
                    focusedBorderColor: MyColors.kmainColor,
                    controller: passwordController,
                    width: 0,
                    onSaved: (value) {
                      print("كلمة المرور: $value");
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: hScreen * .025),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: wScreen * 0.07),
            child: CustomMaterialButton(
              title: 'تسجيل دخول',
              vertical: hScreen * 0.01,
              buttonColor: MyColors.kmainColor,
              textColor: Colors.white,
              borderWidth: 0.5,
              borderColor: MyColors.kmainColor,
              height: hScreen * 0.07,
              width: wScreen * 0.5,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.pushReplacementNamed(context, MyRoutes.homeScreen);
                }
              },
              textsize: fSize * 0.9,
            ),
          ),
          SizedBox(height: hScreen * 0.03),
        ],
      ),
    );
  }
}
