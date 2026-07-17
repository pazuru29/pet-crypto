import 'package:flutter/material.dart';
import 'package:pet_crypto/core/util/bloc/bloc_message.dart';

extension BlocMessageTypeColors on BlocMessageType {
  Color backgroundColor(BuildContext context) {
    switch (this) {
      case .info:
        return Theme.of(context).colorScheme.primaryContainer;
      case .error:
        return Theme.of(context).colorScheme.errorContainer;
    }
  }

  Color foregroundColor(BuildContext context) {
    switch (this) {
      case .info:
        return Theme.of(context).colorScheme.onPrimaryContainer;
      case .error:
        return Theme.of(context).colorScheme.onErrorContainer;
    }
  }
}
