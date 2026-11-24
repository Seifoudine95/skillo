import 'package:firebase_core/firebase_core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skillo/firebase_options.dart';
import 'package:skillo/views/utilisateur/connexion.dart';

void main() async {
  // obligatoire avant d'utiliser Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // on connecte l'appli au projet Firebase (infos dans firebase_options.dart)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Skillo",
      // story I : on arrive d'abord sur la page de connexion
      home: Connexion(),
    );
  }
}