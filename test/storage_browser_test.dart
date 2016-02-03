@TestOn("dartium")
library githubby.storage_test;

import 'package:test/test.dart';

import 'package:githubby/browser_storage.dart';
import 'package:githubby/model.dart';

void main() {
  test("can save, clear, and load", () async {
    var storage = new BrowserStorage(uniqueKey: 'test1');
    expect(storage, isNotNull);
    await storage.clear();
    expect(storage.workspace.authToken, '');
    storage.workspace = new Workspace('123', []);
    await storage.save();
    await storage.load();
    expect(storage.workspace.authToken, '123');
    expect(storage.workspace.repos.length, 0);
    storage.clear();
  });

  test("hasExisting", () async {
    var storage = new BrowserStorage(uniqueKey: 'test2');
    await storage.clear();
    expect(storage.hasData, false);
    storage.workspace = new Workspace('23', []);
    await storage.save();
    expect(storage.hasData, equals(true));
    storage.clear();
  });
}
