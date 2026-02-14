import 'package:flutter/material.dart';

class AppConstants {
  static const bool kIsAdminMode = true;

  static const String kPartnerNameKey = 'partner_name';
  static const String kQuestionKey = 'question';
  static const String kLetterKey = 'letter';
  static const String kProposalImageKey = 'proposal_image';
  static const kBgMusicKey = "bg_music_path";
  static const kGalleryImagesKey = "gallery_images";
  static const kLanguageKey = "app_language";

  // Default values
  static const defaultPartnerName = "My Love";
  static const defaultQuestion = "Will you be my Valentine? ❤️";
  static const defaultLetter = "You are the best thing that ever happened to me. I love you more than words can say...";
  static const defaultProposalImage = "https://media.tenor.com/gUiu1zyxfzYAAAAi/bear-kiss-bear-kisses.gif";

  // Localization
  static const Map<String, Map<String, String>> localizedStrings = {
    'en': {
      'admin_title': "Admin Panel 🛠️",
      'reset': "Reset",
      'lang_select': "App Language",
      'text_settings': "Text Settings",
      'partner_name': "Partner Name",
      'proposal_question': "Proposal Question",
      'letter_content': "Letter Content",
      'media_settings': "Media Settings",
      'proposal_image': "Proposal Image",
      'bg_music': "Background Music (.mp3)",
      'gallery_title': "Photo Gallery",
      'test_app': "TEST THE APP",
      'admin_warning': "⚠️ Remember to set kIsAdminMode = false before giving the code!",
      'yes_btn': "YES",
      'celebration_title': "Glad to Have You! ❤️",
      'celebration_subtitle': "Look at your surprises",
      'letter_gift': "Your Letter",
      'memories_gift': "Our Memories",
      'song_gift': "Our Song",
      'playing': "Playing... 🎵",
      'memories_title': "Our Memories",
      'no_photos': "No photos added yet 😢",
      'close': "Close",
      'add_photo': "Add Photo",
      'clear_gallery': "Clear",
      'browser_path_error': "Could not get file path in this browser.",
      'no_file_selected': "Not selected",
    },
    'tr': {
      'admin_title': "Admin Paneli 🛠️",
      'reset': "Sıfırla",
      'lang_select': "Uygulama Dili",
      'text_settings': "Metin Ayarları",
      'partner_name': "Sevgilimin Adı",
      'proposal_question': "Teklif Sorusu",
      'letter_content': "Mektup İçeriği",
      'media_settings': "Medya Ayarları",
      'proposal_image': "Teklif Görseli",
      'bg_music': "Arkaplan Müziği (.mp3)",
      'gallery_title': "Fotoğraf Galerisi",
      'test_app': "UYGULAMAYI TEST ET",
      'admin_warning': "⚠️ Kodu partnerine vermeden önce kIsAdminMode = false yapmayı unutma!",
      'yes_btn': "EVET",
      'celebration_title': "İyi ki Varsın! ❤️",
      'celebration_subtitle': "Sürprizlerine Bak",
      'letter_gift': "Mektubun",
      'memories_gift': "Anılarımız",
      'song_gift': "Şarkımız",
      'playing': "Çalıyor... 🎵",
      'memories_title': "Anılarımız",
      'no_photos': "Henüz fotoğraf eklenmedi 😢",
      'close': "Kapat",
      'add_photo': "Fotoğraf Ekle",
      'clear_gallery': "Temizle",
      'browser_path_error': "Bu tarayıcıda dosya yolu alınamadı.",
      'no_file_selected': "Seçilmedi",
    }
  };

  static const Color primaryColor = Color(0xFFE91E63);
  static const Color scaffoldBg = Color(0xFFFCE4EC);
}
