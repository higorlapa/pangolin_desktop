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

import 'package:Pangolin/applications/browser/main.dart';
import 'package:Pangolin/applications/calculator/calculator.dart';
import 'package:Pangolin/applications/clock/main.dart';
import 'package:Pangolin/applications/developer/developer.dart';
import 'package:Pangolin/applications/editor/editor.dart';
import 'package:Pangolin/applications/files/main.dart';
import 'package:Pangolin/applications/graft/main.dart';
import 'package:Pangolin/applications/logging/logging.dart';
import 'package:Pangolin/applications/monitor/monitor.dart';
import 'package:Pangolin/applications/terminal/main.dart';
import 'package:Pangolin/applications/terminal/root/main.dart';
import 'package:Pangolin/applications/welcome/welcome.dart';
import 'package:Pangolin/applications/demo/main.dart';
import 'package:Pangolin/desktop/settings/settings.dart';
import 'package:Pangolin/internal/locales/locale_strings.g.dart';
import 'package:Pangolin/utils/hiveManager.dart';
import 'package:Pangolin/utils/widgets/app_launcher.dart';
import 'package:flutter/material.dart';

class ApplicationData {
  final String appName, icon, packageName;
  final Widget app;
  final bool appExists;
  final Color color;

  const ApplicationData(
      {Key key,
      @required this.packageName,
      @required this.appName,
      //only need the file name of the image, path and file type are already defined
      @required this.icon,
      this.app,
      this.color,
      this.appExists = true});
}

List<ApplicationData> applicationsData =
    List<ApplicationData>.empty(growable: true);
List<AppLauncherButton> applications =
    List<AppLauncherButton>.empty(growable: true);
void initializeApps() {
  //clear ApplicationData
  applicationsData.clear();

  //Add ApplicationData

  //Terminal
  applicationsData.add(ApplicationData(
      packageName: "io.dahlia.terminal",
      appName: LocaleStrings.pangolin.appTerminal,
      icon: "terminal",
      app: TerminalApp(),
      color: Colors.grey[900],
      appExists: true));

  //Tasks
  applicationsData.add(ApplicationData(
      packageName: "io.dahlia.taskmanager",
      appName: LocaleStrings.pangolin.appTaskmanager,
      icon: "task",
      app: Tasks(),
      color: Colors.cyan[900],
      appExists: true));

  //Settings
  applicationsData.add(ApplicationData(
      packageName: "io.dahlia.settings",
      appName: LocaleStrings.pangolin.appSettings,
      icon: "settings",
      app: Settings(),
      color: Colors.deepOrange[700],
      appExists: true));

  //Root Terminal
  applicationsData.add(ApplicationData(
      packageName: "io.dahlia.rootterminal",
      appName: LocaleStrings.pangolin.appRootterminal,
      icon: "root",
      app: RootTerminal(),
      color: Colors.red[700],
      appExists: true));

  //Text Editor
  applicationsData.add(ApplicationData(
      packageName: "io.dahlia.notes",
      appName: LocaleStrings.pangolin.appNotes,
      icon: "notes",
      app: TextEditorApp(),
      color: Colors.amber[700],
      appExists: true));

  //Notes Mobile
  applicationsData.add(ApplicationData(
      packageName: "io.dahlia.notesmobile",
      appName: LocaleStrings.pangolin.appNotesmobile,
      icon: "note_mobile",
      appExists: false));

  //Logs
  applicationsData.add(ApplicationData(
      packageName: "io.dahlia.systemlogs",
      appName: LocaleStrings.pangolin.appSystemlogs,
      icon: "logs",
      app: Logs(),
      color: Colors.red[700],
      appExists: true));

  //Files
  applicationsData.add(ApplicationData(
      packageName: "io.dahlia.files",
      appName: LocaleStrings.pangolin.appFiles,
      icon: "files",
      app: Files(),
      color: Colors.deepOrange[800],
      appExists: true));

  //Disks
  applicationsData.add(ApplicationData(
      packageName: "io.dahlia.disks",
      appName: LocaleStrings.pangolin.appDisks,
      icon: "disks",
      appExists: false));

  //Calculator
  applicationsData.add(ApplicationData(
      packageName: "io.dahlia.calculator",
      appName: LocaleStrings.pangolin.appCalculator,
      icon: "calculator",
      app: Calculator(),
      color: Colors.green,
      appExists: true));

  //Graft
  applicationsData.add(ApplicationData(
      packageName: "io.dahlia.containers",
      appName: LocaleStrings.pangolin.appContainers,
      icon: "graft",
      app: Graft(),
      color: Colors.blue[700],
      appExists: true));

  //Welcome
  applicationsData.add(ApplicationData(
      packageName: "io.dahlia.welcome",
      appName: LocaleStrings.pangolin.appWelcome,
      icon: "welcome-info",
      app: Welcome(),
      color: Colors.grey[900],
      appExists: true));

  //Developer Options
  if (HiveManager.get("developeroptions") == true) {
    applicationsData.add(ApplicationData(
        packageName: "io.dahlia.developeroptions",
        appName: LocaleStrings.pangolin.appDeveloperoptions,
        icon: "developer",
        app: DeveloperApp(),
        color: Colors.red[700],
        appExists: true));
  }

  //Web
  applicationsData.add(ApplicationData(
      packageName: "io.dahlia.web",
      appName: LocaleStrings.pangolin.appWeb,
      icon: "web",
      app: BrowserApp(),
      color: Colors.grey[500],
      appExists: true));

  //Clock
  applicationsData.add(ApplicationData(
      packageName: "io.dahlia.clock",
      appName: LocaleStrings.pangolin.appClock,
      icon: "clock",
      app: Clock(),
      color: Colors.blue[900],
      appExists: true));

  //Messages
  applicationsData.add(ApplicationData(
      packageName: "io.dahlia.messages",
      appName: LocaleStrings.pangolin.appMessages,
      icon: "messages",
      appExists: false));

  //Music
  applicationsData.add(ApplicationData(
      packageName: "io.dahlia.music",
      appName: LocaleStrings.pangolin.appMusic,
      icon: "music",
      appExists: false));

  //Photos
  applicationsData.add(ApplicationData(
      packageName: "io.dahlia.media",
      appName: LocaleStrings.pangolin.appMedia,
      icon: "photos",
      appExists: false));

  //Theme Demo
  applicationsData.add(ApplicationData(
      packageName: "io.dahlia.themedemo",
      appName: "Theme Demo",
      icon: "theme",
      app: ThemeDemoApp(),
      color: Colors.blue[700],
      appExists: true));

  //Help
  applicationsData.add(ApplicationData(
      packageName: "io.dahlia.help",
      appName: LocaleStrings.pangolin.appHelp,
      icon: "help",
      appExists: false));
}
