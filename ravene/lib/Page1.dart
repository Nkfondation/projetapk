import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ravene/main.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Page1(),
    );
  }
}

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  bool _isDrawerOpen = false;
  String _solde = '';

  @override
  void initState() {
    super.initState();
    _fetchSolde();
  }

  Future<void> _fetchSolde() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot document = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (document.exists && document.data() != null) {
          var data = document.data() as Map<String, dynamic>;

          String solde = data['solde']?.toString() ?? '0';
          String phoneNumber = data['phone_number']?.toString() ?? '';

          print("Solde récupéré: $solde");
          print("Numéro de téléphone brut récupéré: $phoneNumber");

          String monnaie;
          if (phoneNumber.startsWith('+242') ||
              phoneNumber.startsWith('+237')) {
            monnaie = 'XAF';
          } else if (phoneNumber.startsWith('+243')) {
            monnaie = 'CDF';
          } else {
            monnaie = 'Monnaie non définie';
          }

          setState(() {
            _solde = '$solde $monnaie';
          });
        } else {
          setState(() {
            _solde = '0 (Document non trouvé)';
          });
        }
      } catch (e) {
        print("Erreur lors de la récupération du solde: $e");
        setState(() {
          _solde = '0 (Erreur de récupération)';
        });
      }
    } else {
      print("Aucun utilisateur connecté");
      setState(() {
        _solde = '0 (Aucun utilisateur)';
      });
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    // Redirige vers la page principale dans main.dart
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) =>
              MyApp()), // Remplacez MainPage() par la classe de votre page principale
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    double cardHeight = 120;
    double imageSize = MediaQuery.of(context).size.width - 32;
    double imageSpacing = 16;
    double bottomCardSpacing = 140;

    String imageUrl =
        'https://i.postimg.cc/cHMmZHqs/Story-Instagram-recrutement-employ-annonce-1.png';
    String additionalImageUrl =
        'https://i.postimg.cc/d1v2WYhg/In-partnership-with-1.png';

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.05,
            left: 16,
            child: IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  _isDrawerOpen = !_isDrawerOpen;
                });
                if (_isDrawerOpen) {
                  _showCustomDrawer(context);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                _solde,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15 + imageSpacing,
            left: 16,
            right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: imageSize,
                height: imageSize * 0.6,
                child: Image.network(
                  additionalImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: cardHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: -10,
                    blurRadius: 20,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NiPage()),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.person, color: Colors.blue, size: 40),
                          SizedBox(height: 8),
                          Text(
                            'TRANSFERT',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  VerticalDivider(width: 1, color: Colors.grey),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.shopping_cart,
                            color: Color(0xFFFF6F00), size: 40),
                        SizedBox(height: 8),
                        Text('PAIEMENTS',
                            style: TextStyle(
                                color: Color(0xFFFF6F00),
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  VerticalDivider(width: 1, color: Colors.grey),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.smartphone, color: Colors.purple, size: 40),
                        SizedBox(height: 8),
                        Text('CREDIT',
                            style: TextStyle(
                                color: Colors.purple,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom:
                MediaQuery.of(context).size.height * 0.15 + bottomCardSpacing,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Retrait',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Text(
                        'Juillet 9, 2021 at 8:40 AM',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      Spacer(),
                      Text(
                        '- 1000 F',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomDrawer(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Builder(
          builder: (BuildContext context) {
            return Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: _isDrawerOpen
                          ? MediaQuery.of(context).size.width * 0.8
                          : 0,
                      height: MediaQuery.of(context).size.height,
                      color: Color.fromARGB(255, 255, 255, 255),
                      child: _isDrawerOpen
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 60),
                                  Text(
                                    'RAVENE',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ListTile(
                                            leading: Icon(Icons.account_circle),
                                            title: Text(
                                              'Mon compte',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0)),
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MonComptePage(
                                                            solde: _solde)),
                                              );
                                              print('Mon compte sélectionné');
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.notifications),
                                            title: Text(
                                              'Notifications',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0)),
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                              print(
                                                  'Notifications sélectionnées');
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.support),
                                            title: Text(
                                              'Support',
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0)),
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                              print('Support sélectionné');
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.logout),
                                            title: Text(
                                              'Se déconnecter',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            onTap: () {
                                              _signOut();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      setState(() {
        _isDrawerOpen = false;
      });
    });
  }
}

class MonComptePage extends StatelessWidget {
  final String solde;

  const MonComptePage({Key? key, required this.solde}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Bouton retour
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20),

