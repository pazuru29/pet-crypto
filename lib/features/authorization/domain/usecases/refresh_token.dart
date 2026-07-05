import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_refresh_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_refresh_response.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_status.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';

class RefreshToken {
  final AuthRepository repo;

  RefreshToken({required this.repo});

  Future<Result<AuthStatus>> call() async {
    //TODO
    // AuthRefreshRequest request = AuthRefreshRequest(refreshToken: '');
    // Result<AuthRefreshResponse> response = await repo.refreshToken(request);
    return Ok(.authorized);
  }
}
