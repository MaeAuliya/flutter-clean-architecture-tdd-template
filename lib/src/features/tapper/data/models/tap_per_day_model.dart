import '../../../../core/utils/typedef.dart';
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

  TapPerDayModel.fromLocalDatabase(DataMap map)
    : super(
        id: map['id'] as int,
        dateId: map['date_id'] as String,
        tapCount: map['tap_count'] as int,
        longPressCount: map['long_press_count'] as int,
        date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      );
}
