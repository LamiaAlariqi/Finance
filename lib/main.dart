import 'package:finance/cubits/expenses_cubit/expenses_cubit.dart';
import 'package:finance/cubits/invoice_cubit/invoice_cubit.dart';
import 'package:finance/cubits/login_cubit/login_cubit.dart';
import 'package:finance/cubits/receipt_cubit/receipt_cubit.dart';
import 'package:finance/cubits/reports_cubit/report_cubit.dart';
import 'package:finance/firebase_options.dart';
import 'package:finance/helper/HiveUser.dart';
import 'package:finance/res/routes.dart';
import 'package:finance/res/sizes.dart';
import 'package:finance/res/theme_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(HiveUserAdapter());
  await Hive.openBox<HiveUser>('userBox');

  final box = Hive.box<HiveUser>('userBox');
  final currentUser = box.get('currentUser');
  final firebaseUser = FirebaseAuth.instance.currentUser;

  final isLoggedIn = currentUser != null && firebaseUser != null;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => InvoiceCubit()),
        BlocProvider(create: (context) => ReceiptCubit()),
        BlocProvider(create: (context)=>ExpenseCubit()),
        BlocProvider(create: (context)=>ReportsCubit()),
      ],
      child: FinanceApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class FinanceApp extends StatelessWidget {
  final bool isLoggedIn;
  const FinanceApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    initializeHWFSize(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.lightTheme(),
      themeMode: ThemeMode.light,
      routes: routes,
      initialRoute: isLoggedIn ? MyRoutes.mainScreen : MyRoutes.loginScreen,
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
    );
  }
}
