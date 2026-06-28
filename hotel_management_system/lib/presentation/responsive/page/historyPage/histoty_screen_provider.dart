// history_screen_provider.dart
import 'package:flutter/material.dart';

class BookingHistory {
  final int roomNumber;
  final String date;
  final String payAmount;
  final String keyBooking;
  int selectedRating;
  String reviewComment;
  String reviewStatus;
  bool isReviewed;

  BookingHistory({
    required this.roomNumber,
    required this.date,
    required this.payAmount,
    required this.keyBooking,
    this.selectedRating = 0,
    this.reviewComment = "ไม่ได้แสดงความคิดเห็น",
    this.reviewStatus = "ยังไม่ได้ให้คะแนน",
    this.isReviewed = false,
  });
}

class HistoryScreenProvider extends ChangeNotifier {
  // --- State ---
  List<BookingHistory> _bookingList = [];
  bool _isLoading = false;

  // --- Getter ---
  List<BookingHistory> get bookingList => _bookingList;
  bool get isLoading => _isLoading;

  Future<void> getBookingHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: เชื่อม API จริงตรงนี้
      // _bookingList = await _bookingRepository.getBookingHistory();

      // Mock data
      await Future.delayed(const Duration(milliseconds: 300));
      _bookingList = [
        BookingHistory(
          roomNumber: 205,
          date: "15-17 ก.พ. 2569",
          payAmount: "1000 บาท",
          keyBooking: "BK-10111223",
        ),
        BookingHistory(
          roomNumber: 305,
          date: "10-12 ก.พ. 2569",
          payAmount: "2000 บาท",
          keyBooking: "BK-10111213",
        ),
        BookingHistory(
          roomNumber: 105,
          date: "23-25 ก.พ. 2569",
          payAmount: "1500 บาท",
          keyBooking: "BK-10111233",
        ),
      ];
    } catch (e) {
      // TODO: handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitReview({
    required BookingHistory booking,
    required int rating,
    required String comment,
  }) async {
    try {
      // TODO: เชื่อม API จริงตรงนี้
      // await _bookingRepository.submitReview(
      //   bookingId: booking.keyBooking,
      //   rating: rating,
      //   comment: comment,
      // );

      // Mock update
      booking.selectedRating = rating;
      booking.reviewComment = comment.isEmpty ? "ไม่ได้แสดงความคิดเห็น" : comment;
      booking.reviewStatus = "ให้คะแนนแล้ว ($rating/5)";
      booking.isReviewed = true;

      notifyListeners();
    } catch (e) {
      // TODO: handle error
    }
  }
}