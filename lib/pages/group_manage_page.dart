import 'package:flutter/material.dart';
import 'package:smart_tv_guide/dao/group_dao.dart';
import 'package:smart_tv_guide/dao/user_dao.dart';
import 'package:smart_tv_guide/model/group.dart';
import 'package:smart_tv_guide/widget/loading_container.dart';

import '../http/core/route_jump_listener.dart';
import '../navigator/my_navigator.dart';
import '../util/view_util.dart';
import '../widget/my_expansion_tile.dart';

class GroupManagePage extends StatefulWidget {
  const GroupManagePage({Key? key}) : super(key: key);

  @override
  State<GroupManagePage> createState() => _GroupManagePageState();
}

class _GroupManagePageState extends State<GroupManagePage> {
  List<dynamic> allGroups = [];
  late List<dynamic> myGroups;
  late List<dynamic> otherGroups;
  final TextEditingController nameController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void retrieveData() {
    allGroups = UserDao.getGroupData().values.toList();
    int id = UserDao.getUser().id!;
    myGroups = allGroups.where((group) => group.owner == id).toList();
    otherGroups = allGroups.where((group) => group.owner != id).toList();
  }

  Future<void> refresh() async{
    await UserDao.retrieveGroupData();
    retrieveData();
    setState(() {isLoading = false;});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Groups"),
        actions: [
          IconButton(
              onPressed: () => _showForm(null), icon: const Icon(Icons.add))
        ],
      ),
      body: LoadingContainer(
        isLoading: isLoading,
        child: RefreshIndicator(
            onRefresh: refresh,
            child:ListView(
              children: [allGroups.isEmpty
                  ? _emptyText()
                  : Column(
                children: [
                  if (myGroups.isNotEmpty)
                    _expansionTile(
                        myGroups, 'Owner', 'My Groups', myGroupCard),
                  if (otherGroups.isNotEmpty)
                    _expansionTile(otherGroups, 'Other Groups', 'Joined In',
                        otherGroupCard),
                ],
              )],
            ) ),
      ),
    );
  }

  _emptyText() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width,
            child: GestureDetector(
              child: const Center(
                child: Text(
                  'No groups, join one or create one',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
          )
        ],
      );

  _expansionTile(List groups, String title, String subtitle,
          Widget Function(dynamic group) map) =>
      MyExpansionTile(
        origin: groups,
        title: title,
        subtitle: subtitle,
        toElement: (dynamic group) => map(group),
      );

  void _showForm(String? oldName, {dynamic group}) async {
    if (oldName != null) {
      nameController.text = oldName;
    }
    await showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
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
                      if (newName.isNotEmpty) {
                        if (oldName == null) {
                          if (!myGroups.any((group) => group.name == newName)) {
                            await createGroup(newName);
                          } else {
                            showWarnToast('$newName is exist!');
                          }
                        } else {
                          if (oldName != newName) {
                            await updateGroup(group, newName);
                          }
                        }
                      } else {
                        showWarnToast('The Name is empty!');
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

  Widget myGroupCard(dynamic group) => card(group, color: Colors.lightBlueAccent, buttons: [
        IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showForm(group.name, group: group)),
        IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => showConfirm(
                "Are you sure to dismiss this group?", group, deleteGroup)),
      ]);

  Widget otherGroupCard(dynamic group) => card(group, buttons: [
        IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () =>
                showConfirm("Are you sure to leave this group?", group, quit)),
      ]);

  Widget card(dynamic group, {Color? color, required List<Widget> buttons}) =>
      GestureDetector(
        onTap: () => openPage(group),
        child: Card(
          color: color ?? Colors.orange.shade100,
          margin: const EdgeInsets.all(10),
          elevation: 3,
          child: ListTile(
              title: Text(group.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${group.members.length}'),
                  // Edit button
                  ...buttons
                ],
              )),
        ),
      );

  void refreshItems() {
    allGroups.clear();
    allGroups.addAll(myGroups);
    allGroups.addAll(otherGroups);
    Map result = { for (var e in allGroups) e.gid : e };
    UserDao.saveGroups(result);
    setState(() {});
  }

  // Create new item
  Future<void> createGroup(String name) async {
    var result = await GroupDao.create(name);
    if (result['code'] == 1) {
      myGroups.add(Group.fromJson(result['group']));
      refreshItems();
    } else {
      showWarnToast('Create Fail');
    }
  }

  Future<void> updateGroup(dynamic group, String newName) async {
    var result = await GroupDao.update(group.gid, newName);
    if (result['code'] == 1) {
      group.name = newName;
      refreshItems();
    } else {
      showWarnToast('Update Fail');
    }
  }

  // Delete a single item
  Future<void> deleteGroup(group) async {
    var result = await GroupDao.delete(group.gid);
    if (result['code'] == 1) {
      myGroups.remove(group);
      refreshItems();
    } else {
      showWarnToast('Delete Fail');
    }
  }

  Future quit(group) async {
    if (await GroupDao.quit(group.gid)) {
      otherGroups.remove(group);
      refreshItems();
    } else {
      showWarnToast('Quit Fail');
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void openPage(dynamic group) {
    MyNavigator().onJumpTo(RouteStatus.groupDetail, args: {'group' : group});
  }

  Future showConfirm(String message, group, Function(dynamic) action) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      action(group);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Yes')),
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('No'))
              ],
            ));
  }
}
