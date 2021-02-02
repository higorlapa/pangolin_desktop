/*
Copyright 2019 The dahliaOS Authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import 'dart:ui';

import 'package:Pangolin/applications/calculator/calculator.dart';
import 'package:Pangolin/applications/editor/editor.dart';
import 'package:Pangolin/applications/files/main.dart';
import 'package:Pangolin/applications/monitor/monitor.dart';
import 'package:Pangolin/applications/terminal/main.dart';
import 'package:Pangolin/desktop/launcher/taskbar_item.dart';
import 'package:Pangolin/desktop/settings/settings.dart';
import 'package:Pangolin/utils/applicationdata.dart';
import 'package:Pangolin/utils/hiveManager.dart';
import 'package:Pangolin/utils/widgets/app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia_wm/wm.dart';

class Taskbar extends StatefulWidget {
  final Widget leading;
  final Widget trailing;
  final TaskbarAlignment alignment;
  final Color backgroundColor;
  final Color itemColor;

  Taskbar({
    this.leading,
    this.alignment = TaskbarAlignment.LEFT,
    this.trailing,
    this.backgroundColor = Colors.black,
    this.itemColor = Colors.white,
  });

  @override
  _TaskbarState createState() => _TaskbarState();
}

class _TaskbarState extends State<Taskbar> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final appIcons = Align(
        alignment: taskbarAlignment,
        child: SingleChildScrollView(
            reverse: widget.alignment == TaskbarAlignment.RIGHT,
            scrollDirection: Axis.horizontal,
            child: Row(
                children: <Widget>[
              PinnedTaskBarItem(
                applicationData: ApplicationData(
                    appName: 'Calculator',
                    icon: "calculator",
                    app: Calculator(),
                    packageName: 'io.dahlia.calculator'),
              ),
              PinnedTaskBarItem(
                applicationData: ApplicationData(
                    appName: 'Notes',
                    icon: "notes",
                    app: TextEditorApp(),
                    packageName: 'io.dahlia.notes'),
              ),
              PinnedTaskBarItem(
                applicationData: ApplicationData(
                    appName: 'Terminal',
                    icon: "terminal",
                    app: TerminalApp(),
                    packageName: 'io.dahlia.terminal'),
              ),
              PinnedTaskBarItem(
                applicationData: ApplicationData(
                    appName: 'Files',
                    icon: "files",
                    app: Files(),
                    packageName: 'io.dahlia.files'),
              ),
              PinnedTaskBarItem(
                applicationData: ApplicationData(
                    appName: 'Task Manager',
                    icon: "task",
                    app: Tasks(),
                    packageName: 'io.dahlia.taskmanager'),
              ),
              PinnedTaskBarItem(
                applicationData: ApplicationData(
                    appName: 'Settings',
                    icon: "settings",
                    app: Settings(),
                    packageName: 'io.dahlia.settings'),
              ),
            ]
                  ..add(VerticalDivider())
                  ..addAll(Provider.of<WindowHierarchyState>(context)
                      .windows
                      .map<Widget>(
                        (e) => TaskbarItem(
                          entry: e,
                          color: widget.itemColor,
                        ),
                      )
                      .toList()
                      .joinType(
                        SizedBox(
                          width: 2,
                        ),
                      )))));

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 48,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 24,
            sigmaY: 24,
          ),
          child: Material(
            color: widget.backgroundColor,
            child: Stack(
              children: [
                Row(
                  children: [
                    widget.leading ?? Container(),
                    Expanded(
                      child: widget.alignment != TaskbarAlignment.CENTER
                          ? appIcons
                          : Container(),
                    ),
                    widget.trailing ?? Container(),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 48,
                  child: widget.alignment == TaskbarAlignment.CENTER
                      ? appIcons
                      : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Alignment get taskbarAlignment {
    switch (widget.alignment) {
      case TaskbarAlignment.CENTER:
        return Alignment.center;
      case TaskbarAlignment.RIGHT:
        return Alignment.centerRight;
      case TaskbarAlignment.LEFT:
      default:
        return Alignment.centerLeft;
    }
  }
}

enum TaskbarAlignment {
  LEFT,
  CENTER,
  RIGHT,
}

extension JoinList<T> on List<T> {
  List<T> joinType(T separator) {
    List<T> workList = [];

    for (int i = 0; i < (length * 2) - 1; i++) {
      if (i % 2 == 0) {
        workList.add(this[i ~/ 2]);
      } else {
        workList.add(separator);
      }
    }

    return workList;
  }
}
