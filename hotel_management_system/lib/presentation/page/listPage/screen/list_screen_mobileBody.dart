// list_screen_mobileBody.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/page/listPage/provider/list_screen_provider.dart';
import 'package:provider/provider.dart';

import '../../../../util/provider/user_provider.dart';
import '../../../../util/widget/components/bavbar/bottomNavbar.dart';
import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/core/constants.dart';
import 'boxListCompanent.dart';
import 'infoAbout.dart';

class ListScreenMobileBody extends StatefulWidget {
  final bool? checkInStatus, ckeckOutStatus, statusConCheck;

  const ListScreenMobileBody({
    super.key,
    this.checkInStatus,
    this.ckeckOutStatus,
    this.statusConCheck,
  });

  @override
  State<ListScreenMobileBody> createState() => _ListScreenMobileBodyState();
}

class _ListScreenMobileBodyState extends State<ListScreenMobileBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isLogin = context.read<UserProvider>().isLogin;

      if (!isLogin) {
        // ยังไม่ login → เด้งไปหน้า login แทนที่จะยิง API แล้ว crash
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

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

                        final filteredList = provider.filteredBookingList(
                          checkInStatus: widget.checkInStatus,
                          checkOutStatus: widget.ckeckOutStatus,
                          statusConCheck: widget.statusConCheck,
                        );

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
                                if (filteredList.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 60),
                                    child: Text(
                                      "ไม่มีรายการ",
                                      style: TextStyle(
                                          fontSize: Constants.fontSizeBody,
                                          color: Colors.grey[500]),
                                    ),
                                  ),
                                ...filteredList.map((booking) {
                                  return Boxlistcompanent(
                                    roomNumber: booking.roomId,
                                    payamout: booking.totalPrice ?? 0,
                                    keyBooking: booking.bookingId,
                                    status: booking.status,
                                    textStatus: booking.textStatus,
                                    statusColor: booking.statusColor,
                                    statusChekin: booking.checkInStatus,
                                    statusCheckout: booking.checkOutStatus,
                                    statusConCheck: booking.statusConCheck,
                                    roomKey: booking.roomKey,
                                    onCheckOut: () async {
                                      final success = await context
                                          .read<ListScreenProvider>()
                                          .checkOutBooking(booking.bookingId);
                                      if (!success) {
                                        throw Exception(
                                            "เช็คเอาท์ไม่สำเร็จ กรุณาลองใหม่อีกครั้ง");
                                      }
                                    },
                                    onSubmitReview: (rating, comment) async {
                                      // เพิ่ม
                                      final success = await context
                                          .read<ListScreenProvider>()
                                          .submitReview(
                                            bookingId: booking.bookingId,
                                            rating: rating,
                                            comment: comment,
                                          );
                                      if (!success) {
                                        throw Exception(
                                            "ส่งรีวิวไม่สำเร็จ กรุณาลองใหม่อีกครั้ง");
                                      }
                                    },
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
                                                bookingId: booking.bookingId,
                                                status: booking.bookingStatus,
                                                checkInStatus:
                                                    booking.checkInStatus,
                                                customerName:
                                                    booking.customerName,
                                                phone: booking.phone,
                                                email: booking.email,
                                                roomId: booking.roomId,
                                                checkIn: booking.checkIn,
                                                checkOut: booking.checkOut,
                                                roomsCount: booking.roomsCount,
                                                personCount:
                                                    booking.personCount,
                                                slipUrl: booking.slipUrl,
                                                remainingAmount:
                                                    booking.remainingAmount,
                                                roomKey: booking.roomKey,
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
                      child: Topnavbar(
                        widthFactor: 0.2,
                      )),
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
