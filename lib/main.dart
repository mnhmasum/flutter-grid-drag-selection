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
        primarySwatch: Colors.red,
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
  GlobalKey gridKey = new GlobalKey();

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
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: GridView.builder(
            key: gridKey,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridStateLength,
              //childAspectRatio: 8.0 / 11.9
            ),
            itemBuilder: _buildGridItems,
            itemCount: gridStateLength * gridStateLength,
          ),
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
        RenderBox _box = gridItemKey.currentContext.findRenderObject();
        RenderBox _boxGrid = gridKey.currentContext.findRenderObject();
        Offset position = _boxGrid.localToGlobal(Offset.zero); //this is global position
        double gridLeft = position.dx;
        double gridTop = position.dy;

        double gridPosition = details.globalPosition.dy - gridTop;

        //Get item position
        int indexX = (gridPosition / _box.size.width).floor().toInt();
        int indexY = ((details.globalPosition.dx - gridLeft) / _box.size.width).floor().toInt();
        if (gridState[indexX][indexY] == "Y") {
          gridState[indexX][indexY] = "";
        } else {
          gridState[indexX][indexY] = "Y";
        }

        setState(() {});
      },
      onVerticalDragUpdate: (details) {
        selectItem(gridItemKey, details);
      },
      onHorizontalDragUpdate: (details) {
        selectItem(gridItemKey, details);
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

  void selectItem(GlobalKey<State<StatefulWidget>> gridItemKey, var details) {
    RenderBox _boxItem = gridItemKey.currentContext.findRenderObject();
    RenderBox _boxMainGrid = gridKey.currentContext.findRenderObject();
    Offset position = _boxMainGrid.localToGlobal(Offset.zero); //this is global position
    double gridLeft = position.dx;
    double gridTop = position.dy;

    double gridPosition = details.globalPosition.dy - gridTop;

    //Get item position
    int rowIndex = (gridPosition / _boxItem.size.width).floor().toInt();
    int colIndex = ((details.globalPosition.dx - gridLeft) / _boxItem.size.width).floor().toInt();
    gridState[rowIndex][colIndex] = "Y";

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
      case 'N':
        return Container(
          color: Colors.white,
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
