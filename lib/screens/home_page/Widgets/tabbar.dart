import 'package:flutter/material.dart';

class CategoryPicker extends StatefulWidget {
  List<String> tabItems = ['WatchList', 'Coin', 'NFT'];
  Function? whenTabChanges;
  CategoryPicker({
    this.whenTabChanges,
  });
  @override
  _CategoryPickerState createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  late List<String> tabItems;
  int currentTab = 0;

  @override
  void initState() {
    // TODO: implement initState
    controller = TabController(length: widget.tabItems.length, vsync: this);
    controller.addListener(handleTabChanges);
    super.initState();
  }

  void handleTabChanges() {
    if (controller.indexIsChanging) return;
    //widget.whenTabChanges!(controller.index);
    setState(() {
      currentTab = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorSize: TabBarIndicatorSize.values[0],
      tabs: widget.tabItems
          .map((stringFromTab) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  stringFromTab,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: widget.tabItems[currentTab] == stringFromTab
                        ? Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black
                        : Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey
                            : Colors.black,
                  ),
                ),
              ))
          .toList(),
      indicatorColor: Theme.of(context).textTheme.bodyText2!.color,
      //labelColor: Colors.green,
      isScrollable: true,
      //unselectedLabelColor: Colors.transparent,
      controller: controller,
    );
  }
}
