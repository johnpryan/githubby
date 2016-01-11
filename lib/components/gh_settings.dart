@HtmlImport('gh_settings.html')
library githubby.gh_settings;

import 'dart:async';
import 'package:githubby/storage_browser.dart';
import 'package:githubby/model.dart';

import 'package:web_components/web_components.dart' show HtmlImport;
import 'package:polymer/polymer.dart';

@PolymerRegister('gh-settings')
class GhSettings extends PolymerElement {

  @Property()
  String authToken;

  GhSettings.created() : super.created();

  ready() {
    _loadSettings();
  }

  @reflectable
  save([_, __]) {
    _saveSettings();
  }

  Future _loadSettings() async {
    var storage = new StorageBrowser();

    if (!storage.hasData) {
      return;
    }

    await storage.load();
    set('authToken', storage.workspace.authToken);
  }

  Future _saveSettings() async {
    var storage = new StorageBrowser();

    await storage.clear();

    if(!storage.hasData) {
      storage.workspace = new Workspace(authToken, []);
    } else {
      storage.workspace.authToken = authToken;
      storage.workspace.repos = [];
    }

    await storage.save();
  }
}
