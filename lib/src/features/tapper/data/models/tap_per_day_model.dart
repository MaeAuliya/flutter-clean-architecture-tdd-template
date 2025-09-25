import '../../domain/entities/tap_per_day.dart';

class TapPerDayModel extends TapPerDay {
  const TapPerDayModel({
    required super.id,
    required super.dateId,
    required super.tapCount,
    required super.longPressCount,
    required super.date,
  });

  TapPerDayModel.empty()
    : super(
        id: 0,
        dateId: '',
        tapCount: 0,
        longPressCount: 0,
        date: DateTime.now(),
      );

  TapPerDayModel.fromEntity(TapPerDay entity)
    : super(
        id: entity.id,
        dateId: entity.dateId,
        tapCount: entity.tapCount,
        longPressCount: entity.longPressCount,
        date: entity.date,
      );
}
