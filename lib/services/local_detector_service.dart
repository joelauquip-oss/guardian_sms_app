import '../models/analysis_result.dart';

class LocalDetectorService {
  AnalysisResult analyze({
    required String cleanMessage,
  }) {
    final String lowerText = cleanMessage.toLowerCase();

    int score = 0;
    final List<String> reasons = [];

    final Map<String, String> suspiciousPatterns = {
      'bloqueada': 'Menciona cuenta bloqueada',
      'bloqueado': 'Menciona cuenta bloqueada',
      'suspendida': 'Menciona cuenta suspendida',
      'suspendido': 'Menciona cuenta suspendida',
      'verifica': 'Solicita verificación',
      'verificar': 'Solicita verificación',
      'actualiza': 'Solicita actualización de datos',
      'actualizar': 'Solicita actualización de datos',
      'validar': 'Solicita validar información',
      'valida': 'Solicita validar información',
      'premio': 'Ofrece un premio',
      'ganaste': 'Indica premio o ganancia inesperada',
      'urgente': 'Usa urgencia para presionar al usuario',
      'contraseña': 'Menciona contraseña',
      'clave': 'Menciona clave',
      'token': 'Menciona token o código',
      'cuenta': 'Menciona cuenta financiera o de usuario',
      'tarjeta': 'Menciona tarjeta',
      'enlace': 'Menciona enlace',
      'link': 'Menciona link',
      '<url_domain': 'Contiene enlace web',
    };

    suspiciousPatterns.forEach((pattern, reason) {
      if (lowerText.contains(pattern)) {
        score++;
        if (!reasons.contains(reason)) {
          reasons.add(reason);
        }
      }
    });

    if (lowerText.contains('<url_domain:') &&
        (lowerText.contains('bcp') ||
            lowerText.contains('bbva') ||
            lowerText.contains('interbank') ||
            lowerText.contains('scotia') ||
            lowerText.contains('banco'))) {
      score += 2;
      reasons.add('Usa nombre bancario junto con enlace web');
    }

    if (lowerText.contains('<code>') &&
        (lowerText.contains('compartas') || lowerText.contains('enviar'))) {
      score += 2;
      reasons.add('Relaciona código personal con una acción sospechosa');
    }

    final bool phishing = score >= 3;

    final double riskScore = _calculateRiskScore(score);

    if (phishing) {
      return AnalysisResult(
        label: 'phishing',
        riskScore: riskScore,
        cleanMessage: cleanMessage,
        recommendation:
            'Mensaje sospechoso. No abras enlaces, no ingreses claves y no compartas códigos.',
        source: 'local',
        reasons: reasons,
      );
    }

    return AnalysisResult(
      label: 'safe',
      riskScore: riskScore,
      cleanMessage: cleanMessage,
      recommendation:
          'Mensaje aparentemente seguro. Mantén precaución si contiene enlaces o pide datos personales.',
      source: 'local',
      reasons: reasons,
    );
  }

  double _calculateRiskScore(int score) {
    final double value = score / 8;

    if (value > 1) {
      return 1;
    }

    return value;
  }
}
