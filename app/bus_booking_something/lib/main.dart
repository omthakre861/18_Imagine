import 'package:bus_booking_something/pages/mainpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MainPage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    const kTileHeight = 50.0;
    List<_TimelineStatus> data = [
      _TimelineStatus.done,
      _TimelineStatus.inProgress,
      _TimelineStatus.inProgress,
      _TimelineStatus.todo
    ];

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Timeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            nodeItemOverlap: true,
            connectorTheme: ConnectorThemeData(
              color: Color(0xffe6e7e9),
              thickness: 15.0,
            ),
          ),
          padding: EdgeInsets.only(top: 20.0),
          builder: TimelineTileBuilder.connected(
            indicatorBuilder: (context, index) {
              final status = data[index];
              return OutlinedDotIndicator(
                color:
                    status.isInProgress ? Color(0xff6ad192) : Color(0xffe6e7e9),
                backgroundColor:
                    status.isInProgress ? Color(0xffd4f5d6) : Color(0xffc2c5c9),
                borderWidth: status.isInProgress ? 3.0 : 2.5,
              );
            },
            connectorBuilder: (context, index, connectorType) {
              var color;
              if (index + 1 < data.length - 1 &&
                  data[index].isInProgress &&
                  data[index + 1].isInProgress) {
                color = data[index].isInProgress ? Color(0xff6ad192) : null;
              }
              return SolidLineConnector(
                color: color,
              );
            },
            contentsBuilder: (context, index) {
              var height;
              if (index + 1 < data.length - 1 &&
                  data[index].isInProgress &&
                  data[index + 1].isInProgress) {
                height = kTileHeight - 10;
              } else {
                height = kTileHeight + 5;
              }
              return SizedBox(
                height: height,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _EmptyContents(),
                ),
              );
            },
            itemCount: data.length,
          ),
        ));
  }
}

class _EmptyContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0),
      height: 10.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        color: Color(0xffe6e7e9),
      ),
    );
  }
}

enum _TimelineStatus {
  done,
  sync,
  inProgress,
  todo,
}

extension on _TimelineStatus {
  bool get isInProgress => this == _TimelineStatus.inProgress;
}
