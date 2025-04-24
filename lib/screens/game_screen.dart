import 'package:flutter/material.dart';

//tree class
class Tree {
  int stage; //stage of the tree: 0 = no tree, 1 = seedling, 2 = sapling, 3 = mature tree
  String? matureImage; //field to store the image for the mature tree
  bool isLocked; //field to lock the tree after it becomes mature
  Tree({required this.stage, this.matureImage, this.isLocked = false});
}
class GameScreen extends StatefulWidget {
  final int coins;
  final Function(int) onCoinsUpdated;

  const GameScreen({
    super.key,
    required this.coins,
    required this.onCoinsUpdated,
  });

  @override
  GameScreenState createState() => GameScreenState();
}
class GameScreenState extends State<GameScreen> {
  //15x15 grid to represent the plot of land
  List<List<Tree>> grid = List.generate(15, (i) => List.generate(15,
                                        (j) => Tree(stage: 0) // 0 = no tree, 1 = seedling, 2 = sapling, 3 = mature tree
    )
  );

  //game ui builder
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Garden'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text('Coins: ${widget.coins}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
            )
          )
        ]
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          //plot of land
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.green.shade100, //light green background
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.green.shade300,width: 2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Plot of Land',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)
                ),
                const SizedBox(height: 10),
                //15x15 Grid of trees
                GridView.builder(
                  shrinkWrap: true,
                  //creating a grid with a fixes amount of tiles
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 15, // 15 columns
                    crossAxisSpacing: 4.0, mainAxisSpacing: 4.0,
                  ),
                  itemCount: 15 * 15, // Total number of cells in the grid
                  itemBuilder: (context, index) {
                    int row = index ~/ 15;
                    int col = index % 15;
                    Tree tree = grid[row][col];

                    return GestureDetector(
                      onTap: () {plantTree(row, col);},
                      child: Container(
                        color: getTreeColor(tree.stage),
                        child: tree.stage == 0 ? null : Center(
                          child: tree.stage > 0 ? Image.asset(
                            getTreeImage(row, col), // Pass row and col
                            width: 30, // Size of the tree image
                            height: 30,
                          )
                              : null, // Empty cell
                        )
                      )
                    );
                  }
                )
              ]
            )
          )
        ]
      )
    );
  }

  //plant tree function
  void plantTree(int row, int col) {
    //check if the tree is already matured
    if (grid[row][col].isLocked) {
      return; //do nothing if the tree is locked
    }

    //check if the user has enough coins to plant a tree
    if (widget.coins >= 10) {
      setState(() {
        widget.onCoinsUpdated(widget.coins - 10); //-10 coins for planting a tree
        //plant tree and go to next stage
        if (grid[row][col].stage < 2) {
          grid[row][col].stage++; //stage 1: Seedling -> stage 2: Sapling
        } else if (grid[row][col].stage == 2) {
          //if the tree is in the sapling stage then show the mature trees
          showMatureTreeOptions(row, col);
        }
      });
    } else {
      showNotEnoughCoinsDialog(context); //show message if the user doesn't have enough coins
    }
  }


  //get color based on tree growth stage
  Color getTreeColor(int stage) {
    switch (stage) {
      case 0: return Colors.white; // No tree
      case 1: return Colors.green.shade200; // Seedling
      case 2: return Colors.green.shade400; // Sapling
      case 3: return Colors.green.shade600; // Mature tree
      default: return Colors.white; // No tree
    }
  }

  // Get image path based on tree growth stage
  String getTreeImage(int row, int col) {
    switch (grid[row][col].stage) {
      case 1: return 'assets/tree.png'; // Seedling image
      case 2: return 'assets/tree1.png'; // Sapling image
      case 3: return grid[row][col].matureImage ?? 'assets/tree2.png'; // Default mature image if not set
      default: return ''; // No tree
    }
  }

  void showMatureTreeOptions(int row, int col) {
    // Define the prices for the mature trees
    List<Map<String, dynamic>> matureTrees = [
      {'image': 'assets/tree2.png', 'price': 30}, {'image': 'assets/tree3.png', 'price': 40},
      {'image': 'assets/tree4.png', 'price': 50}, {'image': 'assets/tree5.png', 'price': 60},
      {'image': 'assets/tree6.png', 'price': 70}, {'image': 'assets/tree7.png', 'price': 80},
      {'image': 'assets/tree8.png', 'price': 90}, {'image': 'assets/tree9.png', 'price': 100},
      {'image': 'assets/tree10.png', 'price': 110}, {'image': 'assets/tree11.png', 'price': 120},
      {'image': 'assets/tree12.png', 'price': 130}, {'image': 'assets/tree13.png', 'price': 140},
      {'image': 'assets/tree14.png', 'price': 150}, {'image': 'assets/tree15.png', 'price': 160},
      {'image': 'assets/tree16.png', 'price': 170}
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose a Mature Tree'),
          content: SizedBox(
            height: 200,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 80, //height of each item in the scroll wheel
              physics: FixedExtentScrollPhysics(), // Scrolling behavior
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  final treeOption = matureTrees[index];
                  return GestureDetector(
                    onTap: () {
                      upgradeToMatureTree(row, col, treeOption['image'], treeOption['price']);
                      Navigator.of(context).pop();
                    },
                    child: ListTile(
                      leading: Image.asset(treeOption['image'], width: 50, height: 50),
                      title: Text('Price: ${treeOption['price']} coins'),
                    ),
                  );
                },
                childCount: matureTrees.length,
              ),
            ),
          ),
        );
      },
    );
  }

  //upgrade the tree to a mature tree and deduct coins
  void upgradeToMatureTree(int row, int col, String image, int price) {
    if (widget.coins >= price && !grid[row][col].isLocked) {
      setState(() {
        widget.onCoinsUpdated(widget.coins - price); //deduct coins for mature tree upgrade
        grid[row][col].stage = 3; //set the tree to mature stage
        grid[row][col].matureImage = image; //set the selected mature tree image
        grid[row][col].isLocked = true; //lock the tree after upgrade
      });
    } else if (grid[row][col].isLocked) {
      showAlreadyMaturedDialog(context); //show message if the tree is already mature
    } else {
      showNotEnoughCoinsDialog(context); //show message if the user doesnt have enough coins
    }
  }
  //already matured dialog
  void showAlreadyMaturedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tree Already Matured'),
          content: const Text('This tree has already been upgraded to a mature tree and cannot be upgraded further.'),
          actions: <Widget>[TextButton(onPressed: () {Navigator.of(context).pop();}, child: const Text('OK'))]
        );
      }
    );
  }


  //show a dialog when the user doesnt have enough coins
  void showNotEnoughCoinsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Not Enough Coins'),
          content: const Text('You do not have enough coins to plant a tree or upgrade to a mature tree.'),
          actions: <Widget>[TextButton(onPressed: () {Navigator.of(context).pop();}, child: const Text('OK'))]
        );
      }
    );
  }
}


