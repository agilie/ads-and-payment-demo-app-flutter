import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  MediaQueryData mQuery;

  Size screenSize() {
    return mQuery.size;
  }

  Orientation orientation() {
    return mQuery.orientation;
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    mQuery = MediaQuery.of(context);
  }

  @override
  void dispose() {
    mQuery = null;
    super.dispose();
  }

}
