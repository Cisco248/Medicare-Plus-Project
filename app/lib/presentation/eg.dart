import 'package:app/core/components/avatar.dart';
import 'package:app/core/components/banner.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/card.dart';
import 'package:app/core/components/chip.dart';
import 'package:app/core/components/divider.dart';
import 'package:app/core/components/textfield.dart';
import 'package:app/core/themes/primitives/colors.dart';
import 'package:app/core/themes/primitives/fonts.dart';
import 'package:app/core/themes/primitives/spacing.dart';
import 'package:app/core/themes/tokens/colors.dart';
import 'package:app/core/themes/tokens/spacing.dart';
import 'package:flutter/material.dart';

class ZintraDemoScreen extends StatefulWidget {
  const ZintraDemoScreen({super.key});

  @override
  State<ZintraDemoScreen> createState() => _ZintraDemoScreenState();
}

class _ZintraDemoScreenState extends State<ZintraDemoScreen> {
  bool _switchValue = true;
  bool _checkValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zintra Design System'),
        actions: [
          ZintraAvatar(initials: 'JD', size: 36),
          const SizedBox(width: ZintraSpacing.md),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ZintraSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Typography ──────────────────────────────────────
            _Section(
              title: 'Typography',
              children: [
                Text('Display Bold', style: ZintraTypography.displayBold),
                Text('Title Bold', style: ZintraTypography.titleBold),
                Text('Subtitle Bold', style: ZintraTypography.subtitleBold),
                Text('H1 Bold', style: ZintraTypography.h1Bold),
                Text('H2 Semi Bold', style: ZintraTypography.h2SemiBold),
                Text('H3 Medium', style: ZintraTypography.h3Medium),
                Text(
                  'Body Large Medium',
                  style: ZintraTypography.bodyLargeMedium,
                ),
                Text(
                  'Body Medium Regular',
                  style: ZintraTypography.bodyMediumRegular,
                ),
                Text(
                  'Body Small Regular',
                  style: ZintraTypography.bodySmallRegular,
                ),
                Text(
                  'Label Underline Bold',
                  style: ZintraTypography.labelUnderlineBold,
                ),
                Text(
                  'Caption Strike Medium',
                  style: ZintraTypography.captionStrikeMedium,
                ),
                Text(
                  'Paragraph: The quick brown fox jumps over the lazy dog.',
                  style: ZintraTypography.paragraphMedium,
                ),
              ],
            ),

            // ── Color swatches ──────────────────────────────────
            _Section(
              title: 'Color Palette',
              children: [
                _ColorRow('Primary', ZintraColorPrimitives.primary500),
                _ColorRow('Neutral', ZintraColorPrimitives.neutral500),
                _ColorRow('Destructive', ZintraColorPrimitives.destructive500),
                _ColorRow('Success', ZintraColorPrimitives.success500),
                _ColorRow('Warning', ZintraColorPrimitives.warning500),
                _ColorRow('Lav. Purple', ZintraColorPrimitives.lavendPurple500),
                _ColorRow('Lav. Pink', ZintraColorPrimitives.lavendPink500),
                _ColorRow('Mint Green', ZintraColorPrimitives.mintGreen500),
                _ColorRow('Coral', ZintraColorPrimitives.lightCoral500),
              ],
            ),

            // ── Buttons ─────────────────────────────────────────
            _Section(
              title: 'Buttons',
              children: [
                Wrap(
                  spacing: ZintraSpacing.sm,
                  runSpacing: ZintraSpacing.sm,
                  children: [
                    ZintraButton(label: 'Primary', onPressed: () {}),
                    ZintraButton(
                      label: 'Secondary',
                      onPressed: () {},
                      variant: ZintraButtonVariant.secondary,
                    ),
                    ZintraButton(
                      label: 'Outline',
                      onPressed: () {},
                      variant: ZintraButtonVariant.outline,
                    ),
                    ZintraButton(
                      label: 'Ghost',
                      onPressed: () {},
                      variant: ZintraButtonVariant.ghost,
                    ),
                    ZintraButton(
                      label: 'Danger',
                      onPressed: () {},
                      variant: ZintraButtonVariant.danger,
                    ),
                    ZintraButton(label: 'Disabled'),
                    ZintraButton(
                      label: 'Loading',
                      onPressed: () {},
                      loading: true,
                    ),
                    ZintraButton(
                      label: 'With Icon',
                      onPressed: () {},
                      leadingIcon: Icons.add,
                    ),
                    ZintraButton(
                      label: 'Large',
                      onPressed: () {},
                      size: ZintraButtonSize.large,
                    ),
                    ZintraButton(
                      label: 'Small',
                      onPressed: () {},
                      size: ZintraButtonSize.small,
                    ),
                  ],
                ),
                const SizedBox(height: ZintraSpacing.sm),
                ZintraButton(
                  label: 'Full Width Button',
                  onPressed: () {},
                  fullWidth: true,
                ),
              ],
            ),

            // ── Badges ──────────────────────────────────────────
            _Section(
              title: 'Badges',
              children: [
                Wrap(
                  spacing: ZintraSpacing.sm,
                  runSpacing: ZintraSpacing.sm,
                  children: [
                    const ZintraBadge(label: 'Primary'),
                    const ZintraBadge(
                      label: 'Success',
                      variant: ZintraBadgeVariant.success,
                      dot: true,
                    ),
                    const ZintraBadge(
                      label: 'Warning',
                      variant: ZintraBadgeVariant.warning,
                      dot: true,
                    ),
                    const ZintraBadge(
                      label: 'Danger',
                      variant: ZintraBadgeVariant.danger,
                    ),
                    const ZintraBadge(
                      label: 'Neutral',
                      variant: ZintraBadgeVariant.neutral,
                    ),
                  ],
                ),
              ],
            ),

            // ── Cards ───────────────────────────────────────────
            _Section(
              title: 'Cards',
              children: [
                ZintraCard(
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const ZintraBadge(
                            label: 'Featured',
                            variant: ZintraBadgeVariant.primary,
                          ),
                          const Spacer(),
                          Icon(
                            Icons.bookmark_border,
                            color: ZintraColors.iconSubtle,
                          ),
                        ],
                      ),
                      const SizedBox(height: ZintraSpacing.sm),
                      Text('Card Title', style: ZintraTypography.h5Bold),
                      const SizedBox(height: ZintraSpacing.xxs),
                      Text(
                        'Card description text goes here. Supports multiple lines.',
                        style: ZintraTypography.bodyMediumRegular.copyWith(
                          color: ZintraColors.textSubtle,
                        ),
                      ),
                      const SizedBox(height: ZintraSpacing.md),
                      ZintraButton(
                        label: 'Action',
                        onPressed: () {},
                        size: ZintraButtonSize.small,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: ZintraSpacing.sm),
                ZintraCard(
                  elevated: true,
                  child: Row(
                    children: [
                      const ZintraAvatar(initials: 'AB', size: 48),
                      const SizedBox(width: ZintraSpacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alice Brown',
                            style: ZintraTypography.bodyLargeBold,
                          ),
                          Text(
                            'Senior Designer',
                            style: ZintraTypography.bodyMediumRegular.copyWith(
                              color: ZintraColors.textSubtle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ── Inputs ──────────────────────────────────────────
            _Section(
              title: 'Inputs',
              children: [
                const ZintraTextField(
                  label: 'Email',
                  hint: 'hello@example.com',
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: ZintraSpacing.sm),
                const ZintraTextField(
                  label: 'Password',
                  hint: '••••••••',
                  obscureText: true,
                  suffixIcon: Icons.visibility_off_outlined,
                ),
                const SizedBox(height: ZintraSpacing.sm),
                const ZintraTextField(
                  label: 'Notes',
                  hint: 'Write something...',
                  maxLines: 4,
                ),
                const SizedBox(height: ZintraSpacing.sm),
                const ZintraTextField(
                  label: 'Error field',
                  hint: 'Invalid input',
                  errorText: 'This field is required',
                ),
              ],
            ),

            // ── Status Banners ───────────────────────────────────
            _Section(
              title: 'Status Banners',
              children: [
                const ZintraStatusBanner(
                  type: ZintraStatusType.success,
                  title: 'Success',
                  message: 'Your changes have been saved.',
                ),
                const SizedBox(height: ZintraSpacing.sm),
                const ZintraStatusBanner(
                  type: ZintraStatusType.warning,
                  title: 'Warning',
                  message: 'Please review your submission.',
                ),
                const SizedBox(height: ZintraSpacing.sm),
                const ZintraStatusBanner(
                  type: ZintraStatusType.error,
                  title: 'Error',
                  message: 'Something went wrong. Please try again.',
                ),
                const SizedBox(height: ZintraSpacing.sm),
                const ZintraStatusBanner(
                  type: ZintraStatusType.info,
                  message: 'New updates are available.',
                ),
              ],
            ),

            // ── Dividers ────────────────────────────────────────
            _Section(
              title: 'Dividers',
              children: [
                const ZintraDivider(),
                const ZintraDivider(label: 'OR'),
              ],
            ),

            // ── Controls ────────────────────────────────────────
            _Section(
              title: 'Controls',
              children: [
                Row(
                  children: [
                    Text('Switch', style: ZintraTypography.bodyLargeMedium),
                    const Spacer(),
                    Switch(
                      value: _switchValue,
                      onChanged: (v) => setState(() => _switchValue = v),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Checkbox', style: ZintraTypography.bodyLargeMedium),
                    const Spacer(),
                    Checkbox(
                      value: _checkValue,
                      onChanged: (v) => setState(() => _checkValue = v!),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: ZintraSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}

// ── Internal helpers ───────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: ZintraSpacing.xl),
        Text(
          title,
          style: ZintraTypography.h4Bold.copyWith(
            color: ZintraColors.textDefault,
          ),
        ),
        const SizedBox(height: ZintraSpacing.md),
        ...children,
      ],
    );
  }
}

class _ColorRow extends StatelessWidget {
  final String name;
  final Color color;
  const _ColorRow(this.name, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: ZintraRadius.sm,
              border: Border.all(color: ZintraColors.borderDefault),
            ),
          ),
          const SizedBox(width: ZintraSpacing.sm),
          Text(name, style: ZintraTypography.bodyMediumMedium),
          const Spacer(),
          Text(
            '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
            style: ZintraTypography.bodySmallRegular.copyWith(
              color: ZintraColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
