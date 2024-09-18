import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class showSnackBar extends StatefulWidget {
  final String text;
  const showSnackBar({super.key, required this.text});

  @override
  State<showSnackBar> createState() => _showSnackBarState();
}

class _showSnackBarState extends State<showSnackBar> {
  @override
  Widget build(BuildContext context) {
    return SnackBar(content: Text(widget.text));
  }
}

class CustomProgressIndicator {
  static final CustomProgressIndicator _singleton =
      CustomProgressIndicator._internal();
  late BuildContext _context;
  bool isDisplayed = false;

  factory CustomProgressIndicator() {
    return _singleton;
  }

  bool getDisplayStatus() {
    return isDisplayed;
  }

  CustomProgressIndicator._internal();

  show(BuildContext context) {
    if (isDisplayed) {
      return;
    }
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          _context = context;
          isDisplayed = true;
          return WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, top: 16, right: 16),
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
          );
        });
  }

  dismiss() {
    if (isDisplayed) {
      Navigator.of(_context).pop();
      isDisplayed = false;
    }
  }
}
//import 'package:flutter/material.dart';

class RightSlideDrawer extends StatelessWidget {
  final Widget drawerContent;
  final double drawerWidth;
  final bool isOpen;
  final VoidCallback onClose;

  const RightSlideDrawer({
    required this.drawerContent,
    this.drawerWidth = 300.0,
    this.isOpen = false,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      transform: Matrix4.translationValues(
        isOpen
            ? MediaQuery.of(context).size.width - drawerWidth
            : MediaQuery.of(context).size.width,
        0.0,
        0.0,
      ),
      child: SizedBox(
        width: drawerWidth,
        child: Drawer(
          child: drawerContent,
        ),
      ),
    );
  }
}
