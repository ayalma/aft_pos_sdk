import 'package:flutter/material.dart';
import 'package:aft_pos_sdk/aft_pos_sdk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  var isConnected = false;
  Future<PosResponse> posResponse;
  AftPosConnection connection = AftPosConnection(
    ip: '192.168.1.421',
    port: 1010,
  );
  @override
  void initState() {
    connection.connect().then((value) => setState(() {
          isConnected = true;
        }));
    super.initState();
  }

  void sendRequest() async {
    BTLV btlv = new BTLV();
    btlv.addTagValue(Tag.PR, "000000");
    btlv.addTagValue(Tag.AM, "1000");
    btlv.addTagValue(Tag.CU, "364");
    btlv.addTagValue(Tag.T1, "");
    btlv.addTagValue(Tag.R1, "");
    btlv.addTagValue(Tag.T2, "");
    btlv.addTagValue(Tag.R2, "");
    btlv.addTagValue(Tag.SV, "");
    btlv.addTagValue(Tag.SG, "");
    btlv.addTagValue(Tag.ST, "1=1002=200");
    btlv.addTagValue(Tag.AV, "ID1=1000ID2=2000");

    posResponse = connection.sendRequest(btlv);
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
            //if (isConnected)
            FutureBuilder<PosResponse>(
                future: posResponse,
                builder: (context, snapshot) {
                  return Text(
                    '${snapshot.data.getMessage}',
                    style: Theme.of(context).textTheme.headline4,
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (isConnected) ? sendRequest : null,
        tooltip: 'Payment',
        child: Icon(Icons.payment),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
