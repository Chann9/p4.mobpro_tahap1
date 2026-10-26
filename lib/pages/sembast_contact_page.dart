import 'package:flutter/material.dart';
import '../data/sembast_helper.dart';

class SembastContactPage extends StatefulWidget {
  const SembastContactPage({super.key});

  @override
  State<SembastContactPage> createState() => _SembastContactPageState();
}

class _SembastContactPageState extends State<SembastContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  List<Map<String, dynamic>> _contacts = [];
  bool _loading = false;
  int? _editingId;

  static const Color appBlue = Color(0xFF42A5F5);

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    setState(() => _loading = true);

    try {
      final records = await SembastHelper.instance.getContacts();

      if (!mounted) return;

      setState(() {
        _contacts = records.map((record) {
          return <String, dynamic>{'id': record.key, ...record.value};
        }).toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _message('Gagal memuat kontak: $e');
    }
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final data = <String, Object?>{
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
    };

    try {
      if (_editingId == null) {
        await SembastHelper.instance.insertContact(data);
      } else {
        await SembastHelper.instance.updateContact(_editingId!, data);
      }

      if (!mounted) return;

      final wasEditing = _editingId != null;
      _clearForm();
      await _loadContacts();

      if (!mounted) return;
      _message(
        wasEditing
            ? 'Kontak berhasil diperbarui'
            : 'Kontak berhasil ditambahkan',
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _message('Gagal menyimpan kontak: $e');
    }
  }

  Future<void> _deleteContact(int id) async {
    try {
      await SembastHelper.instance.deleteContact(id);
      if (!mounted) return;

      if (_editingId == id) _clearForm();

      await _loadContacts();
      if (!mounted) return;
      _message('Kontak berhasil dihapus');
    } catch (e) {
      if (!mounted) return;
      _message('Gagal menghapus kontak: $e');
    }
  }

  void _editContact(Map<String, dynamic> contact) {
    setState(() {
      _editingId = contact['id'] as int;
      _nameController.text = contact['name']?.toString() ?? '';
      _phoneController.text = contact['phone']?.toString() ?? '';
      _emailController.text = contact['email']?.toString() ?? '';
    });
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();

    setState(() => _editingId = null);
  }

  void _message(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _field(String label, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: appBlue),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) =>
            value == null || value.trim().isEmpty ? '$label wajib diisi' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBlue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          tooltip: 'Kembali',
          icon: const Icon(Icons.home, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Sembast Contact App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          _editingId == null ? 'Tambah Kontak' : 'Edit Kontak',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _field('Nama', Icons.person, _nameController),
                      _field('Nomor Telepon', Icons.phone, _phoneController),
                      _field('Email', Icons.email, _emailController),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _loading ? null : _saveContact,
                              child: Text(
                                _editingId == null
                                    ? 'Tambah Kontak'
                                    : 'Simpan Perubahan',
                              ),
                            ),
                          ),
                          if (_editingId != null)
                            IconButton(
                              onPressed: _clearForm,
                              icon: const Icon(Icons.close),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Daftar Kontak',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_contacts.isEmpty)
              const Center(child: Text('Belum ada kontak'))
            else
              ..._contacts.map((contact) {
                final id = contact['id'] as int;

                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(contact['name'].toString()),
                    subtitle: Text('${contact['phone']}\n${contact['email']}'),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editContact(contact);
                        } else if (value == 'delete') {
                          _deleteContact(id);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Hapus')),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}