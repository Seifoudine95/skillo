import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillo/firebase_options.dart';
import 'package:skillo/views/utilisateur/accueil.dart';
import 'package:skillo/views/utilisateur/connexion.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  bool? isConnect = prefs.getBool('isConnect');
  runApp(ProviderScope(child: MyApp(isConnect: isConnect)));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.isConnect});
  final bool? isConnect;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: isConnect == true ? Accueil() : Connexion(),
    );
  }
}
