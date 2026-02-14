import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:media_kit/media_kit.dart' as mk;

class MediaHelper {
  static ImageProvider getImage(String path) {
    if (path.isEmpty) {
      return const NetworkImage("https://via.placeholder.com/400x200?text=Resim+Yok");
    }
    
    if (path.startsWith('http')) {
      return NetworkImage(path);
    }
    
    // Check if it's an asset path
    if (path.startsWith('assets/')) {
      // In Debug mode, the file might have just been copied to assets/ folder
      // but not bundled yet. Let's try to load it from the filesystem first (Desktop only).
      if (kDebugMode && !kIsWeb) {
        final localFile = File(path);
        if (localFile.existsSync()) {
          return FileImage(localFile);
        }
      }
      return AssetImage(path);
    }
    
    if (kIsWeb) {
      // On web we can't read local files directly via path
      return const NetworkImage("https://via.placeholder.com/400x200?text=Local+Files+Not+Supported+on+Web");
    }

    try {
      if (path.startsWith('file://')) {
        return FileImage(File.fromUri(Uri.parse(path)));
      }
      if (path.contains('%')) {
         try {
           final decoded = Uri.decodeComponent(path);
           if (File(decoded).existsSync()) {
             return FileImage(File(decoded));
           }
         } catch (_) {}
      }
      return FileImage(File(path));
    } catch (e) {
      return const NetworkImage("https://via.placeholder.com/400x200?text=Resim+Bulunamadi"); 
    }
  }

  static Source getSource(String path) {
    if (path.startsWith('http')) {
      return UrlSource(path);
    }
    
    if (path.startsWith('assets/')) {
       return AssetSource(path.replaceFirst('assets/', ''));
    }
    
    if (kIsWeb) return UrlSource(path);

    try {
      String localPath = path;
      if (path.startsWith('file://')) {
        localPath = Uri.parse(path).toFilePath();
      } else if (path.contains('%')) {
        try {
          localPath = Uri.decodeComponent(path);
        } catch (_) {}
      }
      return DeviceFileSource(localPath);
    } catch (e) {
      return UrlSource(path);
    }
  }

  static mk.Media getMediaKitSource(String path) {
    if (path.startsWith('http')) {
      return mk.Media(path);
    }

    if (path.startsWith('assets/')) {
      if (kDebugMode && !kIsWeb) {
        final localFile = File(path);
        if (localFile.existsSync()) {
          return mk.Media(localFile.path);
        }
      }
      return mk.Media('asset:///flutter_assets/$path');
    }
    
    if (kIsWeb) return mk.Media(path);

    try {
      String localPath = path;
      if (path.startsWith('file://')) {
        localPath = Uri.parse(path).toFilePath();
      } else if (path.contains('%')) {
        try {
          localPath = Uri.decodeComponent(path);
        } catch (_) {}
      }
      return mk.Media(localPath);
    } catch (e) {
      return mk.Media(path);
    }
  }
}
