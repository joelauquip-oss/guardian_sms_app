import 'package:flutter/material.dart';

class PrivacyCard extends StatelessWidget {
  const PrivacyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE3F2FD),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(
              Icons.privacy_tip,
              color: Color(0xFF1565C0),
              size: 30,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Privacidad: Guardian SMS reemplaza correos, teléfonos, DNI, tarjetas, cuentas, códigos y enlaces antes de enviar el mensaje al servidor.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
