import 'package:equatable/equatable.dart';

enum BlocMessageType { info, error }

class BlocMessage extends Equatable {
  final String text;
  final BlocMessageType type;

  const BlocMessage({required this.text, required this.type});

  const BlocMessage.info(String text) : this(text: text, type: .info);

  const BlocMessage.error(String text) : this(text: text, type: .error);

  @override
  List<Object?> get props => [text, type];
}
