import 'package:email_validator/email_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skillo/providers/providers.dart';
import 'package:skillo/views/utilisateur/accueil.dart';
import 'package:skillo/views/utilisateur/connexion.dart';

class Inscription extends ConsumerStatefulWidget {
  const Inscription({super.key});

  @override
  ConsumerState<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends ConsumerState<Inscription> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nom = TextEditingController();

  final TextEditingController _prenom = TextEditingController();

  final TextEditingController _mail = TextEditingController();

  final TextEditingController _age = TextEditingController();

  final TextEditingController _adressePostal = TextEditingController();

  final List<String> _motivations = [
    "Poursuite d'étude",
    "Reconversion pro",
    "Réorientation",
  ];

  String? _motivation;

  @override
  void dispose() {
    super.dispose();
    _nom.dispose();
    _prenom.dispose();
    _mail.dispose();
    _age.dispose();
    _adressePostal.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Inscription')),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.3,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text(
                  'INSCRIPTION',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nom,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veillez entrer votre Nom';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _prenom,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Prénom',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veillez entrer votre Prénom';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _mail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Mail',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veillez entrer votre Mail';
                    }
                    if (!EmailValidator.validate(value.trim())) {
                      return 'Veillez entrer une dresse mail invalide';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _age,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veillez entrer votre Age';
                    }
                    final number = int.tryParse(value);
                    if (number == null) {
                      return 'Veuillez entrer un nombre';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _adressePostal,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Adresse Postal',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veillez entrer votre adresse postal';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  initialValue: _motivation,
                  decoration: const InputDecoration(
                    labelText: 'Sélectionnez votre motivation',
                    border: OutlineInputBorder(),
                  ),
                  items: _motivations.map((String motivation) {
                    return DropdownMenuItem<String>(
                      value: motivation,
                      child: Text(motivation),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _motivation = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez choisir votre motivation';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await ref
                          .read(userProvider)
                          .inscriptionUser(
                            _nom.text,
                            _prenom.text,
                            _mail.text,
                            _age.text,
                            _adressePostal.text,
                            _motivation!,
                          );
                      _nom.text = "";
                      _prenom.text = "";
                      _mail.text = "";
                      _age.text = "";
                      _adressePostal.text = "";
                      _motivation = "";
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    }
                  },
                  child: Text('S\'inscrire'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Connexion()),
                    );
                  },
                  child: Text('Déjà un compte ? Se connecter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
