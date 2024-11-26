import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icm_eventos/modules/auth/view/auth_page.dart';
import 'package:icm_eventos/modules/auth/view/login_responsavel.dart';
import 'package:icm_eventos/modules/home/view/eventos_config_page.dart';
import 'package:icm_eventos/modules/home/view/eventos_responsavel.dart';
import 'package:icm_eventos/modules/home/view/eventos_responsavel_edit.dart';
import 'package:icm_eventos/modules/home/view/lista_horarios.dart';
import 'package:icm_eventos/utils/icm_custom_scroll.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'modules/home/view/lista_ventos.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://yjeunmiwickqijkmvrqu.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlqZXVubWl3aWNrcWlqa212cnF1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIxNDg1MzAsImV4cCI6MjA0NzcyNDUzMH0.7sbxEi1NcGkQCak0qxlKTOz-QmypjqBDV-aktDSOsQ4',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'ICM EVENTOS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      getPages: [
        GetPage(
          name: '/',
          page: () => const AuthPage(),
        ),
        GetPage(
          name: '/eventos', // Nome da rota
          page: () => const ListaEventosPage(),
          transition: Transition.rightToLeft, // Transição personalizada
        ),
        GetPage(
          name: '/horarios', // Nome da rota
          page: () => const ListaHorariosPage(),
          transition: Transition.rightToLeft, // Transição personalizada
        ),
        GetPage(
          name: '/login-responsavel', // Nome da rota
          page: () => const LoginResponsavelPage(),
          transition: Transition.rightToLeft, // Transição personalizada
        ),
        GetPage(
          name: '/eventos-responsavel', // Nome da rota
          page: () => const EventosResponsavelPage(),
          transition: Transition.rightToLeft, // Transição personalizada
        ),
        GetPage(
          name: '/eventos-config', // Nome da rota
          page: () => const EventosConfigPage(),
          transition: Transition.rightToLeft, // Transição personalizada
        ),
        GetPage(
          name: '/eventos-responsavel-edit', // Nome da rota
          page: () => const EventosResponsavelEditPage(),
          transition: Transition.rightToLeft, // Transição personalizada
        ),
      ],
    );
  }
}
