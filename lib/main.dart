import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String equation = '0';
  String result = '0';
  String expression = '';
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  bottomPressed(String text) {
    setState(() {
      if (text == 'C') {
        equation = '0';
        result = '0';
        equationFontSize = 38.0;
        resultFontSize = 48.0;
      } else if (text == '⌫') {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        equation = equation.substring(0, equation.length - 1);
        if (equation == '') {
          equation = '0';
          equationFontSize = 38.0;
          resultFontSize = 48.0;
        }
      } else if (text == '=') {
        expression = equation;
        expression = expression.replaceAll('÷', '/');
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          result = 'Error';
        }
      } else {
        if (equation == '0') {
          equation = text;
        } else {
          equation = equation + text;
        }
      }
    });
  }

  Widget _buildBottom(String title, Color colour, double height) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * height,
      color: colour,
      child: FlatButton(
        padding: EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.white,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        onPressed: () => bottomPressed(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SuperCalcul'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              equation,
              style: TextStyle(
                fontSize: equationFontSize,
              ),
            ),
            alignment: Alignment.centerRight,
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              result,
              style: TextStyle(
                fontSize: resultFontSize,
              ),
            ),
            alignment: Alignment.centerRight,
          ),
          Expanded(
            child: Divider(),
          ),
          ClipPath(
            clipper: ClipBottom(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Table(
                    children: [
                      TableRow(
                        children: [
                          _buildBottom('C', Colors.black54, 1),
                          _buildBottom('⌫', Colors.black54, 1),
                          _buildBottom('÷', Colors.black54, 1),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildBottom('7', Colors.black54, 1),
                          _buildBottom('8', Colors.black54, 1),
                          _buildBottom('9', Colors.black54, 1),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildBottom('4', Colors.black54, 1),
                          _buildBottom('5', Colors.black54, 1),
                          _buildBottom('6', Colors.black54, 1),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildBottom('1', Colors.black54, 1),
                          _buildBottom('2', Colors.black54, 1),
                          _buildBottom('3', Colors.black54, 1),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildBottom('0', Colors.black54, 1),
                          _buildBottom('.', Colors.black54, 1),
                          _buildBottom('00', Colors.black54, 1),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Table(
                    children: [
                      TableRow(
                        children: [
                          _buildBottom('*', Colors.black54, 1),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildBottom('-', Colors.black54, 1),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildBottom('+', Colors.black54, 1),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildBottom('=', Colors.black54, 2),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ClipBottom extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    var firstController = Offset(0.0, size.height / 2 + 20);
    var firstEndPoint = Offset(size.width - 20, size.height / 2 + 10);
    path.quadraticBezierTo(firstController.dx, firstController.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    var secondController = Offset(size.width - 1 / 4, size.height / 2 + 50);
    var secondEndPoint = Offset(size.width - 50, size.height / 2);
    path.quadraticBezierTo(secondController.dx, secondController.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
