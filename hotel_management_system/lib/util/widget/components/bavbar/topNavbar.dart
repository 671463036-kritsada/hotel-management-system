import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hotel_management_system/util/provider/cart_provider.dart';
import 'package:hotel_management_system/util/provider/user_provider.dart';
import 'package:hotel_management_system/util/widget/core/constants.dart';

class Topnavbar extends StatelessWidget {
  final double widthFactor;

  const Topnavbar({super.key, required this.widthFactor});

  @override
  Widget build(BuildContext context) {
    final isLogin = context.read<UserProvider>().isLogin;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    width: screenWidth * widthFactor,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/cart'),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Constants.white.withOpacity(0.3),
                  ),
                  alignment: Alignment.center,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_cart,
                          color: Constants.white, size: 40),
                      Consumer<CartProvider>(
                        builder: (context, cart, _) {
                          if (cart.itemCount == 0) {
                            return const SizedBox.shrink();
                          }
                          return Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                  minWidth: 18, minHeight: 18),
                              child: Text(
                                '${cart.itemCount}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  if (isLogin) {
                    Navigator.pushNamed(context, '/profile');
                  } else {
                    Navigator.pushNamed(context, '/login');
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Constants.white.withOpacity(0.3),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.person,
                      color: Constants.white, size: 40),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }
}
