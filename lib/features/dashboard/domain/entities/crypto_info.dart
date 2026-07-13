import 'package:equatable/equatable.dart';

class CryptoInfo extends Equatable {
  final String name;
  final String symbol;
  final String? logo;
  final String? description;
  final List<String>? tags;
  final List<String>? website;
  final List<String>? technicalDoc;
  final List<String>? sourceCode;

  const CryptoInfo({
    required this.name,
    required this.symbol,
    this.logo,
    this.description,
    this.tags,
    this.website,
    this.technicalDoc,
    this.sourceCode,
  });

  @override
  List<Object?> get props => [
    name,
    symbol,
    logo,
    description,
    tags,
    website,
    technicalDoc,
    sourceCode,
  ];
}
