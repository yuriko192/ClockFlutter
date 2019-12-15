import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'dart:math' as math;

final bigrad = radians(360 / 60);
final smallrad = radians(360 / 12);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark,
          textTheme: TextTheme(),
          primaryColor: Colors.blueGrey[900],
          secondaryHeaderColor: Colors.lightBlue[900]),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  clockTime clock = clockTime();
  double height;

  @override
  void initState() {
    Timer.periodic(
        Duration(seconds: 1),
        (v) => {
              setState(() {
                clock = clockTime();
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    final clocksize = MediaQuery.of(context).size.width / 3;
    this.height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(right: 30, left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CustomPaint(
                  size: Size(clocksize, clocksize),
                  painter: PaintClock(clock.now),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                ),
                timeColumn(clock.H),
                timeColumn(clock.h),
                timeColumn(":"),
                timeColumn(clock.M),
                timeColumn(clock.m),
                timeColumn(":"),
                timeColumn(clock.S),
                timeColumn(clock.s),
              ],
            )
          ],
        ),
      ),
    );
  }

  Column timeColumn(x) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          x,
          style: TextStyle(fontSize: height / 4, color: Colors.teal),
        ),
      ],
    );
  }
}

class PaintClock extends CustomPainter {
  double sec, min, hr;
  Offset center;
  PaintClock(DateTime now) {
    sec = now.second * bigrad - math.pi / 2.0;
    min = now.minute * bigrad - math.pi / 2.0;
    hr = now.hour * smallrad + (now.minute / 60) * smallrad - math.pi / 2.0;
  }
  void paint(Canvas canvas, Size size) {
    this.center = Offset(size.width / 2, size.height / 2);
    Paint paint = Paint();
    paint.style = PaintingStyle.stroke;

    //draw border
    paint.strokeWidth = 5;
    paint.color = Colors.white;
    canvas.drawCircle(center, size.width / 2, paint);

    paint.strokeWidth = 2;
    //draw seconds
    paint.color = Colors.blue;
    canvas.drawLine(center, calcpos(sec, 70), paint);

    //draw Minute
    paint.color = Colors.white;
    canvas.drawLine(center, calcpos(min, 50), paint);
    //draw Hour
    paint.color = Colors.teal;
    canvas.drawLine(center, calcpos(hr, 30), paint);
  }

  Offset calcpos(rad, double length) =>
      center + Offset(math.cos(rad), math.sin(rad)) * length;

  bool shouldRepaint(PaintClock old) {
    return sec != old.sec;
  }
}

class clockTime {
  List<String> _time;
  DateTime now;
  clockTime() {
    now = DateTime.now();
    String hhmmss = DateFormat("Hms").format(now).replaceAll(':', '');

    _time = hhmmss
        .split('')
        .map((str) => int.parse(str).toRadixString(10))
        .toList();
  }

  get H => _time[0];
  get h => _time[1];
  get M => _time[2];
  get m => _time[3];
  get S => _time[4];
  get s => _time[5];
}
