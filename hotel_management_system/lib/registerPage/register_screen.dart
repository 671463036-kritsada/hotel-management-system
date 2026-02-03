import 'package:flutter/material.dart';
import 'package:hotel_management_system/components/button.dart';
import 'package:hotel_management_system/core/constants.dart';
import 'package:hotel_management_system/core/form_enum.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _myGender = "ชาย";

  @override
  Widget build(BuildContext context) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Constants.bgcolor,
      body: SafeArea(
          child: Column(
        children: [
          // nav bar
          Container(
            padding: const EdgeInsets.all(Constants.padding),
            decoration: BoxDecoration(
              color: Constants.primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(Constants.borderRadius),
                bottomRight: Radius.circular(Constants.borderRadius),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      width: screenWidth * 0.2,
                      alignment: Alignment.center,
                      height: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(Constants.borderRadius)),
                        color: Constants.secondaryColor,
                      ),
                      child: const Text(
                        "กลับ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Constants.fontSizeLabel),
                      )),
                ),
              ],
            ),
          ),

          // content body
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    "สมัครสมาชิก",
                    style: TextStyle(
                      fontSize: Constants.fontSizeDisplay,
                      fontWeight: Constants.fontWeightMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(Constants.padding),
                    child: Column(
                      children: [
                        createInputField(InputFieldType.username),
                        createInputField(InputFieldType.email),
                        createInputField(InputFieldType.phoneNumber),
                        createInputField(InputFieldType.password),
                        createInputField(InputFieldType.conformPassword),
                        SizedBox(height: 20),
                        createInputField(InputFieldType.gender,
                            selectedValue: _myGender, onChanged: (value) {
                          setState(() {
                            _myGender = value.toString();
                          });
                        }),
                        SizedBox(height: 100),
                        Button(
                          text: "สมัครสมาชิก",
                          onTap: () {},
                          color: Constants.secondaryColor,
                          btnSize: 300,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
