@HtmlImport('gh_settings.html')
library githubby.gh_settings;

import 'dart:async';
import 'package:githubby/storage_browser.dart';
import 'package:githubby/model.dart';

import 'package:web_components/web_components.dart' show HtmlImport;
import 'package:polymer/polymer.dart';

String _reposToText(List<String> repos) =>
  repos.fold('', (String prev, String next) {
    if (prev == '') return next;
    return prev + ', ' + next;
  });

List<String> _textToRepos(String repos) =>
  repos.split(new RegExp(r',[ ]*'));

@PolymerRegister('gh-settings')
class GhSettings extends PolymerElement {

  @Property()
  String authToken;

  @Property()
  String reposInput;

  GhSettings.created() : super.created();

  ready() {
    _loadSettings();
  }

  @reflectable
  save([_, __]) {
    _saveSettings();
  }

  @reflectable
  cancel([_, __]) {
    fire('gh-complete');
  }

  Future _loadSettings() async {
    var storage = new StorageBrowser();

    if (!storage.hasData) {
      return;
    }

    await storage.load();
    set('authToken', storage.workspace.authToken);
    print('loading repos ${storage.workspace.repos}');
    set('reposInput', _reposToText(storage.workspace.repos));
  }

  Future _saveSettings() async {
    var storage = new StorageBrowser();

    await storage.load();

    if(!storage.hasData) {
      storage.workspace = new Workspace(authToken, []);
    } else {
      storage.workspace.authToken = authToken;
      storage.workspace.repos = _textToRepos(reposInput);
    }

    await storage.save();
    fire('gh-complete');
  }
}
