import 'package:flutter/material.dart';
import 'package:EcoSaver/Pages/OnAppStart/welcome_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SettingsUserGuide extends StatefulWidget {
  @override
  _SettingsUserGuideState createState() => _SettingsUserGuideState();
}

class _SettingsUserGuideState extends State<SettingsUserGuide> {
  final _key = UniqueKey();
  bool isLoading = true;
  String siteLink =
      "https://sites.google.com/view/trashpick--app-user-guide/home";

  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(
        "https://sites.google.com/view/trashpick--app-user-guide/home"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: Theme.of(context).iconTheme.color),
          onPressed: () {
            print("Go to Welcome Page");
            Navigator.pop(context);
          },
        ),
        title: Text(
          "User Guide",
          style: Theme.of(context).textTheme.headline6,
        ),
        elevation: Theme.of(context).appBarTheme.elevation,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(
              key: _key,
              controller: controller,
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(),
          ],
        ),
      ),
    );
  }
}
