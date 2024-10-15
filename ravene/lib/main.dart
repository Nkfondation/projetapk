import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Page1.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ravene',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFF6F00)),
        useMaterial3: true,
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: Colors.black,
            fontFamily: 'CustomFont',
            fontSize: 16,
          ),
          bodyText2: TextStyle(
            color: Colors.black,
            fontFamily: 'CustomFont',
            fontSize: 14,
          ),
          headline6: TextStyle(
            color: Colors.black,
            fontFamily: 'CustomFont',
            fontSize: 22,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.network(
          'https://i.postimg.cc/MH1tW65P/MONICA.png',
          height: 260,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Country? _selectedCountry;
  String _selectedCode = '+243'; // Default code
  bool _isButtonEnabled = false;

  final List<Country> _countries = [
    Country(
      '',
      'https://th.bing.com/th/id/OIP.0XYav5oWD75pQeove4sU9gHaE7?w=258&h=180&c=7&r=0&o=5&dpr=1.5&pid=1.7',
      '+242',
    ),
    Country(
        '',
        'https://th.bing.com/th/id/R.2d282b4dcc6acb6df4f94d1e25e242af?rik=e9fX3sNI1Ju39w&riu=http%3a%2f%2fwww.allflags.org%2fAllFlagsImages%2fFlag_of_Cameroon.png&ehk=fRClOk5JVtQybbxUmfvQpJ4LJwQri2bl3N70Ep7IloM%3d&risl=&pid=ImgRaw&r=0',
        '+237'),
    Country(
        '',
        'data:image/jpeg;base64,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',
        '+243'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedCountry =
        _countries.firstWhere((country) => country.code == '+242');
    _selectedCode = _selectedCountry?.code ?? '+243';
    _phoneController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_updateButtonState);
    _phoneController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final isValid = _phoneController.text.length == 9;
    setState(() {
      _isButtonEnabled = isValid;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final phoneNumber = _selectedCode + _phoneController.text;

      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            UserCredential userCredential =
                await FirebaseAuth.instance.signInWithCredential(credential);
            await _createUserIfNotExists(userCredential.user);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Page1()),
            );
          },
          verificationFailed: (FirebaseAuthException e) {
            _showErrorDialog(); // Appel du popup d'erreur
          },
          codeSent: (String verificationId, int? resendToken) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => VerificationPage(
                  verificationId: verificationId,
                  selectedCode: _selectedCode,
                  phoneNumber: phoneNumber,
                  createUserIfNotExists: _createUserIfNotExists,
                ),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la vérification : $e')),
        );
      }
    }
  }

  Future<void> _createUserIfNotExists(User? user) async {
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'phone_number': user.phoneNumber,
          'country_code': _selectedCode,
          'solde': 0,
          'nom': '',
          'prenom': '',
          'mail': '',
          'nomUser': '',
          'montantR': '',
          'recharge': '',
          'date_time': '',
          'montantV': '',
          'date': '',
          'heure': '',
        });
      }
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: SizedBox(
            width: 300, // Largeur du popup
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 60, // Taille de l'icône
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 36, // Taille de l'icône
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Vous avez entré un mauvais numéro de téléphone',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Ferme le popup
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFF6F00), // Orange
                    padding: const EdgeInsets.symmetric(
                        vertical: 16), // Remplissage vertical
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size(double.infinity, 48), // Largeur maximale
                  ),
                  child: const Text(
                    'Réessayez',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Text(
                        'Bienvenue chez Ravene !\nPour commencer, entrez votre numéro de téléphone',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'CustomFont',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: Color(0xFFFF6F00), width: 2),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: DropdownButtonFormField<Country>(
                                  value: _selectedCountry,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  items: _countries.map((Country country) {
                                    return DropdownMenuItem<Country>(
                                      value: country,
                                      child: Row(
                                        children: <Widget>[
                                          Image.network(
                                            country.flagAsset,
                                            width: 30,
                                            height: 20,
                                            fit: BoxFit.cover,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                              '${country.name} (${country.code})'),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (Country? newValue) {
                                    setState(() {
                                      _selectedCountry = newValue;
                                      _selectedCode = newValue?.code ?? '+243';
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Veuillez sélectionner un pays';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    labelText: 'Numéro de téléphone',
                                    prefixText: _selectedCode,
                                    prefixStyle: TextStyle(
                                      color: Color(0xFFFF6F00),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 14),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(9),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez entrer votre numéro de téléphone';
                                    }
                                    if (value.length != 9) {
                                      return 'Le numéro de téléphone doit comporter 9 chiffres';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isButtonEnabled ? _submitForm : null,
                style: ElevatedButton.styleFrom(
                  primary: _isButtonEnabled
                      ? Color(0xFFFF6F00)
                      : Color(0xFFFF6F00).withOpacity(0.6),
                  onPrimary: Colors.white,
                  minimumSize: Size(double.infinity, 48),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Suivant',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'CustomFont',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerificationPage extends StatelessWidget {
  final String verificationId;
  final String selectedCode;
  final String phoneNumber;
  final Future<void> Function(User?) createUserIfNotExists;

  const VerificationPage({
    Key? key,
    required this.verificationId,
    required this.selectedCode,
    required this.phoneNumber,
    required this.createUserIfNotExists,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _smsCodeController = TextEditingController();

    void _verifyCode() async {
      final smsCode = _smsCodeController.text;

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        await createUserIfNotExists(userCredential.user);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Page1()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la vérification : $e')),
        );
      }
    }

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Vérification par SMS',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Nous vous avons envoyé un code au numéro ${phoneNumber}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _smsCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Code SMS',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _verifyCode,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 12.0),
                    ),
                    child: const Text(
                      'Vérifier',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

// Fonction pour formater le numéro
    String _formatPhoneNumber(String phoneNumber) {
      if (phoneNumber.length <= 5) return phoneNumber;
      return '${phoneNumber.substring(0, phoneNumber.length ~/ 2)}${'*' * (phoneNumber.length - phoneNumber.length ~/ 2)}';
    }
  }
}

class Country {
  final String name;
  final String flagAsset;
  final String code;

  Country(this.name, this.flagAsset, this.code);
}
