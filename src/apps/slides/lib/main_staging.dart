import 'package:slides/app/app.dart';
import 'package:slides/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
