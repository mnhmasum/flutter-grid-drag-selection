import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Grid'),
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
  GlobalKey appbarKey = new GlobalKey();

  List<List<String>> gridState = [
    ["", "", "", "", "", "", "", "", "", ""],
    ["", "", "", "", "", "", "", "", "", ""],
    ["", "", "", "", "", "", "", "", "", ""],
    ["", "", "", "", "", "", "", "", "", ""],
    ["", "", "", "", "", "", "", "", "", ""],
    ["", "", "", "", "", "", "", "", "", ""],
    ["", "", "", "", "", "", "", "", "", ""],
    ["", "", "", "", "", "", "", "", "", ""],
    ["", "", "", "", "", "", "", "", "", ""],
    ["", "", "", "", "", "", "", "", "", ""],
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      //DeviceOrientation.landscapeRight,
      //DeviceOrientation.landscapeLeft,
    ]);
  }

  Widget _buildBody() {
    int gridStateLength = gridState.length;
    return Column(children: <Widget>[
      AspectRatio(
        aspectRatio: 1.0,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridStateLength,
            //childAspectRatio: 8.0 / 11.9
          ),
          itemBuilder: _buildGridItems,
          itemCount: gridStateLength * gridStateLength,
        ),
      ),
    ]);
  }

  Widget _buildGridItems(BuildContext context, int index) {
    int gridStateLength = gridState.length;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    GlobalKey gridItemKey = new GlobalKey();

    return GestureDetector(
      onTapDown: (details) {
        selectIItem(gridItemKey, details);
      },
      onVerticalDragUpdate: (details) {
        selectIItem(gridItemKey, details);
      },
      onHorizontalDragUpdate: (details) {
        selectIItem(gridItemKey, details);
      },
      child: GridTile(
        key: gridItemKey,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          child: Center(
            child: _buildGridItem(x, y),
          ),
        ),
      ),
    );
  }

  void selectIItem(GlobalKey<State<StatefulWidget>> gridItemKey, var details) {
    RenderBox _box = gridItemKey.currentContext.findRenderObject();
    RenderBox _boxAppBar = appbarKey.currentContext.findRenderObject();

    //Remove appbar height to get grid actual position
    double gridPosition = details.globalPosition.dy - _boxAppBar.size.height;

    //Get item position
    int indexX = (gridPosition / _box.size.width).floor().toInt();
    int indexY = (details.globalPosition.dx / _box.size.width).floor().toInt();

    gridState[indexX][indexY] = "Y";
    setState(() {});
  }

  Widget _buildGridItem(int x, int y) {
    switch (gridState[x][y]) {
      case '':
        return Text('');
        break;
      case 'Y':
        return Container(
          color: Colors.green,
        );
        break;
      default:
        return Text(gridState[x][y].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: appbarKey,
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _buildBody(),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _gridItemTapped(int x, int y) {
    print("x is $x and Y is $y");
  }
}
