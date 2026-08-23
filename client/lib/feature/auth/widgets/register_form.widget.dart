import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/core/themes/primitives/colors.dart';
import 'package:client/core/utils/notification.utils.dart';
import 'package:client/core/widgets/textfield.widget.dart';
import 'package:client/feature/auth/models/auth.model.dart';
import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _stepKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _mobile = TextEditingController();
  final _weight = TextEditingController();
  final _height = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  DateTime? _birthDay;
  int _step = 0;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _mobile.dispose();
    _weight.dispose();
    _height.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label is required.';
    return null;
  }

  String? _validateEmail(String? value) {
    final empty = _required(value, 'Email');
    if (empty != null) return empty;
    final email = value!.trim();
    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String? _validateMobile(String? value) {
    final empty = _required(value, 'Mobile number');
    if (empty != null) return empty;
    final digits = value!.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 9) return 'Enter a valid mobile number.';
    return null;
  }

  String? _positiveNumber(String? value, String label) {
    final empty = _required(value, label);
    if (empty != null) return empty;
    final parsed = double.tryParse(value!.trim());
    if (parsed == null || parsed <= 0) return 'Enter a valid $label.';
    return null;
  }

  String? _validatePassword(String? value) {
    final empty = _required(value, 'Password');
    if (empty != null) return empty;
    if (value!.trim().length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  bool _validateCurrentStep() {
    if (_step == 1 && _birthDay == null) {
      NotificationUtils.error(context, 'Please select your date of birth.');
      return false;
    }
    return _stepKeys[_step].currentState?.validate() ?? false;
  }

  void _next() {
    if (!_validateCurrentStep()) return;
    setState(() => _step += 1);
  }

  void _back() {
    if (_step == 0) return;
    setState(() => _step -= 1);
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year, now.month, now.day);
    final firstDate = DateTime(now.year - 120);
    final selected = await showDatePicker(
      context: context,
      initialDate: _birthDay ?? DateTime(now.year - 25),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (selected == null) return;
    setState(() => _birthDay = selected);
  }

  Future<void> _submit() async {
    if (!_validateCurrentStep()) return;
    if (_password.text != _confirmPassword.text) {
      NotificationUtils.error(context, 'Passwords do not match.');
      return;
    }
    final weight = double.tryParse(_weight.text.trim());
    final height = double.tryParse(_height.text.trim());
    final birthDay = _birthDay;
    if (weight == null || height == null || birthDay == null) {
      NotificationUtils.error(context, 'Please complete your profile details.');
      return;
    }

    final user = AuthRequestModel(
      name: _name.text.trim(),
      email: _email.text.trim(),
      birthDay: birthDay,
      weight: weight,
      height: height,
      mobnum: _mobile.text.trim(),
      password: _password.text,
    );

    try {
      await ref.read(authenticationProvider.notifier).register(user);
      if (!mounted) return;
      NotificationUtils.info(context, 'Account created. Please sign in.');
    } catch (error) {
      if (!mounted) return;
      final message = error is AppException
          ? error.message
          : 'Unable to create your account.';
      NotificationUtils.error(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authenticationProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final submitting = authState.isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepHeader(step: _step),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: switch (_step) {
            0 => Form(
              key: _stepKeys[0],
              child: _AccountStep(
                name: _name,
                email: _email,
                mobile: _mobile,
                requiredValidator: _required,
                emailValidator: _validateEmail,
                mobileValidator: _validateMobile,
              ),
            ),
            1 => Form(
              key: _stepKeys[1],
              child: _ProfileStep(
                birthDay: _birthDay,
                weight: _weight,
                height: _height,
                onPickBirthday: submitting ? null : _pickBirthday,
                numberValidator: _positiveNumber,
              ),
            ),
            _ => Form(
              key: _stepKeys[2],
              child: _PasswordStep(
                password: _password,
                confirmPassword: _confirmPassword,
                passwordValidator: _validatePassword,
              ),
            ),
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            if (_step > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: submitting ? null : _back,
                  child: const Text('Back'),
                ),
              ),
            if (_step > 0) const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: submitting ? null : (_step == 2 ? _submit : _next),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
                  minimumSize: const WidgetStatePropertyAll(
                    Size.fromHeight(48),
                  ),
                ),
                child: submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _step == 2 ? 'Create account' : 'Continue',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: ZintraColorPrimitives.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    const labels = ['Account', 'Profile', 'Password'];
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        for (var index = 0; index < labels.length; index++) ...[
          if (index > 0)
            Expanded(
              child: Divider(
                color: index <= step
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
              ),
            ),
          Column(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: index <= step
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 11,
                    color: index <= step
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                labels[index],
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  color: index == step
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _AccountStep extends StatelessWidget {
  const _AccountStep({
    required this.name,
    required this.email,
    required this.mobile,
    required this.requiredValidator,
    required this.emailValidator,
    required this.mobileValidator,
  });

  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController mobile;
  final String? Function(String?, String) requiredValidator;
  final FormFieldValidator<String> emailValidator;
  final FormFieldValidator<String> mobileValidator;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('signup-account'),
      spacing: 8,
      children: [
        ZintraTextField(
          label: 'Full name',
          hint: 'Your name',
          controller: name,
          validator: (value) => requiredValidator(value, 'Name'),
        ),
        ZintraTextField(
          label: 'Email',
          hint: 'you@example.com',
          controller: email,
          keyboardType: TextInputType.emailAddress,
          validator: emailValidator,
        ),
        ZintraTextField(
          label: 'Mobile number',
          hint: '07xxxxxxxx',
          controller: mobile,
          keyboardType: TextInputType.phone,
          validator: mobileValidator,
        ),
      ],
    );
  }
}

class _ProfileStep extends StatelessWidget {
  const _ProfileStep({
    required this.birthDay,
    required this.weight,
    required this.height,
    required this.onPickBirthday,
    required this.numberValidator,
  });

  final DateTime? birthDay;
  final TextEditingController weight;
  final TextEditingController height;
  final VoidCallback? onPickBirthday;
  final String? Function(String?, String) numberValidator;

  @override
  Widget build(BuildContext context) {
    final age = birthDay == null ? null : AuthRequestModel.ageFrom(birthDay!);
    final birthdayLabel = birthDay == null
        ? 'Select date of birth'
        : '${birthDay!.year.toString().padLeft(4, '0')}-'
              '${birthDay!.month.toString().padLeft(2, '0')}-'
              '${birthDay!.day.toString().padLeft(2, '0')}';

    return Column(
      key: const ValueKey('signup-profile'),
      spacing: 8,
      children: [
        InkWell(
          onTap: onPickBirthday,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Date of birth',
              helperText: age == null ? null : 'Age: $age years',
            ),
            child: Text(birthdayLabel),
          ),
        ),
        ZintraTextField(
          label: 'Height (cm)',
          hint: 'e.g. 170',
          controller: height,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) => numberValidator(value, 'height'),
        ),
        ZintraTextField(
          label: 'Weight (kg)',
          hint: 'e.g. 68',
          controller: weight,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) => numberValidator(value, 'weight'),
        ),
      ],
    );
  }
}

class _PasswordStep extends StatelessWidget {
  const _PasswordStep({
    required this.password,
    required this.confirmPassword,
    required this.passwordValidator,
  });

  final TextEditingController password;
  final TextEditingController confirmPassword;
  final FormFieldValidator<String> passwordValidator;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('signup-password'),
      spacing: 8,
      children: [
        ZintraTextField(
          label: 'Password',
          hint: 'At least 6 characters',
          controller: password,
          obscureText: true,
          validator: passwordValidator,
        ),
        ZintraTextField(
          label: 'Confirm password',
          hint: 'Re-enter your password',
          controller: confirmPassword,
          obscureText: true,
          validator: (value) {
            final empty = passwordValidator(value);
            if (empty != null) return empty;
            if (value != password.text) return 'Passwords do not match.';
            return null;
          },
        ),
      ],
    );
  }
}
