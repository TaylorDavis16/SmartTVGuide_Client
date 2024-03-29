import 'package:flutter/material.dart';
import 'package:smart_tv_guide/http/core/my_state.dart';

import '../util/app_util.dart';
import '../util/view_util.dart';

final Map<IconData, Map> tabs = {
  Icons.tv: {'type': 'Channels', 'title': 'Channels Collection Folder'},
  Icons.star: {'type': 'Programs', 'title': 'Programs Collection Folder'}
};

abstract class CollectionTabPage extends StatefulWidget {
  final IconData data;
  final BuildContext context;

  const CollectionTabPage(this.data, this.context, {Key? key})
      : super(key: key);

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
          showSliverAppBar(tabs[widget.data]?['title']!),
          SliverList(
            delegate: SliverChildListDelegate(_cardList()),
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
      backgroundColor: Colors.lightBlueAccent,
      floating: true,
      pinned: true,
      snap: false,
      title: Text(screenTitle),
      bottom: TabBar(
        tabs: tabs.entries
            .map((item) => Tab(icon: Icon(item.key), text: item.value['type']))
            .toList(),
      ),
    );
  }

  List<Widget> _cardList() {
    List<String> list = List.from(items.keys);
    sortNames(list);
    return list.map((key) => card(key)).toList();
  }

  Widget card(String name) => GestureDetector(
        onTap: () => openPage(name),
        child: Card(
          color: name == 'Default'
              ? Colors.orange.shade50
              : Colors.orange.shade100,
          margin: const EdgeInsets.all(10),
          elevation: 3,
          child: ListTile(
              title: Text(name),
              trailing: name == 'Default'
                  ? Text('${items[name].length}')
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${items[name].length}'),
                        // Edit button
                        IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showForm(name)),
                        // Delete button
                        IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => showDeleteConfirm(name)),
                      ],
                    )),
        ),
      );

  void _showForm(String? oldName) async {
    // itemKey == null -> create new item
    // itemKey != null -> update an existing item
    if (oldName != null) {
      nameController.text = oldName;
    }
    await showModalBottomSheet(
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
                      String newName = nameController.text.trim();
                      if(newName.isNotEmpty){
                        if (oldName == null) {
                          if (items[newName] == null) {
                            createItem(nameController.text.trim());
                          } else {
                            showWarnToast(
                                'Collection $newName is already exist!');
                          }
                        } else {
                          if (items[newName] == null) {
                            updateItem(oldName, nameController.text.trim());
                          } else {
                            showWarnToast('The new name is exited!');
                          }
                        }
                      }else {
                        showWarnToast('The name is empty!');
                      }
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: Text(oldName == null ? 'Create New' : 'Update'),
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
            ));
    nameController.clear();
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

  Future showDeleteConfirm(String name) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text(
                  'Are you sure want to delete this folder? All the contents in it will be gone'),
              actions: [
                TextButton(
                    onPressed: () {
                      deleteItem(name);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Yes')),
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('No'))
              ],
            ));
  }

  @override
  bool get wantKeepAlive => true;

  void openPage(String name);

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
