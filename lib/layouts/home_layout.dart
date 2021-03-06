import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:http/http.dart' as httpPkg;

import '../util/urls.dart';
import '../model/question.dart';

class Home extends StatefulWidget {
  
  static const routeName = '/';
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _globalKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  List<Items> items = []; 

  void initState() {
    _loadMore();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
        
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.refresh),
        backgroundColor: Colors.green,
        onPressed: () {
          _loadMore();
        },
      ),

        
        appBar: AppBar(
          title: Text('Stackoverflow Qustions')
        ),
        body: LazyLoadScrollView( 

                isLoading: isLoading, 
                onEndOfPage: () => _loadMore(), 
                child: 
                (items.length == 0)? Center(child: CircularProgressIndicator()): 
                ListView.builder( 
                  itemCount: items.length,
                  
                  itemBuilder: (context, index) { 
                  
                   return Container(
            
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
                        child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(items[index].owner.profileImage),
                          onBackgroundImageError: (error, stackTrace){},
                          backgroundColor: Colors.black45,
                        ),
                        title: Text(items[index].owner.displayName, maxLines: 1,),
                        subtitle: Text(items[index].title, maxLines: 3,),
                      ),
                   );
                }, 

              ), 
            ),
    );
  }

  Future _loadMore() async { 
    
    setState(() { 
      isLoading = true; 
    }); 

    // fetch more questions
    // Page Size is 20
    // Calculating next page Index

    final page = (items.length / 20).round() + 1;
    if(page > 1){
      final snackBar = SnackBar(content: Text('Fetching more questions'));
            _globalKey.currentState.showSnackBar(snackBar);
    }
    await httpPkg.get(BASE_URL+'$page=1&pagesize=20&order=desc&sort=activity&q=flutter&site=stackoverflow')
          .then((value)  {
            print (value.body);
            final Map parsed = json.decode(value.body);
            final tempItem = parsed['items'].map((ele) => Items.fromJson(ele)).toList();
            items.addAll([...tempItem]);
          })
          .catchError((error){
            final snackBar = SnackBar(content: Text('Something went wrong'));
            _globalKey.currentState.showSnackBar(snackBar);
          });

    setState(() { 
      isLoading = false; 
    }); 
  } 
}