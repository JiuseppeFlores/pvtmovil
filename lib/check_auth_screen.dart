import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/main.dart';
import 'package:muserpol_pvt/model/user_model.dart';
import 'package:muserpol_pvt/screens/login.dart';
import 'package:muserpol_pvt/screens/navigator_bar.dart';
import 'package:muserpol_pvt/services/auth_service.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:muserpol_pvt/services/services.dart';
import 'package:provider/provider.dart';

//WIDGET: verifica la autenticación del usuario
class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //llamamos a los proveedores de estados
    final authService = Provider.of<AuthService>(context, listen: false);
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    // final appState = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          //verificamos si el usuario está autenticado
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            //en el caso de no encontrar el token solicitado
            //redireccionamos al usuario al ScreenLogin
            if (!snapshot.hasData) return const Text('');
            if (snapshot.data == '') {
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const ScreenLogin(),
                        transitionDuration: const Duration(seconds: 0)));
              });
            } else {
              //en el caso de encontrar el token solicitado
              //redireccionamos al usuario al ScreenLoading
              UserModel user = userModelFromJson(prefs!.getString('user')!);
              userBloc.add(UpdateUser(user.user!));
              // appState.addKey(
              //     'cianverso', prefs!.getString('ci')!); //num carnet
              // appState.addKey(
              //     'cireverso', prefs!.getString('ci')!); //num carnet
              // appState.addKey('cireverso', user.user!.fullName!); //nombre
              //controleVerified(context);

              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const NavigatorBar(),
                        transitionDuration: const Duration(seconds: 0)));
              });
            }
            return Container();
          },
        ),
      ),
    );
  }

  Future<void> controleVerified(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    final Map<String, dynamic> data = json.decode(await authService.readData());
    var response = await serviceMethod(
        context, 'post', data, serviceAuthSession(), false, false);
    if (response != null) {
      UserModel user =
          userModelFromJson(json.encode(json.decode(response.body)['data']));

      authService.login(context, user.apiToken!, data);
      userBloc.add(UpdateUser(user.user!));
      prefs!.setString('user', json.encode(json.decode(response.body)['data']));
    }
  }
}
