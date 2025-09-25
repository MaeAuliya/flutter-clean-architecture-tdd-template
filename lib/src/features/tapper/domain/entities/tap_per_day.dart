import 'package:equatable/equatable.dart';

class TapPerDay extends Equatable {
  final int id;
  final String dateId;
  final int tapCount;
  final int longPressCount;
  final DateTime date;

  const TapPerDay({
    required this.id,
    required this.dateId,
    required this.tapCount,
    required this.longPressCount,
    required this.date,
  });

  @override
  List<Object?> get props => [id, dateId, tapCount, longPressCount, date];
}
