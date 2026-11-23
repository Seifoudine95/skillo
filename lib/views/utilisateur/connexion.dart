import 'package:material_ui/material_ui.dart';
import 'package:skillo/views/utilisateur/inscription.dart';

class Connexion extends StatelessWidget {
  const Connexion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connexion')),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: InputDecoration(labelText: 'Nom', border: OutlineInputBorder())),
              SizedBox(height: 10),
              TextField(decoration: InputDecoration(labelText: 'Mail', border: OutlineInputBorder())),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () {}, child: Text('Se connecter')),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Inscription()));
                },
                child: Text('Pas de compte ? S\'inscrire'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}