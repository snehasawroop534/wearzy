import 'package:flutter/material.dart';

class RefundCancellationPolicy extends StatefulWidget {
  const RefundCancellationPolicy({super.key});

  @override
  State<RefundCancellationPolicy> createState() =>
      _RefundCancellationPolicyState();
}

class _RefundCancellationPolicyState extends State<RefundCancellationPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Refund & Cancellation Policy",
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [

            sectionTitle("Cancellation Policy"),
            sectionText(
                "Orders can be cancelled only within a limited time after placing "
                    "the order. Once an order is processed or shipped, cancellation "
                    "may not be possible. Wearzy reserves the right to cancel any order "
                    "due to stock unavailability, pricing errors or suspicious activity."
            ),

            sectionTitle("Return Policy"),
            sectionText(
                "Products are eligible for return only if they are received in a "
                    "damaged, defective or incorrect condition. The return request "
                    "must be initiated within the specified return window mentioned "
                    "on the product page."
            ),

            sectionTitle("Non-Returnable Items"),
            sectionText(
                "Certain products such as innerwear, personal care items, "
                    "and products marked as non-returnable cannot be returned "
                    "due to hygiene and safety reasons."
            ),

            sectionTitle("Refund Process"),
            sectionText(
                "Once the returned product is received and inspected, the refund "
                    "will be initiated. Refunds will be processed to the original "
                    "payment method used during purchase."
            ),

            sectionTitle("Refund Timeline"),
            sectionText(
                "Refunds are usually processed within 5-10 business days after "
                    "successful quality check. The actual credit time may vary "
                    "depending on your bank or payment provider."
            ),

            sectionTitle("Partial Refunds"),
            sectionText(
                "In certain cases, only partial refunds may be granted if the "
                    "product shows signs of usage, damage, or missing accessories."
            ),

            sectionTitle("Exchange Policy"),
            sectionText(
                "Exchanges are subject to product availability. If the requested "
                    "replacement is unavailable, a refund will be initiated instead."
            ),

            sectionTitle("Shipping Charges"),
            sectionText(
                "Shipping charges, if any, are non-refundable unless the return "
                    "is due to an error from Wearzy’s side."
            ),

            sectionTitle("Contact Support"),
            sectionText(
                "For any issues related to refunds or cancellations, users can "
                    "reach out to Wearzy customer support through the app."
            ),

            SizedBox(height: 20),
            Center(
              child: Text(
                "© 2026 Wearzy. All rights reserved.",
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Reusable Widgets (Same as Terms & Conditions)
class sectionTitle extends StatelessWidget {
  final String text;
  const sectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class sectionText extends StatelessWidget {
  final String text;
  const sectionText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
        height: 1.5,
      ),
    );
  }
}
