import 'package:material_ui/material_ui.dart';

class ProfilUtilisateur extends StatelessWidget {
  const ProfilUtilisateur({super.key});

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(horizontal: 300),
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
                        "Nom d'utilisateur",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.logout_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Motivation de l'utilisateur",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Adresse Postale de l'utilisateur",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 300),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Text(
                    'Nombre de cours suivis : 3',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.school),
                      title: Text('Cours 1'),
                      onTap: () {
                        // Action when the username is tapped
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.school),
                      title: Text('Cours 2'),
                      onTap: () {
                        // Action when the email is tapped
                      },
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: Icon(Icons.school),
                      title: Text('Cours 3'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
