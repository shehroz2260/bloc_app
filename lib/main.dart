import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/view/splash_view/splash_view.dart';
import 'package:chat_with_bloc/view_model/bio_bloc/bio_bloc.dart';
import 'package:chat_with_bloc/view_model/filter_bloc.dart/filter_bloc.dart';
import 'package:chat_with_bloc/view_model/home_bloc/home_bloc.dart';
import 'package:chat_with_bloc/view_model/inbox_bloc/inbox_bloc.dart';
import 'package:chat_with_bloc/view_model/main_bloc/main_bloc.dart';
import 'package:chat_with_bloc/view_model/map_bloc/map_bloc.dart';
import 'package:chat_with_bloc/view_model/dob_bloc/dob_bloc.dart';
import 'package:chat_with_bloc/view_model/matches_bloc/matches_bloc.dart';
import 'package:chat_with_bloc/view_model/preference_bloc/preference_bloc.dart';
import 'package:chat_with_bloc/view_model/sign_in_bloc/sign_in_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/sign_up_bloc/sign_up_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'view_model/gender_bloc/gender_bloc.dart';
import 'view_model/location_permission_bloc/location_bloc.dart';
import 'view_model/chat_bloc/chat_bloc.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
@override
  void initState() {
   WidgetsBinding.instance.addObserver(this);

    super.initState();
  }
    @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateOnLineAndOfflineStatus(true);
    } else if (state == AppLifecycleState.paused) {
      _updateOnLineAndOfflineStatus(false);
    }
  }

_updateOnLineAndOfflineStatus(bool isOnline)async{
await FirebaseFirestore.instance.collection(UserModel.tableName).doc(FirebaseAuth.instance.currentUser?.uid??"").set({
  "isOnline" : isOnline
},SetOptions(merge: true));
}
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserBaseBloc()),
        BlocProvider(create: (context) => SignInBloc()),
        BlocProvider(create: (context) => SignUpBloc()),
        BlocProvider(create: (context) => MainBloc()),
        BlocProvider(create: (context) => InboxBloc()),
        BlocProvider(create: (context) => ChatBloc()),
        BlocProvider(create: (context) => LocationBloc()),
        BlocProvider(create: (context) => MapBloc()),
        BlocProvider(create: (context) => DobBloc()),
        BlocProvider(create: (context) => GenderBloc()),
        BlocProvider(create: (context) => PreferenceBloc()),
        BlocProvider(create: (context) => HomeBloc()),
        BlocProvider(create: (context) => FilterBloc()),
        BlocProvider(create: (context) => MatchesBloc()),
        BlocProvider(create: (context) => BioBloc()),
      ],
      child: 
       GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashView(),
        ),
      ),
    );
  }
}




// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:local_auth/local_auth.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final LocalAuthentication auth = LocalAuthentication();
//   _SupportState _supportState = _SupportState.unknown;
//   bool? _canCheckBiometrics;
//   List<BiometricType>? _availableBiometrics;
//   String _authorized = 'Not Authorized';
//   bool _isAuthenticating = false;

//   @override
//   void initState() {
//     super.initState();
//     auth.isDeviceSupported().then(
//           (bool isSupported) => setState(() => _supportState = isSupported
//               ? _SupportState.supported
//               : _SupportState.unsupported),
//         );
//   }

//   Future<void> _checkBiometrics() async {
//     late bool canCheckBiometrics;
//     try {
//       canCheckBiometrics = await auth.canCheckBiometrics;
//     } on PlatformException catch (e) {
//       canCheckBiometrics = false;
//       print(e);
//     }
//     if (!mounted) {
//       return;
//     }

//     setState(() {
//       _canCheckBiometrics = canCheckBiometrics;
//     });
//   }

//   Future<void> _getAvailableBiometrics() async {
//     late List<BiometricType> availableBiometrics;
//     try {
//       availableBiometrics = await auth.getAvailableBiometrics();
//     } on PlatformException catch (e) {
//       availableBiometrics = <BiometricType>[];
//       print(e);
//     }
//     if (!mounted) {
//       return;
//     }

//     setState(() {
//       _availableBiometrics = availableBiometrics;
//     });
//   }

//   Future<void> _authenticate() async {
//     bool authenticated = false;
//     try {
//       setState(() {
//         _isAuthenticating = true;
//         _authorized = 'Authenticating';
//       });
//       authenticated = await auth.authenticate(
//         localizedReason: 'Let OS determine authentication method',
//         options: const AuthenticationOptions(
//           stickyAuth: true,
//         ),
//       );
//       setState(() {
//         _isAuthenticating = false;
//       });
//     } on PlatformException catch (e) {
//       print(e);
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = 'Error - ${e.message}';
//       });
//       return;
//     }
//     if (!mounted) {
//       return;
//     }

//     setState(
//         () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
//   }

//   Future<void> _authenticateWithBiometrics() async {
//     bool authenticated = false;
//     try {
//       setState(() {
//         _isAuthenticating = true;
//         _authorized = 'Authenticating';
//       });
//       authenticated = await auth.authenticate(
//         localizedReason:
//             'Scan your fingerprint (or face or whatever) to authenticate',
//         options: const AuthenticationOptions(
//           stickyAuth: true,
//           biometricOnly: true,
//         ),
//       );
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = 'Authenticating';
//       });
//     } on PlatformException catch (e) {
//       print(e);
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = 'Error - ${e.message}';
//       });
//       return;
//     }
//     if (!mounted) {
//       return;
//     }

//     final String message = authenticated ? 'Authorized' : 'Not Authorized';
//     setState(() {
//       _authorized = message;
//     });
//   }

//   Future<void> _cancelAuthentication() async {
//     await auth.stopAuthentication();
//     setState(() => _isAuthenticating = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: ListView(
//           padding: const EdgeInsets.only(top: 30),
//           children: <Widget>[
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 if (_supportState == _SupportState.unknown)
//                   const CircularProgressIndicator()
//                 else if (_supportState == _SupportState.supported)
//                   const Text('This device is supported')
//                 else
//                   const Text('This device is not supported'),
//                 const Divider(height: 100),
//                 Text('Can check biometrics: $_canCheckBiometrics\n'),
//                 ElevatedButton(
//                   onPressed: _checkBiometrics,
//                   child: const Text('Check biometrics'),
//                 ),
//                 const Divider(height: 100),
//                 Text('Available biometrics: $_availableBiometrics\n'),
//                 ElevatedButton(
//                   onPressed: _getAvailableBiometrics,
//                   child: const Text('Get available biometrics'),
//                 ),
//                 const Divider(height: 100),
//                 Text('Current State: $_authorized\n'),
//                 if (_isAuthenticating)
//                   ElevatedButton(
//                     onPressed: _cancelAuthentication,
//                     child: const Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         Text('Cancel Authentication'),
//                         Icon(Icons.cancel),
//                       ],
//                     ),
//                   )
//                 else
//                   Column(
//                     children: <Widget>[
//                       ElevatedButton(
//                         onPressed: _authenticate,
//                         child: const Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             Text('Authenticate'),
//                             Icon(Icons.perm_device_information),
//                           ],
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: _authenticateWithBiometrics,
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             Text(_isAuthenticating
//                                 ? 'Cancel'
//                                 : 'Authenticate: biometrics only'),
//                             const Icon(Icons.fingerprint),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// enum _SupportState {
//   unknown,
//   supported,
//   unsupported,
// }