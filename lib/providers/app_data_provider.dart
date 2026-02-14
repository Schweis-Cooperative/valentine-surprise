import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import 'package:valentine_mobile_app_2/core/constants/app_constants.dart';

class AppData extends ChangeNotifier {
  late SharedPreferences _prefs;

  String _partnerName = AppConstants.defaultPartnerName;
  String _question = AppConstants.defaultQuestion;
  String _letter = AppConstants.defaultLetter;
  String _proposalImagePath = AppConstants.defaultProposalImage;
  String? _bgMusicPath;
  List<String> _galleryImages = [];
  String _language = 'en';

  String get partnerName => _partnerName;
  String get question => _question;
  String get letter => _letter;
  String get proposalImagePath => _proposalImagePath;
  String? get bgMusicPath => _bgMusicPath;
  List<String> get galleryImages => _galleryImages;
  String get language => _language;

  String tr(String key) {
    return AppConstants.localizedStrings[_language]?[key] ?? key;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _partnerName = _prefs.getString(AppConstants.kPartnerNameKey) ?? AppConstants.defaultPartnerName;
    _question = _prefs.getString(AppConstants.kQuestionKey) ?? AppConstants.defaultQuestion;
    _letter = _prefs.getString(AppConstants.kLetterKey) ?? AppConstants.defaultLetter;
    _proposalImagePath = _prefs.getString(AppConstants.kProposalImageKey) ?? AppConstants.defaultProposalImage;
    _bgMusicPath = _prefs.getString(AppConstants.kBgMusicKey);
    _galleryImages = _prefs.getStringList(AppConstants.kGalleryImagesKey) ?? [];
    _language = _prefs.getString(AppConstants.kLanguageKey) ?? 'en';
    notifyListeners();
  }

  Future<void> updateString(String key, String value) async {
    String finalValue = value;
    
    // If it's a local file and we are in debug mode, try to copy it to assets (Desktop only)
    if (kDebugMode && !kIsWeb && !value.startsWith('http') && !value.startsWith('assets/')) {
      finalValue = await _saveToAssets(value, key);
    }

    await _prefs.setString(key, finalValue);
    if (key == AppConstants.kPartnerNameKey) _partnerName = finalValue;
    if (key == AppConstants.kQuestionKey) _question = finalValue;
    if (key == AppConstants.kLetterKey) _letter = finalValue;
    if (key == AppConstants.kProposalImageKey) _proposalImagePath = finalValue;
    if (key == AppConstants.kBgMusicKey) _bgMusicPath = finalValue;
    if (key == AppConstants.kLanguageKey) _language = finalValue;
    notifyListeners();
  }

  Future<void> addGalleryImage(String path) async {
    String finalPath = path;
    if (kDebugMode && !kIsWeb && !path.startsWith('http')) {
      finalPath = await _saveToAssets(path, 'gallery_${DateTime.now().millisecondsSinceEpoch}');
    }
    _galleryImages.add(finalPath);
    await _prefs.setStringList(AppConstants.kGalleryImagesKey, _galleryImages);
    notifyListeners();
  }

  Future<String> _saveToAssets(String sourcePath, String prefix) async {
    try {
      final sourceFile = File(sourcePath);
      if (!sourceFile.existsSync()) return sourcePath;

      final extension = p.extension(sourcePath);
      final isAudio = ['.mp3', '.wav', '.aac', '.m4a'].contains(extension.toLowerCase());
      final subDir = isAudio ? 'audio' : 'images';
      
      // Target filename
      final fileName = "${prefix.replaceAll(' ', '_')}$extension";
      final targetRelativePath = p.join('assets', subDir, fileName);
      final targetFile = File(targetRelativePath);

      // Create directories if they don't exist
      await Directory(p.dirname(targetRelativePath)).create(recursive: true);
      
      // Copy file
      await sourceFile.copy(targetFile.path);
      debugPrint("File synced to assets: $targetRelativePath");
      return targetRelativePath;
    } catch (e) {
      debugPrint("Error saving to assets: $e");
      return sourcePath;
    }
  }

  Future<void> clearGallery() async {
    _galleryImages.clear();
    await _prefs.setStringList(AppConstants.kGalleryImagesKey, []);
    notifyListeners();
  }

  Future<void> resetDefaults() async {
    await _prefs.clear();
    await init();
  }
}

