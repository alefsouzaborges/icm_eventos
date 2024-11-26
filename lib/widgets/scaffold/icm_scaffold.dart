import 'package:flutter/material.dart';
import 'package:icm_eventos/utils/icm_colors.dart';

class IcmScaffold extends StatefulWidget {
  final AppBar? appBar;
  final Widget body;
  final Widget? bottomMenu;
  final FloatingActionButton? floatingActionButton;
  const IcmScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomMenu,
    this.floatingActionButton,
  });

  @override
  State<IcmScaffold> createState() => _IcmScaffoldState();
}

class _IcmScaffoldState extends State<IcmScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.floatingActionButton,
      backgroundColor: ICMColors.COR_PRINCIPAL,
      appBar: widget.appBar,
      body: widget.body,
      bottomSheet: Container(
        color: ICMColors.COR_PRINCIPAL,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: widget.bottomMenu,
        ),
      ),
    );
  }
}
