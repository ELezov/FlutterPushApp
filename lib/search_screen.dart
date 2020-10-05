import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'configs.dart';

import 'search_screen_builder.dart';


class SearchScreen extends StatefulWidget {
  SearchScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  StreamController _streamController;
  Stream _stream;
  
  TextEditingController _controller = TextEditingController();
  Timer search;

  _search() async {
    if (_controller.text == null || _controller.text.length == 0) {
      _streamController.add(null);
      return;
    } else {
      _streamController.add('waiting');
      final data = await http.get(url + _controller.text.trim(),
          headers: {'Authorization': 'Token ' + token});
      print(data.body);
      if (data.body.contains('[{"message":"No definition :("}]')) {
        _streamController.add('NoData');
        return;
      } else {
        _streamController.add(json.decode(data.body));
        return;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _streamController = StreamController();
    _stream = _streamController.stream;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[800],
        appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Text(
                widget.title,
                style: TextStyle(color: Colors.blueAccent),
            ),
            bottom: PreferredSize(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 12, bottom: 8, right: 12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24)),
                      child: TextFormField(
                        autovalidate: true,
                        autocorrect: true,
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (val) {
                          _search();
                        },
                        onChanged: (val) {
                          if (search?.isActive ?? false) search.cancel();
                              search = Timer(Duration(milliseconds: 1000), () {
                                _search();
                              });
                              },
                        controller: _controller,
                        decoration: InputDecoration(
                            hintText: 'Search for a word',
                            contentPadding: const EdgeInsets.only(left: 24.0),
                            border: InputBorder.none),
                      ),
                    )
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _search();
                      })
                  ],
              ),
              preferredSize: Size.fromHeight(48),
            ),
        ),
      body: SearchScreenStreamBuilder(stream: _stream, controller: _controller),
    );
  }
}
