import 'package:flutter/material.dart';

import '../models/analysis_result.dart';

class StatusCard extends StatelessWidget {
  final AnalysisResult? result;

  const StatusCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasResult = result != null;
    final bool isPhishing = result?.isPhishing ?? false;

    final Color color = !hasResult
        ? Colors.grey
        : isPhishing
            ? Colors.red
            : Colors.green;

    final IconData icon = !hasResult
        ? Icons.sms
        : isPhishing
            ? Icons.warning_amber_rounded
            : Icons.verified_user;

    final String title = !hasResult
        ? 'Sin análisis'
        : isPhishing
            ? 'SMS sospechoso'
            : 'SMS aparentemente seguro';

    final String description = !hasResult
        ? 'Pega un mensaje y presiona analizar.'
        : result!.recommendation;

    final double risk = result?.riskScore ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              icon,
              size: 68,
              color: color,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            if (hasResult)
              Text(
                'Riesgo estimado: ${(risk * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (hasResult) const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                height: 1.35,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasResult) ...[
              const SizedBox(height: 12),
              Text(
                'Fuente de análisis: ${result!.source}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ],
            if (hasResult && result!.reasons.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Motivos detectados:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...result!.reasons.map(
                (reason) => Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('• $reason'),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
