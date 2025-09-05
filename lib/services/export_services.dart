import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendToWebhook(String extractedText) async {
  final url = Uri.parse(
    "https://hathoriastro.app.n8n.cloud/webhook/e761aae7-415b-4cd0-bb9e-60b1d0ddf03a",
  );
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"text": extractedText}),
  );

  print("Webhook response: ${response.body}");
}
