import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/feature/reports/notifiers/reports.notifier.dart';
import 'package:client/feature/reports/widgets/report_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const List<String> _documentTypes = [
  'Lab Report',
  'Prescription',
  'Scan / Imaging',
  'Discharge Summary',
  'Vaccination Record',
  'Doctor Note',
  'Other',
];

const List<String> _allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png'];

const int _maxFileSizeBytes = 10 * 1024 * 1024;

/// Form for uploading a new medical document.
class UploadReportPage extends ConsumerStatefulWidget {
  const UploadReportPage({super.key});

  @override
  ConsumerState<UploadReportPage> createState() => _UploadReportPageState();
}

class _UploadReportPageState extends ConsumerState<UploadReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _issuerController = TextEditingController();
  final _hospitalController = TextEditingController();

  String? _docType;
  DateTime? _reportDate;
  PlatformFile? _file;
  String? _fileError;
  bool _isUploading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _issuerController.dispose();
    _hospitalController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _allowedExtensions,
      withData: true,
    );
    final file = result?.files.firstOrNull;
    if (file == null) return;

    setState(() {
      if (file.bytes == null || file.bytes!.isEmpty) {
        _fileError = 'The selected file could not be read.';
        _file = null;
      } else if (file.size > _maxFileSizeBytes) {
        _fileError = 'File is too large. Maximum size is 10 MB.';
        _file = null;
      } else {
        _fileError = null;
        _file = file;
      }
    });
  }

  Future<void> _pickReportDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _reportDate ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: now,
    );
    if (picked != null) setState(() => _reportDate = picked);
  }

  Future<void> _submit() async {
    final isFormValid = _formKey.currentState!.validate();
    if (_file == null) {
      setState(() => _fileError = 'Please select a document to upload.');
    }
    if (!isFormValid || _file == null) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() => _isUploading = true);
    try {
      await ref
          .read(reportsProvider.notifier)
          .uploadDocument(
            title: _titleController.text.trim(),
            docType: _docType!,
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            issuer: _issuerController.text.trim().isEmpty
                ? null
                : _issuerController.text.trim(),
            hospital: _hospitalController.text.trim().isEmpty
                ? null
                : _hospitalController.text.trim(),
            reportDate: _reportDate,
            fileName: _file!.name,
            fileBytes: _file!.bytes!,
          );
      messenger.showSnackBar(
        const SnackBar(content: Text('Document uploaded successfully.')),
      );
      navigator.pop();
    } on AppException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Upload failed. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload Document',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FilePickerField(
                  file: _file,
                  errorText: _fileError,
                  onTap: _isUploading ? null : _pickFile,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  enabled: !_isUploading,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter a title.'
                      : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _docType,
                  decoration: const InputDecoration(
                    labelText: 'Document type',
                    border: OutlineInputBorder(),
                  ),
                  items: _documentTypes
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: _isUploading
                      ? null
                      : (value) => setState(() => _docType = value),
                  validator: (value) =>
                      value == null ? 'Please select a document type.' : null,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _isUploading ? null : _pickReportDate,
                  borderRadius: BorderRadius.circular(4),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Report date (optional)',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today, size: 18),
                    ),
                    child: Text(
                      _reportDate == null
                          ? 'Not set'
                          : formatDocumentDate(_reportDate!),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: _reportDate == null
                            ? colorScheme.onSurface.withAlpha(120)
                            : colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _issuerController,
                  enabled: !_isUploading,
                  decoration: const InputDecoration(
                    labelText: 'Doctor / issuer (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _hospitalController,
                  enabled: !_isUploading,
                  decoration: const InputDecoration(
                    labelText: 'Hospital / clinic (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  enabled: !_isUploading,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: _isUploading ? null : _submit,
                    child: _isUploading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Upload'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilePickerField extends StatelessWidget {
  const _FilePickerField({
    required this.file,
    required this.errorText,
    required this.onTap,
  });

  final PlatformFile? file;
  final String? errorText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer.withAlpha(180),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: errorText == null
                    ? colorScheme.primary.withAlpha(80)
                    : colorScheme.error,
              ),
            ),
            child: Column(
              children: [
                FaIcon(
                  file == null
                      ? FontAwesomeIcons.fileArrowUp
                      : FontAwesomeIcons.fileCircleCheck,
                  size: 28,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  file == null
                      ? 'Tap to select a file\n(PDF, JPG, JPEG or PNG, max 10 MB)'
                      : file!.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (file != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${(file!.size / 1024).toStringAsFixed(0)} KB',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              errorText!,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
