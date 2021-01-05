import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/box_input_rounded_widget.dart';
import '../../widgets/alerts_varios.dart';
import '../../repository/user_repository.dart';


class FrmLoginWidget extends StatefulWidget {

  final ScaffoldState keyScaffoldParent;

  FrmLoginWidget({Key key, this.keyScaffoldParent}) : super(key: key);

  @override
  _FrmLoginWidgetState createState() => _FrmLoginWidgetState();
}

class _FrmLoginWidgetState extends State<FrmLoginWidget> {

  AlertsVarios alertsVarios = AlertsVarios();
  UserRepository emUser = UserRepository();

  TextEditingController _userCtrl = TextEditingController();
  TextEditingController _passCtrl = TextEditingController();
  FocusNode _userFocus = FocusNode();
  FocusNode _passFocus = FocusNode();
  GlobalKey<FormState> _keyFrm = GlobalKey<FormState>();

  bool _obscurePass = true;
  bool _isInit = false;
  BuildContext _context;
  IconData _iconoVerPass = Icons.remove_red_eye;

  @override
  void dispose() {
    this._userCtrl?.dispose();
    this._passCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(!this._isInit) {
      this._isInit = true;
      this._context = context;
      context = null;
    }

    return Container(
      width: MediaQuery.of(this._context).size.width,
      height: MediaQuery.of(this._context).size.height,
      child: Center(
        child: Form(
          key: this._keyFrm,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(this._context).size.width * 0.1,
            ),
            children: [
              BoxInputRoundedWidget(
                bg: Colors.white,
                input: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Image(
                    image: AssetImage('assets/images/buscomex_logo.png'),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'AUTENTÍCATE',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
              const SizedBox(height: 10),
              BoxInputRoundedWidget(
                bg: Colors.white,
                hasBorder: true,
                input: _inputUser(),
              ),
              const SizedBox(height: 20),
              BoxInputRoundedWidget(
                bg: Colors.white,
                hasBorder: true,
                input: _inputPass(),
              ),
              const SizedBox(height: 30),
              _btnEnviar()
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _inputUser() {

    return TextFormField(
      controller: this._userCtrl,
      focusNode: this._userFocus,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      validator: (String val) {
        if(val.isEmpty) {
          return 'El usuario es requerido';
        }
        return null;
      },
      onEditingComplete: () {
        FocusScope.of(this._context).requestFocus(this._passFocus);
      },
      decoration: InputDecoration(
        labelText: 'Usuario:',
        border: InputBorder.none
      ),
    );
  }

  ///
  Widget _inputPass() {

    return TextFormField(
      controller: this._passCtrl,
      focusNode: this._passFocus,
      obscureText: this._obscurePass,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      onEditingComplete: (){
        FocusScope.of(this._context).requestFocus(new FocusNode());
      },
      validator: (String val) {
        if(val.isEmpty) {
          return 'La contraseña es requerida';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Contraseña:',
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: Icon(this._iconoVerPass),
          onPressed: () {
            setState(() {
              this._obscurePass = !this._obscurePass;
              this._iconoVerPass = (!this._obscurePass) ? Icons.lock : Icons.remove_red_eye;
            });
          },
        )
      ),
    );
  }

  ///
  Widget _btnEnviar() {

    return RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      color: Colors.white,
      textColor: Colors.blue,
      onPressed: () async => await _enviar(),
      child: Text('IDENTIFÍCATE'),
    );
  }

  ///
  Widget _miSnackErrorFrmLogin() {

    return SnackBar(
      padding: EdgeInsets.all(0),
      backgroundColor: Colors.red,
      content: Text(
        '¡ERROR en el FORMULARIO!',
        textScaleFactor: 1,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  ///
  Future<bool> _enviar() async {

    if(this._keyFrm.currentState.validate()) {
      Map<String, dynamic> dataUser = {
        'usname': this._userCtrl.text.trim(),
        'uspass': this._passCtrl.text.trim(),
      };
      bool res = await emUser.firstAutenticacion(this._context, dataUser);
      if(res) {
        Navigator.of(this._context).pushNamedAndRemoveUntil('init_config_ctrl', (route) => false);
      }
    }else{
      widget.keyScaffoldParent.showSnackBar(_miSnackErrorFrmLogin());
    }
    return false;
  }
}