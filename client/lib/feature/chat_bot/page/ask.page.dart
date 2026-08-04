import 'package:client/core/widgets/divider.widget.dart';
import 'package:client/feature/chat_bot/models/message_model.dart';
import 'package:client/feature/chat_bot/providers/chat.notifier.dart';
import 'package:client/feature/chat_bot/widgets/display.widget.dart';
import 'package:client/feature/chat_bot/widgets/message.widget.dart';
import 'package:client/feature/chat_bot/widgets/search.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AskPage extends ConsumerStatefulWidget {
  const AskPage({super.key});

  @override
  ConsumerState<AskPage> createState() => _AskPageState();
}

class _AskPageState extends ConsumerState<AskPage> {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatProvider);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final message = state.messages[index];
                final isUser = message.type == MessageType.user;
                return MessageWidget(variant: isUser, message: message);
              },
            ),
          ),
          if (state.isLoading) DisplayWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: const ZintraDivider(thickness: 1),
          ),
          SearchWidget(_scrollController),
        ],
      ),
    );
  }
}

// Container(
//   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//   decoration: BoxDecoration(
//     color: Theme.of(context).colorScheme.primary,
//     borderRadius: const BorderRadius.vertical(
//       top: Radius.circular(20),
//     ),
//   ),
//   child: Row(
//     children: [
//       const Icon(Icons.smart_toy, color: Colors.white),
//       const SizedBox(width: 10),
//       const Expanded(
//         child: Text(
//           "Medicare Assistant",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       IconButton(
//         onPressed: () => ref.read(popUpProvider.notifier).toggle(),
//         icon: const FaIcon(FontAwesomeIcons.xmark, color: Colors.red),
//       ),
//     ],
//   ),
// ),
