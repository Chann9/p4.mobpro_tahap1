import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_application_10/pages/main_app.dart';

void main() async {
  // Memastikanbinding widget Flutter terinisialisasi sebelum melakukan operasi asynchronous
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive untuk platform Flutter (menyiapkan direktori penyimpanan lokal)
  await Hive.initFlutter();

  // Membuka Hive Box dengan nama 'contacts_box' untuk menyimpan data kontak secara lokal
  await Hive.openBox('contacts_box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainApp());
  }
}