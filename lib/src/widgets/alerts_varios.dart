import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AlertsVarios {

  BuildContext _context;
  String _titulo;
  String _body;
  Widget _contenido;

  ///
  Future<void> cargando(BuildContext context, {String titulo, String body}) async {

    this._titulo = titulo;
    this._body = body;
    this._context = context;

    context = titulo = body = null;
    this._contenido = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        LinearProgressIndicator(),
        Text(
          '${this._body}',
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: TextStyle(),
        )
      ],
    );

    return _showDialog('cargando');
  }

  ///
  Future<void> entendido(BuildContext context, {String titulo, String body, IconData icono = Icons.check}) async {

    this._titulo = titulo;
    this._body = body;
    this._context = context;

    context = titulo = body = null;
    this._contenido = _contenidoClasico(icono, Colors.blue, this._body);

    return _showDialog('entendido');
  }

  ///
  Future<dynamic> aceptarAndCancelar(BuildContext context, {String titulo, String body, IconData icono = Icons.check}) async {

    this._titulo = titulo;
    this._body = body;
    this._context = context;

    context = titulo = body = null;
    this._contenido = _contenidoClasico(icono, Colors.blue, this._body);

    return _showDialog('aceptarAndCancelar');
  }

  ///
  Future<bool> prosRoto(BuildContext context, {String proceso}) async {

    this._titulo = proceso;
    this._context = context;

    context = proceso = null;
    String body = 'Se detectó un proceso roto, el cual fué recuperado.\n\n'+
    'Presiona [ELIMINAR], en caso de no querer continuar con el, '+
    'de lo contrario preciona [RECUPERAR].';

    this._contenido = _contenidoClasico(FontAwesomeIcons.heartBroken, Colors.red, body);

    dynamic res = await _showDialog('prosroto');
    return (res == false) ? false : true;
  }

  ///
  Widget _contenidoClasico(IconData icono,  Color iconoColor, String body) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icono, size: 40, color: iconoColor),
        Text(
          '$body',
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: TextStyle(),
        )
      ],
    );
  }

  ///
  Future<dynamic> _showDialog(String tipoAlert) {

    return showDialog(
      barrierDismissible: false,
      context: this._context,
      builder: (_) => _alertaDialog(_getAccionesSegunDialog(tipoAlert))
    );
  }

  ///
  Widget _alertaDialog(List<Widget> acciones) {

    return AlertDialog(
      insetPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      actions: acciones,
      title: Text(
        '${this._titulo}',
        textScaleFactor: 1,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red
        ),
      ),
      content: this._contenido,
    );
  }

  ///
  List<Widget> _getAccionesSegunDialog(String dialog) {

    switch (dialog) {

      case 'entendido':
        return [
          FlatButton(
            onPressed: () => Navigator.of(this._context).pop(false),
            child: Text(
              'ENTENDIDO',
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.blue
              ),
            )
          )
        ];
        break;

      case 'prosroto':
        return [
          FlatButton(
            onPressed: () => Navigator.of(this._context).pop(false),
            child: Text(
              'ELIMINAR',
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.red
              ),
            )
          ),
          FlatButton(
            onPressed: () => Navigator.of(this._context).pop(true),
            child: Text(
              'RECUPERAR',
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.blue
              ),
            )
          )
        ];
        break;

      case 'aceptarAndCancelar':
        return [
          FlatButton(
            onPressed: () => Navigator.of(this._context).pop(false),
            child: Text(
              'CANCELAR',
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.red
              ),
            )
          ),
          FlatButton(
            onPressed: () => Navigator.of(this._context).pop(true),
            child: Text(
              'ACEPTAR',
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.blue
              ),
            )
          )
        ];
        break;
      default:
        return null;
    }
  }

}