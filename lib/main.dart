import 'package:chat_with_bloc/view_model/filter_bloc.dart/filter_bloc.dart';
import 'package:chat_with_bloc/view_model/home_bloc/home_bloc.dart';
import 'package:chat_with_bloc/view_model/inbox_bloc/inbox_bloc.dart';
import 'package:chat_with_bloc/view_model/main_bloc/main_bloc.dart';
import 'package:chat_with_bloc/view_model/map_bloc/map_bloc.dart';
import 'package:chat_with_bloc/view_model/dob_bloc/dob_bloc.dart';
import 'package:chat_with_bloc/view_model/preference_bloc/preference_bloc.dart';
import 'package:chat_with_bloc/view_model/sign_in_bloc/sign_in_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/sign_up_bloc/sign_up_bloc.dart';
import 'package:chat_with_bloc/view/splash_view/splash_view.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
