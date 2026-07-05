import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum BlocMessageType {
  info,
  error;

  Color getColor(BuildContext context) {
    switch (this) {
      case .info:
        return Theme.of(context).colorScheme.primaryContainer;
      case .error:
        return Theme.of(context).colorScheme.errorContainer;
    }
  }
}

class BlocMessage extends Equatable {
  final String text;
  final BlocMessageType type;

  const BlocMessage({required this.text, required this.type});

  const BlocMessage.info(String text) : this(text: text, type: .info);

  const BlocMessage.error(String text) : this(text: text, type: .error);

  @override
  List<Object?> get props => [text, type];
}
