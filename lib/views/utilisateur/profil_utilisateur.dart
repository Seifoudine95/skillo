import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skillo/providers/providers.dart';
import 'package:skillo/views/utilisateur/connexion.dart';

class ProfilUtilisateur extends ConsumerStatefulWidget {
  ProfilUtilisateur({super.key});

  @override
  ConsumerState<ProfilUtilisateur> createState() => _ProfilUtilisateurState();
}

class _ProfilUtilisateurState extends ConsumerState<ProfilUtilisateur> {
  String? _motivationModif = "";

  final _adresseModif = TextEditingController();

  final List<String> _motivations = [
    "Poursuite d'étude",
    "Reconversion pro",
    "Réorientation",
  ];

  @override
  Widget build(BuildContext context) {
    final utilisateur = ref.watch(userProvider).utilisateurCourant;
    final resultas = ref.watch(userProvider).resultats;
    final nombreCoure = resultas?.length ?? 0;

    if (utilisateur == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      // _motivationModif = utilisateur.motivation;
      _adresseModif.text = utilisateur.adressePostal!;
      return Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.2,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${utilisateur.nom}  ${utilisateur.prenom} ${utilisateur.age} ans",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: SizedBox(
                                        height: 200,
                                        child: Column(
                                          children: [
                                            DropdownButtonFormField<String>(
                                              initialValue:
                                                  _motivationModif == ""
                                                  ? utilisateur.motivation
                                                  : _motivationModif,
                                              items: _motivations.map((
                                                String motivation,
                                              ) {
                                                return DropdownMenuItem<String>(
                                                  value: motivation,
                                                  child: Text(motivation),
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _motivationModif = value;
                                                });
                                              },
                                            ),
                                            SizedBox(height: 10),
                                            TextField(
                                              controller: _adresseModif,
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Anuler'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await ref
                                                .read(userProvider)
                                                .updateUser(
                                                  _adresseModif.text.trim(),
                                                  _motivationModif == ""
                                                      ? utilisateur.motivation
                                                      : _motivationModif!,
                                                );
                                            if (!context.mounted) return;
                                            Navigator.pop(context);
                                          },
                                          child: Text('Modifier'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.edit_outlined,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                ref.read(userProvider).deconnexionUser();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Connexion(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.logout_rounded,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Text(
                      utilisateur.adressePostal ?? "",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      utilisateur.motivation ?? "",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Nombre de cours suivis : $nombreCoure',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            nombreCoure == 0
                ? Text(
                    "Tu n'as pas encore fait des cours",
                    style: TextStyle(fontSize: 25),
                  )
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 300),
                      child: ListView.builder(
                        itemCount: nombreCoure,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: Icon(Icons.school),
                              title: Text(resultas![index].matiere),
                              trailing: Text(
                                "${resultas[index].score}/${resultas[index].totalQuestions}",
                              ),
                              onTap: () {},
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      );
    }
  }
}
