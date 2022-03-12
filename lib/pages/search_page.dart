import 'package:flutter/material.dart';
import 'package:smart_tv_guide/util/view_util.dart';
import 'package:smart_tv_guide/widget/appbar.dart';
import '../widget/navigation_bar.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String selected = 'United Kingdom';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Search", "", () => print('123'), centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBar(
            height: 50,
            child: _appBar(),
            color: Colors.white,
            statusStyle: StatusStyle.DARK_CONTENT,
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 30),
          ),
          _chip('Beijing                                                                  '),
          _chip('CCTV 4                                                              '),
          _chip('Tianjin                                                            '),
          _chip('Sichuan                                                       '),
          _chip('Ningxia                                               '),
          _chip('Guangdong                              '),
          _chip('Guangxi                               '),
          _chip('Jilin                              '),
          _chip('Gansu                       '),
          _chip('CCTV children       '),
          offstage(false)
        ],
      )
    );
  }

  _appBar() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: const Image(
                height: 46,
                width: 46,
                image: AssetImage('assets/avatar.png'),
              ),
            ),
          ),
          Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    height: 32,
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.search, color: Colors.grey),
                    decoration: BoxDecoration(color: Colors.grey[100]),
                  ),
                ),
              )),
          Icon(
            Icons.explore_outlined,
            color: Colors.grey,
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(
                Icons.mail_outline,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _chip(String label) {
    return Chip(
      padding: EdgeInsets.zero,
      backgroundColor: Colors.lightBlueAccent,
      label: Text(label),
      avatar: CircleAvatar(
        backgroundColor: Colors.blue.shade900,
        child: Text(
          label.substring(0, 1),
          style: TextStyle(fontSize: 10),
        ),
      ),
    );
  }
}
