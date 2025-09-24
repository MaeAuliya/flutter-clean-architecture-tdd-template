import 'package:equatable/equatable.dart';

class ExampleEntity extends Equatable {
  final String text;
  final num numbers;
  final bool isBoolean;
  final List<String> textList;
  final List<num> numberList;
  final List<bool> booleanList;
  final String? textNullable;
  final num? numberNullable;

  const ExampleEntity({
    required this.text,
    required this.numbers,
    required this.isBoolean,
    required this.textList,
    required this.numberList,
    required this.booleanList,
    required this.textNullable,
    this.numberNullable,
  });

  @override
  List<Object?> get props => [
    text,
    numbers,
    isBoolean,
    textList,
    numberList,
    booleanList,
    textNullable,
    numberNullable,
  ];
}
