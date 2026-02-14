import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart' as mk;
import 'package:provider/provider.dart';
import 'package:valentine_mobile_app_2/core/utils/media_helper.dart';
import 'package:valentine_mobile_app_2/providers/app_data_provider.dart';
import 'package:valentine_mobile_app_2/widgets/confetti_painter.dart';

class CelebrationScreen extends StatefulWidget {
  const CelebrationScreen({super.key});

  @override
  State<CelebrationScreen> createState() => _CelebrationScreenState();
}

class _CelebrationScreenState extends State<CelebrationScreen> with SingleTickerProviderStateMixin {
  // Dual player support
  AudioPlayer? _audioPlayer; // Audioplayers
  mk.Player? _mkPlayer;       // MediaKit (for Linux/Robust Desktop)
  
  late AnimationController _confettiController;
  
  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    _initAudio();
  }

  Future<void> _initAudio() async {
    final data = Provider.of<AppData>(context, listen: false);
    if (data.bgMusicPath != null && data.bgMusicPath!.isNotEmpty) {
      final path = data.bgMusicPath!;

      // Use MediaKit on Desktop platforms for better stability as requested
      if (!kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
        _mkPlayer = mk.Player();
        try {
          await _mkPlayer!.setPlaylistMode(mk.PlaylistMode.loop);
          await _mkPlayer!.open(MediaHelper.getMediaKitSource(path));
        } catch (e) {
          debugPrint("MediaKit Error: $e");
        }
      } else {
        // Use Audioplayers for other platforms
        _audioPlayer = AudioPlayer();
        try {
          await _audioPlayer!.play(MediaHelper.getSource(path));
          await _audioPlayer!.setReleaseMode(ReleaseMode.loop);
        } catch (e) {
          debugPrint("AudioPlayer Error: $e");
        }
      }
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer?.dispose();
    _mkPlayer?.dispose();
    super.dispose();
  }
  
  // Correction: _audioPlayer is late. Accessing it before init throws.
  // I should probably make it nullable to be safe.
  
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AppData>(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF8BBD0), Color(0xFFFCE4EC)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        data.tr('celebration_title'),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF880E4F),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        data.tr('celebration_subtitle'),
                        style: const TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                      const SizedBox(height: 40),
 
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildGiftCard(
                            icon: Icons.favorite,
                            label: data.tr('letter_gift'),
                            color: Colors.redAccent,
                            onTap: () => _showLetter(context, data.letter, data.tr('close')),
                          ),
                          _buildGiftCard(
                            icon: Icons.photo_library,
                            label: data.tr('memories_gift'),
                            color: Colors.purpleAccent,
                            onTap: () => _showGallery(context, data.galleryImages, data.tr('memories_title'), data.tr('no_photos')),
                          ),
                          _buildGiftCard(
                            icon: Icons.music_note,
                            label: data.tr('song_gift'),
                            color: Colors.blueAccent,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(data.tr('playing'))),
                              );
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 50),
                      Image.network(
                        "https://media.tenor.com/gUiu1zyxfzYAAAAi/bear-kiss-bear-kisses.gif", 
                        height: 200,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          IgnorePointer(
            child: CustomPaint(
              painter: ConfettiPainter(animation: _confettiController),
              size: MediaQuery.of(context).size,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGiftCard({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.1),
              radius: 30,
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _showLetter(BuildContext context, String content, String closeText) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFFF0F5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(child: Text("💌")),
        content: SingleChildScrollView(
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, height: 1.5),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(closeText))
        ],
      ),
    );
  }

  void _showGallery(BuildContext context, List<String> images, String title, String emptyMsg) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: images.isEmpty
              ? Center(child: Text(emptyMsg))
              : GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: images.length,
                  itemBuilder: (_, i) {
                    final path = images[i];
                    final imgProvider = MediaHelper.getImage(path);

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image(
                        image: imgProvider,
                        fit: BoxFit.cover, 
                        errorBuilder: (c,e,s) => const Icon(Icons.error),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
