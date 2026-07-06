import 'package:logging/logging.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_session.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';

class CheckAuthStatus {
  final AuthRepository repo;

  CheckAuthStatus({required this.repo});

  final Logger _log = Logger('CheckAuthStatus');

  Future<Result<AuthSession?>> call() async {
    final response = await repo.restoreSession();

    switch (response) {
      case Ok(value: var session):
        if (session == null) {
          return const Ok(null);
        }

        bool hasRequiredFields = _checkRequiredFields(session);
        if (!hasRequiredFields) {
          //TODO - add fetch user data
          // session = repo.fetchUserData();
        }
        return Ok(session);
      case Err(failure: final error):
        _log.warning(error.message);
        return Err(StorageFailure(error.message));
    }
  }

  bool _checkRequiredFields(AuthSession session) {
    if (session.image.isEmpty ||
        session.email.isEmpty ||
        session.fullName.isEmpty) {
      return false;
    }
    return true;
  }
}
