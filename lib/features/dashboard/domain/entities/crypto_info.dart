class CryptoInfo {
  final String name;
  final String symbol;
  final String? logo;
  final String? description;
  final List<String>? tags;
  final List<String>? website;
  final List<String>? technicalDoc;
  final List<String>? sourceCode;

  CryptoInfo({
    required this.name,
    required this.symbol,
    this.logo,
    this.description,
    this.tags,
    this.website,
    this.technicalDoc,
    this.sourceCode,
  });
}
