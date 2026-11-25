import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skillo/providers/providers.dart';
import 'package:skillo/views/utilisateur/page_qsm.dart';
import 'package:skillo/views/utilisateur/profil_utilisateur.dart';

class Accueil extends ConsumerWidget {
  const Accueil({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matieres = ref.watch(getMatiereProvider);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            // padding: const EdgeInsets.only(top: 20),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Bienvenue sur Skillo",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      // iconSize: 30,
                      icon: Icon(Icons.person, color: Colors.lightBlue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilUtilisateur(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          matieres.when(
            error: (err, stack) => Center(child: Text('Erreur: $err')),
            loading: () => Center(child: CircularProgressIndicator()),
            data: (matiere) {
              if (matiere.isEmpty) {
                return Center(child: Text("Pas de donnée"));
              }
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).width * 0.2,
                    vertical: 20,
                  ),
                  child: ListView.builder(
                    itemCount: matiere.length,
                    itemBuilder: (context, index) {
                      final bool dejaTermine = ref
                          .watch(userProvider)
                          .estCoursTermine(matiere[index].nom);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          onTap: () {
                            if (dejaTermine) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(
                                      child: Text("Cours déjà validé "),
                                    ),
                                  );
                                },
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PageQsm(nomMat: matiere[index].nom),
                                ),
                              );
                            }
                          },
                          subtitle: Text(
                            dejaTermine ? 'Cours déjà validé' : 'Disponible',
                          ),
                          title: Text(matiere[index].nom),
                          style: ListTileStyle.list,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
