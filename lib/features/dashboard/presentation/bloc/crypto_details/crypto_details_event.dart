part of 'crypto_details_bloc.dart';

sealed class CryptoDetailsEvent {}

class CryptoDetailsInitEvent extends CryptoDetailsEvent {
  final String? id;

  CryptoDetailsInitEvent({required this.id});
}

class CryptoDetailsOpenLinkEvent extends CryptoDetailsEvent {
  final String link;

  CryptoDetailsOpenLinkEvent({required this.link});
}
