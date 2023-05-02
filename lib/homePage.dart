import 'package:flutter/material.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _smsText = '';
  String _amount = '';
  final String _beneficiaryNumber = '';

  @override
  void initState() {
    super.initState();
    SmsAdvanced.startSmsReceiver((SmsMessage message) {
      setState(() {
        _smsText = message.body!;
        _extractData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Payment App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Reception of the Airtel Money SMS notification"),
            TextField(
              decoration: const InputDecoration(labelText: 'SMS Text'),
              onChanged: (value) {
                setState(() {
                  _smsText = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Text('Amount: $_amount'),
            const SizedBox(height: 16.0),
            Text('Beneficiary Number: $_beneficiaryNumber'),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _extractData,
              child: const Text('Extract Data'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _executeUssdCode,
              child: const Text('Execute USSD Code'),
            ),
          ],
        ),
      ),
    );
  }

  void _extractData() {
    // code to extract data from SMS
    _amount = ''; // amount extracted from SMS
    double amountWithFees = double.parse(_amount) - 0.5; // assuming fee is 0.5
    if (double.parse(_amount) >= 100 && double.parse(_amount) < 1000) {
      amountWithFees -= 50;
    } else if (double.parse(_amount) >= 1000 && double.parse(_amount) < 10000) {
      amountWithFees -= 100;
    }
    _amount = amountWithFees.toString();
  }

  void _executeUssdCode() async {
    String encodedHash = Uri.encodeComponent('#');
    String ussdCode = '*771*$_beneficiaryNumber*$_amount*123456'; // your USSD code
    String uri = 'tel:$ussdCode$encodedHash';
    if (await canLaunchUrl(uri as Uri)) {
      await launchUrl(uri as Uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}

class SmsAdvanced {
  static void startSmsReceiver(Null Function(SmsMessage message) param0) {}
}

