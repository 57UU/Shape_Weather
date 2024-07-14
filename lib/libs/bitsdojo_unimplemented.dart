import 'package:flutter/material.dart';

void doWhenWindowReady(dynamic p){
  throw UnimplementedError();
}

Widget WindowTitleBarBox({dynamic child}){
  throw UnimplementedError();
}

Widget MoveWindow(){
  throw UnimplementedError();
}
abstract class DesktopWindow {
  DesktopWindow();
  int? get handle;
  double get scaleFactor;

  Rect get rect;
  set rect(Rect newRect);

  Offset get position;
  set position(Offset newPosition);

  Size get size;
  set size(Size newSize);

  set minSize(Size? newSize);
  set maxSize(Size? newSize);

  Alignment? get alignment;
  set alignment(Alignment? newAlignment);

  set title(String newTitle);

  @Deprecated("use isVisible instead")
  bool get visible;
  bool get isVisible;
  @Deprecated("use show()/hide() instead")
  set visible(bool isVisible);
  void show();
  void hide();
  void close();
  void minimize();
  void maximize();
  void maximizeOrRestore();
  void restore();

  void startDragging();

  Size get titleBarButtonSize;
  double get titleBarHeight;
  double get borderSize;
  bool get isMaximized;
}

DesktopWindow get appWindow {
  throw UnimplementedError('appWindow has not been implemented.');
}
Widget MinimizeWindowButton({dynamic colors}){
  throw UnimplementedError();
}
Widget MaximizeWindowButton({dynamic colors}){
  throw UnimplementedError();
}
Widget CloseWindowButton({dynamic colors}){
  throw UnimplementedError();
}

class WindowButtonColors {
  late Color normal;
  late Color mouseOver;
  late Color mouseDown;
  late Color iconNormal;
  late Color iconMouseOver;
  late Color iconMouseDown;
  WindowButtonColors(
      {Color? normal,
        Color? mouseOver,
        Color? mouseDown,
        Color? iconNormal,
        Color? iconMouseOver,
        Color? iconMouseDown}) ;
}
