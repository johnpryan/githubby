library githubby.generate;

import 'package:source_gen/generators/json_literal_generator.dart' as literal;
import 'package:source_gen/generators/json_serializable_generator.dart' as json;
import 'package:source_gen/source_gen.dart';

main(List<String> args) async {
  var msg = await build(args, const [
    const json.JsonSerializableGenerator(),
    const literal.JsonLiteralGenerator()
  ], librarySearchPaths: [
    'lib/model'
  ]);
  print(msg);
}