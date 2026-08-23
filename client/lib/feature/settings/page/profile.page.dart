import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:client/feature/dashboard/models/patient_profile.model.dart';
import 'package:client/feature/dashboard/notifiers/clinical_snapshot.notifier.dart';
import 'package:client/feature/dashboard/notifiers/server_health.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _height = TextEditingController();
  final _weight = TextEditingController();
  final _dob = TextEditingController();
  final _blood = TextEditingController();
  final _allergies = TextEditingController();
  bool _saving = false;
  String? _error;
  PatientProfile? _profile;
  String? _gender;
  final Set<String> _conditions = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  @override
  void dispose() {
    _height.dispose();
    _weight.dispose();
    _dob.dispose();
    _blood.dispose();
    _allergies.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final auth = ref.read(authenticationProvider).value?.data;
    if (auth == null) return;
    try {
      final profile = await ref
          .read(harRepositoryProvider)
          .fetchProfile(token: auth.token);
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _height.text = profile.heightCm?.toString() ?? '';
        _weight.text = profile.weightKg?.toString() ?? '';
        _dob.text = profile.dateOfBirth ?? '';
        _blood.text = profile.bloodGroup ?? '';
        _allergies.text = profile.allergies ?? '';
        _gender = _normalizeGender(profile.gender);
        _conditions
          ..clear()
          ..addAll(profile.conditions.map((item) => item.code));
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _profile = PatientProfile(
          id: auth.id,
          name: auth.name,
          email: auth.email,
          mobnum: auth.mobnum,
        );
      });
    }
  }

  Future<void> _save() async {
    final auth = ref.read(authenticationProvider).value?.data;
    if (auth == null) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final updated = await ref
          .read(harRepositoryProvider)
          .updateProfile(
            token: auth.token,
            body: {
              if (_dob.text.isNotEmpty) 'date_of_birth': _dob.text,
              if (_height.text.isNotEmpty)
                'height_cm': double.parse(_height.text),
              if (_weight.text.isNotEmpty)
                'weight_kg': double.parse(_weight.text),
              if (_blood.text.isNotEmpty) 'blood_group': _blood.text,
              if (_allergies.text.isNotEmpty) 'allergies': _allergies.text,
              if (_gender != null) 'gender': _gender,
              'conditions': [
                for (final code in _conditions)
                  {'code': code, 'label': code.replaceAll('_', ' ')},
              ],
            },
          );
      if (!mounted) return;
      ref.invalidate(patientProfileProvider);
      setState(() {
        _profile = updated;
        _saving = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = 'Unable to save your profile. Check the values and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authenticationProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.transparent),
          ),
        ),
      ),
      body: auth.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Unable to load profile.')),
        data: (status) {
          final user = status.data;
          if (user == null) {
            return const Center(
              child: Text('No profile information is available.'),
            );
          }
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                  child: ListTile(
                    title: const Text('Name'),
                    subtitle: Text(user.name),
                    style: ListTileStyle.list,
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: ListTile(
                    title: const Text('Email'),
                    subtitle: Text(user.email),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: ListTile(
                    title: const Text('Mobile'),
                    subtitle: Text(user.mobnum),
                  ),
                ),
                if (_profile?.age != null)
                  SizedBox(
                    height: 60,
                    child: ListTile(
                      title: const Text('Age'),
                      subtitle: Text('${_profile!.age} years'),
                    ),
                  ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  key: ValueKey('profile-gender-$_gender'),
                  initialValue: _gender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('Male')),
                    DropdownMenuItem(value: 'female', child: Text('Female')),
                    DropdownMenuItem(value: 'other', child: Text('Other')),
                  ],
                  onChanged: (value) => setState(() => _gender = value),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _dob,
                  decoration: const InputDecoration(
                    labelText: 'Date of birth (YYYY-MM-DD)',
                  ),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _height,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Height (cm)'),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _weight,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _blood,
                  decoration: const InputDecoration(labelText: 'Blood group'),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _allergies,
                  decoration: const InputDecoration(labelText: 'Allergies'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Recorded conditions',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final code in const [
                      'hypertension',
                      'diabetes',
                      'cardiovascular_disease',
                      'obesity',
                      'asthma',
                      'copd',
                      'chronic_kidney_disease',
                      'smoking',
                      'stroke',
                    ])
                      FilterChip(
                        label: Text(code.replaceAll('_', ' ')),
                        selected: _conditions.contains(code),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _conditions.add(code);
                            } else {
                              _conditions.remove(code);
                            }
                          });
                        },
                      ),
                  ],
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: Text(_saving ? 'Saving…' : 'Save profile'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

String? _normalizeGender(String? raw) {
  switch (raw?.trim().toLowerCase()) {
    case 'male':
    case 'female':
    case 'other':
      return raw!.trim().toLowerCase();
    default:
      return null;
  }
}
