import 'package:flutter/material.dart';
import 'package:wp_notify/models/responses/WPStoreTokenResponse.dart';
import 'package:wp_notify/wp_notify.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WooSignal Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'WooSignal Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();

    // INSTALL THE WP NOTIFY PLUGIN
    // FIRST ON YOUR WORDPRESS STORE
    // LINK https://woosignal.com/plugins/wordpress/wp-notify

    WPNotifyAPI.instance.initWith(baseUrl: "http://mysite.com");

  }

  _storeToken() async {
    WPStoreTokenResponse wpStoreTokenResponse;
    try {
      wpStoreTokenResponse = WPNotifyAPI.instance.api((request) => request.wpNotifyStoreToken(token: "fcm token", userId: 12));
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              child: Text("Store token"),
              onPressed: _storeToken,
            )
          ],
        ),
      ),
    );
  }
}
