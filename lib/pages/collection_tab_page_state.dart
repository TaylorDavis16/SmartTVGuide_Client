import 'package:flutter/material.dart';
import 'package:smart_tv_guide/http/core/my_state.dart';

import '../util/color.dart';
import '../util/view_util.dart';

final Map<IconData, String> tabs = {
  Icons.tv: 'Channels',
  Icons.star: 'Programs'
};

abstract class CollectionTabPage extends StatefulWidget{
  final IconData data;
  final BuildContext context;
  const CollectionTabPage(this.data, this.context, {Key? key}) : super(key: key);

  @override
  CollectionTabPageBaseState createState();
}

abstract class CollectionTabPageBaseState<T extends CollectionTabPage>
    extends MyState<T> with AutomaticKeepAliveClientMixin {

  final TextEditingController nameController = TextEditingController();
  late Map items;

  @override
  void initState() {
    super.initState();
    initItems();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          showSliverAppBar(tabs[widget.data]!),
          SliverList(
            delegate: SliverChildListDelegate(
                items.keys.map((key) => card(key)).toList()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  SliverAppBar showSliverAppBar(String screenTitle) {
    return SliverAppBar(
      backgroundColor: primary,
      floating: true,
      pinned: true,
      snap: false,
      title: Text(screenTitle),
      bottom: TabBar(
        tabs: tabs.entries
            .map((item) => Tab(icon: Icon(item.key), text: item.value))
            .toList(),
      ),
    );
  }

  Widget card(String name) => GestureDetector(
    onTap: () => openPage(name),
    child: Card(
      color: Colors.orange.shade100,
      margin: const EdgeInsets.all(10),
      elevation: 3,
      child: ListTile(
          title: Text(name),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit button
              IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showForm(name)),
              // Delete button
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deleteItem(name),
              ),
            ],
          )),
    ),
  );

  void _showForm(String? itemKey) async {
    // itemKey == null -> create new item
    // itemKey != null -> update an existing item
    if (itemKey != null) {
      nameController.text = itemKey;
    }
    showModalBottomSheet(
        context: widget.context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(widget.context).viewInsets.bottom,
                  top: 15,
                  left: 15,
                  right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String name = nameController.text.trim();
                      // Save new item
                      if (itemKey == null) {
                        if (items[name] == null) {
                          createItem(nameController.text.trim());
                        } else {
                          showWarnToast('Collection $name is already exist!');
                        }
                      } else {
                        if (itemKey != name) {
                          updateItem(itemKey, nameController.text.trim());
                        } else {
                          showWarnToast('The name has to be different!');
                        }
                      }
                      // update an existing item
                      // Clear the text fields
                      nameController.text = '';
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: Text(itemKey == null ? 'Create New' : 'Update'),
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
            ));
  }

  void initItems();

  void refreshItems() {
    setState(() {});
  }

  // Create new item
  Future<void> createItem(String name) async {
    items[name] = [];
    refreshItems();
  }

  // Update a single item
  Future<void> updateItem(String oldName, String newName) async {
    items[newName] = items.remove(oldName)!;
    refreshItems();
  }

  // Delete a single item
  Future<void> deleteItem(String name) async {
    items.remove(name);
    refreshItems();
  }

  @override
  bool get wantKeepAlive => true;

  void openPage(String name);
}
