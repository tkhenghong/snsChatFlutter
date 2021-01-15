import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/state/bloc/index.dart';

// Resource: https://medium.com/flutterpub/implementing-search-in-flutter-17dc5aa72018
// TODO: Require Bloc to implement search on the list.
class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    if (query.length < 3) {
      return showRejectSearchTermPage();
    }

    //Add the search term to the searchBloc.
    //The Bloc will then handle the searching and add the results to the searchResults stream.
    //This is the equivalent of submitting the search term to whatever search service you are using
    BlocProvider.of<PhoneStorageContactBloc>(context).add(SearchPhoneStorageContactEvent(searchTerm: query, callback: (bool done) {}));

    return Column(
      children: <Widget>[
        //Build the results based on the searchResults stream in the searchBloc

        BlocBuilder<PhoneStorageContactBloc, PhoneStorageContactState>(
          builder: (context, phoneStorageContactState) {
            if (phoneStorageContactState is PhoneStorageContactsLoaded) {
              if (phoneStorageContactState.searchResults.isEmpty) {
                return Column(
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Invalid Search term.",
                      ),
                    )
                  ],
                );
              } else {
                return Column(
                  children: <Widget>[
                    Container(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: phoneStorageContactState.searchResults.length,
                        itemBuilder: (context, index) {
                          var result = phoneStorageContactState.searchResults[index];
                          return ListTile(
                            title: Text(result.displayName),
                            onTap: () {},
                          );
                        },
                      ),
                      height: Get.height * 0.8,
                    ),
                  ],
                );
              }
            }

            return showLoading();
          },
        )

//        StreamBuilder(
//          stream: InheritedBlocs.of(context).searchBloc.searchResults,
//          builder: (context, AsyncSnapshot<List<Result>> snapshot) {
//            if (!snapshot.hasData) {
//              return Column(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Center(child: CircularProgressIndicator()),
//                ],
//              );
//            } else if (snapshot.data.length == 0) {
//              return Column(
//                children: <Widget>[
//                  Text(
//                    "No Results Found.",
//                  ),
//                ],
//              );
//            } else {
//              var results = snapshot.data;
//              return ListView.builder(
//                itemCount: results.length,
//                itemBuilder: (context, index) {
//                  var result = results[index];
//                  return ListTile(
//                    title: Text(result.title),
//                  );
//                },
//              );
//            }
//          },
//        ),
      ],
    );
  }

  Widget showLoading() {
    return Column(
      children: <Widget>[
        Text(
          "No Results Found.",
        ),
      ],
    );
  }

  Widget showRejectSearchTermPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text(
            "Invalid Search term.",
          ),
        )
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }

//  @override
//  List<Widget> buildActions(BuildContext context) {
//    // TODO: implement buildActions
//    return null;
//  }
//
//  @override
//  Widget buildLeading(BuildContext context) {
//    // TODO: implement buildLeading
//    return null;
//  }
//
//  @override
//  Widget buildResults(BuildContext context) {
//    // TODO: implement buildResults
//    return null;
//  }
//
//  @override
//  Widget buildSuggestions(BuildContext context) {
//    // TODO: implement buildSuggestions
//    return null;
//  }
}
