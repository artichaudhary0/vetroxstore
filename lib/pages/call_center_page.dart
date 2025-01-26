import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallCenterScreen extends StatelessWidget {
  const CallCenterScreen({super.key});

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> contactOptions = [
      {
        "type": "Phone",
        "icon": Icons.phone,
        "contact": "+91 9876543210",
        "action": () {
          _launchURL("tel:+919340968782");
        }
      },
      {
        "type": "Email",
        "icon": Icons.email,
        "contact": "support@company.com",
        "action": () {
          _launchURL("mailto:vetroxvet1@gmail.com");
        }
      },
      {
        "type": "WhatsApp",
        "icon": Icons.chair,
        "contact": "+91 9876543210",
        "action": () {
          _launchURL("https://wa.me/919340968782");
        }
      },
      {
        "type": "Visit Website",
        "icon": Icons.web,
        "contact": "Visit our Website",
        "action": () {
          _launchURL("https://vetrox.in/");
        }
      },
      {
        "type": "Live Chat",
        "icon": Icons.chat_bubble_outline,
        "contact": "Start Chat",
        "action": () {
          _launchURL("sms:+919340968782");
        }
      },
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(15.0),
        child: AppBar(
          automaticallyImplyLeading: false,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How can we help you?",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              "Contact our support team through any of the following options:",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 15.0),
            Expanded(
              child: ListView.builder(
                itemCount: contactOptions.length,
                itemBuilder: (context, index) {
                  final option = contactOptions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 3.0,
                    child: ListTile(
                      leading: Icon(
                        option["icon"],
                        size: 32.0,
                        color: const Color(0xFF082580),
                      ),
                      title: Text(
                        option["type"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        option["contact"],
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        ),
                      ),
                      onTap: option["action"],
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16.0,
                        color: Colors.black45,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
