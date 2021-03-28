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

import 'dart:io';
import 'dart:ui';

import 'package:Pangolin/utils/widgets/settingsTile.dart';
import 'package:flutter/material.dart';

class GraftForm extends StatefulWidget {
  @override
  GraftFormState createState() {
    return GraftFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class GraftFormState extends State<GraftForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<GraftFormState>.
  String? pkgurl;
  bool updates = true;
  bool extPkgs = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 0),
              child: Text("Software Updates")),
          Row(
            children: [
              Switch(
                value: updates,
                onChanged: (value) {
                  setState(() {
                    updates = value;
                  });
                },
              ),
              Text("Enable System Updates"),
            ],
          ),
          Row(
            children: [
              Switch(
                value: extPkgs,
                onChanged: (value) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                      content: Text(
                          'DANGER: UNSIGNED PACKAGES CAN BE DANGEROUS! Only use update packages you trust!')));
                  setState(() {
                    extPkgs = value;
                  });
                },
              ),
              Text("Allow Unsigned Packages"),
            ],
          ),
          TextFormField(
            initialValue: 'https://dahliaos.io/update/next.upd',
            decoration: InputDecoration(
                labelText: "Update Package URL",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.storage)),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'The package can\'t be empty';
              }

              pkgurl = value;
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.

                if (_formKey.currentState?.validate() ?? false) {
                  //check if URL is allowed here
                  if (updates == true) {
                    if (extPkgs == false && (pkgurl?.length ?? 0) < 20) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                          content: Text('That update source isn\'t trusted')));
                    }
                    if (extPkgs == false &&
                        pkgurl?.substring(0, 20) != "https://dahliaos.io/") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                          content: Text('That update source isn\'t trusted')));
                    }
                    if (extPkgs == true) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 3),
                          content: Text('Update initialized')));
                      Process.start('external-updater', [pkgurl ?? ""],
                          mode: ProcessStartMode.detached);
                    }

                    if (extPkgs == false &&
                        pkgurl?.substring(0, 20) == "https://dahliaos.io/") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 3),
                          content: Text('Update initialized')));
                      Process.start('external-updater', [pkgurl ?? ""],
                          mode: ProcessStartMode.detached);
                    }
                  } else if (updates == false) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 3),
                        content: Text('Software updates are disabled')));
                  }
                }
              },
              child: Text('Update System'),
            ),
          ),
        ],
      ),
    );
  }
}

class Updates extends StatefulWidget {
  @override
  _UpdatesState createState() => _UpdatesState();
}

class _UpdatesState extends State<Updates> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    "Updates",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                        fontFamily: "Roboto"),
                  )),
              new Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      SettingsTile(
                        children: [
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: GraftForm(),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ], //end of column
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
