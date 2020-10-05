import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';


class SearchScreenStreamBuilder extends StatefulWidget {
  SearchScreenStreamBuilder({Key key, this.stream, this.controller}) : super(key: key);
  Stream stream;
  TextEditingController controller;
  bool descTextShowFlag = false;

  @override
  _SearchScreenStreamBuilderState createState() => _SearchScreenStreamBuilderState();
}

class _SearchScreenStreamBuilderState extends State<SearchScreenStreamBuilder> {

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.stream,
      builder: (ctx, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: Text(
              'Type a word to get its meaning 🤔',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          );
        }
        if (snapshot.data == 'waiting') {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data == 'NoData') {
          return Center(
            child: Text(
              'No Defination 😭',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          );
        }
        return ListView.builder(
            itemCount: snapshot.data['definitions'].length,
            itemBuilder: (ctx, i) => ListBody(
              children: [
                Card(
                  color: Colors.grey[500],
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin:
                  EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ExpansionTile(
                      onExpansionChanged: (bool expanding) =>
                          setState(() => this.isExpanded = expanding),
                      // backgroundColor: Colors.grey,
                      leading: snapshot.data['definitions'][i]
                      ['image_url'] ==
                          null
                          ? CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Icon(Icons.chevron_right),
                        maxRadius: 25,
                      )
                          : CircleAvatar(
                        maxRadius: 25,
                        backgroundImage: NetworkImage(snapshot
                            .data['definitions'][i]['image_url']),
                      ),
                      title: Text(
                        widget.controller.text.trim() +
                            "  (" +
                            snapshot.data['definitions'][i]['type'] +
                            ")",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: isExpanded
                              ? FontWeight.w400
                              : FontWeight.w300,
                          color:
                          isExpanded ? Colors.white : Colors.black,
                        ),
                      ),
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Defination:',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () => {
                                  setState(() => widget.descTextShowFlag =
                                  !widget.descTextShowFlag)
                                },
                                child: snapshot
                                    .data['definitions'][i]
                                ['definition']
                                    .isNotEmpty
                                    ? AnimatedCrossFade(
                                  duration:
                                  Duration(milliseconds: 400),
                                  crossFadeState: widget.descTextShowFlag
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                                  firstChild: Text(
                                      snapshot.data['definitions']
                                      [i]['definition']
                                          .trimLeft(),
                                      // textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          height: 1.5,
                                          fontSize: 17,
                                          color: Colors.grey[900],
                                          fontWeight:
                                          FontWeight.bold)),
                                  secondChild: Text(
                                      snapshot.data['definitions']
                                      [i]['definition'],
                                      maxLines: 7,
                                      overflow:
                                      TextOverflow.ellipsis,
                                      style: TextStyle(
                                          height: 1.5,
                                          fontSize: 16,
                                          color:
                                          Colors.grey[1000],
                                          fontWeight:
                                          FontWeight.w400)),
                                )
                                    : Container(),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0),
                                child: Divider(
                                    endIndent: 100,
                                    color: Colors.white),
                              ),
                              snapshot.data['definitions'][i]['example']
                                  .toString() !=
                                  'null'
                                  ? Text(
                                'Example:',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                                  : SizedBox(),
                              snapshot.data['definitions'][i]['example']
                                  .toString() !=
                                  'null'
                                  ? Text(
                                  snapshot.data['definitions'][i]
                                  ['example']
                                      .toString(),
                                  maxLines: 7,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      height: 1.5,
                                      fontSize: 16,
                                      color: Colors.grey[1000],
                                      fontWeight: FontWeight.w400))
                                  : Container(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }
}
