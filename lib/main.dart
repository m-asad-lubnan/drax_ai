import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenRouter Multi-Model AI',
      debugShowCheckedModeBanner: false, // DEBUG tag remove
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;

  // ✅ Models list
  final List<String> _models = [
    "google/gemini-2.0-flash-exp:free",
    "deepseek/deepseek-r1:free",
    "meta-llama/llama-3.3-70b-instruct:free",
    "mistralai/mistral-small-3.2-24b-instruct:free",
    "qwen/qwen3-coder:free",
    "openai/gpt-oss-20b:free",
    "nvidia/llama-3.1-nemotron-ultra-253b-v1:free",
    "meta-llama/llama-3.2-11b-vision-instruct:free",
    "meta-llama/llama-3.2-3b-instruct:free",
  ];

  String _selectedModel = "All Models"; // Default option
  Map<String, String> _responses = {};

  Future<void> sendPrompt(String prompt) async {
    setState(() {
      _loading = true;
      _responses = {};
    });

    const apiKey =
        "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"; // 👈 apni regenerated key
    const url = "https://openrouter.ai/api/v1/chat/completions";

    final headers = {
      "Authorization": "Bearer $apiKey",
      "Content-Type": "application/json",
    };

    // agar user "All Models" select kare
    if (_selectedModel == "All Models") {
      await Future.wait(
        _models.map((model) async {
          final body = jsonEncode({
            "model": model,
            "messages": [
              {"role": "user", "content": prompt},
            ],
          });

          try {
            final res = await http.post(
              Uri.parse(url),
              headers: headers,
              body: body,
            );

            if (res.statusCode == 200) {
              final data = jsonDecode(res.body);
              final content =
                  data["choices"][0]["message"]["content"] ?? "No response";

              setState(() {
                _responses[model] = content;
              });
            } else {
              setState(() {
                _responses[model] = "Error: ${res.statusCode}";
              });
            }
          } catch (e) {
            setState(() {
              _responses[model] = "Exception: $e";
            });
          }
        }),
      );
    } else {
      // agar user ek single model select kare
      final body = jsonEncode({
        "model": _selectedModel,
        "messages": [
          {"role": "user", "content": prompt},
        ],
      });

      try {
        final res = await http.post(
          Uri.parse(url),
          headers: headers,
          body: body,
        );

        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          final content =
              data["choices"][0]["message"]["content"] ?? "No response";

          setState(() {
            _responses[_selectedModel] = content;
          });
        } else {
          setState(() {
            _responses[_selectedModel] = "Error: ${res.statusCode}";
          });
        }
      } catch (e) {
        setState(() {
          _responses[_selectedModel] = "Exception: $e";
        });
      }
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Drax AI Explorer")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Prompt input
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Enter your prompt",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Dropdown for model selection
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedModel,
                    items: ["All Models", ..._models]
                        .map(
                          (m) => DropdownMenuItem(
                            value: m,
                            child: Text(
                              m,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedModel = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Select Model",
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () => sendPrompt(_controller.text.trim()),
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      _selectedModel == "All Models"
                          ? "Send to All Models"
                          : "Send to ${_selectedModel.split('/').last}",
                    ),
            ),

            const SizedBox(height: 20),

            // Responses area
            Expanded(
              child: ListView(
                children: _responses.entries.map((entry) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(entry.value),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
