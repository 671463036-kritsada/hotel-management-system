// list_screen.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/responsive/page/listPage/list_screen_provider/list_screen_provider.dart';
import 'package:provider/provider.dart';

import '../../../components/bavbar/bottomNavbar.dart';
import '../../../components/bavbar/topNavbar.dart';
import '../../../core/constants.dart';
import '../../page/listPage/list_screen_companents/boxListCompanent.dart';
import '../../page/listPage/list_screen_companents/infoAbout.dart';

class ListScreenMobileBody extends StatefulWidget {
  final bool? checkInStatus, ckeckOutStatus, statusConCheck;

  const ListScreenMobileBody({
    super.key,
    this.checkInStatus,
    this.ckeckOutStatus = false,
    this.statusConCheck = false,
  });

  @override
  State<ListScreenMobileBody> createState() => _ListScreenMobileBodyState();
}

class _ListScreenMobileBodyState extends State<ListScreenMobileBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListScreenProvider>().getBookingList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    child: Consumer<ListScreenProvider>(
                      builder: (context, provider, _) {
                        if (provider.isLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(Constants.padding),
                            child: Column(
                              children: [
                                const SizedBox(height: 100),
                                const Row(
                                  children: [
                                    Text("รายการของฉัน",
                                        style: TextStyle(
                                            fontSize:
                                                Constants.fontSizeHeader)),
                                  ],
                                ),
                                ...provider.bookingList.map((booking) {
                                  return Boxlistcompanent(
                                    roomNumber: booking.roomNumber,
                                    date: booking.date,
                                    payamout: booking.payAmount,
                                    keyBooking: booking.keyBooking,
                                    status: booking.status,
                                    textStatus: booking.textStatus,
                                    statusColor: booking.statusColor,
                                    statusChekin: booking.checkInStatus,
                                    statusCheckout: booking.checkOutStatus,
                                    statusConCheck: booking.statusConCheck,
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        showDragHandle: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20)),
                                        ),
                                        backgroundColor: Colors.white,
                                        builder: (context) {
                                          return FractionallySizedBox(
                                            heightFactor: 0.9,
                                            child: SingleChildScrollView(
                                              child: Infoabout(
                                                status: booking.checkInStatus ==
                                                    true,
                                                checkInStatus:
                                                    booking.checkInStatus,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                }),
                                const SizedBox(height: 150),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      child: Topnavbar(widthFactor: 0.2)),
                  const Positioned(
                      bottom: 0, right: 0, left: 0, child: Bottomnavbar()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
