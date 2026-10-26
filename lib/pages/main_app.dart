import 'package:flutter/material.dart';
import 'package:flutter_application_10/pages/notes_app/notes_home.dart';
import 'package:flutter_application_10/pages/contact_app/contact_home.dart';
import 'sqlite_contact_page.dart';
import 'sembast_contact_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FF),
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        title: const Text(
          'Main App',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SizedBox(
  width: double.infinity,
  child: SingleChildScrollView(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // NOTES APP
              const Text(
                'Notes App',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 8),
              const Text(
                'Storage: shared_preference',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NotesHome(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[800],
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Buka Aplikasi'),
              ),

              const SizedBox(height: 50),

              // CONTACT APP
              const Text(
                'Contact App',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 8),
              const Text(
                'Storage: hive',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ContactHome(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[800],
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Buka Aplikasi'),
              ),

              const SizedBox(height: 50),

              // SQLITE CONTACT APP
              const Text(
                'SQLite Contact App',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 8),
              const Text(
                'Storage: SQLite (Sqflite)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          const SqliteContactPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[800],
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Buka Aplikasi'),
              ),

              const SizedBox(height: 50),

              // SEMBAST CONTACT APP
              const Text(
                'Sembast Contact App',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 8),
              const Text(
                'Storage: Sembast Web',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          const SembastContactPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[800],
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Buka Aplikasi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}