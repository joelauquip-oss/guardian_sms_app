class TokenizerService {
  String tokenizeSms(String text) {
    String cleaned = text;

    cleaned = cleaned.replaceAll(
      RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w+\b'),
      '<EMAIL>',
    );

    cleaned = cleaned.replaceAll(
      RegExp(r'\b(?:\+51\s?)?9\d{8}\b'),
      '<PHONE>',
    );

    cleaned = cleaned.replaceAll(
      RegExp(r'\b\d{8}\b'),
      '<DNI>',
    );

    cleaned = cleaned.replaceAll(
      RegExp(r'\b\d{4}[-\s]?\d{4}[-\s]?\d{4}[-\s]?\d{4}\b'),
      '<CARD>',
    );

    cleaned = cleaned.replaceAll(
      RegExp(r'\b\d{6,20}\b'),
      '<ACCOUNT>',
    );

    cleaned = cleaned.replaceAll(
      RegExp(r'\b\d{4,6}\b'),
      '<CODE>',
    );

    cleaned = cleaned.replaceAllMapped(
      RegExp(
        r'(https?:\/\/)?(www\.)?([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})(\/[^\s]*)?',
      ),
      (match) {
        final domain = match.group(3) ?? 'unknown-domain';
        return '<URL_DOMAIN:$domain>';
      },
    );

    cleaned = cleaned.replaceAll(
      RegExp(r'\s+'),
      ' ',
    );

    return cleaned.trim();
  }
}
