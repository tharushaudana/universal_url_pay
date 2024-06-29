import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Universal URL Pay'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _appLinks = AppLinks();

  bool _paySuccess = false;

  Future<Uri> _generatePaymentUrl() async {
    /*
    * Call API to generate payment URL. 
    * Set "universal_url_pay://payment/success" as the redirect URL.
    */
    return Uri.parse('http://192.168.43.86/test-gateway');
  }

  Future<void> _launchPayment() async {
    Uri url = await _generatePaymentUrl();

    if (!await launchUrl(url)) {
      throw Exception('Could not launch');
    }
  }

  Future<void> _onPaymentResponse() async {
    setState(() {
      _paySuccess = true;
    });
  }

  @override
  void initState() {
    _appLinks.uriLinkStream.listen((uri) {
      if (uri.toString() == "universalurlpay://payment/success") {
        _onPaymentResponse();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            !_paySuccess
                ? FilledButton(
                    onPressed: _launchPayment,
                    child: const Text("Pay Now"),
                  )
                : Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.done,
                          size: 60,
                          color: Colors.green,
                        ),
                        Text(
                          "Payment Success",
                          style: TextStyle(color: Colors.green),
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
