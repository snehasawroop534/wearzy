import 'package:flutter/material.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({super.key});

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Terms & Conditions",
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

            sectionTitle("Welcome to Wearzy"),
            sectionText(
                "Wearzy is an e-commerce platform that allows users to browse, "
                    "purchase and manage fashion products such as clothing, footwear "
                    "and accessories. By accessing or using the Wearzy app, you agree "
                    "to comply with and be bound by these Terms & Conditions."
            ),

            sectionTitle("User Eligibility"),
            sectionText(
                "To use Wearzy, you must be at least 18 years old or have parental "
                    "permission. By using this app, you confirm that the information "
                    "provided by you is accurate and complete."
            ),

            sectionTitle("Account Registration"),
            sectionText(
                "You are responsible for maintaining the confidentiality of your "
                    "account credentials. Wearzy will not be responsible for any loss "
                    "arising from unauthorized access to your account."
            ),

            sectionTitle("Product Information"),
            sectionText(
                "We strive to display accurate product descriptions, prices and "
                    "images. However, Wearzy does not guarantee that all product details "
                    "are error-free. Colors may vary due to screen settings."
            ),

            sectionTitle("Pricing & Payments"),
            sectionText(
                "All prices listed on Wearzy are inclusive/exclusive of applicable "
                    "taxes as mentioned. Payments can be made using available payment "
                    "methods. Wearzy reserves the right to modify prices at any time."
            ),

            sectionTitle("Orders & Cancellations"),
            sectionText(
                "Once an order is placed, it may be cancelled only within a limited "
                    "time window. Wearzy reserves the right to cancel any order due to "
                    "unavailability of stock, pricing errors or suspicious activity."
            ),

            sectionTitle("Returns & Refunds"),
            sectionText(
                "Returns and refunds are subject to Wearzy’s return policy. Products "
                    "must be returned in unused condition with original packaging. "
                    "Refunds will be processed to the original payment method."
            ),

            sectionTitle("Wishlist & Cart"),
            sectionText(
                "Adding items to wishlist or cart does not reserve stock. Product "
                    "availability may change at any time without prior notice."
            ),

            sectionTitle("Intellectual Property"),
            sectionText(
                "All content on Wearzy including logos, images, text and design is "
                    "the property of Wearzy. Unauthorized use or reproduction is strictly prohibited."
            ),

            sectionTitle("User Conduct"),
            sectionText(
                "Users agree not to misuse the app, attempt unauthorized access, "
                    "post harmful content or violate any applicable laws."
            ),

            sectionTitle("Limitation of Liability"),
            sectionText(
                "Wearzy shall not be liable for any indirect, incidental or "
                    "consequential damages arising from the use of the app or products."
            ),

            sectionTitle("Changes to Terms"),
            sectionText(
                "Wearzy reserves the right to update or modify these Terms & Conditions "
                    "at any time. Continued use of the app implies acceptance of revised terms."
            ),

            sectionTitle("Contact Us"),
            sectionText(
                "For any questions regarding these Terms & Conditions, please contact "
                    "us through the Wearzy support section."
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

// 🔹 Reusable Widgets
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
