// register_screen.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/core/form_enum.dart';
import 'package:provider/provider.dart';

import '../../../components/button/button.dart';
import '../../../core/constants.dart';
import '../../page/loginPage/login_screen.dart';
import '../../page/registerPage/register_screen_provider.dart';


class RegisterScreenMobileBody extends StatelessWidget {
  const RegisterScreenMobileBody({super.key});

  void _handleRegisterResult(BuildContext context, RegisterStatus status) {
    if (status == RegisterStatus.success) {
      _showSuccessDialog(context);
    } else if (status == RegisterStatus.error) {
      final msg = context.read<RegisterScreenProvider>().errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red),
      );
      context.read<RegisterScreenProvider>().resetStatus();
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline,
                    color: Colors.green, size: 64),
                const SizedBox(height: 16),
                const Text('สมัครสมาชิกสำเร็จ',
                    style: TextStyle(
                        fontSize: Constants.fontSizeTitle,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('กลับไปหน้าเข้าสู่ระบบครับ',
                    style: TextStyle(
                        fontSize: Constants.fontSizeBody,
                        color: Colors.grey[700]),
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.secondaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => const LoginScreen()));
                    },
                    child: const Text('ตกลง',
                        style: TextStyle(
                            fontSize: Constants.fontSizeBody,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Constants.bgcolor,
      body: SafeArea(
        child: Column(
          children: [
            // --- Nav Bar ---
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
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: screenWidth * 0.2,
                      alignment: Alignment.center,
                      height: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(Constants.borderRadius)),
                        color: Constants.secondaryColor,
                      ),
                      child: const Text('กลับ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Constants.fontSizeLabel)),
                    ),
                  ),
                ],
              ),
            ),

            // --- Content Body ---
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const Text('สมัครสมาชิก',
                        style: TextStyle(
                            fontSize: Constants.fontSizeDisplay,
                            fontWeight: Constants.fontWeightMedium)),
                    Consumer<RegisterScreenProvider>(
                      builder: (context, provider, _) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _handleRegisterResult(context, provider.status);
                        });

                        return Padding(
                          padding: const EdgeInsets.all(Constants.padding),
                          child: Column(
                            children: [
                              createInputField(InputFieldType.username,
                                  controller: provider.usernameController),
                              createInputField(InputFieldType.email,
                                  controller: provider.emailController),
                              createInputField(InputFieldType.phoneNumber,
                                  controller: provider.phoneNumberController),
                              createInputField(InputFieldType.password,
                                  controller: provider.passwordController),
                              createInputField(InputFieldType.confirmPassword,
                                  controller:
                                      provider.confirmPasswordController),
                              const SizedBox(height: 100),
                              provider.isLoading
                                  ? const CircularProgressIndicator()
                                  : Button(
                                      text: 'สมัครสมาชิก',
                                      onTap: () => provider.register(),
                                      color: Constants.secondaryColor,
                                      btnSize: 300,
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
