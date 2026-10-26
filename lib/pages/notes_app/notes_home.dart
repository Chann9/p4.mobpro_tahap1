import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesHome extends StatefulWidget {
  const NotesHome({super.key});

  @override
  State<NotesHome> createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  final _inputNoteKey = GlobalKey<FormFieldState>();
  final _updateNoteKey = GlobalKey<FormFieldState>();

  List<String> _notes = [];

  @override
  void initState() {
    super.initState();
    // Memuat data catatan dari SharedPreferences saat halaman pertama kali dibuka
    _loadNotes();
  }

  // Fungsi untuk mengambil/membaca data catatan dari SharedPreferences (key: 'notes_key')
  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes = prefs.getStringList('notes_key') ?? [];
    });
  }

  // Fungsi untuk menyimpan perubahan/list catatan ke SharedPreferences secara lokal
  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notes_key', _notes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[400],
        title: Text(
          "Notes App",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.home, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  "Buat Catatan",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                TextFormField(
                  key: _inputNoteKey,
                  decoration: InputDecoration(
                    labelText: "Catatan",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Input tidak boleh kosong";
                    }

                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  label: Text("Tambah"),
                  icon: Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_inputNoteKey.currentState!.validate()) {
                      setState(() {
                        _notes.add(_inputNoteKey.currentState!.value);
                      });
                      _saveNotes();
                      _inputNoteKey.currentState!.reset();
                    }
                  },
                ),
                Divider(
                  height: 25,
                  thickness: 3,
                  radius: BorderRadius.all(Radius.circular(10)),
                ),
              ]),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(childCount: _notes.length, (
                context,
                index,
              ) {
                return Card(
                  color: Colors.blueGrey[100],
                  child: ListTile(
                    leading: Icon(Icons.notes),
                    title: Text(_notes[index]),
                    trailing: PopupMenuButton(
                      initialValue: null,
                      onSelected: (menu) async {
                        if (menu == "Update") {
                          await showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Update Catatan"),
                                content: TextFormField(
                                  key: _updateNoteKey,
                                  initialValue: _notes[index],
                                  decoration: InputDecoration(
                                    labelText: "Catatan",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Input tidak boleh kosong";
                                    }

                                    return null;
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Batal"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (_updateNoteKey.currentState!
                                          .validate()) {
                                        setState(() {
                                          _notes[index] = _updateNoteKey
                                              .currentState!
                                              .value;
                                        });
                                        _saveNotes();
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text(
                                      "Simpan",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          await showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Ingin Menghapus"),
                                content: Text(
                                  "Apakah kamu yakin ingin menghapus?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Batal"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _notes.removeAt(index);
                                      });
                                      _saveNotes();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Hapus",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(value: "Update", child: Text("Update")),
                          PopupMenuItem(
                            value: "Hapus",
                            child: Text(
                              "Hapus",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ];
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}