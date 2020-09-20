// import 'package:flutter/material.dart';
// import 'package:aft_pos_sdk/aft_pos_sdk.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   var isConnected = false;

//   AftPosConnection connection = AftPosConnection(
//     ip: '192.168.1.241',
//     port: 1197,
//   );
//   @override
//   void initState() {
//     connection.connect().then((value) => setState(() {
//           isConnected = true;
//         }));
//     super.initState();
//   }

//   void sendRequest() async {
//     final builder = RequestBuilderFactory.create(PaymentType.Sep);
//     builder
//       ..setAmount("1000")
//       ..setCurrentcy(364);

//     setState(() {
//       //posResponse = connection.sendRequest(builder);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             if (posResponse != null)
//               FutureBuilder<PosResponse>(
//                   future: posResponse,
//                   builder: (context, snapshot) {
//                     return Text(
//                       '${snapshot.data.getMessage}',
//                       style: Theme.of(context).textTheme.headline4,
//                     );
//                   }),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: (isConnected) ? sendRequest : null,
//         tooltip: 'Payment',
//         child: Icon(Icons.payment),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
