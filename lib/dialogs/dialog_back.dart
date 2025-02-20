import 'package:muserpol_pvt/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogBack extends StatelessWidget {
  const DialogBack({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Column(
        children: const [
          Text(
            '¿Estás seguro de salir de Muserpol?',
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: ButtonWhiteComponent(
                text: 'Salir',
                onPressed: () => SystemChannels.platform
                    .invokeMethod('SystemNavigator.pop'))),
            Expanded(child:ButtonWhiteComponentOutlined(
              text: 'Cancelar',
              onPressed: () => Navigator.of(context).pop(),
            ))
            
          ],
        )
      ],
    );
  }
}
