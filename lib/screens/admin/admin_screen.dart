import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:valentine_mobile_app_2/core/constants/app_constants.dart';
import 'package:valentine_mobile_app_2/providers/app_data_provider.dart';
import 'package:valentine_mobile_app_2/screens/proposal/proposal_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AppData>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(data.tr('admin_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: data.resetDefaults,
            tooltip: data.tr('reset'),
          )
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
          _buildHeader(data.tr('lang_select')),
          DropdownButtonFormField<String>(
            initialValue: data.language,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            items: const [
              DropdownMenuItem(value: 'en', child: Text("English 🇬🇧")),
              DropdownMenuItem(value: 'tr', child: Text("Türkçe 🇹🇷")),
            ],
            onChanged: (v) {
              if (v != null) data.updateString(AppConstants.kLanguageKey, v);
            },
          ),
          const Divider(height: 40),
          _buildHeader(data.tr('text_settings')),
          _buildTextField(data.tr('partner_name'), data.partnerName, (v) => data.updateString(AppConstants.kPartnerNameKey, v)),
          const SizedBox(height: 10),
          _buildTextField(data.tr('proposal_question'), data.question, (v) => data.updateString(AppConstants.kQuestionKey, v)),
          const SizedBox(height: 10),
          _buildTextField(data.tr('letter_content'), data.letter, (v) => data.updateString(AppConstants.kLetterKey, v), maxLines: 3),
          
          const Divider(height: 30),
          _buildHeader(data.tr('media_settings')),
          
          ListTile(
            leading: const Icon(Icons.image, color: Colors.pink),
            title: Text(data.tr('proposal_image')),
            subtitle: Text(data.proposalImagePath, maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () async {
              final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
              if (image != null) {
                data.updateString(AppConstants.kProposalImageKey, image.path);
              }
            },
            trailing: const Icon(Icons.edit),
          ),
          
          ListTile(
            leading: const Icon(Icons.music_note, color: Colors.pink),
            title: Text(data.tr('bg_music')),
            subtitle: Text(data.bgMusicPath ?? data.tr('no_file_selected'), maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['mp3', 'wav', 'aac'],
              );
              
              if (result != null) {
                if (result.files.single.path != null) {
                   data.updateString(AppConstants.kBgMusicKey, result.files.single.path!);
                } else if (kIsWeb && result.files.single.bytes != null) {
                   if (context.mounted) {
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data.tr('browser_path_error'))));
                   }
                }
              }
            },
            trailing: const Icon(Icons.edit),
          ),
 
          const Divider(height: 30),
          _buildHeader("${data.tr('gallery_title')} (${data.galleryImages.length})"),
          Wrap(
            spacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final List<XFile> images = await ImagePicker().pickMultiImage();
                  if (images.isNotEmpty) {
                    for (var img in images) {
                      data.addGalleryImage(img.path);
                    }
                  }
                },
                icon: const Icon(Icons.add_photo_alternate),
                label: Text(data.tr('add_photo')),
              ),
              OutlinedButton.icon(
                onPressed: data.clearGallery,
                icon: const Icon(Icons.delete),
                label: Text(data.tr('clear_gallery')),
              ),
            ],
          ),
 
          const SizedBox(height: 40),
          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProposalScreen()),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: Text(data.tr('test_app')),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            data.tr('admin_warning'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink)),
    );
  }

  Widget _buildTextField(String label, String initVal, Function(String) onChanged, {int maxLines = 1}) {
    return TextFormField(
      initialValue: initVal,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: onChanged,
    );
  }
}
