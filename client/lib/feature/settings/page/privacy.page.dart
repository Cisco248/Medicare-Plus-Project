import 'package:flutter/material.dart';

class PrivacyStatementPage extends StatelessWidget {
  const PrivacyStatementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy statement',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Section(
                title: 'About this statement',
                body:
                    'This is the privacy statement for the MediCare Plus university prototype. It describes how the demo application handles information. It is not a full legal policy for a production hospital or pharmacy system.',
              ),
              _Section(
                title: 'What health data is collected',
                body:
                    'If you grant Health Connect access, the dashboard may read activity and selected vital-sign records already stored on your device. E-Doc can store documents you choose to upload, such as reports or prescriptions. E-Pharmacy stores cart, wishlist and demo order details on the device.',
              ),
              _Section(
                title: 'Why it is collected',
                body:
                    'Health Connect data is used to show a personal activity summary. Documents are stored so you can view them later. Pharmacy data is used only to complete the demo shopping and order flow.',
              ),
              _Section(
                title: 'How medical documents are used',
                body:
                    'Uploaded documents stay attached to your account on the project server, or appear as clearly marked demo records if the server is unavailable. They are not sent to a real hospital, laboratory or insurer.',
              ),
              _Section(
                title: 'How pharmacy and order data is used',
                body:
                    'Cart, wishlist, delivery address and order history are saved locally so the demo checkout can continue after the app is closed. Demo card details are not stored.',
              ),
              _Section(
                title: 'How data is stored',
                body:
                    'Account tokens use the existing secure storage. Pharmacy cart and order state use the existing SharedPreferences helper. Document files are stored by the project backend when that service is running.',
              ),
              _Section(
                title: 'Data sharing',
                body:
                    'This prototype does not sell data and does not connect to a real payment gateway or external pharmacy. Health Connect data stays on the device unless you have already shared it through Health Connect itself.',
              ),
              _Section(
                title: 'Your control',
                body:
                    'You can deny Health Connect access, delete uploaded documents, clear the cart, and log out. Logging out removes the stored session token.',
              ),
              _Section(
                title: 'Permissions',
                body:
                    'Health Connect is used only for dashboard metrics. File access is used only when you upload or download a document. The app does not request location or camera access.',
              ),
              _Section(
                title: 'Third-party services',
                body:
                    'The app may call the project API, the optional RAG service, and Android Health Connect. There is no advertising SDK in this prototype.',
              ),
              _Section(
                title: 'Contact',
                body:
                    'For this university project, use the support details provided by your teaching team. There is no public production support desk.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
