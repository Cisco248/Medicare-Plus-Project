import 'package:client/feature/pharmacy/notifiers/pharmacy.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchWidget extends ConsumerStatefulWidget {
  const SearchWidget({super.key, this.onSubmitted});

  final VoidCallback? onSubmitted;

  @override
  ConsumerState<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<SearchWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      height: 40,
      child: TextField(
        controller: _controller,
        onChanged: ref.read(pharmacyQueryProvider.notifier).setSearch,
        onSubmitted: (_) => widget.onSubmitted?.call(),
        decoration: InputDecoration(
          hintText: 'Search medicines and products',
          prefixIcon: const Icon(Icons.search, size: 18),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          isDense: true,
        ),
      ),
    );
  }
}
