import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(HexPickerPage());

class HexPickerPage extends StatefulWidget {
  @override
  HexPickerPageState createState() => new HexPickerPageState();
}

class HexPickerPageState extends State<HexPickerPage> {
  bool state = true; // true attente new game, false Game en cours
  HSVColor color = new HSVColor.fromColor(Colors.blue);
  void onChanged(HSVColor value) => this.color = value;
  var rng = new Random();
  Color randomColor;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                  title: Text('Random Color Game'),
                ),
                body: new Column(children: <Widget>[
                  Visibility(
                    child: RaisedButton(
                        onPressed: () {
                          newGame();
                        },
                        child: const Text('                         New game                         '),
                        textTheme: ButtonTextTheme.primary,
                        color: randomColor),
                    visible: state,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                  ),
                  new Divider(),
                  new Center(
                      child: new Container(
                          width: 260,
                          child: new Card(
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0.0))),
                              elevation: 2.0,
                              child: new Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: new Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new FloatingActionButton(
                                          onPressed: () {
                                            print(color.toColor());
                                          },
                                          backgroundColor: this.color.toColor(),
                                        ),
                                        new Divider(),

                                        ///---------------------------------
                                        new PaletteSaturationPicker(
                                          color: this.color,
                                          onChanged: (value) => super.setState(
                                              () => this.onChanged(value)),
                                        )

                                        ///---------------------------------
                                      ]))))),
                  new Divider(),
                  Visibility(
                      child: RaisedButton(
                        onPressed: () {
                          verify();
                        },
                        child: const Text('Verify'),
                      ),
                      visible: !state),
                ]))));
  }

  newGame() {
    setState(() {
      randomColor = new Color.fromRGBO(
          rng.nextInt(256), rng.nextInt(256), rng.nextInt(256), 1.0);
      state = false;
    });
    Fluttertoast.showToast(
        msg: "                                                                                                        ",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 5,
        backgroundColor: randomColor,
        textColor: randomColor,
        fontSize: 16.0);
  }

  verify() {
    int c1r = color.toColor().red;
    int c1g = color.toColor().green;
    int c1b = color.toColor().blue;

    int c2r = randomColor.red;
    int c2g = randomColor.green;
    int c2b = randomColor.blue;

    double rmean = (c1r + c2r) / 2;
    int r = c1r - c2r;
    int g = c1g - c2g;
    int b = c1b - c2b;
    double weightR = 2 + rmean / 256;
    double weightG = 4.0;
    double weightB = 2 + (255 - rmean) / 256;
    double score = sqrt(weightR * r.toDouble() * r.toDouble() +
        weightG * g.toDouble() * g.toDouble() +
        weightB * b.toDouble() * b.toDouble());
    Fluttertoast.showToast(
        msg: ("Score : "+score.toString()),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 5,
        backgroundColor: Colors.grey,
        textColor: Colors.black,
        fontSize: 20.0);
    setState(() {
      state = true;
    });
  }
}