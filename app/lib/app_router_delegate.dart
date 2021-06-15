import 'package:flutter/material.dart';
import 'package:fluttermin/app_route_path.dart';
import 'package:fluttermin/models/app_model.dart';
import 'package:fluttermin/pages/about_page.dart';
import 'package:fluttermin/pages/app_users_page.dart';
import 'package:fluttermin/pages/login_page.dart';
import 'package:provider/provider.dart';

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    AppModel model = Provider.of<AppModel>(context, listen: false);
    return Navigator(
      key: navigatorKey,
      pages: model.isAuthorized
          ? [
              MaterialPage(child: AboutPage()),
              MaterialPage(child: AppUsersPage()),
            ]
          : [
              MaterialPage(child: LoginPage()),
//        MaterialPage(
//          key: ValueKey('BooksListPage'),
//          child: BooksListScreen(
//            books: books,
//            onTapped: _handleBookTapped,
//          ),
//        ),
//        if (show404)
//          MaterialPage(key: ValueKey('UnknownPage'), child: UnknownScreen())
//        else if (_selectedBook != null)
//          BookDetailsPage(book: _selectedBook)
            ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // Update the list of pages by setting _selectedBook to null
        //_selectedBook = null;
        //show404 = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath path) async {
//    if (path.isUnknown) {
//      _selectedBook = null;
//      show404 = true;
//      return;
//    }
//
//    if (path.isDetailsPage) {
//      if (path.id < 0 || path.id > books.length - 1) {
//        show404 = true;
//        return;
//      }
//
//      _selectedBook = books[path.id];
//    } else {
//      _selectedBook = null;
//    }
//
//    show404 = false;
  }

//  void _handleBookTapped(Book book) {
//    _selectedBook = book;
//    notifyListeners();
//  }
}
