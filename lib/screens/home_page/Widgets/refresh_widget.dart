import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class RefreshWidget extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  RefreshWidget({Key? key, required this.onRefresh, required this.child})
      : super(key: key);

  @override
  State<RefreshWidget> createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  @override
  Widget build(BuildContext context) => Platform.isAndroid?buildAndroidList(): buildIOSList(); //;
  Widget buildAndroidList() =>
      RefreshIndicator(child: widget.child, onRefresh: widget.onRefresh);

  Widget buildIOSList() => CustomScrollView(physics: BouncingScrollPhysics(),slivers: [
    CupertinoSliverRefreshControl(onRefresh: widget.onRefresh,),
    SliverToBoxAdapter(child: widget.child,)
  ],);
}
