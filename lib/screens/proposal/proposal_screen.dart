import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valentine_mobile_app_2/core/utils/media_helper.dart';
import 'package:valentine_mobile_app_2/providers/app_data_provider.dart';
import 'package:valentine_mobile_app_2/screens/celebration/celebration_screen.dart';

class ProposalScreen extends StatefulWidget {
  const ProposalScreen({super.key});

  @override
  State<ProposalScreen> createState() => _ProposalScreenState();
}

class _ProposalScreenState extends State<ProposalScreen> {
  final Random _rnd = Random();
  int _noCount = 0;
  double _yesScale = 1.0;
  Alignment _noAlignment = const Alignment(0.5, 0.8);

  final List<String> _guiltTextsTr = [
    "Hayır",
    "Emin misin?",
    "Gerçekten mi?",
    "Yapma böyle...",
    "Kalbimi kırıyorsun 💔",
    "Beni üzerin 😢",
    "Son şansın!",
    "LÜTFEN ❤️",
  ];

  final List<String> _guiltTextsEn = [
    "No",
    "Are you sure?",
    "Really?",
    "Don't do this...",
    "You're breaking my heart 💔",
    "I'll be sad 😢",
    "Last chance!",
    "PLEASE ❤️",
  ];

  void _onNoPressed() {
    setState(() {
      _noCount++;
      _yesScale += 0.2;
      _noAlignment = Alignment(
        _rnd.nextDouble() * 1.8 - 0.9,
        _rnd.nextDouble() * 1.6 - 0.8,
      );
    });
  }

  void _onYesPressed() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 1),
        pageBuilder: (context, animation, secondaryAnimation) => const CelebrationScreen(),
        transitionsBuilder: (_, a1, a2, child) => FadeTransition(opacity: a1, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AppData>(context);
    final texts = data.language == 'tr' ? _guiltTextsTr : _guiltTextsEn;
    final String currentNoText = texts[min(_noCount, texts.length - 1)];
    
    final ImageProvider bgImage = MediaHelper.getImage(data.proposalImagePath);

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.pink.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))
                        ],
                        image: DecorationImage(image: bgImage, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "${data.language == 'tr' ? 'Merhaba' : 'Hello'} ${data.partnerName} ❤️",
                    style: const TextStyle(fontSize: 22, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    data.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC2185B),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          Align(
            alignment: const Alignment(0, 0.7),
            child: Transform.scale(
              scale: _yesScale,
              child: ElevatedButton.icon(
                onPressed: _onYesPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  elevation: 10,
                ),
                icon: const Icon(Icons.favorite),
                label: Text(data.tr('yes_btn'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          ),

          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            alignment: _noCount == 0 ? const Alignment(0, 0.85) : _noAlignment,
            curve: Curves.easeOutBack,
            child: _noCount > 8
                ? const SizedBox()
                : TextButton(
                    onPressed: _onNoPressed,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                      foregroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(currentNoText, style: const TextStyle(fontSize: 16)),
                  ),
          ),
        ],
      ),
    );
  }
}
