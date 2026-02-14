import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:media_kit/media_kit.dart';
import 'package:valentine_mobile_app_2/core/constants/app_constants.dart';
import 'package:valentine_mobile_app_2/providers/app_data_provider.dart';
import 'package:valentine_mobile_app_2/screens/admin/admin_screen.dart';
import 'package:valentine_mobile_app_2/screens/proposal/proposal_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  
  final appData = AppData();
  await appData.init();

  runApp(
    ChangeNotifierProvider.value(
      value: appData,
      child: const ValentineApp(),
    ),
  );
}

class ValentineApp extends StatelessWidget {
  const ValentineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Valentine Surprise',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppConstants.scaffoldBg,
        fontFamily: 'Georgia',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryColor,
          surface: AppConstants.scaffoldBg,
        ),
      ),
      home: AppConstants.kIsAdminMode ? const AdminScreen() : const ProposalScreen(),
    );
  }
}
