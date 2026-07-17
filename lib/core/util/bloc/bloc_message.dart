import 'package:equatable/equatable.dart';
import 'package:pet_crypto/core/errors/app_error_code.dart';

enum BlocMessageType { info, error }

class BlocMessage extends Equatable {
  final AppErrorCode code;
  final BlocMessageType type;

  const BlocMessage._({required this.type, required this.code});

  const BlocMessage.info(AppErrorCode code) : this._(code: code, type: .info);

  const BlocMessage.error(AppErrorCode code) : this._(code: code, type: .error);

  @override
  List<Object?> get props => [code, type];
}
