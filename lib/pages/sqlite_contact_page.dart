import 'package:flutter/material.dart';
import '../data/sqlite_helper.dart';

class SqliteContactPage extends StatefulWidget {
  const SqliteContactPage({super.key});

  @override
  State<SqliteContactPage> createState() =>
      _SqliteContactPageState();
}

class _SqliteContactPageState
    extends State<SqliteContactPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  List<Map<String, Object?>> _contacts = [];

  bool _isLoading = false;
  bool _isEditing = false;
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
    if (mounted) {
      setState(() => _isLoading = true);
    }

    try {
      final result =
          await SqliteHelper.instance.getContacts();

      if (!mounted) return;

      setState(() {
        _contacts = result;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      _showMessage('Gagal memuat kontak: $e');
    }
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) return;

    final isEditing = _isEditing;
    final editingId = _editingId;

    setState(() => _isLoading = true);

    try {
      final contact = <String, Object?>{
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
      };

      if (isEditing && editingId != null) {
        await SqliteHelper.instance.updateContact(
          editingId,
          contact,
        );
      } else {
        await SqliteHelper.instance.insertContact(contact);
      }

      if (!mounted) return;

      _clearForm();
      await _loadContacts();

      if (!mounted) return;

      _showMessage(
        isEditing
            ? 'Kontak berhasil diperbarui'
            : 'Kontak berhasil ditambahkan',
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      _showMessage('Gagal menyimpan kontak: $e');
    }
  }

  Future<void> _deleteContact(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Kontak'),
        content: const Text(
          'Apakah kamu yakin ingin menghapus kontak ini?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await SqliteHelper.instance.deleteContact(id);

      if (!mounted) return;

      if (_editingId == id) {
        _clearForm();
      }

      await _loadContacts();

      if (!mounted) return;
      _showMessage('Kontak berhasil dihapus');
    } catch (e) {
      if (!mounted) return;
      _showMessage('Gagal menghapus kontak: $e');
    }
  }

  void _editContact(Map<String, Object?> contact) {
    setState(() {
      _isEditing = true;
      _editingId = contact['id'] as int?;
      _nameController.text =
          contact['name']?.toString() ?? '';
      _phoneController.text =
          contact['phone']?.toString() ?? '';
      _emailController.text =
          contact['email']?.toString() ?? '';
    });
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();

    setState(() {
      _isEditing = false;
      _editingId = null;
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String validationMessage,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: appBlue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: appBlue,
              width: 2,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return validationMessage;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildContactCard(
    Map<String, Object?> contact,
  ) {
    final id = contact['id'] as int;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: Color(0xFFE3F2FD),
              child: Icon(
                Icons.person,
                color: appBlue,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact['name']?.toString() ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          contact['phone']?.toString() ?? '',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.email,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          contact['email']?.toString() ?? '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              tooltip: 'Pilihan kontak',
              onSelected: (value) {
                if (value == 'edit') {
                  _editContact(contact);
                } else if (value == 'delete') {
                  _deleteContact(id);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: appBlue),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Hapus'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Header mengikuti Contact App.
      appBar: AppBar(
  backgroundColor: const Color(0xFF42A5F5),
  foregroundColor: Colors.white,
  elevation: 0,
  automaticallyImplyLeading: false,
  leading: IconButton(
    icon: const Icon(Icons.home, size: 30),
    tooltip: '',
    onPressed: () {
      Navigator.of(context).pop();
    },
  ),
  title: const Text(
    'SQLite Contact App',
    style: TextStyle(
      color: Colors.white,
      fontSize: 23,
      fontWeight: FontWeight.bold,
    ),
  ),
),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEditing
                              ? 'Edit Kontak'
                              : 'Tambah Kontak',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 18),

                        _buildTextField(
                          controller: _nameController,
                          label: 'Nama',
                          icon: Icons.person,
                          validationMessage:
                              'Nama wajib diisi',
                        ),

                        _buildTextField(
                          controller: _phoneController,
                          label: 'Nomor Telepon',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          validationMessage:
                              'Nomor telepon wajib diisi',
                        ),

                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email,
                          keyboardType:
                              TextInputType.emailAddress,
                          validationMessage:
                              'Email wajib diisi',
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _isLoading
                                    ? null
                                    : _saveContact,
                                icon: Icon(
                                  _isEditing
                                      ? Icons.save
                                      : Icons.person_add,
                                ),
                                label: Text(
                                  _isEditing
                                      ? 'Simpan Perubahan'
                                      : 'Tambah Kontak',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: appBlue,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                            if (_isEditing) ...[
                              const SizedBox(width: 8),
                              IconButton(
                                tooltip: 'Batal mengedit',
                                onPressed: _clearForm,
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  const Icon(
                    Icons.contacts,
                    color: appBlue,
                    size: 26,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Daftar Kontak',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Muat ulang',
                    onPressed:
                        _isLoading ? null : _loadContacts,
                    icon: const Icon(
                      Icons.refresh,
                      color: appBlue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: appBlue,
                    ),
                  ),
                )
              else if (_contacts.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.contact_page_outlined,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Belum ada kontak',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tambahkan kontak melalui formulir di atas.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ..._contacts.map(_buildContactCard),
            ],
          ),
        ),
      ),
    );
  }
}