              // Icônes en haut à droite de la carte
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(Icons.send, color: Colors.black),
                      SizedBox(width: 4),
                      Text('Envoyer', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  SizedBox(width: 20),
                  Row(
                    children: [
                      Icon(Icons.receipt, color: Colors.black),
                      SizedBox(width: 4),
                      Text('Recevoir', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Carte de style Visa
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Stack(
                  children: [
                    Positioned(
                      left: 16,
                      top: 16,
                      child: Text(
                        'Ravene',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      bottom: 50,
                      child: Text(
                        'Mon solde',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      bottom: 10,
                      child: Text(
                        solde,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      top: 16,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://i.postimg.cc/FR3X6Sj1/MONICA-1.png',
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Carte view avec image de fond
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://th.bing.com/th/id/OIP.p872iPTHgoA0pW0cwsjKcAHaEo?w=275&h=180&c=7&r=0&o=5&dpr=1.5&pid=1.7',
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Envoyez et Recevez de l\'argent sans limite',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Connectez-vous au futur du paiement',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Carte pour Recharger, Épargne et Achat
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RechargePage()),
                          );
                        },
                        child: Column(
                          children: [
                            Icon(Icons.monetization_on,
                                size: 40, color: Colors.cyan),
                            SizedBox(height: 8),
                            Text(
                              'Recharge',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.cyan,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(color: Color.fromARGB(255, 0, 0, 0)),
                      Column(
                        children: [
                          Icon(Icons.savings, size: 40, color: Colors.purple),
                          SizedBox(height: 8),
                          Text(
                            'Épargne',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      VerticalDivider(color: Color.fromARGB(255, 0, 0, 0)),
                      Column(
                        children: [
                          Icon(Icons.shopping_cart,
                              size: 40, color: Color.fromARGB(255, 176, 3, 3)),
                          SizedBox(height: 8),
                          Text(
                            'Achat',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromARGB(255, 176, 3, 3),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Titre "Historique des transactions"
              Center(
                child: Text(
                  'Historique des transactions',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Historique des recharges
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('recharges')
                      .where('user_id',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final userId = FirebaseAuth.instance.currentUser?.uid;
                    if (userId == null) {
                      return Center(child: Text("Vous devez être connecté."));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Erreur: ${snapshot.error}"));
                    }

                    final recharges = snapshot.data?.docs;

                    if (recharges == null || recharges.isEmpty) {
                      return Center(child: Text("Aucune transaction trouvée."));
                    }

                    final now = DateTime.now();

                    // Filtrer les recharges pour ne garder que celles de moins de 24 heures
                    final filteredRecharges = recharges.where((recharge) {
                      final dateField = recharge['date'];

                      // Assurez-vous que la date est un Timestamp
                      DateTime rechargeDate;
                      if (dateField is Timestamp) {
                        rechargeDate = dateField.toDate();
                      } else if (dateField is String) {
                        // Si la date est une chaîne, vous devez la parser
                        rechargeDate = DateTime.parse(dateField);
                      } else {
                        return false; // Si ce n'est ni un Timestamp ni une String, ignorez l'élément
                      }

                      return now.difference(rechargeDate).inHours < 24;
                    }).toList();

                    if (filteredRecharges.isEmpty) {
                      return Center(
                          child: Text(
                              "Aucune transaction trouvée dans les dernières 24 heures."));
                    }

                    return ListView.builder(
                      itemCount: filteredRecharges.length,
                      itemBuilder: (context, index) {
                        final recharge = filteredRecharges[index];
                        final date = recharge['date']?.toString() ?? '';
                        final time = recharge['heure'] ?? '';
                        final amount = recharge['amount']?.toString() ?? '';

                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Recharge : +$amount",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 9, 4, 94),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "Réussi",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            "$date, $time",
                            style: TextStyle(color: Colors.black54),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RechargePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1,
          children: [
            _buildServiceBlock(
                'MTN Money',
                'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAsJCQcJCQcJCQkJCwkJCQkJCQsJCwsMCwsLDA0QDBEODQ4MEhkSJRodJR0ZHxwpKRYlNzU2GioyPi0pMBk7IRP/2wBDAQcICAsJCxULCxUsHRkdLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCz/wAARCAEOAYoDASIAAhEBAxEB/8QAHAABAAMBAQEBAQAAAAAAAAAAAAEGBwUEAgMI/8QATxAAAQMDAgIGBAcNBAkFAQAAAQACAwQFEQYhEjETQVFhcYEHFCKRFSMyQlJyoSQzNDVic3SCkrGys8FDouHwFkRTVGPC0dLxJVWEk6NF/8QAHAEBAAIDAQEBAAAAAAAAAAAAAAUGAwQHAQII/8QAOxEAAQMCBAQCCAQFBAMAAAAAAQACAwQRBRIhMQYTQVFhcRQiMoGRocHRNDWx8DNCcuHxFSNSUxaSsv/aAAwDAQACEQMRAD8AuJJTJQqFwJXBMlMlERFOSmSoREU5KjJRERTkqMlEwiKclRkoiIpyUyVCIinJUZKIiJkpkoiIpydlGSnYiIpyVGSiIinJTJUIiKclRkoiIpyVGSiIinJUZKIiKclRkoiImSpyVCIilFCIilMqERFKKERFKKERFOSmSoRETJUqERFKKERFKKERFJUKSoRERERERERERE26ygRfcMT5pWRN+U88/ot6yuo+1REfFyOafytxlfVsp+jjM7xh8oHDn5rOoDxXJ1RqcWH1KGniinq53dK+ORzg1lMMjiJbvkn5PgfPpWB8PRS016hl3P8AkFXq3EDE4kOsAv2moqqHcsL2/SYeLzI5rzbr7tWs7DcSyKZ5oql23R1RAjcexkww0+eF3ZqOlqBktAcdw9mx8chYMQ4QLCTTG3gfuvumxVsgudR4KvovZUW+ohy5o6SPnxN+UB3hePB92yo9TRzUrskzbFTMcrJBdpRF9Mjlld0cbS5+2w6u8nsXYpbfFDwyS4kk5j6LPAFbmHYTUYg60YsOpOyxz1LIRrv2XjpaCWfD5Mxx7ED57gezsX1W0Ahb0sIPRge2MklveF83zUdrscZ6U9NWObmGkicBI7r4nnk1vefcV6rTdaC80UVZTOy12WSxOxxwyY9qOQdo+1dC/wDF6ZtJywNf+XW/2UF/qTjNYHXsuOi9ldServDmD4p+eHta7mQvEuY1dLJSSmGQahWGKRsjczVKIoWosqlEREREREREUIilEUIilERERERERERERERERERERERERERERERERFClEREREUlQpKhERFCIilFCL0IpXoo6c1E4aR7DMPk8Po+a85zkADJyMDtPYrBRU4poQCPjH+3Ie0kcvLkrBgOHGtqQXey3U/QLRq5+VHpuV91dVS0NLU1dQ4Mp6aN0kh7gOQ7zyCxC53CpuldVV9RtJUP4gzORHGNmRjuA29/ardr29dPNHZad/wAXTls1eWnZ0xGWRH6oOT3kfRVF3XdKGAMbm7/oudYlUcx3KbsFGx57ruWjU17sxY2CfpqUHelqcuix+QflNPgfIrhot58bZBZwUZHK6M3YbLZLLquz3rhia71asIyaaoLQ53fC/k79/cF0qigp5yXDMcmfaczAyO8HZYV9E9bXBwI2II5EY61dLBreqozHS3cvqaXk2p+VUQ9gk+k37R3qCr8Iinblc0OHYqfo8WINnmx7rSIYYKaPDAGtaCXuJ323y5xVJ1DriOHpaKyObJNktlriAYmHkRADs4/lcuzPVb5GW280D2F0dTQVsWCWPPDIzuc3B2WW6j0rWWRz6iAvqLYTtNgdJTk/MnDersd+48/KGCCOzCLW2HRbFfNNkzR+8qvSSSzSSSzSPklkdxSSSOL3uPaXO3XUsN7qbHXMqWF76aThjrYGnaWP6QH0m82+Y+dtydupR1qfcxrxlI0VYZI5js4Oq3aRtNdre7oah4grafihqKV/DIzjGWyxuHzgcEeCyGo1hqTTlyqrTf6SCsdTScPTxA00ssbhlkrS0dGQ4b/JHXvkKw6EvpgnNkqH/EzudJQOcdo5ub4Rnqdzb35+ltZtRaPsGpujkrmTR1UMRiiqaZ/BK1meLhc0gtIBzjI/fvUK/C6eVxbOwHx6/HdXOjrHPjD2FVq3aw0tcuFrKz1WZ39jXgRHPY2TJj/vLv4yGuGC127XNILSO4jZZ5dvRNfaYPltNXBXxjJEUn3PUY7BxExk/rBVVtTrPSswhebhb3A4EM7X9BJ1nDXgxkeCp9XwlG67qZ9j2O3xUxHiLho8LbUWcW30lSDhZdre142BnoT0b/ExO9n3EK5W7UWnbrwijuEJldygqSIJ/AMecE+BKqdXg1ZSAmRlx3GqkI6uKTQFdVFJBHMEeIwftXyoay27qURES6IihEUoihEUooREUooREUooREUoihEUooREUooUoiIoREUooUoiIoREX0VCkqEREUIiKUBwi+o2PkexjB7T3YH/AFK+2sLnBrdyvCQBcr222n6WUzOb7EPyc9cn+C/a/XeOy22prDh02OipI3HHSTvHsjwHM9wXQghbBFHEzk0YyeZPWSsl1devhe5vjhcTRUBfT02CeGSTPxkvZuRgdw712vh/ChTQtjO+7lTMUrcoLx5BV6R8sr5JZXufLK98sj3nLnve4ucSe0kkr5zy+1S0Pe6NjGOfJI5scbIwXSPe48Iaxo3JPUtE0/oOBrIqu+ASzHDm0THZgi6wJi35TvPHirjLMyEaqpwU8lS7RUKkoblcHFtBRVNURsTBGXMHi/5P2rrs0Xq94z6hGzI5SVVOD7muK2COGKFjIoWMjjYOFjI2hrGjsDWjC+8KNdXv/lUwzCowPWJWMzaS1ZTt4nWx8gH+7ywyn9lruL7FxZY5oZHQzxSQzN+VHOx0bx38LgCv6AwvHX2y23OIw11NFOzB4S9o42HtY8e0D4FfTK9wPrBfMmFNtdh1WQWO/wBxsVRxwEyU0hHrNK9x4JBy4mnqcOo+/I5a1bblbb3RippXNkhkaY5opA3ijcR7UUzDnf8AzyKzfUmkamzh9ZRufUW0HLy7eelH/ExzZ3+/tXFtN2r7PWMq6R4yQGzQuJ6KoiB+RIB/dPV9hyywtqG8yPda8NRJSP5U3sqw6r0obZ0lxtzCbaSXzxDJdRuJyXDr6P8Acqfj/PWtxtdzt97oWVVMQ6OQGOeF+C6OTHtRSt/znn1rN9WaaNnm9do2n4MqH44Rv6rK456PJ+afm9nJKaoN+U/dK2kFudDsVV2PkjfHJE4slje2SJ7Tgsew8TSD4rbbFdGXi2Udc3Ae9vBUMG/R1Eez2+/ceKxHsV09H9zMFfVWx7vi61hngyeU8Qw4Dxbv+qslZFmZmHRY8Nn5cmU7FdC4+kI6evdZaL7bH9ExzZKWst7i7pKaTeNzoZyDkbhxEh3BwNlYaK/aP1LC6Cnq6CsbK0h9JVNaJCOsOgnAd/dVP9LVlFRbaC9xMBlt8opapwG5pZ3ewXHsa/AH5wrFgS0gtJBBBBGxB6sFQisy3y8ejDSNx45KNs1sqHZOaQ8UBd+VBKcY7muas9u/ox1dbS+SibFc6duSHUh4KgAdboJCDnuaXLn2jX+sbRwMjr3VVO3A6C4A1DMZ5Ne49IP2loFp9LVlqOCO8Uc1FJtmWnzUU5OeZbtIPcURZtR6k1fYZPVjUVLBEeF9HcWOexuOro5xkeWFb7d6SKCXgjutDJTv5GaiJlh8TFIeMDwc5aUH6P1VTcINtusPDktPRyyxgnGS04kb9iqN29E9iqQ+S01VRQSHJEUuainyd8DiIkA/WKiqvCKOs/iM17jQrYjqJI/ZK6tDcbXc4jNbqyCpjbjj6IkPjz/tI3APHmF61h00V/0fenRPPQV9G9p9g8UM8TsOB6g6Nw7vcRtstsr4bpb6C4RDDKqFspbnPA8EtezPcQR5LnuN4IcOIkYbsPxBUzS1XO9V269iIoVZW+FKIoRFKKERFKIiIiIoRFKIoRFKKERFKIiIiKFKIiKFKIiIoRF9FQpKhERFCIildW10+A6pe3cjhiH5PWfNc+ngdUTMjHyTu89jetd+SWmo6eWaV4jp6eJ0kjjyZGwZJ23V14Xw3nS+lPGjdvP+yicQqMreWOqretL38GW00kD8Vtxa+Jhafaip+Uku3jwt7zn5qybIwANhjAxnqXRvN0nvFwq66bIEh4KeMnPQ07chjOzvPeSvxttEblcLdQDOKypjikI5iIHjkI/VDl2aCIQx3O+651VTekzWG2wV80Jp9kULb5VsBnqGkW9rh95pzt0oz85/V3fWV8AAyvyc+mpIcvdFDTwta0F7mxxsa3YDJwAFyxqjS3EWfC9Fnfm8hu35RGPtUO9z5nF1lYYmR07Ay67WybLj3bUVoszaV1Y+U+tMkkgFPEZeNrOHJBB4esda9lvuVDc6aGsopBJBLkZGzmOHNj29Th1hY8pAzELOJGl2UHVexR2qp0GrJ6zUb7JJRRQsZNXQdJ0znyOfThxGBwgYIBVcqdV61nuVRbKL1Zs4q6mlhjp6dnG/onOGeKZxHIZWZtO9xstd9ZG0X8be9aa5jHgtcA5rgQ5rhlpBGCCOxZBqywtsteHU4xb63ikpufxTwfbh8BsR3HuXdp6H0o1FRRy1NS+OKOohlkjlq4o2vja8Ocwx07evfrVm1Zb23Gx3BgGZaZnrtOesPh9o48RkLLE70d4FwQey152elRElpBG11l9ivVVY65lTCC+F/DHWQZwJos8x+U3m0+XI4WwNdbrzbw4cFRQ18B2OCHscNwR2j7CO5YVz4SOvdXDRV/8Ag+rFrqn/AHHXSDoHPOBBUu2Ayep/7/FblXBmHMbuFHYfVZXcp+xXEvtnnsdwlo5CXQuHS0ku+JIScdfWORGf37+Kkq30NZRV0fyqSojnAHW1h9pvmMjzWvansjL3bZImAeuU/FPRO/4gG8ZPY4bHyPUsbLXNJa4FrmlzXtcMOaWnBBHaN8rJTSiaPKd1iq4DTShzditwuVHT3uzV9ES10VyoZI43c2tdIzMcg8DgjwX8uSxyQySxSNLZInvjkaebXsJaQV/SOi6z1vT1v4nZkpDJRP7uhcWs/u8J81i3pBtwt2q70xjeGKqkZXxdhFS3jeR+txKEe3K4hWWJ+dgd3VUTKIvlZF+kM1RTyMlgmlhlYQWyQvcx7SOsOaQVuvoxvl7vNruDbnK+o9RqYoYKmXJlka9hc5kj+ZLdtzv7SwZf0noi0fAumrRTPZwVE0XrtXkEOE1SBIQ7PW1vC0/VRFnfpgdS/CdhYz8KbQTOmPX0Tpj0efMPK7Oho5Y9M23pAR0ktXLGD/s3Slo+0E+azzUdbPqfVda+nPF63XMoaEYwOhY4QRk4zz5nxK2OmpoKOnpaSAYhpYY4Ih+TG0NBPjz81TeLahradkHUm/w/ypPDmEvL+y/VEULminVKIoRFKKERFKKERFKKERFKIoRFKKERFKKFKIiKERFKKFKIiKERF9FQpKhEREXsoKfppw5w+LiILu93U1bVLSvqpmws3KxSyCNpc5dG303QRcbvvko4nfkt6gqXr69fe7HTu59HUXAgnYfKjhP8R8lcbxc4LPbquvlweibwwsJx0szvZZGPE8+5YjUVE9VPPU1Dy+eeR8srj1vecn/Bd4wigZBG1jfZaqDi1YbEX1d+i/NWXQ0bZNR0pIyYaSslb3OwxmftPvVZVi0XOINR27JwKiKrpvNzBIB/dU9Uaxu8lA0pHObfuvXqeur7/qAWeB+KeKrFvp4nZEZmacSTSAHfBB8m9+/eHo6sxp+B9fX9OWHjkzAIs43IiLCMefmqveG1Fh1XLVGPPBX/AAlADkNlgmfxkZPiWnvHerZedUaXuFjuEDKt3TVVK+OOnMMhnbKcFrXNA4eY+lhaDxI1rBFsVKx8tz3un38Vzta0jYbNpsNqGVLrfJ8HSzMwOJ/q4OXNaSAfYBIz1qt2u5XfTk1HWxMeaWvhE3RPPxFZCCWkteM4eN+8dYIOF+tERLpHUEZ4Q2gu9BWA5w0GVradwDvk57fFWzS1Fb77pOOhrGtkZBVVcMb2Y44nteXtfG4dYz/RfWYRMLX6i6xBhnlzx6G1wq1T19JLrShuFI53QVlyhcONvC5pqogx7XDfcEuB3X53t1XbtWV8tGPuplwZNSANDsyVEYwA122/ER5qajS+pLbdIY6eiqKxkFRBUQVFOGhj42SB2XlzhhwxuP6Kwam0zf7jffX7dFB0XRUTzLNOI8TwO4vkgE9QX3zI2vBB0svkRSvjNxrmuvzpG+lSpq6CWp6aOnZUwPmY+SigY6EOBeCyI8RGO5aE9jJGSRuGWva5jh2hw4SpbnDc8+EZ8V+dTM2mp6mod8mCGWZ3hGwvUW9+c6ABTccfLabknzWBEYc5vU1zgPIkKOf/AF6x4FSDnLutxLvecorGNtVT3GxNlsGkb0bxa2CZ4NbRFtPVdr8DMcuPyh9oPYqXrm0ihubK6FmKe5cT34A4WVTMcY/WGD71z9LXY2m8Usr3Ypasikq88g17hwSH6p38Ce1aXqa2C7Weuga3M8bfWabt6aIFwaPEZHmokj0acOGxU+0isprHcKtejip2vlETs19NWMH5xronY/Zaq56YaLhrLBcGt+/U1RRyO7TC8SNz+0V69Az9Hf8Ao/m1VBUxY/KY6OXf3FdT0t0ol09RVPzqW5xfszRvYf6LXq22lPitnDnZoAD0WGIiLVUgu9pCz/DmorRQPZxU/TCorMglvq0A6V7XY+ljh8XBbrra7fA2mrvUtdieaP1Km/PVGWZG/UOI+Sp3ois/R093vkjPanc23UpII+LZiWYg8sE8A/UK8Hpdu/S1tqssbvZpIjW1OP8AbTZZGD3hoJ/XRFwfR3bfWrvNXvb8VbYC5pPLp58xs9w4j5Bawq3om2/B9gpXubia4ONdLnnwvHDEN/yQD5rs1FytdJJ0NVWQwy8LX8D+PPC7kfZBC5RjckmIV7mxAuy6ADXbf5qfpskEIc82uvWi/CmrKGsbI6kqI5wxwa7o8+ySMjIIB3X7KvSQvicWSCx7HQreZI14zNNwpRfhU1lDRNjfV1EcIkJbH0hOXkc8AAnAX509ytdXJ0VLVxSy8BeWM4g7hHM+0Asoo5zHzgw5e9jb4rGaiIOyFwv2uvWi8U91s9NLJBPXQRzRkB8b+PiaeeDhpX5/Ddg3zcqb/wDT/tWVuG1jmhzYnEf0n7L4dWQNNi8X8wuii5/w3p//ANypv/0/7VBvmnwCTcqbA3P3z/tXv+l1v/S7/wBT9l56bT/9g+IXRRfhPWUVNFHPUzxwwyFrY3vzwuLm8Qxwgncbr8obpZ6mVkNPWwSzP4uBjOPidgZIHEAMrC2iqHsMjYyQOtjZZHVETXZS4X817ETC89VW0FEIvW6mKHpeLo+k4va4cZI4Qe1YYoXyuyRi57BZHyNYMzjYL0IvNTV9urTI2kqYpzEGmUR8XsBxIBPEBzwV6F7JC+J2SQEHsdEZI2QZmG4UooUrEvtEUIiKUUKUREUIiL6KhSVCIpDSXNa0ZcSGtHa48sKxUsDaeFkY3PN56y48yuda6ficahw2blseet3W7/P9F6bs27Pt9ZHajEK6SPo4XTPLGs4tnOBAO4GeHvXSuFsM5bPSZN3aDwH91AYjUXORvRZtrW9i5XH1OB+aK3F8YLT7MtT8mR/gPkt8D9JVVdKtsOoLcD63bqkMH9rEOnj26+OLP7lzMtdnBG2xHYe9dVhDWsDWrntSXvkLpBZF+sE8tLUUtVD99pp4qiPvdG4Owe48vNfmgWYgEWK12ktNwtplo7Fqe3UVRPC2aCaJs9PIHFk0JeNw17CHAjkRnmO5cuLQOlo5A+QVszc7RSVLxH4EM4TjzVY0dqRtqldba5+KCok44pXfJpp3nfiP0XdZ6jv1krU2kEZGCDyPUQoKUSQOLQdFaYDFUsDyBdeeG322npm0cNJTspWgAQtjb0Wxzu3GF+7GRsbwsY1rfosAaPcF9bItQkndbwaBsmBsiJ2psvUVU1zc2UVodRtcPWLk7oGgHdsLSHSv/c3zVgr6+jtlLNW1kojgiGST8pzupjB1uPUFjN6u9Veq+atnBa3HR08WdoIQfZZ2Z63d/wBm5SQ8x4cdgo+vqRFGW9SuailQp1VVCAcg9YWz6WuRulloJ3ninhb6rUk8zLAA0k+IwfNYwrz6PK8x1lytzj7NRE2riH/Ei9h4HkQtGtjzR37KTwyXJLl6FeenpRaNfU1O0cML62V0OOXRVcEha3fszhWT0jQCfR97P+x9UnH6k7B/VebVVMItRaJuLQRx18FHKQNgWzNczJ7+J3uXV1qzpNKamb2W+R/7Dmv/AKKNndnDT4KbpWctz2+P6r+al9MY97msY0ue9waxrRkucTgAAKFbPR7aPhbU1uD2cVPQcVxqMgkYhI4AfFxatZbq3OwW6GwWC10LyxjaGjD6p52b0pBmmec9WS4rAZpJ9W6rlk9r/wBVuWwOzo6UHAG30WADyWx+ke7/AAXpitiY7hqLq4W6PBGRHIC6Y4O+OEOb+sFnXo3t3HU3K6vb7NNGKSDPXLNu8jwaP7y0MRqvRKV83YaefRZYWcyQNWmhrGNayMBrGNDGNHJrGgNAA8FRtV/jc5P+p0v/ADK8/wCfFUXVn43/APh0v/OqXwQc2KXP/Fyy8RgCjt4hc613Ge2VbaiPLozhlRHnAliz+8dS0eOopZKcVjZW+qmH1gynAAixkk/uWYGCZsEVUWfEySyQNcD/AGjAHFp8jkL9W3CtZQzW4PxSSyiZ7Mbgjm0H6J5kd3vvGPcOxYu9s0RAcDZx7gb+8KuYbir6Bjo3i4IuPNftdri+6VktQciFgMVLGfmRDt7zzK92lM/Csm/+oz/aWrjGGUQQ1JaRDLLNDE4/PfCGl2O4Zwf8F2dKfjaT9Cm/iat3FoYYMGlig9lrbaeBWvRPfLiDJJdybr97xY71V3S4VNPTNdDNKHRuM0LSRwgcnuC49ba7nb2RSVkQjZK8xxkSRvy4DiI9hxWl9arWsPwS1nr9am/lKn8PcUVc9RDQlrcu19b6DzU/iuDQRxSVIJzb/PyVTpaWqrZ2U1MwPme17mtLg0EMGTu7Ze92m9QlrwKRuS0gfdEHZ9dfWmvx1Sfmqv8AlrQFK8S8S1WFVXIhaCCAdb/Sy0cIweGtgMkhIN+n+FW9UNcyz0LSMFtVTNduD7QgeMZGyprXPY+N7HOa9jg5jmHDmuG4IKuurvxZTfp0f8uRU6mpairdOyBnG+GnkqXMHynMYRxcK3eEpGnCc8psLuv8f0WvjjCK7KzewV9st3bdKYh3C2spwBUsGweOQlYOeD19hyuVrLlZt+qsH2xqsUlXUUVRDVU7uGSM7ZzwuaT7TXjng9a7moa+muNJY6mDYH1tssbiC+GX4vMbv6HrBCjmYAcPxqKogH+04n3G37stt2J+lYe+KX2x81+2jvv133/saU/3pFb9+tU/Rv367fmKX+ORXDtVM4w/NpPJv/yFYMA/At9/6oiIqkp1EREREUKURERERSVCkqERdCmuJgYyN8Ycxo4QWnBx4Fe+O4UcmBx8B22kHDv48lwEVlo+I6umaIzZzR3+60JaGN5vsVaQWuGWkEHswQuXcNPafueTV0FO6QjHTMb0UwHdJHh32rmMlli3jkez6pIHmOS9sV0qWkCQNkHbjhd9mytVJxZTvsJQWH4hR02GOtp6wVZuHo6HtPtde5p5iGvbxt8BNGA73tcqhcLFfrXxmtoJmxN/t4R00GM8zJGDjzAWyRXGlkwHExuPU/l7xsvWC1wyCCD2bgq40eLsmbeJ4cFAVGFMO4sV/PoII55B/wA9Ss1h1fcrM2OlmHrdA3AbE93DNA3siecjA7CPMc1fblpLTtyL3upRT1Dsnp6M9C4nnlzR7B82qk3TQl8o+KSicy4QjJ4WDo6kDvjJ4T5FSwnhnGV6ijSVFMc8evkr3b9UaduIaIq6KKUjeGrIglBPzcSHBPg4rtNwQCCCDyIOR9i/n+SOSJ7opo3xyt2MUzCx48WuAP2I2SRmzHvYPyHuaPsKxuoRf1XLMzFHDR7brfZZoIG8c8sUTBzdK9rG+9xCrN01xYaFr2UjzX1I2Dac4gB/KnI4f2Q5ZO4l5y8lx7XEuPvKhfTKBoN3G6+JMVcRZjbLpXa9XS9TietlyGE9BDHlsEAPPgbk7nrJOVzURSDWhosFEPe55zONyiIi+l8Iupp6rNDfLLUZw31pkEm+Pi5/iiPeR7ly0LnNBew+2zEjD+Ww8bftAXy8ZmkFZInZHhy2TVFP0tHapgMmivtmqc9xqWwE/wB9fWrgDpjU4PL4Mq/savZIG3K0wObuKiKiqWY7WujnH2heHWbgzS2pyf8A22oH7WAq2drK5MHrFw62X80LbvRNaPVrPWXaRoEtzqOjgJGD6tTEsyD3u4v2Vi1NTz1dTS0kDS+epnip4Wjm6SVwja3zJX9Owx0OnLHGzIFJZ7d7TiQ0vbTx5LjnbLiM+JXwsqx70q3b12/w22N2YbRThjgCCPWagNlkIx3cDf1Srhpa2/BditlO5uJpYvXKgEYIlqMP4T3tHCPJZdaIJtS6nidVZeKutlr644yOia4zSA+PyR4hbYTkknmTvjllUXi2rs1lKDvqfopXDo7kvTsVF1Z+OP8A4dL/AM6vXaqTqiCqluznRU9RI31WmAdFE97duLbLRjK0uCntjxK7zYZTv7lr8RNc6ks0X1C9+naWmrbHXUtQ0mKWsmBxzYQxvC9p7QuU3St6dUNieIW05l4H1DZW5EQO72s55xyXe0tHNHbZmyxyRuNZI4NlYWOxwt3wRld5Z6ziKqw2vqG0zgWucfG3iFjp8Khq6aJ0oIIA/ZVR1XBDTU1hp4GcEUPrTI2jqaBF/wCSvHpP8av/AEKf97V0tXRTzNtIiilkLXVfH0Ub38PEIwM8IK8Ol6eqiub3yU9RGz1OZodLE9jSSWkAFwG6sFNVNfw1JneC8g9dd1FTwluLtyt0BHTRXbsVa1j+B2v9Kl/lKycwq7qyKaWltrYopZXNqZS4RMfIQOjxkhoKo3DLgzFIS42F1ZcZBNG9o3XC0z+OaT81V/y1oComnKaqjvFK+SmqWNENTl0kMjGAmPrLhhXv/qpbjeRkle1zCCMo21Wjw41zaUhwtqq9q78WU36dF/LkXF0mT8Lu/Q5/3tXd1VHLLbadkUUkjxWMcWxMc93D0bwXENC4+mKeqiurny09RG31SdvFLE9jckt2yRhTOFzRjhqVmYZrP6qOrY3HFmOANtF96ls3q7n3CkZinkdmqjaM9DK4/fGgfNPWqz/itYcGva5j2hzHtLHNcAQ5p2IOVQbzY6igqR6rFNNSTFxh6JrnuiI5xvAydvm9oW7wpxEJmeh1bvWGxPUfcLBjeEmJ3PhGh3A7r36N+/Xb8xS/xSK4dqqekYKiGW59LBNGDFTBpljcziIdIcDiCtipXFzmvxWQtNxZv6BWHAmltE0OFt/1RERVRTiIiIiIoUoiIiIikqFJUIiIoREUoiL1eIvuOaaI5je5vgdj4g7L4UL7jkdGczDYrxzGuFiF1Ibq4bTx5/Kj5+4roxVFPOPi5Gk9bSfaHiCq2pYMub7Rbvu4EjhHW7I7FaKLieqhIbN64+fxUfNQRu9Zui7VxtFpu0fR19JFMMey9w4ZWd7JG+0PeqHd9AVsHHNZ5vWYxk+rVLgycDsjlPsnzx4lePT/AKQb/ctT/BLIKeqt9bXSspuL4qalpY8uMgkYMEBrXOwW5PatWGT17rqlPUytaDtfoqzPSxykhwWAzw1FNK+CohlhmZs+OZpjeO/DgvzW53O02q7Q9DX0zJsAiN/yZoj2xyN9oHzWdXrRF0oA+e3l9dSDLjGABVxN+oNnDvG/cpiGsY/R2hUBUYdJHqzUKoop2OccwSCDsQRzBB3TC3lGbKEREXilAoRF6Fs+kZjPpyxOJyWUogJ/MOMX9F5NfyCPSGoyTgup4Yx38c8bcL50HJx6cp2H+yqq6P3zuf8A1XP9KU3R6TnZneorqKHHg50v/Kq1MLSO81dKc5omnwWfei60fCOovXntzT2eF1TuAWmplzFC0/3nD6ivPpUu/qNhht0b8TXecMcA4Z9WgxI8457nhHmvT6MrR8G6ahqpG4qLvK6tdnGRD97hAI6iBxD66zf0kXV111PU08JL4bY1ltha05DpmnilwB18R4T9VY/FZl1vRtbeCG53Z7RmVzaGnJBBDGYklI7ieEfqlaB/krwWa3ttVqtlAAA6np2CbHXO/wBuR3vJXuXGMXq/S6x8o22HkNvurPTR8uMBSmSNskeBKbIosE9FsWum6KN1KFeBASOsjwTJPMk+JKImY7L2wTbqQcQ6z5Ii9v2XhshJPWfeURF4SV6BZAT24QknrJ8yihMx2S2t1KDI68d4REBQhMk9ZOO0omyeC9JvqmyIiL4XqIoU+S9ARETmiWRERQvEX0VCkqERERERERERERECIuJqu4/Bdguc7XYnqGeoU2OfSVAIc4eDeL3hdtZl6Sbj0lZb7Sx3sUUJqaj9InGw8mge9TeB0fpVaxp2Gp8h/dadZLy4yuv6IrRxzXi+SNy2FrbbSkgEdI/hmmcM7ggcA/XKt+vbk+lttPRwyFk1fO0uLHFr2wQkPJGDnc8I966ekrR8B6es9A5uJxAJ6vYZ9YnPSvBI+jnhHc0LPdZXH16+VTWuzDQNFFEMgguZkyOGO/byXWKmTJHpudFi4eo/Sq1ocLhup+i9tn1xcqLgguQdWUzcNEgI9ajHjyd5+9aNb7nbbrAKihqGTR7cYGQ+N30ZGH2gfJYSvTRV1db52VNFUSQTN+cw7OaPmvafZI7iFpRVbmWD9QrlifDUFTd9N6rvkVq1+0la7yHzsApa/BxUxNGJD2TsGAR38+/ty+52m52ef1euhLC7PRSNJdDMBzdG/GPEc1oun9Z0dyMVJcBHS17tmOaSKeoPL2C7k7uJ8FZK6goblTy0tbCyaB/Nr+bT1OY7mCOoj/zP01bYaG4XJ8UwV8UhZK3K79Vg6Kxai0tWWNzp4i6e2ucAyfHtw55MqMfY79x2VeU8x7ZG5mqoSxOiOVyIoQL7WNap6PTmxzDsuNUPeGO/quZ6SqeW5nR1jhcekud3dxBpGWxxsDHPwfohxPkun6PRixTHHyrjVn3cAXpdT+v60FQ5oMNgszI4842rbjI4nGexjR+0q5P/ABHK40v8Fq6V0raTT1irqxrWNgtdDw07DgNLmNEUMfmeFvmsE0hRS3fUVPLUcUrad8lyq3v3L3NdxAuJ6y4hX/0uXfoaG12SJ/t1kprakA4PQQ5ZG1w7HOJPjGuf6O7d6va6q4vbiS4zdHGSNxT05xt4uz+yoHGqv0Sie8bnQe/+ykqaPmSgK7czk8ycoiLjZ3VnReerrqCgZE+smETJXuYwlsjuJwbxYwxpXoVZ1h+CWz9Km/lqWwaiZX1sdNIbBx6eS0MQqHUtO+Zm4XR/0h07/v478Q1B/wCRdKCenqYY6iCQSQyDiY9ucHqPPfbrWVBd7Tl39SmNJUP+46hw4S7lBMdg76p5HvwVfMX4LjgpnS0ZJc3Wx6jr71WqHiF8koZOAAeqvSIO8DZeesrIKClqKycexEMMZ1yynZkY8Tz7lzOKF80gjYLuJt71b3ytjYXu2C/KrutqoJWw1dUyKV0bZODgke4MdsCeBpxnqX4f6Q6eOAK4EkgAdDPuScAbsVAqKieqnqKqofxTTPdI89QJ2w3uHUvzZ8tn5yP+ILrMfA1KIQZnnMBr2v2VIdxJMZLRtGVav/gif4fuRcicLGyvTTcAomE8kOBuvmy9uiJzREuocWsa97jhrGOe877NaC4nbdcsah07z9fbvjlDUf8AYujUfg1d+iVX8p6ypvIeAV24XwGnxdshnJGW23iq5jOKS0JaIwNVp1Jc7XXukjpKlsr42h728MjCGk4yONoXr/wWXUlVUUdRDVQO4ZYjkc8OaflMcOw8itIoa2nuNNDVQfJePbaflRyD5THd4+3n1rFxJw4cJLZIiTGevYrJhOLemgtfo4dl6V+dRUQUkElRUytigj4Q57sndxwA0N3JX6gOJAHzjgeKompLqK+pbSwPzR0bnNaRymm5OkPd1Dw71G4Fg78WqhEPZGpPYLcxKvbRQ5zudgrN/pFp3/f2+UNR/wBi9tJW0VdE6akl6WISOiL+F7faaASMPAPWsuKvOkvxXL+mz/y4laOIuF6XDKL0iFxJuBr4qFwrGZq2cQyAWsSu+o2Upg9i5wrbdSVCk81C8XqIiIiIiIiIiIiF0cbZJZTiKFj5ZXHkI2NLnZ8gsl07BLqzW0M8zSYn1r7nUg49mnp3B7WEHqPsN81ddcXL4P0/UxMdie5yNoY8cxFjpJj4Yw39ZfPojtJiorreZG+1WSijpicfeofae4eLjj9VdJ4SpMkLqk/zGw8hv8/0UFiMl3Bg6LRLrXNtttuFc7/VoHvYO2Q+yxvmSAsKc573Oe8lz3uc97jzc9x4nE+JWj+kO4cFLb7XG72qh5q5xn+yh2YD3F2/6qzcqerH3flHRXrhSk5VMZyNXn5D+6IiLRVwU7ePI47xyV10zrKSlMNBd5HSUuQyGreeJ8A6mynmW9/Md/VSU/8AB7+5ZI5HRm7VoV2Hw18fLmHkeo9635zYKiItcI5oJmEEHhfHJG8dnIgrLNVaWfZ3uraJrn2t7/abkudSPcdmuzuWHqJO3Lx/bSWqnW6SO23CQm3yODYJX5JpHu2wT/sz9nhy02WOGeKSKVjJIpWuY9jwHMexwwQRywrDSVdvWHvC4zjeDPpnmKUeR7j99FgW6Lu6m0/JYa3EfE6gqS59HI7csxu6F57W9XaPBcIc1ZGPD25wqDLE6JxY7ota0Ezh05Suwfjamuf4/dD2f0Vgp6VkD6yQYMtXUdPK7G5PC2NozzwAAuXpKIwabsLSN30jZz4zEy/1UauuwsunrxXNdwzCB1PS88+sT/FMIx2ZJ8lXpjeRxVwgGWNo8Fh2r7hLqLVleac9Iw1UdsoACeFzI3dC0tz1OOXfrLXKKkit9HQ0MX3ukp4qdp+lwDBd5nJ81legLd65fBWPHFFbYnVBJ3BqH5jiBz+s79Va51rm/FtVmkZTA+yLnzKn8OjsDIiIioxUuirOsPwS2fpU38tWZVnWH4JbP0qb+WrLwt+bQ+f0Kh8a/Ayfvqqb1YTAO3POxHb3KCcBx7N/FeutoZ6F9OJN2VNPFUwSAYD2vY1xG/WCcH/Fd7dLGxwY46nbxXMGscWlwGgVs01dnVcbbdUPzVQsJge7bpYW42yebm9fd4LiaiuvwhVdDA77ipC5kWDtLLydN/Rvd4risc9jg5rnMeM4c0kOGQRzHiV8nYcj2ANG56gAB9ir9Pw7S0uIvrm6E7DsepH70UtNis01M2mJ2+YU4Ut+XH+cj/iC9FbRz0ErKefHTGngmka3kwysD+DPdyXnZ8uP85H/ABhT/MZJCXMNwQSowMcyQNduCtX7PL9y81dX0Vuh6erkLWk4jYz2pZXdjG/vPJelzmMa+SQ8McbHSSHsYxvE4rNLncJrlVy1Upw0uLaeMcooc7Nb48z3rhvD2BHF6k5zaNu/2XR8UxL0GJob7R2+66tXqy6SucKSOKkjzsSBLMfrPft7gvAdQai4s/CVR4Zbw+7C/C3W+pudS2mgLW4aZJpXglsUY2yQN8nkB/02sb9H0nRkR19R02NnSRxmMnvY0ZA8HLos7sBwdzaeRrQbdrn3myqcTcTxAGVhNvO3wXipNV3ONzRWRxVUfWWtEU4Hc5ox9itlFX0dwgbPTPy3k9rhiSN3Y9qzirpJ6OompahobLEcHByHDmHNPYV+1ruEltrIahhPRFwZUs6pIicHPeOYWpjHDFHXU/pFCA11ri2x93is9BjU9PKIqg3GxvuFo9R+DVv6JVfyXLKm8vILVZyDSVhByDSVJae0GFxBWVDkPALR4ABDZ2nuPqtjicgujt2Kdi61juptdT8YSaOfDalg+b1CVo7R19y8sFFPNSVtZH7TaOSNs7APaEbx988B1rycs9h27e5X6ohgr4pKZ+o2Pgf3qq1C+Wle2Vmh3Hir5qK7Cio209O8Gqr4zwuac8FK4YMg73cm92VQscv8lfRc53CXOc7ha1g4iThjeTRnqC9EdHO6iqq/GKeCaKmBI++yvJy1v1eZUdhOGQYLT8u+rjqe5OgC2q6slxCUyW0A27LzK86T/Fcv6dN/LiVG8FedJfiuX9On/giUXxr+Vn+oLc4d0rR5Fd8loDi5zWta0uc5xDWtaOZcTsuM7Uunmuc31id2CRxNidh2OsZGVzdWXJ4MdrhcQ0sbPWEc38XyIj3Y3Pl2KpYCrXD/AAhHWUoqau/rbAdu581L4pjz6ebkwdN1rJUKSoXMlclCKURERERET/FF+dRUw0NNV102Oio4Jap+evoxxBu/acDzX2xpe4NaLkr5c7KCSst9IFdJX32ntkGXi3RspWMbvxVc5D5AO/Ja39VbdYrZHZrRarYzH3JTRxvI5OmI4pHebiSsS0DQzX7V8VdU/GNpJJrxVOdnDpg/Me/bxlp8GnsW8zskkhqImPMb5IpWMkHNjnNLQ8eC7fRUwpadkI/lH+fmqtI7mPLj1WNaluHwnerjUNdxQsk9Vp8HI6GA8AIPYTl36y4699ws13tTnMraSaNjSWtmDXPgeByc2Ro4d14OrPVhRUl8xzLtdCImwMZC4FoAGmqIiLGt26IiL1FP7uw/uK0jQ1/fUx/A9XITNAwmiked5IG84yest6u7wWbL9qSpnoqmmrIDiamlbNF3lvzT3HkfFZYZDG+4UVi2HsxCnMZ33B7FbZeLVT3i31NBMAOkbxQyD5UMzd2SDwPP3daxGqp6inlqaSVhbUQyPpnsHVKDwbeO2PFbrQVkNwoqOth+9VUDJWjs4hktPhyVM1LYxNqfTNTG0dHcaqJlXgfPo/j+I+IGD4K10c4bcHYhcFxGjLnA21BsVdaKAU1HRU7eUFNBCPBjA1ZT6XbvmS0WSNxwxpuNUATjidmKJp6thxHzWvEgAlxAaASSTgADckkr+a7pUTat1ZUyRFxFyuLYKfnllM0iJhwexgyfNaL3BoLnKRY3QNC0DQdu9RsMU724muUjqtxxgiIfFxt9wLh9ZWor5jjjhjihibwxQxshjaOQYxoa0DyC+lxCvqTVVL5j1Py6K1ws5bA1FClFpLMirOsPwS2fpU38tWZVnWH4JbP0qb+WrLwt+bQ+f0Kh8a/AyfvqqW75Lu8FaJNborpZqGncQ2QUlI+nl645RC0DyPI/4LPDyPmtRofwG3fodL/Kar/xtUPpm08sRsQ4n5Kr8ORNmMsb9QQsynjkpppqecCOaFxZIxxwQRsu/pi1iqm+EZwDT0zsUwPyZZxtx+DP3+G9xfTUkjy+Wmp3vIGXPiY5xxsNyF+jWMja1kbGsY35LWANaO4ADCgsQ41kqaM08TMr3Cxdfp1t5qTpeHmwz8x7rtGwVD1T+OKjt9XpMf8A1hcVh9tn14x/eC7WqfxzP+jUn8sLis+Uz85H/GF0PBvyqL+gfoqpXfjn/wBX1Wj3t7mWe7uHP1UM8pJGMd9hKzfGADkf9epalV04q6WrpScCogfECeTXFvsk+BwVl8kckT5I5QWyRvfFI1wwWuacEYVV4ElZypov5s17eCm+JI3cyN/QhWrRwbw3h2Pb4qZp7eABxA95P+QrZ/5Pcs7sl0FrrHSSNc6nnjEVQG7uaActe0Zxkb+RKunw3YeDpPhKnDMZwS7pcfm8cWfJV7izCqo4g6aNhc19rEC/QCxUrgdbCKVsbnAFt91XdYxtFbbZAMOkpHB57mSOa0KsOxwuB5EEHwwupe7ky6VxmjDm08UbYKZr/lcDd+Nw7XHdeKkpJa2pp6SIZdUPDSRn2Yxu95x1ALpODMfQYXEKnQtbc+A3sqhXvbU1jjFrc6LRKYvdZYi7PEbS4uz2+rlZoOTfALVJWtZR1bGbMZR1DGZ+i2BzQsrbyHgqtwQ8PNS4bFw+qmeI25BE09Afordo4B0d5a5ocHSU7XB3JzSxwIK5N+tJtdRxRj7iqHEwHqjd1xHw6u7wXX0b8i7/AJ2n/hKtEkcMo4ZY45Gg5DZGtcM9uHBRVfjcmEY7M8atNrj3D5qQp8OZX4bG06EbFZjQ0s1wqoKSnI6SY7uGCIox8qR3h9qt9/pqej0/HS07eGGGopWs33O7tz3nmT3ruxwUsJLoYIYiRhxijawkdmWhcjVP4nf+l037yvh/ET8XxSma0ZWBw08e5+i9GEtw+jmcTdxB18FQledJfiuX9On/AIIlRgrzpL8Vzfp0/wDBErVxr+Vn+pqg+HfxnuKq97c594uzjz9ae3ya0Ae7C52O8Lu6oo309ylqeEiKtaJmOHLpGgNkbnt68Lgbf5yrBg8sU9DE9h0yjb99FGV8bmVMgdvcrWyoUnmoX5uXXFCKUREREREVN9Idy9Us8FAx2JbnP7YB39XpyHHyLsfsq5AEloG5JAA7SVkeq55dQ6sZbqQ8TY56ez0nW3j4wxzjgcuIuJ8FZuG6T0itDyNGa+/otCukyR2HVaJ6KrR6lYZ7nI0ia71Be3Ox9Wpi6KMYPaekPfkK+vmp43RMlmiY+U8MTJHsa557GBxyV8UVHBQUdFQU7SIKOnhpYgTkiOJojGT24G6/mzVN1qrvf7vWzOk/CpoYGPc74mGJxjYxo6uWT3k9q6uq8v6ZLGOaWuAIcMODhsR2EHZV+46O03cC93q5pZ3ZPS0Z6I5P0mD2D7liFo1zrCy9GynuMk1MzAFNXfdEPCPmt4zxgfVcFodn9Llqn4I71QzUbzgGekJngJ6y6M4kA8OJfLmNduFsQVE0Ds0LiD4FfFw0BeafL6CeGsjGSGP+JnA7ubCfcqrV0dbQyGKspp6d/LE7C3P1XfJPkStzo6ykuFLS1tI/pKaqiZNA8sewvjeMg8LwHDzC/SWCnqI3RTwxSxuGHMla17SO8OWm+iafZ0VnpOLKqPScB4+BWAcuaLWLjoXT9WHOpRJQSnJBp8OhJPbDJluPAhU64aI1HRcb6dkddC3cGmPDNjtMMhz7i5aT6aRvS6ttJxFQ1OhdlPY6fPZVhF9yRzQvdFNHJFK04LJWljh4h2CvnBWvqN1YGkP1Gq030e1rpbbW0LiCaKq42D6MVQOkA9/Grm6ONzo3Oa0ujJMbiASwkcJLT4LNPR09wuV1i+a+ihefGOUgfxFadspqldeIFcf4ghEWISAbHX4qp+kC7/BGl7m5jsVFeBbKfHPNQCJCCDnZgeQe3Cy/0c27prhW3N7Mx0MQhhJAx6xPkZHg0O969vpau/rV5obTG74q10/STAbfdNUGvIPVs0Mx9Yqy6Qt3wbYLfG5oE9UDXVG2HcU2CwHwbw+8qG4iq/RqJwB1fp9/ktCijzygnYLvoiLkisYRQpRERV7VVNVVNNbmU8E0zm1EznCFheWgx4BOFYU2HXhSWG1rsPqWVLRct1stSrp21URhcbArMnWq84d/6fWbA/2Llo1G1zKOhY9pa9lLTNc07EOETQQV++cnOftTZS+NcRS4wxrJGBuXXS60MNwllA5xa4m6IiKr3UzZUrUdDcai7TSQUdTLGYKVvHFGXMy2MAjIXJZa7xxMzb6wDpIySYXYADgVpeduSZPaVfaTjOopaVtM2IENGW+qrM3D0c0zpi8i5unZ4BcK92Blyd6zTObFWYw/iz0dQGjDQ48w4cgff3d1FUaLEJ6GcTwGxCnKmljqY+VILhZdU0ddRPLKqnlhIyMvbmM+D25YfevNxs+mz3jK1rOdiMjsO49y+OhgB4hDEDzyI2Zz44XQoePyGf7sF3dw630VWk4XGb1JLDyWa0dsudwc0UtLI5hO8soMcDe8vdzHhlXi0WWntUbncQmrJm8M02MDh/2cQO4aurxZ57qN1XcY4rqsTYYQMjOw6+ZUtQYLDRuDybu8fovicE09W1oJc6mqWgNGS5zo3AALNm2u8YGbdWjxhctNTJO+TstbA+IZcHa9sbA7Nbe/TyWTEcKZXkFzrW7Kt6UpaumZc/WaeaEySQFgmYWlwDSCRlWQ7pzRReKV7sQqnVThYu6Leo6YUkLYWm9kXH1JDPPanRU8Uk0nrNO7giaXOwCcnAXYTluNj3LBRVRpKhlQ0XLTdfdTAJ4nRE7iyzL4LvI//nVv/wBJVx0xBUU1tlZUQyQv9cmfwytLXFvBGAQCu5k57Ah9rmrRi/FU2KU5p5Iw0XBuL9FEUOCR0Mola8leWvoaW40z6aoaeEniY9uz4pAMB7CdshVR2kLkHODKukLASGk9ICW52JGFde5M9w9wUXhvEFbhjCynd6p6FbVZhdPWEPkBuOyk81Ck81CryllCKUXqIiIiL6Znjbjn83PU7GyxzSVTBRa1tM9c8Ma241UUrpNg2WZssLS7PL2iMnqWwjtzg9R7D2rMNb6XqoaupvFBC6SjqSZayOJvE+mlPynlo34HcwfHOOu58K1ccMz4Xmxda3u6KLxCMuaHDot43PPqPUqVfvRvpm9TVFZGZqGtncZJJKXhMMkh3LnQu2yeZwR29e+dWP0m6mtMcNNVtiuVJEGsaKkuZUtY3YNbO3/ma5aLaPSZo+58EdRNJbZ3YBbXgCEk/RnZlmPrcK6UoNZzdvRfq2g430bYblC3fNK7gnA33MMpB9ziuLpyxzVuprLZ6+CWDpaprqmGojfG8wxNdO9pa/B9oNI81/ScUsE8bJoJY5YnjLJIXtexw7WuaSFD6emklhnfFE6aHiMUjmNL4+IcJ4HEZGetEXN1Bd4NPWW4XN0YcKSJjYIR7IfM9wiij26skZ7vBY1R+lHWVPUyy1D6WrgkkLzTTQhjIx9GJ8eHDHVkla/qmw/6R2WqtTagU8kkkE0Ur2dI1r4nh2HNBBwRkc+vrxg4hdvR9rO08b3UBradv9vbCagY7TGAJhjrJZjvRFq+lvSDadSVMdu9VqKS4Pikkax5bLBJ0beJwZIMOzjJ3b1e+6c1iPossFfNeTe5YpI6O3RVEUcj2lomqpWGAxtzz4QXF3YcDr2uHpPvE9rs1BHSVc9PXVNwjfC+mkdFII4GOc88TCDjJaPNEV0rLfba9nR1tLBUN5ATMDiPqnmPeqlX+j+2zBz7dUzUkhyRG8dNBnsGcPHvVBtHpV1PRcEdyip7nCNi54FPU4xjAliHB74z4rQrR6R9G3QsjlqX2+odgdFcQGRk/kztJj95Hgsb42P9oLdpsQqaU3heR++y+dI6cu1luFylrRCY308UMEkL+ISe2XOOCMjGBt3q4VNRDS09TUznhhp4ZaiY4ziONpe448Avpj45GMkjcx8cjQ9j4yHMc0jIc1zdiD4qj+lC7fB+nHUbHYmu07aUAc+gZ8bKQc/VH6yMYIxlavmsrJa2XnTb/ZZHSMn1Vqlrpsk3O4S1VTj5kAcZngZ7GjA8ltu22BgbcIHIDqCzn0b23e6XZ7eQFBTHvOJZT/AB4laMua8VVnNqhC3Zg+Z1P0Ulh8WVmY9UREVQUmihSiIihSiXRRgKURe3JRFClF4iIURLpZFClERFG/apRLrywRQpRF6iIiXRERERQpRERN0RERFGB2KUS6KTzUKTzUIihFKIihFKIiIDjBGxHZlEXtyvCFxrlpjTd14nVNBEyZxJM9KBBLntJZ7J82qm3H0bVTOJ9qrmTN3LYawdFL4CRmWE+QWlpv8A0U1SY3W0gAY+47HVastJFJuFiLRrPSk3Gw3K3O4slzC4U7zy3LcxO+1W+0+lu8U/BHeKKGtjGAZqcinqMdpbvGfcFf3Br2uY9rXMcCHNe0OaR2EHZVy46K0vceN4pnUczj98oSIxnviIMZ9wVspOLYn+rUsynuNR9/1UdJhzhqwqyWnXujrxwMjuDKad23QXDFO/PYHuPRnu9pWgEENIIIIBaRyI7isAuPo7vlNxPt80FdGNwz7xUY+pIeA+T/JcqkvetdLyiGKpuFEWkn1aqa50DuonoZwWeYCtVNW09WLwPB/fZR74nx+0F/SuB3rP9a6DuOpasV9PdgySKEQw0lVGegY0bngkZkgk7klp+zbiWj0vEcEV8tmeo1NtO/LYmCY48cSDwWg2jVOmL2Gi3XOmkmP+ryEw1IPMgQy4ecdZAI71ubLGsBu2j9V2UvdW2yfoGk/dFOOnp8DrL484HiAuCM52X9bYHIjn1d3/AEXDrtIaPuU7amss1G+cP43PY0xGR3/F6ItDvPKIuP6NIK6HSdAap7i2eeqnpGOBBipnP4WtGeokOcO5yzj0nXYXHUj6OM8UNpibRtA5OnfiSXGO8hp+qttuFXR2S1VtYWMjpbbRPkZFGAxgbEzDImAbDOzWjvX896ZpJ77qWnfUnpM1Et0rnEfK4HGVxwNt3Ee9YZ5WwRuldsBf4L6Y0ucGharYLcLVZrXQluJI4BJP2meX4x+fAkj/AMLpL6O+SoXD6iZ08rpXbuJPxVrY0MaGjoihSiwL7RQpRERQpRERQpRERQpREUIpREUIpREUIpRERQpREUIpREUKUREUIpREUKUREUIpREUnmoUnmoXiIiIvURERERERERERETdN0RERfnPT01VE6GqhinidzZOxsjPc8Ffoi+mvc03abFfJAOhVQuWgNO1fE+jdNQSnJHROMsGe+OQ8Q8nKnXHQmpaDifTxx10Td+OkPxoHaYnYd7srYE5clY6TiOtp9HOzjx++60pKKJ+wsset2t9cWF/QGsnkZGcPpbqx02O743Eo8nBXq3+l63Pj4bpa6mKYfOoXslid+rKWuHvK71bbrZcmdHX0dPUt6uljBe3PW1/ygfNVOs9HNhme59JVVdJnfozwzxj6peQ/3uKtVLxXSyC0wLT8R9/ko9+HyN9nVcTWPpBqdRwfBtFTvpLYXNfOJXNdPUuYeJok4fZDQcHAJ3HPbA7fo/s01DQ1FyqY+CW4iMU7XD2xSM9oOx1cZ3HcO9eq16D07QSsnn6eulYQ5gquFsLSOR6Jmx83HwVs55UVjnEEVTCaem2O5+gWxSUbmOzvUIiKjEqXCIiLxERERERERERERERERERERERERERERERERERERERERERERERERERERFJ5qF9EblRhNtF8r5RThMIvpETCYREUKcJhERQpwmERFC+kRFCKUwiKEU4UYRFCKcJhETsRTjkowl0RQpwmERETCYREUL6wowiIinCYS68uoRThMJdLqEU4TCXS6hFOEwl0uoRThMJdLqEU4TCXS6hFOEAS6XUIvrCYXl0uvlF9YTCXS6+UX1hMJdLr5RThThe3S6+UX1hMLy6XX//Z',
                context),
            _buildServiceBlock(
                'Airtel Money',
                'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAsJCQcJCQcJCQkJCwkJCQkJCQsJCwsMCwsLDA0QDBEODQ4MEhkSJRodJR0ZHxwpKRYlNzU2GioyPi0pMBk7IRP/2wBDAQcICAsJCxULCxUsHRkdLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCz/wAARCAEOAX4DASIAAhEBAxEB/8QAGwABAAIDAQEAAAAAAAAAAAAAAAEGBAUHAwL/xABLEAACAgIBAgQCAw0EBwUJAAAAAQIDBBEFEiEGEzFBUWEiMnEHFCM1QlJ0gZGhsbPRFTNydSQ2c4K0wfA0RFOy0hdDVWKTlKKj4f/EABsBAQACAwEBAAAAAAAAAAAAAAABBQIDBAYH/8QANxEAAgICAAQDBgUCBQUAAAAAAAECAwQRBRIhMQZBURMUImFxgRUykbHRM6EjJDQ1wUJy4fDx/9oADAMBAAIRAxEAPwDR7Y2wDzZ93G2NsAAbY2wABtjbAAG2NsAAbY2wABtjbAAG2NsAAbY2wABtjbAAG2NsAAbY2wABtjbAAG2NsAAbY2wABtjbAAG2NsAAbY2wABtjbAAG2NsAAbY2wABtjbAAG2NsAAbY2wAAAAAACQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAACQAAAAAAAAAAAAAAAAAAAAAAAAAACG9AHvi4mZnW+Th0WX2bSarT1Hf50vRFrwfA2RNKzkspVL18nGScvsdj/oba6Z2dkV+ZxPGwl/jS0/Tz/Qpr0u7aS+fYjrh+fH9qOp4/hnw3i66cKu2S/Lvbslv5t9v3Gxhg8XFJLDxkl7KqH9DqWFLzZ5yzxZRF/BW39zjicX9Vp/YDruRwPh/KT8zBx+p7+lCChJfY46Kvy3gqVUZ38VZKxR+k8a57k1/8k/Xf2mFmJOK2up14nibFvlyTTi/n2KUCZQnCU4TjKM4ScZwktOLXZpkHG1roz1Caa2gAASAAAAAAAAAAAAAAAAAAAAAAAAAAQAACQAAAAAAAAAAAAAAAAAAAAAAA3pb036JJLbbfZJIAfD17vS13bb7aSRa+E8HZmaoZHJdWPivTVEe11i9fpv2RuPC/hivGjXyHIQUsuyKlTXJbjjxa/8AM/dlyeor+BZUYvTmsPBcY8RyUnRhvWu8v4/kxMXCwePpjTiUV1VxWkoJb/W/Umcz6nP1MWUtvsWKWux4eUpSfNJ7Z9OW3snrS9X+oxp29PaPd+79kfCm97ZJiZqnJv5HvXL0TMKFsHr6Xr6HvGW/cDeyreMeDrlRLlsaGraf+1Riu06/z/tX8PsKBo7ZbCGRj5FFiUo2VThJP0fVFrucVnB1ztqb71WWVt/4ZNFTmV8rUl5n0XwvmytqlRN75e30PkAHCeyAAAAAAAAAAAAAAAAAAAAAAAAAAIAABIAAAAAAAAAAAAAAAAAAAAABZPCHFR5DkJZN0FLHwOmaT9J3PvFNfL1K2dE8C9C4vMlFJ2ffc+v4/L/+HRjRUrEmUPiC+VGDJw7vS/UuPZfsPCc/Uxrs6cNpVLft9Lt/AxJZeTNe0fbsv6l3o+S79TKssit7evl7mJK1z7R7R9z4etSssmowguqc7Goxil7yk3pIrHJ+Kopzo4fUntwnnWR+gvZ+RW/X7WYTsjBbZ2YmFfmT5Ko7+Zvs3kOO42EZ5l8a5S24VJOd1n+GC7/rekVrK8U51rawaK8av/xMhebfJL3Ufqr95XZTsssnbbOdl1j3Oy2TlOT+bZ9JldPKlLpHse6xPDlFC5r/AIn/AGNrXzvOwn1yy/Nj2brtqrUJL4fg0n+8vXE50M7GpuimlZFvUu7i4vTi38mczTXb/ruXnwlGX3hU3267MmS9txc9I2YtknLTK/j+DRTQra4pNPXTzLRGWlLftGT+zSOL3TVl+VYvSeRdNfY5s6rzuYuP4jkcjf0nTKir522roiv3nJlHpjFfBJb+OjHNl2ibvCdUk7LfLogwAVx7sAAEgAAAAAAAAAAAAAAAAAAAAAAEAAAkAAAAAAAAAAAAAAAAAAAAAA2/B85k8LkSnGHm412lkVb0216Sg/TqRqAZQm4PaOfJxq8mt1WraZ0WzxX4ZyI9TuyKZa712Y8219nTtGrv8W8fUmsLGyMmftK9eRUvm/Wf7kU8mELbbKqqoOdtklXVCPrJv20dfvlj6I85HwxhVtzm216N9P2MzkOW5PlJazLvwKf4PGp3DHgv8Hq39rZhr+hduN8HYldULuYtcptJ+TW5Rqr+Tku7Z7ch4U4i7Hus46MqLq65WV6m3VPpW+mUW/f4iWPbNc0mRXxvhuNNY9K0l5pdP18yibPpM+E216a9U1812G9d36I4/qen1tbXYyKarcm2nHpW7r5qqC+G/WX2L1Z1Hi8WGLjVVQ+pXXCqD77aiu8v1ld8M8LZQll5MdZN8foQet49ElvTf50vf4Gz8Q85Xw2MqMZp8hkQax4dvwUV2d0/kvVfEtKIeyhzyPnXGsqXEcmOJj9df3f/AIK/4y5SOVl18bVLqpwX15DT+jLIku0e3b6K/eyqMnbbk5NuUpSnOUntynN9Tk/m/Uh+xX22OyW2e44dhRwqI0x8u/1IABqLIAAAAAAAAAAAAAAAAAAAAAAAAAAgAAEgAAAAAAAAAAAAAAAAAAAAAAAAF58GcVVCqzmciCc7OqvEjr6taenJb95Pv9hRZfVl800dhwKY04HHVQSUIYtPSlvX1V6HbhQUp7fkeT8UZUqseNUP+vv9EfclK2W7P1R/JXyK/wCI+fp4yi3j8VxnyF1fRLT2sWua11z1+V8Ee3iXmp8XRTRiuP3/AJkZuub7rHqh2la0/f2RQsbA5HkbJfe1Vl0pz6rr7m1Fyk9uVlj92dd9zj8EF1PNcH4XC3/M5L1Bevnr/gw12UYrb79MV6uUn7Jeu2XDgPDc4zqzM+tefFqePjye1S/ay7Xbq+C9jY8R4bxONTzMqcJ31x6p5N2o00RXqq1P0+19zB5jxdVXGzE4Pbk9qefNJqPt+Ai13fzZorpjUue3uXObxS7iUni8NT12cvl/BtuZ57D4Ot49XTfyM4pwqe9Q3+Xc16L4L3OdXXZGTfdk5Nsrci59Vlkvf5Jey+CPhuUpTnOUp2WScrJzk5TnJ/lSk+7YOa692v5F3wrg9XD4b7zfd/x8gQAc5eAAAkAAAAAAAAAAAAAAAAAAAAAAAAAAgAAEgAAAAAAAAAAAAAAAAAAAAAAAANbTXyaOi+G/EXH5GHjYWdkV4+ZRBVLz2oQuhHtGUJy7b+K2c6Gk+zSe/ikbqbpVPaKrifDK+I1ck+jXZnVuQq8NZEqr86/jXKmLUJ3XVSai3tpLe9GmyfFXh7Bg6+OqszrY7UOiPk4sX6d5tfwiUHohvfTHf2I+m32OieY3+VaKWnwvXFKNtjkl5dkbDk+Z5bl5f6ZclTGW68WhOGPD5uPrJ/Ntmu/67E7ZBxzm5vcj09GNVjx5KopIAAxOgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAEgAAAAAAAAAAAAAAAAAgAAdn6fuABn8VxOfzGS8XEUF0QVl1tjahTDek2l3bfsjALT4N5bB47JzaMyyNMMtVSrvn2grK9rpnL5+xtpjGU0pFdxK66jFnZQtyX3PHlvCXJcXjSzPPqyaK0nf5cZQnWm9dWn6r4lc+DOm+Jef4inis6inKx8nKzKLMairHsjb/AHi6XZY4bSUVt9/gcy9or4JI3ZNcYS+Ar+A5mTl1Slkrqn06a2AB+tftOU9COy7t9viQpRe9NPXwLh4L4rieRXK2Z2JVfPHuojV5qbUYyg5Pt6GZ43w8LEwOKWLjUUqWdJS8iuEG0qZdn0o6Fjt1+02UNnG64ZqwlF73rf8AcogH29gc5fAAEEAjqjtLa38N9/2Gx4XGxsvl+KxsmuNlF17hZCTepRUW9PR0nM4fhcPiuWljcfiVSr4/NlCUaYdcWqpPak03+86asd2JyTKPiXGa8C2NMotuX86OTAiP1Yf4Y/wJOcvF2AABIAAAAAAAAAAAAAAAAAAABAAAJAAAAAAAAAAAAAAAAMzjcKPI52JhO+NH3xJx8xx6ltLfTFb1t99GGTCyVM67oS6Z1WV21y/NnF9UWv1kxa3tmu2M5VyjW9Nrv6M6fi+DvDGHBTyKXkyil1W51m19uu0UZT8PeEsuuSrwMGUH9HrxulNf79b2UB8P4w5ubyb8fMv631Rnn2+VWo69IVS7JfD6JvfDPh7xFxPKQvvqqqxJ0215CqyIyUm0nB+WkvctISTfKq9I+d5WPbXCVlmZua8k/wBuv/BrPEvhp8P0ZWLOdmDZZ0NWac6Jv6qcveL9jC8OcVjczyNuJkzuhXDFlkfgXGMpNTjHpbkn27nRfE9cbPD/ADkWk3HEnYur2dbU0/3FL8C9+byP8un6/wC0ga50xV8V5MsMLid9/CrZyl8cOz8zO8Q+GeD4fhc3LxKJ/fMbcSEbbbJTklK6MWl7e5UMPBzuQya8XCpdt0238IVw33nZL2SOk+Nv9Xc39Iwf+IgV7wEt8lyv6FT/ADZGN1UXaoLsOF8Qvhwy7JnLmkn5/Y23G+BeLpip8lOeZc+8oKUq8eL+EYRab/WzY3cJ4MrjbC3C46HlQlO3bgrIQittvUuo8vGl+Tj8DkyousplZkYtMp0ycJ+XOaUoqS7rfucr6Ku/0Vt723tvb+bezbbKun4VE4+H42bxeMsiV7Wn5bOheBLKLZeJLMeryseebVLHq235dPQ+hbff0LPyPFcZy0Kqs/HjfCmfmVpuUembTjv6LRVfue/3XOdtJX4y/wD1s9/H87IYPE9FlkOrOl1eXOUN/gZevS0bK5JU8zRwZ2PKfFnTXPT2lvr6L7lU8T4eHxvMZWLiUxpxq8fHsjCPU1uUXKT3Jtm64DwbDLprzOX8yMLYqdOHCTh9B91K6S79/h7Fe4PD/tHmeMx7eucJWq65zk5udVC69Nybet6R1rLsux8PMtxqnbfVj2zoqitudqi+iOvtNFFULG7Guhc8Yz8jBqrwa5/FrrL/AN9TWPwr4W6XD+y8dLXf6/V8PVPZV/EXhGvAx7c/jXZKilOeTjzbm4V+rnVJ99L3X9DUYuB4yozaOSeFyk8vzq7brZ7fmbkuuMl1a6WtrWv4HWHCN1cozX0bIOE4v82a04s3RjC6LXLoqrsjK4VbCav50+/Xf2OReHPx9wfv/pW/t+hL0Op8t+KeZ/y7N/kyOY8JT97eJ+Pxn/3fk8nH/wDp+ZFHTuW/FPM/5dm/yZmOKtQkmdPiOaszKZrs0n/c4tD6kfsj/AkiH1I/ZH+BJVH0VdgAASAAAAAAAAAAAAAAAAAAAAQAACQAAAAAAAAAAAAAAAC3+COJoy78rksiEZxw7I04sZrcVc0pSs0+216IqBe/AWZSoclx8mla7o5da/PrlBQko7+DXf7ToxknYuYouPzshgTdfy/TfUsvOc1icHhrKurnbOyxU49FbSlbY1vXU+ySW22aPhPF+ZyvJ42BZx9NFd1d0/MhfOyUXXHqS7xS7mX4v4fN5TCxJYceu/DyJW+V1KLshZHokoyl22uzRXvCvCc7j8zi5eTgXUY9NWSpzvcItucdJKKbZYWTsVqjHseKwsbBnw+y21r2i3rr29NLzLl4j/EPPfoGR/5SkeBPx1f/AJdP+ZAu/iNpcDzu2lvBvSbeu7jpFI8CfjrI/wAun/MgY2/14G/hn+1ZRafG3+rub/t8L/iIFd8A/jLlf0Kn+bIsPjb/AFdzv9vhf8RAr3gH8Zcr+hUfzZEWf6iP0MsH/Zb/AK/wb/xz+ILf0zB/mI5gdO8c/iC39Mwv5hzI5sz+p9i88Kf6OX1f7Ivn3Pf7rnP0jG/ls9fugf8AYuI/Tp/yZGL9z++uM+axW15k3j5EVv1gk4P9n/M3PjDi83k+Px1hw82/FyVkeV1KMrIOEoNRb7b7nVBc2PpFHlzVPHeefRbX7FR8FuC5+jfq8TK6ft+izo3J5y43j87PdUrli0ytdcWouemuybRyjDszOC5bBvyaLKrMeyE7qp66/IsThLaT16d/X2OsXQxuSwb6lNTx83GlBTi004Wx0pRIxW1Bx80T4lhF5kL31hJLqvl3Kgvug1//AAi3/wC7h/6Cf/aDXv8AFFnt/wB6h/6CuZPhbxLi2ypjg25MIvprvx5QcLEvRtSkmvntGbg+C+dyeqWV5eJBQk4xlJWWzml9GOo/RSfv3NPtMjetFnLA4HCCsclr/ue/02YvE5H354rw8tQ8tZXJ3ZCg3twVkZPp2dM5b8U8z/l2b/Kkcp4WxYfN8TLIXlujOjTdGW065tupp7+DZ1rNpeTh52MmovIxr6FJ+idkHFM24u3CXqVniOEasmjl/KorX2ZxKH1IfZH+BJm5nEcvxkI/f+JZTHqVUbeqEqpy16RlFmEVsouL00fQqbYXQU63tfIAAxNwAAAAAAAAAAAAAAAAAAABAAAJAAAAAAAAAAAAAAAAPXHvyMW6rIx7JV30y66rIfWT91p9mvijyATae0YyhGacZLaZd8Px/bGChn8f5lkV/e4k1GMvm4WLs/1npd90Gvpf3vxNzn+S8i+uEE/n0JsogOpZdiWjzz8OcPlPm5fts2XK85zHMyj9+3KOPGXVDEx04URae05Jvcmvm/1H3wXLx4TMtzHjPIc8eVCgrFXrqkpb2017GqBp9rPm5m+pafh+OqHjRjqL7pFo5zxa+Y467j/7OlQ7bMefmO+M0vLsVmulRXrr4mv4HmlweTl5H3q8j74phSoKxV9PTJyb20acGTvm5c77mmvhWLXRLGgvhk9tb6lm53xZ/bXHywVx8qOq+i12SvjPXly6tdKivUrIBhZZKx7kdGHhU4Nfs6V07mRiZeXg5FWXi2uq+pvokkmmveMk+zT90W+j7oE4wSyuKc7NLcsa9RjJ69emxbX7SkAzhdOvpFmjM4Vi5z3dHb9ezNjzPJLl+SyM9USpVtdFaqnNTa8uPS3uPYzOF8T8nw0VjqMcrCT2qLZOM623t+VPv2+TRogYq2SlzrubJcOx50LGlHcUun87Ogr7oHHdD6uNzlPT+ipUNP8A3tr+Bq8/x1yl8XXx+LVhJr++vayLl/gikq9/tKkDc8ux9Ctr8OYFcublb+rPqc7Lp2WXTnZdbKVltlj/AAk7Jd3JyXv+wtXG+NuQw6asfNxY5kK4qMLY2eVe0vRT2nFv9hUwaoWzg9p9SzyuHY+VBV2x6Lt5aLH4h8TQ5zHxcavBtx1TkrIc7bYT3qEo6SgvmVwAxnY7HzS7mWFhVYVXsaewABgdoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAPXHplk34+PBpSusjBOS2lv3aNxZ4a5GPlKu6i1zlqTUZQVa1vqlt7f6jE4Kvr5TE91XG239kOlfxN/wA/nZWHViwx7PLnfOfVOKXWoRXtspsvKvjkxx6Guvqily8m9ZMaKGuvqjXT8MZMYSlDKrnak2oeW4pv4Jtnxj+Gs+2KlkW10NrflpOyS/xNPRv+Jsvt47BtyJudk6+ucp+rTbab18jTcZyXJZvLwjPIm8drJl5SS6FCK+j2/YcUMvNkrEpL4fPX7HBDLzJKxKS+Du/4NbyXFX8d5UpWRtqsbjGcY9P0kt6a2fGBxedyLk6emFMX0yus307X5MUu7N74mcp1cZjR7TvyX0/LaUE/3mxvnXxXG2SpjFLFpUa17OctQi3+vubVxK32ENa55Pp6G78SuWPDXWcno0svC16i3HMrc9dk65KL/XvZosmm/Ettpvh02V6TXrvfo018SweH83NysnMhkXTtiq42/TfaM3LX0V7I+fENSs5PiYLXXdGmD7d2vO/obaMu+vIdF75ujfpo20Zd9eQ6b3vo32+Wzwl4a5CNPmwvpnNxi41KE4tt67Obeu32HrDwvkuO7MypT9emFcpJP7W/+RvOVyrMLj776WlbGVdVTktpSlJR3+wwfD+Tm5VWbZkXTt1fGFbnrs1DcktI4nm5k6HepJJP9Ti99zJUu7mSSfp1KvmYt2Ffbj3OPVWlLa9JJ900bHB4DkMyELZuOPXNbrU4ylZNfHpXp+szcimGd4mdU0nVjwhKaffq8uG0n9rZteUq5XIprowLK6VOX+kWSk4y6Uu0Y6Wzqu4hYo1wTUZNJtvstnVdxGxRrhFpOSTbfkV/N8PZeLVZdXbC6NacpwUXCSiu7a2fOLwGZl49WTDIx4121+ZBNTlLXft2LBKUOJ4voyr3bZCiyEZWP6d1k00kk++u54+HLOvja4Se3RdbVr00t9SX7zQ+IZCodm96et67pnP7/kqiU096et67oqVFNmTfVjwcVbbNwj5knGKl8G13M/kOGyOPx6r53Qs6rFCfRFqMG1td5ep6YeHKXPOpdoYuVdfN+uoQb1+3Zs/E98I4+NjJ/Ttt86S+EIbS7fad9uXY8muuD6NbZ325dnvNVcH0ktsqgALgugAAAAAAAAAAAAAAAAAAAAAACAAASAAAAAAAAAAAAAAAAPgAAb7wvW3lZlvtXjwhF695y3/yI8UWyllY1S7uvG3pP3sk+37jAwOTyuOVyx40vzpKU3ZBye0tLXc8svMvzMh5V3l+Y/LWoRcYfQ9FoqVi2PNd8u2un6FSsWz3x3vtrp+hdXrD4qfssfj2l7fSVeiveGK28rLtf/u8eEE/nOXc8MjnuRyse7Gsjjqu2KjNwg1LpTT0m2Y+ByeVxvm+RGl+dKLm7YOT+itL3OWvAvhRZHpzSOWrBuhRZF65pfM2viC9R5TiU/q46psl79PXbt+n2G55bGvzOPyaaNSsl0WRjtan0yUtb9O5S8zLvz8iWTf0eY4wglCPTFKK0klszsTnuTxK4VaquhBagrk9pa9OqJFnDrY11Sq1zQ9SLeH2qup1a5o//TdcDxl+FXkW5EYwuvaSintwrh6KT9PmYLyIcl4jxZVvqpxm4wfbTVUHuS17b9DBy+c5LLrnS3CqqS6ZwpWnNfByb6tGJhZl2BesimNbsUJQ/CR6lqXrpI2wwrm53Wa52mkZ14V8nZdZrnaaX3LJ4nt6cPEp/wDFyXN/NQg/6nt4br6ONpk9buvts/3XLpX8Cs5/JZnIul5CqSqU1BVRcfrerfcyMbneRxqKcaqOMqqk4x6q25a9e/c1S4fb7nGhd97ZhLh93ukaFre9szOMyYS8QZ85SW8h5UIt+7jNaS/UuxtuVp5qyNMuOyHX0KSsrUlDr3rUk5IpXXNTVkZOM1PrjKPZqW29o3NXiTlIJRnGi1rS65xcXL7elmeRgW+1jbUk2klpmWTw+12RtpSeklp/I8M3jeWpoebyFqcvMhVGMrXbNuXd9/RGw8L2pS5Ghv18q5L/APB/8jHyrPEHLYtF3kQliSlOUK8aKUlKL6dyUu5n8BxWXiztyslOuyytVV0rTfS2pOU9e5hk2L3OUL5Lm9F+xhkWr3OUL5Lm32Xl17G1jRi4U+RzZyUXe1dfOWvowrikox+X9Sk5+ZPOyrsmXZSfTVH8ytfVX9TbeIOTVsvvDHknTW95E4+lli/IXyj7lfN3C8WcY+3t/M/2N3CsWUV7e38z7fQAAu+xdgAAkAAAAAAAAAAAAAAAAAAAAgAAEgAAAAAAAAAAAAAAAAAAAAgAAAAAEgAAADYBAAAJIN5g+ILMPHpx5YsJwqj0wcJyg2vXv6ojM8RZuTCdVFcceEk1KUW5WNP2UmaQHD+H4/P7Rx6nD+H4/P7Tl6j/AK/WADtO8AAkAAAAAAAAAAAAAAAAAAAAAAAEAAAkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAE6Y0QTogDROgNEAnRGgNADROgNEAaJ0BogDROgNEAnQ0BogE6I0BoAnRGgNADROgNEAnRGgNAE6GgNEAnRGgNAE6GgNEAaGgNAE6I0BoAaJ0BogE6GgNEAnQ0BogE6I0BoAaGgNAE6GgNEAaGgNAE6I0Bo//Z',
                context),
            _buildServiceBlock(
                'Mastercard',
                'https://th.bing.com/th/id/OIP.Zcc2agoYNmGpwGO7Ww6w8AAAAA?rs=1&pid=ImgDetMain',
                context),
            _buildServiceBlock(
                'Visa',
                'https://minkabu.jp/creditcard/wp-content/uploads/recommended-visa-credit-card.png',
                context),
            _buildServiceBlock(
                'Paypal',
                'https://static.vecteezy.com/system/resources/previews/009/469/637/original/paypal-payment-icon-editorial-logo-free-vector.jpg',
                context),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceBlock(
      String serviceName, String imageUrl, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (serviceName == 'MTN Money') {
          _showRechargeDialog(context);
        }
      },
      child: Card(
        margin: EdgeInsets.all(10),
        elevation: 4,
        color: Colors.cyan,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              imageUrl,
              height: 60,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 10),
            Text(
              serviceName,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRechargeDialog(BuildContext context) {
    TextEditingController amountController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Veuillez vous connecter')));
      return;
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((document) {
      if (document.exists) {
        phoneController.text = document['phone_number'] ?? '';
      }
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur lors de la récupération des données : $e')));
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          backgroundColor: Colors.white,
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Image.network(
                          'data:image/jpeg;base64,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iOtp9HOzjx++60pKKJ+wsset2t9cWF/QGsnkZGcPpbqx02O743Eo8nBXq3+l63Pj4bpa6mKYfOoXslid+rKWuHvK71bbrZcmdHX0dPUt6uljBe3PW1/ygfNVOs9HNhme59JVVdJnfozwzxj6peQ/3uKtVLxXSyC0wLT8R9/ko9+HyN9nVcTWPpBqdRwfBtFTvpLYXNfOJXNdPUuYeJok4fZDQcHAJ3HPbA7fo/s01DQ1FyqY+CW4iMU7XD2xSM9oOx1cZ3HcO9eq16D07QSsnn6eulYQ5gquFsLSOR6Jmx83HwVs55UVjnEEVTCaem2O5+gWxSUbmOzvUIiKjEqXCIiLxERERERERERERERERERERERERERERERERERERERERERERERERERERFJ5qF9EblRhNtF8r5RThMIvpETCYREUKcJhERQpwmERFC+kRFCKUwiKEU4UYRFCKcJhETsRTjkowl0RQpwmERETCYREUL6wowiIinCYS68uoRThMJdLqEU4TCXS6hFOEwl0uoRThMJdLqEU4TCXS6hFOEAS6XUIvrCYXl0uvlF9YTCXS6+UX1hMJdLr5RThThe3S6+UX1hMLy6XX//Z',
                          height: 80),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Entrez le montant", style: TextStyle(fontSize: 16)),
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("Numéro de téléphone",
                          style: TextStyle(fontSize: 16)),
                      TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text("Confirmer"),
                    onPressed: () async {
                      final amount = double.tryParse(amountController.text);
                      if (amount != null) {
                        Navigator.of(context).pop();
                        final userDoc = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .get();
                        double currentSolde =
                            userDoc['solde']?.toDouble() ?? 0.0;
                        double newSolde = currentSolde + amount;

                        DateTime now = DateTime.now();
                        String formattedDate =
                            "${now.year}-${now.month}-${now.day}";
                        String formattedHeure =
                            "${now.hour}:${now.minute.toString().padLeft(2, '0')}";

                        try {
                          // Mettez à jour le solde dans le document utilisateur
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .update({
                            'solde': newSolde,
                            'recharge': FieldValue.increment(1),
                            'last_recharge_date': formattedDate,
                            'last_recharge_heure': formattedHeure,
                            'last_recharge_amount': amount,
                            'phone_number': phoneController.text,
                          });

                          // Enregistrez les détails de la recharge dans la collection 'recharges'
                          await _saveRechargeDetails(
                              user.uid,
                              amount,
                              phoneController.text,
                              formattedDate,
                              formattedHeure);

                          _showConfirmationDialog(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Erreur lors de l\'enregistrement : $e')));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Montant invalide')));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveRechargeDetails(String userId, double amount,
      String phoneNumber, String date, String heure) async {
    await FirebaseFirestore.instance.collection('recharges').add({
      'user_id': userId,
      'amount': amount,
      'phone_number': phoneNumber,
      'date': date,
      'heure': heure,
      'date_time': FieldValue.serverTimestamp(),
    });
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Paiement Validé"),
          content: Text("Votre recharge a été effectuée avec succès."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class NiPage extends StatelessWidget {
  // Page "Ni"
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Deux blocs par ligne
          childAspectRatio: 1, // Blocs carrés
          children: [
            _buildServiceBlock('MTN Money',
                'data:image/jpeg;base64,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dq0nJ/onatJyf6Kj0TRPmnN6ew7vq6l52rScn+idq0nJ/oqNNE+ac3p7Du+rqXnatJyf6J2rScn+io00T5pzensO76upedq0nJ/onatJyf6Kj0RPmnN6ew7vq6l52rScn+ijtWk5P9FSaJonzTm9PYd31dS77VpOT/RT2rScn+io9E0T5pzensO76upedq0nJ/onatJyf6Kj0TRPmnN6ew7vq6l32rScnJ2rScn+ipNE0T5pzensO76updm6UhBBDteOmhWIZLFvmYUNOZvi6CPe5/WxlV6J8052nh7Du+ozZ7jUS5Ef0bcY044WESXHJJJ5k5KhSoPKzr8t63SbNyumFfCKCIi0jKEREAREQBERAE5InJAfSIiFpB4lQpPFR6oXBERAEREAREQBFKICEREAREQBERAEREAREQBERAEUqEARFKAhERAERSgIREQBERAEREAREQBERAERSgIREQBEUoCEREAREQBOSJyQH0iImhaO9ERHzAREVAEREAUoiqgFCIgCIioAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCkIieKBKIi2S0//2Q=='),
            _buildServiceBlock('Airtel Money',
                'https://th.bing.com/th?q=Airtel+Money+Rapide&w=120&h=120&c=1&rs=1&qlt=90&cb=1&dpr=1.5&pid=InlineBlock&mkt=en-WW&cc=CG&setlang=fr&adlt=moderate&t=1&mw=247'),
            _buildServiceBlock('Western Union',
                'data:image/jpeg;base64,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'),
            _buildServiceBlock('M-pesa',
                'https://th.bing.com/th?q=M-PESA+Vodacom+PNG&w=120&h=120&c=1&rs=1&qlt=90&cb=1&dpr=1.5&pid=InlineBlock&mkt=en-WW&cc=CG&setlang=fr&adlt=moderate&t=1&mw=247'),
            _buildServiceBlock('Orange Money',
                'data:image/jpeg;base64,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qzU3kUDaaKittFvpqSF23h2zsB0jsNGQNzQGgAelBRLr+TdXmhutm1w60AUzYqqkfVPhLNlxdtOg7+Mh4yQTvBwMHmeJ1zV2FjKC1Wq73K6vpz3tfVVVxqKumdK1uw0RNe4xbXEktGBnAJyQ3h8plBQ+yu4Wu3Xa7S3Cuo6OOS3CNj6yeOBr39+x2y0yEDO5bbRmpbbRaq1tTVVdSxW25V1dW01TNPGymMkdS/ZLZHEN8bXZG/fshSbJCZKCsyalttb2nW6sdX0rLTbIKmihqpJo2UxHkkxc8SE7Hie4gHO/AXug1jYLdrnU7ZqunktN5htYZWwSNmp456elbF4nRZGycua48iByyRGMlEFftWmNFadu7b/Lqu2y0NG6Wehp2ywOk2nNIbtOjkc52yCSA1mSQOmD7NLavstfqTWdzrK2koKWojtdPbxXzxQOkhp++bn844DJ9kRndtKKZRB2mg6230er46qsq6anpgy5ZnqZWRReNjg3xvIG/lvXa0OrrBFqPW1pq6+KO23epZLR3GmmHcCR9HHTSDv48gZAGy7gC0796i2SmSgr0Vn0/ZxV11619U19G2N3k1NQXGRlRIeLd0U73OPIAADmThavs5vn9arnSES+S39tUWRzSvnkbJDtzx95K8lxIbttJPHKmuSu703r+n05aoaJlhp6itiNQWVr52xvImeX7LgIi/A4Y2+SDZdqtwgjmsmnKNrY6W10zJpIo9zGOe0Rwx4/wMG7/OpkvZc7jWXavrbjWPD6mrldNKQMNBOAGtBJ8LQABv4BeNAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREH//2Q=='),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceBlock(String serviceName, String imageUrl) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 4,
      color: Color(0xFFFF6F00), // Changer la couleur de la Card en rouge
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            imageUrl,
            height: 60, // Hauteur de l'image
            fit: BoxFit.contain, // Pour garder le ratio
          ),
          SizedBox(height: 10),
          Text(
            serviceName,
            style: TextStyle(
                fontSize: 20,
                color: Colors.white), // Texte en blanc pour le contraste
          ),
        ],
      ),
    );
  }
}
