@HtmlImport('gh_settings.html')
library githubby.gh_settings;

import 'dart:async';

import 'package:githubby/context.dart';
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

  Context _context;

  @Property()
  String authToken;

  @Property()
  String reposInput;

  GhSettings.created() : super.created();

  void set context(Context c) {
    _context = c;
    render();
  }

  void render() {
    var storage = _context.storage;
    var workspace = storage.workspace;
    print('reloading token ${workspace.authToken}');
    set('authToken', workspace.authToken);
    set('reposInput', _reposToText(workspace.repos));
  }

  @reflectable
  save([_, __]) {
    _saveSettings();
    fire('gh-complete');
  }

  @reflectable
  cancel([_, __]) {
    fire('gh-complete');
  }

  @reflectable
  clear([_, __]) async {
    await _context.clearWorkspace();
    render();
  }

  Future _saveSettings() async {
    var storage = _context.storage;
      storage.workspace.authToken = authToken;
      storage.workspace.repos = _textToRepos(reposInput) ?? [];

    // use the (possibly changed) auth token
    _context.service.loadAuth();

    await storage.save();
    fire('gh-complete');
  }
}
