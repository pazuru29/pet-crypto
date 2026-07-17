import 'package:pet_crypto/application/localization/l10n/app_localizations.dart';
import 'package:pet_crypto/core/errors/app_error_code.dart';

extension AppErrorCodeLocalization on AppErrorCode {
  String localizedMessage(AppLocalizations l10n) => switch (this) {
    .invalidCredentials => l10n.appErrorInvalidCredentials,
    .sessionExpired => l10n.appErrorSessionExpired,
    .accessDenied => l10n.appErrorAccessDenied,
    .invalidRequest => l10n.appErrorInvalidRequest,
    .notFound => l10n.appErrorNotFound,
    .serverUnavailable => l10n.appErrorServerUnavailable,
    .networkUnavailable => l10n.appErrorNetworkUnavailable,
    .invalidResponse => l10n.appErrorInvalidResponse,
    .storageFailure => l10n.appErrorStorageFailure,
    .configuration => l10n.appErrorConfiguration,
    .unexpected => l10n.appErrorUnexpected,
    .invalidLink => l10n.appErrorInvalidLink,
    .unsupportedLink => l10n.appErrorUnsupportedLink,
    .openLinkFailed => l10n.appErrorOpenLinkFailed,
  };
}
