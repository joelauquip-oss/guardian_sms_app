import 'package:flutter/material.dart';

import '../models/analysis_result.dart';
import '../services/api_service.dart';
import '../services/local_detector_service.dart';
import '../services/tokenizer_service.dart';
import '../widgets/message_card.dart';
import '../widgets/privacy_card.dart';
import '../widgets/status_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController smsController = TextEditingController();

  final TokenizerService tokenizerService = TokenizerService();
  final LocalDetectorService localDetectorService = LocalDetectorService();
  final ApiService apiService = ApiService();

  bool isLoading = false;
  bool useServer = false;

  String cleanMessage = '';
  AnalysisResult? result;

  Future<void> analyzeSms() async {
    final String originalSms = smsController.text.trim();

    if (originalSms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero pega o escribe un SMS.'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
      cleanMessage = '';
      result = null;
    });

    final String tokenizedMessage = tokenizerService.tokenizeSms(originalSms);

    try {
      AnalysisResult analysis;

      if (useServer) {
        analysis = await apiService.analyzeSms(
          cleanMessage: tokenizedMessage,
        );
      } else {
        analysis = localDetectorService.analyze(
          cleanMessage: tokenizedMessage,
        );
      }

      setState(() {
        cleanMessage = tokenizedMessage;
        result = analysis;
      });
    } catch (error) {
      final AnalysisResult fallback = localDetectorService.analyze(
        cleanMessage: tokenizedMessage,
      );

      setState(() {
        cleanMessage = tokenizedMessage;
        result = fallback;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo conectar al servidor. Se usó análisis local. Detalle: $error',
          ),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void clearScreen() {
    setState(() {
      smsController.clear();
      cleanMessage = '';
      result = null;
      isLoading = false;
    });
  }

  void loadPhishingExample() {
    smsController.text =
        'BCP: Tu cuenta fue bloqueada. Ingresa a http://bcp-validacion-segura.xyz para verificar tus datos. Código 839201.';
  }

  void loadSafeExample() {
    smsController.text =
        'Hola, recuerda que mañana tenemos reunión a las 5 en la universidad.';
  }

  @override
  void dispose() {
    smsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guardian SMS'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Protección contra SMS fraudulentos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Primero limpiamos datos personales, luego analizamos si el SMS parece phishing.',
              style: TextStyle(
                fontSize: 15,
                height: 1.35,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            const PrivacyCard(),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: smsController,
                  minLines: 6,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    labelText: 'Mensaje SMS',
                    hintText:
                        'Ejemplo: Tu cuenta fue bloqueada, ingresa a este enlace...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: loadPhishingExample,
                    child: const Text('Ejemplo phishing'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: loadSafeExample,
                    child: const Text('Ejemplo seguro'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              child: SwitchListTile(
                value: useServer,
                onChanged: (value) {
                  setState(() {
                    useServer = value;
                  });
                },
                title: const Text(
                  'Usar servidor IA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Déjalo apagado hasta crear el backend. Si está apagado, usa análisis local.',
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: isLoading ? null : analyzeSms,
              icon: const Icon(Icons.security),
              label: Text(
                isLoading ? 'Analizando...' : 'Analizar SMS',
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: clearScreen,
              icon: const Icon(Icons.cleaning_services),
              label: const Text('Limpiar'),
            ),
            const SizedBox(height: 22),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (!isLoading) StatusCard(result: result),
            const SizedBox(height: 18),
            MessageCard(
              title: 'SMS tokenizado',
              message: cleanMessage,
              icon: Icons.token,
            ),
            const SizedBox(height: 24),
            const Text(
              'Versión MVP: la conexión al servidor quedará lista para la siguiente parte del proyecto.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
