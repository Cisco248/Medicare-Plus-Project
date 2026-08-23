import 'package:flutter/material.dart';

class UserAgreementPage extends StatelessWidget {
  const UserAgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User agreement',
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
                title: 'Acceptance of terms',
                body:
                    'By using MediCare Plus you agree that this is a university healthcare application prototype. It is provided for learning and demonstration, not for clinical or commercial use.',
              ),
              _Section(
                title: 'Account responsibilities',
                body:
                    'Keep your login details private. Do not upload real patient records that you are not allowed to store. Use demo or fictional information where possible.',
              ),
              _Section(
                title: 'Health information disclaimer',
                body:
                    'Dashboard metrics, chatbot answers and assessment forms are educational only. They are not a diagnosis, prescription or emergency service.',
              ),
              _Section(
                title: 'E-Doc usage',
                body:
                    'E-Doc lets you view and upload documents for the prototype. Files are not reviewed by a real clinician unless your course staff say otherwise.',
              ),
              _Section(
                title: 'E-Pharmacy usage',
                body:
                    'The pharmacy catalogue is a demo. Products, prices and stock are sample data. No real medicine is dispensed.',
              ),
              _Section(
                title: 'Prescription requirements',
                body:
                    'Items marked as prescription-required cannot be added to the cart until a demo verification step is completed. That step is simulated.',
              ),
              _Section(
                title: 'Demo payment disclaimer',
                body:
                    'Checkout uses Cash on Delivery or a demo card form. No real payment is taken and card numbers must not be real. Details are not stored.',
              ),
              _Section(
                title: 'Order cancellation',
                body:
                    'Demo orders can be viewed in order history. There is no live courier, refund or cancellation desk in this prototype.',
              ),
              _Section(
                title: 'Data and privacy',
                body:
                    'The Privacy Statement explains how the prototype stores account, document and pharmacy data.',
              ),
              _Section(
                title: 'Prohibited misuse',
                body:
                    'Do not use the app to store stolen records, attempt unauthorized access, or present demo results as real medical advice.',
              ),
              _Section(
                title: 'Changes to terms',
                body:
                    'These terms may change as the university project develops. Continued use after an update means you accept the revised statement.',
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
