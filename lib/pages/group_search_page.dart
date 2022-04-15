import 'package:flutter/material.dart';
import 'package:smart_tv_guide/dao/group_dao.dart';
import 'package:smart_tv_guide/dao/user_dao.dart';
import 'package:smart_tv_guide/util/view_util.dart';

import '../http/core/route_jump_listener.dart';
import '../navigator/my_navigator.dart';

class GroupSearchPage extends StatefulWidget {
  const GroupSearchPage({Key? key}) : super(key: key);

  @override
  _GroupSearchPageState createState() => _GroupSearchPageState();
}

class _GroupSearchPageState extends State<GroupSearchPage> {
  final TextEditingController controller = TextEditingController();
  List groups = [];

  @override
  Widget build(BuildContext context) {
    int id = UserDao.hasLogin() ? UserDao.getUser().id! : -1;
    return FutureBuilder(
        future: search(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var widget = snapshot.connectionState == ConnectionState.done
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Card(
                          color: groups[index]['owner'] == id
                              ? Colors.lightBlueAccent
                              : Colors.orange.shade100,
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            leading: Text(
                              groups[index]['name'].substring(0, 1),
                              style: const TextStyle(fontSize: 24),
                            ),
                            title: Text(
                                '${groups[index]['name']}    Size:  ${groups[index]['size']}'),
                            subtitle: Text(
                                'Owner: ${groups[index]['username']}. Created at ${DateTime.fromMillisecondsSinceEpoch(groups[index]['date'])}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => showAddConfirm(groups[index]),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: groups.length, // 1000 list items
                  ),
                )
              : SliverList(
                  delegate: SliverChildListDelegate([
                  const Center(
                    child: Text(
                      'Loading......Please Wait',
                      style: TextStyle(fontSize: 30),
                    ),
                  )
                ]));
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: false,
                  centerTitle: false,
                  title: const Text('Group'),
                  actions: [
                    IconButton(
                      onPressed: () => UserDao.ensureLogin(() =>
                          MyNavigator().onJumpTo(RouteStatus.groupDetail)),
                      icon: const Icon(Icons.supervised_user_circle_sharp),
                    ),
                  ],
                  bottom: AppBar(
                    automaticallyImplyLeading: false,
                    title: Container(
                      height: 40,
                      color: Colors.white,
                      child: Center(
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                              hintText: 'Search for group',
                              prefixIcon: const Icon(Icons.keyboard),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => controller.clear(),
                              )),
                        ),
                      ),
                    ),
                    actions: [
                      // Navigate to the Search Screen
                      IconButton(
                          onPressed: () => setState(() {}),
                          icon: const Icon(Icons.search))
                    ],
                  ),
                ),
                // Other Sliver Widgets
                widget
              ],
            ),
          );
        });
  }

  Future<void> search() async{
    String text = controller.text.trim();
    if (text.isNotEmpty) {
      controller.clear();
      var result = await GroupDao.search(text);
      if (result['code'] == 1) {
        groups = result['result'];
        setState(() {});
      }
    }
  }

  void add(dynamic info) {
    UserDao.ensureLogin(() {
      int id = UserDao.getUser().id!;
      if (!UserDao.getGroupData()
          .any((group) => group.owner == id && group.gid == info['gid'])) {
        GroupDao.join(
            info['gid'], info['owner'], info['username'], info['name']);
      } else {
        showWarnToast('This is your own group!');
      }
    });
  }

  Future showAddConfirm(dynamic info) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                  'Are you sure you want to join in ${info['name']} created by ${info['username']}?'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      add(info);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Yes')),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('No'))
              ],
            ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
