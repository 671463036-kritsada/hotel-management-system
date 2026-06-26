// history_screen.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/historyPage/companents/boxShowDataHistory.dart';
import 'package:hotel_management_system/presentation/historyPage/histoty_screen_provider.dart';
import 'package:provider/provider.dart';

import '../components/bavbar/bottomNavbar.dart';
import '../components/bavbar/topNavbar.dart';
import '../components/button/button.dart';
import '../core/constants.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryScreenProvider>().getBookingHistory();
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _showRatingBottomSheet(BuildContext context, BookingHistory booking) {
    int tempRating = 0;
    _commentController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "ให้คะแนนห้อง ${booking.roomNumber}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < tempRating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 40,
                      ),
                      onPressed: () =>
                          setSheetState(() => tempRating = index + 1),
                    );
                  }),
                ),
                TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                      hintText: "เขียนความคิดเห็นของคุณ..."),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                Button(
                  text: "ส่งรีวิว",
                  color: Constants.primaryColor,
                  onTap: () {
                    context.read<HistoryScreenProvider>().submitReview(
                          booking: booking,
                          rating: tempRating,
                          comment: _commentController.text,
                        );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.white,
      body: SafeArea(
        child: SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Consumer<HistoryScreenProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(Constants.padding),
                      child: Column(
                        children: [
                          const SizedBox(height: 100),
                          const Row(
                            children: [
                              Text(
                                "รายการของฉัน",
                                style: TextStyle(
                                    fontSize: Constants.fontSizeHeader),
                              ),
                            ],
                          ),
                          ...provider.bookingList
                              .map((booking) => Boxshowdatahistory(
                                    roomNumber: booking.roomNumber,
                                    date: booking.date,
                                    payamout: booking.payAmount,
                                    keyBooking: booking.keyBooking,
                                    status: booking.reviewStatus,
                                    textStatus: booking.reviewComment,
                                    onTap: booking.isReviewed
                                        ? null
                                        : () => _showRatingBottomSheet(
                                            context, booking),
                                    ratingWidget: booking.isReviewed
                                        ? Row(
                                            children: List.generate(
                                              5,
                                              (index) => Icon(
                                                Icons.star,
                                                size: 15,
                                                color: index <
                                                        booking.selectedRating
                                                    ? Colors.amber
                                                    : Colors.grey[300],
                                              ),
                                            ),
                                          )
                                        : null,
                                  ))
                              .toList(),
                          const SizedBox(height: 150),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Positioned(top: 0, right: 0, left: 0, child: Topnavbar()),
              Positioned(bottom: 0, right: 0, left: 0, child: Bottomnavbar()),
            ],
          ),
        ),
      ),
    );
  }
}
