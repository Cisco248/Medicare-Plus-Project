import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActivityCardWidget extends ConsumerStatefulWidget {
  final String value;
  final String valueName;
  final FaIconData icon;
  final Color iconColor;

  const ActivityCardWidget({
    required this.value,
    required this.valueName,
    required this.icon,
    required this.iconColor,
    super.key,
  });

  @override
  ConsumerState<ActivityCardWidget> createState() => _ActivityCardWidgetState();
}

class _ActivityCardWidgetState extends ConsumerState<ActivityCardWidget> {
  String value = "";

  @override
  void initState() {
    setState(() {
      value = widget.value;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.all(Radius.circular(16)),
        gradient: LinearGradient(
          colors: [
            colorScheme.onSurface.withAlpha(10),
            colorScheme.surfaceContainer.withAlpha(100),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FaIcon(widget.icon, size: 48, color: widget.iconColor),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.valueName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: widget.iconColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
