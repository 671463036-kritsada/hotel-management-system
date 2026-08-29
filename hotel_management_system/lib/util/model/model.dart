class RoomDetailArguments {
  final String roomId;
  final String roomType;

  RoomDetailArguments({required this.roomId, required this.roomType});
}


class RoomConditionCheckArguments {
  final String roomId;
  final String bookingId;

  RoomConditionCheckArguments({
    required this.roomId,
    required this.bookingId,
  });
}

class HomeFilterArgs {
  final DateTime checkIn;
  final DateTime checkOut;

  const HomeFilterArgs({
    required this.checkIn,
    required this.checkOut,
  });
}

class LoginPageArguments {
  final String redirectRoute;
  final Object? redirectArguments;

  LoginPageArguments({
    required this.redirectRoute,
    this.redirectArguments,
  });
}


// class ListScreenArguments {
//   final bool? checkInStatus;
//   final bool? ckeckOutStatus;
//   final bool? statusConCheck;

//   ListScreenArguments({
//     this.checkInStatus,
//     this.ckeckOutStatus,
//     this.statusConCheck,
//   });
// }
