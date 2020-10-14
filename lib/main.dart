import 'dart:collection';
import 'dart:math';
import 'package:dijkshortpath/coordinate.dart';
import 'package:dijkshortpath/node.dart';
import 'package:dijkshortpath/vertex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  bool started = false;
  GlobalKey gridKey = new GlobalKey();

  //List<Vertex> visitedVertex = new List<Vertex>();
  List<Adjacent> visited = new List<Adjacent>();

  List<Adjacent> node = new List<Adjacent>();

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

  int counter = 0;

  @override
  void initState() {
    super.initState();
    adjacent(1, 1);
  }

  bool checkValid(int row, int col) {
    if (row >= 0 && row <= 9 && col >= 0 && col <= 9) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> adjacent(int row, int col) async {
    counter++;
    //print("row $row col $col");
    //print("Node length ${node.length} Visited Lenght: ${visited.length}");

    if (checkValid(row, col)) {
      if (node.isNotEmpty) {
        node[0].visited = true;
        int index = node[0].vertexIndex;
        row = getXY(index).x;
        col = getXY(index).y;
        print("current coor $row,$col");
        gridState[row][col] = "P";
        print(gridState);
      } else {
        int index = (row * 10) + col;
        gridState[row][col] = "P";
        Adjacent adjacent = new Adjacent();
        adjacent.visited = true;
        adjacent.vertexDistance = 0;

        adjacent.previousVertexIndex = index;
        adjacent.vertexIndex = index;
        node.add(adjacent);
      }
    }

    //1
    if (checkValid(row - 1, col)) {
      if (gridState[row - 1][col] == "P") {} else
      if (gridState[row - 1][col] == "Y") {
        for (int i = 0; i < node.length; i++) {
          if (coordToIndex(row - 1, col) == node[i].vertexIndex) {
            double afterIncrease =
                getDistance(row, col, row - 1, col) + node[0].vertexDistance;
            if (afterIncrease < node[i].vertexDistance) {
              node[i].vertexDistance = afterIncrease;
              node[i].previousVertexIndex = coordToIndex(row, col);
              break;
            }
          }
        }
      } else {
        gridState[row - 1][col] = "Y";

        Adjacent adjacent = new Adjacent();
        adjacent.visited = false;
        //sqrt(pow((row-(row - 1)), 2) + pow((col-col), 2))
        double dist = getDistance(row, col, row - 1, col);
        print("Distance $dist");
        adjacent.vertexDistance = dist;

        adjacent.previousVertexIndex = coordToIndex(row, col);
        adjacent.vertexIndex = ((row - 1) * 10) + col;
        node.add(adjacent);
      }
    }

    //2
    if (checkValid(row + 1, col)) {
      if (gridState[row + 1][col] == "P") {} else
      if (gridState[row + 1][col] == "Y") {
        for (int i = 0; i < node.length; i++) {
          if (coordToIndex(row + 1, col) == node[i].vertexIndex) {
            double afterIncrease =
                getDistance(row, col, row + 1, col) + node[0].vertexDistance;
            if (afterIncrease < node[i].vertexDistance) {
              node[i].vertexDistance = afterIncrease;
              node[i].previousVertexIndex = coordToIndex(row, col);
              break;
            }
          }
        }
      } else {
        gridState[row + 1][col] = "Y";
        Adjacent adjacent = new Adjacent();
        adjacent.visited = false;
        adjacent.vertexDistance = getDistance(row, col, row + 1, col);
        print(adjacent.vertexDistance);
        adjacent.previousVertexIndex = ((row) * 10) + col;
        adjacent.vertexIndex = ((row + 1) * 10) + col;
        node.add(adjacent);
      }
    }

    //3
    if (checkValid(row, col - 1)) {
      if (gridState[row][col - 1] == "P") {} else
      if (gridState[row][col - 1] == "Y") {
        for (int i = 0; i < node.length; i++) {
          if (coordToIndex(row, col - 1) == node[i].vertexIndex) {
            double afterIncrease =
                getDistance(row, col, row, col - 1) + node[0].vertexDistance;
            if (afterIncrease < node[i].vertexDistance) {
              node[i].vertexDistance = afterIncrease;
              node[i].previousVertexIndex = coordToIndex(row, col);
              break;
            }
          }
        }
      } else {
        gridState[row][col - 1] = "Y";
        Adjacent adjacent = new Adjacent();
        adjacent.visited = false;
        adjacent.vertexDistance = getDistance(row, col, row, col - 1);
        print(adjacent.vertexDistance);
        adjacent.previousVertexIndex = ((row) * 10) + col;
        adjacent.vertexIndex = ((row) * 10) + (col - 1);
        node.add(adjacent);
      }
    }

    //4
    if (checkValid(row, col + 1)) {
      if (gridState[row][col + 1] == "P") {} else
      if (gridState[row][col + 1] == "Y") {
        for (int i = 0; i < node.length; i++) {
          if (coordToIndex(row, col + 1) == node[i].vertexIndex) {
            double afterIncrease =
                getDistance(row, col, row, col + 1) + node[0].vertexDistance;
            if (afterIncrease < node[i].vertexDistance) {
              node[i].vertexDistance = afterIncrease;
              node[i].previousVertexIndex = coordToIndex(row, col);
              break;
            }
          }
        }
      } else {
        gridState[row][col + 1] = "Y";
        Adjacent adjacent = new Adjacent();
        adjacent.visited = false;
        adjacent.vertexDistance = getDistance(row, col, row, col + 1);
        print(adjacent.vertexDistance);
        adjacent.previousVertexIndex = ((row) * 10) + col;
        adjacent.vertexIndex = ((row) * 10) + (col + 1);
        node.add(adjacent);
      }
    }

    //5 Top Right
    if (checkValid(row - 1, col + 1)) {
      if (gridState[row - 1][col + 1] == "P") {} else
      if (gridState[row - 1][col + 1] == "Y") {
        for (int i = 0; i < node.length; i++) {
          if (coordToIndex(row - 1, col + 1) == node[i].vertexIndex) {
            double afterIncrease = getDistance(row, col, row - 1, col + 1) +
                node[0].vertexDistance;
            if (afterIncrease < node[i].vertexDistance) {
              node[i].vertexDistance = afterIncrease.floor().toDouble();
              node[i].previousVertexIndex = coordToIndex(row, col);
              break;
            }
          }
        }
      } else {
        gridState[row - 1][col + 1] = "Y";
        Adjacent adjacent = new Adjacent();
        adjacent.visited = false;
        adjacent.vertexDistance =
            getDistance(row, col, row - 1, col + 1).floor().toDouble();
        print(adjacent.vertexDistance);
        adjacent.previousVertexIndex = ((row) * 10) + col;
        adjacent.vertexIndex = ((row - 1) * 10) + (col + 1);
        node.add(adjacent);
      }
    }

    //6
    if (checkValid(row + 1, col + 1)) {
      if (gridState[row + 1][col + 1] == "P") {} else
      if (gridState[row + 1][col + 1] == "Y") {
        for (int i = 0; i < node.length; i++) {
          if (coordToIndex(row + 1, col - 1) == node[i].vertexIndex) {
            double afterIncrease = getDistance(row, col, row + 1, col + 1)
                .floor()
                .toDouble() +
                node[0].vertexDistance;
            if (afterIncrease < node[i].vertexDistance) {
              node[i].vertexDistance = afterIncrease;
              node[i].previousVertexIndex = coordToIndex(row, col);
              break;
            }
          }
        }
      } else {
        gridState[row + 1][col + 1] = "Y";
        Adjacent adjacent = new Adjacent();
        adjacent.visited = false;
        adjacent.vertexDistance =
            getDistance(row, col, row + 1, col + 1).floor().toDouble();
        print(adjacent.vertexDistance);
        adjacent.previousVertexIndex = ((row) * 10) + col;
        adjacent.vertexIndex = ((row + 1) * 10) + (col + 1);
        node.add(adjacent);
      }
    }

    //7
    if (checkValid(row - 1, col - 1)) {
      if (gridState[row - 1][col - 1] == "P") {} else
      if (gridState[row - 1][col - 1] == "Y") {
        for (int i = 0; i < node.length; i++) {
          if (coordToIndex(row - 1, col - 1) == node[i].vertexIndex) {
            double afterIncrease = getDistance(row, col, row - 1, col - 1)
                .floor()
                .toDouble() +
                node[0].vertexDistance;
            if (afterIncrease < node[i].vertexDistance) {
              node[i].vertexDistance = afterIncrease;
              node[i].previousVertexIndex = coordToIndex(row, col);
              break;
            }
          }
        }
      } else {
        gridState[row - 1][col - 1] = "Y";
        Adjacent adjacent = new Adjacent();
        adjacent.visited = false;
        adjacent.vertexDistance =
            getDistance(row, col, row - 1, col - 1).floor().toDouble();
        print(adjacent.vertexDistance);
        adjacent.previousVertexIndex = coordToIndex(row, col);
        adjacent.vertexIndex = ((row - 1) * 10) + (col - 1);
        node.add(adjacent);
      }
    }

    //8
    if (checkValid(row + 1, col - 1)) {
      if (gridState[row + 1][col - 1] == "P") {} else
      if (gridState[row + 1][col - 1] == "Y") {
        for (int i = 0; i < node.length; i++) {
          if (coordToIndex(row + 1, col - 1) == node[i].vertexIndex) {
            double afterIncrease = getDistance(row, col, row + 1, col - 1) +
                node[0].vertexDistance;
            if (afterIncrease < node[i].vertexDistance) {
              node[i].vertexDistance = afterIncrease.floor().toDouble();
              node[i].previousVertexIndex = coordToIndex(row, col);
              break;
            }
          }
        }
      } else {
        gridState[row + 1][col - 1] = "Y";
        Adjacent adjacent = new Adjacent();
        adjacent.visited = false;
        adjacent.vertexDistance =
            getDistance(row, col, row + 1, col - 1).floor().toDouble();
        print(adjacent.vertexDistance);
        adjacent.previousVertexIndex = ((row) * 10) + col;
        adjacent.vertexIndex = ((row + 1) * 10) + (col - 1);
        node.add(adjacent);
      }
    }

    if (node.isNotEmpty) {
      visited.add(node[0]);
      node.removeAt(0);
      node.sort((a, b) => a.vertexDistance.compareTo(b.vertexDistance));
      for (var value in node) {
        print(
            "Node ${value.vertexIndex} Distance ${value
                .vertexDistance} Prev ${value.previousVertexIndex}");
      }

      setState(() {});

      /// new Future.delayed(const Duration(seconds: 7));

      if (row == 3 && col == 8) {
        int index = (row * 10) + col;
        if (index == 38) {
          getPath(38);
          path.add(38);
          print("====Final ==== $path");

          for (int p in path) {
            gridState[getXY(p).x][getXY(p).y] = "R";
          }

          setState(() {

          });

          return;
        }
      }

      int index = node[0].vertexIndex;
      //if (counter < 30) {
      adjacent(getXY(index).x, getXY(index).y);
      //}
    }
  }

  double getDistance(int row, int col, int row1, int col1) =>
      sqrt(pow((row - row1), 2) + pow((col - col1), 2));

  List<int> path = new List<int>();

  Future<bool> getPath(int index) async {
    int prev = 1000;
    for (var last in visited) {
      print("${last.vertexIndex}  Prev ${last.previousVertexIndex}");
      if (last.vertexIndex == index) {
        prev = last.previousVertexIndex;
        print(prev);
        break;
      }
    }

    path.add(prev);

    if (prev == 11) {
      return false;
    }

    return getPath(prev);
  }

  Coordinate getXY(int index) {
    Coordinate c = new Coordinate();
    c.x = (index / 10).floor();
    c.y = index % 10;
    return c;
  }

  int coordToIndex(int row, int col) {
    return ((row) * 10) + col;
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
    int x,
        y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    GlobalKey gridItemKey = new GlobalKey();

    return GestureDetector(
      onTapDown: (details) {
        RenderBox _box = gridItemKey.currentContext.findRenderObject();
        RenderBox _boxGrid = gridKey.currentContext.findRenderObject();
        Offset position =
        _boxGrid.localToGlobal(Offset.zero); //this is global position
        double gridLeft = position.dx;
        double gridTop = position.dy;

        double gridPosition = details.globalPosition.dy - gridTop;

        //Get item position
        int indexX = (gridPosition / _box.size.width).floor().toInt();
        int indexY = ((details.globalPosition.dx - gridLeft) / _box.size.width)
            .floor()
            .toInt();
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
    Offset position =
    _boxMainGrid.localToGlobal(Offset.zero); //this is global position
    double gridLeft = position.dx;
    double gridTop = position.dy;

    double gridPosition = details.globalPosition.dy - gridTop;

    //Get item position
    int rowIndex = (gridPosition / _boxItem.size.width).floor().toInt();
    int colIndex =
    ((details.globalPosition.dx - gridLeft) / _boxItem.size.width)
        .floor()
        .toInt();
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
          color: Colors.black12,
        );
        break;
      case 'S':
        return Container(
          color: Colors.orange,
        );
        break;
      case 'E':
        return Container(
          color: Colors.red,
        );
        break;
      case 'P':
        return Container(
          color: Colors.deepPurple,
        );
        break;
      case 'N':
        return Container(
          color: Colors.white,
        );
        break;
      case 'R':
        return Container(
          color: Colors.lightGreen,
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
