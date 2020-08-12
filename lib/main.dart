import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:transformer_page_view/transformer_page_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpellingApp',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'SpellingApp'),
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
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: rootBundle.loadString('lib/assets/questions.csv'), //
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<List<dynamic>> csvTable =
              CsvToListConverter().convert(snapshot.data);
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: TransformerPageView(
                loop: true,
                viewportFraction: 0.8,
                transformer:   PageTransformerBuilder(
                    builder: (Widget child, TransformInfo info) {
                  return   Padding(
                    padding:   EdgeInsets.all(10.0),
                    child:   Material(
                      elevation: 8.0,
                      textStyle:   TextStyle(color: Colors.indigo[50]),
                      borderRadius:   BorderRadius.circular(10.0),
                      child:   Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                            Positioned(
                            child:   Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                  ParallaxContainer(
                                  child:   Text(
                                    csvTable[info.index + 1][0],
                                    style:   TextStyle(
                                      fontSize: 24.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  position: info.position,
                                  translationFactor: 300.0,
                                ),
                              ],
                            ),
                            left: 10.0,
                            right: 10.0,
                            top: 100.0,
                          )
                        ],
                      ),
                    ),
                  );
                }),
                itemCount: csvTable.length - 1),
          );
        });
  }
}
