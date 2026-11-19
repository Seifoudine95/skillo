import 'package:material_ui/material_ui.dart';
import 'package:skillo/views/utilisateur/connexion.dart';

class Inscription extends StatelessWidget {
  const Inscription({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inscription')),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: InputDecoration(labelText: 'Nom', border: OutlineInputBorder())),
              SizedBox(height: 10),
              TextField(decoration: InputDecoration(labelText: 'Prénom', border: OutlineInputBorder())),
              SizedBox(height: 10),
              TextField(decoration: InputDecoration(labelText: 'Mail', border: OutlineInputBorder())),
              SizedBox(height: 10),
              TextField(decoration: InputDecoration(labelText: 'Motivation', border: OutlineInputBorder())),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () {}, child: Text('S\'inscrire')),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Connexion()));
                },
                child: Text('Déjà un compte ? Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}