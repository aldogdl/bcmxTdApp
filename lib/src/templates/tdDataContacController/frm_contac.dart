import 'package:flutter/material.dart';

import '../../singletons/tds_singleton.dart';
import '../../widgets/ayudas_by_campos.dart';
import '../../widgets/box_input_rounded_widget.dart';
import '../../entity/td_entity.dart';
import '../../repository/user_repository.dart';
import '../../repository/prosroto_repository.dart';
import '../../utils/text_utils.dart';
import '../../widgets/alerts_varios.dart';

class FrmContac extends StatefulWidget {

  final ScaffoldState scaffoldParent;
  FrmContac({Key key, this.scaffoldParent}) : super(key: key);

  @override
  _FrmContacState createState() => _FrmContacState();
}

class _FrmContacState extends State<FrmContac> {

  TextUtils textUtils = TextUtils();
  TdEntity _tdEntity = TdEntity();
  TdsSingleton tdsSng = TdsSingleton();
  ProsRotoRepository emRoto = ProsRotoRepository();
  UserRepository emUser = UserRepository();
  AlertsVarios alertsVarios = AlertsVarios();

  TextEditingController _usernameCtrl = TextEditingController();
  TextEditingController _nombreClienteCtrl = TextEditingController();
  TextEditingController _nombreEmpresaCtrl = TextEditingController();
  TextEditingController _giroCtrl = TextEditingController();
  TextEditingController _queVendeCtrl = TextEditingController();
  TextEditingController _domicilioCtrl = TextEditingController();
  TextEditingController _referenciasCtrl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();

  GlobalKey<FormState> _keyFrm = GlobalKey<FormState>();

  FocusNode _usernameFocus = FocusNode();
  FocusNode _nombreClienteFocus = FocusNode();
  FocusNode _nombreEmpresaFocus = FocusNode();
  FocusNode _giroFocus = FocusNode();
  FocusNode _queVendeFocus = FocusNode();
  FocusNode _domicilioFocus = FocusNode();
  FocusNode _referenciasFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  bool _requireFacFocus = false;

  bool _isInit = false;
  bool _verMasInputs = false;
  String _usernameChk = 'El nombre de Usuario debe ser único';
  BuildContext _context;

  @override
  void dispose() {
    this._usernameCtrl?.dispose();
    this._nombreClienteCtrl?.dispose();
    this._nombreEmpresaCtrl?.dispose();
    this._giroCtrl?.dispose();
    this._queVendeCtrl?.dispose();
    this._domicilioCtrl?.dispose();
    this._referenciasCtrl?.dispose();
    this._emailCtrl?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_checkHasData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(!this._isInit) {
      this._isInit = true;
      this._context = context;
      context = null;
    }
  
    return Form(
      key: this._keyFrm,
      child: _body(),
    );
  }

  ///
  Future<void> _checkHasData(_) async {

    Map<String, dynamic> hasData = tdsSng.dataTd;
    if(hasData['nombreEmpresa'] != null) {
      this._usernameCtrl.text    =hasData['username'];
      this._nombreClienteCtrl.text=hasData['nombreCliente'];
      this._nombreEmpresaCtrl.text=hasData['nombreEmpresa'];
      this._giroCtrl.text        = hasData['giro'];
      this._queVendeCtrl.text    = hasData['queVende'];
      this._domicilioCtrl.text   = hasData['domicilio'];
      this._referenciasCtrl.text = hasData['referencias'];
      this._emailCtrl.text       = hasData['email'];
      this._requireFacFocus      = hasData['requireFac'];
    }

    if(this._domicilioCtrl.text.length > 3) {
      this._verMasInputs = true;
    }

    hasData = null;
    setState(() {});
  }

  ///
  Widget _body() {

    return ListView(
      padding: EdgeInsets.all(20),
      shrinkWrap: true,
      addAutomaticKeepAlives: true,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
      children: [
        BoxInputRoundedWidget(
          bg: const Color(0xffFFFFFF),
          hasBorder: false,
          input: _inputUsername(),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, top: 5),
          child: Text(
            this._usernameChk,
            textScaleFactor: 1,
            style: TextStyle(
              color: this._usernameChk.startsWith('OK') ? Colors.purple : Colors.red,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(height: 20),
        BoxInputRoundedWidget(
          bg: const Color(0xffFFFFFF),
          hasBorder: false,
          input: _inputNombreCliente(),
        ),
        const SizedBox(height: 10),
        BoxInputRoundedWidget(
          bg: const Color(0xffFFFFFF),
          hasBorder: false,
          input: _inputNombreEmpresa(),
        ),
        const SizedBox(height: 10),
        BoxInputRoundedWidget(
          bg: const Color(0xffFFFFFF),
          hasBorder: false,
          input: _inputGiro(),
        ),
        const SizedBox(height: 10),
        BoxInputRoundedWidget(
          bg: const Color(0xffFFFFFF),
          hasBorder: false,
          input: _inputQueVende(),
        ),
        const SizedBox(height: 10),
        FlatButton(
          onPressed: (){
            setState(() {
              this._verMasInputs = !this._verMasInputs;
            });
            FocusScope.of(this._context).requestFocus(this._domicilioFocus);
          },
          child: Text(
            'Colocar DOMICILIO o EMAIL',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.purple,
              decoration: TextDecoration.underline,
              decorationThickness: 1,
              decorationStyle: TextDecorationStyle.solid,
            ),
          ),
        ),
        (!this._verMasInputs)
        ?
        SizedBox(height: 0)
        :
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: BoxInputRoundedWidget(
            bg: const Color(0xffFFFFFF),
            hasBorder: false,
            input: _inputDomicilio(),
          ),
        ),
        (!this._verMasInputs)
        ?
        SizedBox(height: 0)
        :
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: BoxInputRoundedWidget(
            bg: const Color(0xffFFFFFF),
            hasBorder: false,
            input: _inputReferencia(),
          ),
        ),
        (!this._verMasInputs)
        ?
        SizedBox(height: 0)
        :
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: BoxInputRoundedWidget(
            bg: const Color(0xffFFFFFF),
            hasBorder: false,
            input: _inputEmail(),
          ),
        ),
        CheckboxListTile(
          title: Text(
            '¿Requiere Factura?',
            textScaleFactor: 1,
          ),
          subtitle: Text(
            'El costo sería más I.V.A.',
            textScaleFactor: 1,
          ),
          value: this._requireFacFocus,
          onChanged: (bool val) {
            setState(() {
              this._requireFacFocus = val;
            });
          },
        ),
        RaisedButton.icon(
          onPressed: () async => await _sendDataContac(),
          icon: Icon(Icons.arrow_forward, color: Colors.blue),
          label: Text(
            'SIGUIENTE',
            textScaleFactor: 1,
          )
        )
      ],
    );
  }

  ///
  Widget _inputUsername() {
    
    return TextFormField(
      controller: this._usernameCtrl,
      focusNode: this._usernameFocus,
      validator: (String val) {
        if(val.isEmpty) {
          return 'El nombre de Usuario, es obligatorio';
        }
        return null;
      },
      onFieldSubmitted: (String val) async {
        FocusScope.of(this._context).requestFocus(this._nombreClienteFocus);
        await _checkUnicUsername();
      },
      onEditingComplete: () async {
        FocusScope.of(this._context).requestFocus(this._nombreClienteFocus);
        await _checkUnicUsername();
      },
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: '*Nombre de Usuario:',
        labelStyle: TextStyle(
          fontSize: 14
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.help, color: Colors.blue.withAlpha(100), size: 30),
          onPressed: () => AyudaByCampos(this._context).verAyuda('username'),
        )
      ),
    );
  }

  ///
  Widget _inputNombreCliente() {
    
    return TextFormField(
      controller: this._nombreClienteCtrl,
      focusNode: this._nombreClienteFocus,
      validator: (String val) {
        if(val.isEmpty) {
          return 'El nombre del Cliente, es obligatorio';
        }
        return null;
      },
      onFieldSubmitted: (String val) async {
        FocusScope.of(this._context).requestFocus(this._nombreEmpresaFocus);
      },
      onEditingComplete: () async {
        FocusScope.of(this._context).requestFocus(this._nombreEmpresaFocus);
      },
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: '*Nombre del Cliente:',
        labelStyle: TextStyle(
          fontSize: 14
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.help, color: Colors.blue.withAlpha(100), size: 30),
          onPressed: () => AyudaByCampos(this._context).verAyuda('nombreCliente'),
        )
      ),
    );
  }

  ///
  Widget _inputNombreEmpresa() {
    
    return TextFormField(
      controller: this._nombreEmpresaCtrl,
      focusNode: this._nombreEmpresaFocus,
      validator: (String val) {
        if(val.isEmpty) {
          return 'El nombre, es obligatorio';
        }
        return null;
      },
      onFieldSubmitted: (String val) {
        FocusScope.of(this._context).requestFocus(this._giroFocus);
      },
      onEditingComplete: () {
        FocusScope.of(this._context).requestFocus(this._giroFocus);
      },
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: '*Nombre de la Empresa:',
        labelStyle: TextStyle(
          fontSize: 14
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.help, color: Colors.blue.withAlpha(100), size: 30),
          onPressed: () => AyudaByCampos(this._context).verAyuda('nombreEmpresa'),
        )
      ),
    );
  }

  ///
  Widget _inputGiro() {
    
    return TextFormField(
      controller: this._giroCtrl,
      focusNode: this._giroFocus,
      maxLines: 3,
      validator: (String val) {
        if(val.isEmpty) {
          return 'El giro de la empresa, es obligatorio';
        }
        return null;
      },
      onFieldSubmitted: (String val) {
        FocusScope.of(this._context).requestFocus(this._queVendeFocus);
      },
      onEditingComplete: () {
        FocusScope.of(this._context).requestFocus(this._queVendeFocus);
      },
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: '*Giro de la Empresa:',
        labelStyle: TextStyle(
          fontSize: 14
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.help, color: Colors.blue.withAlpha(100), size: 30),
          onPressed: () => AyudaByCampos(this._context).verAyuda('giroEmpresa'),
        )
      ),
    );
  }

  ///
  Widget _inputQueVende() {
    
    return TextFormField(
      controller: this._queVendeCtrl,
      focusNode: this._queVendeFocus,
      maxLines: 3,
      validator: (String val) {
        if(val.isEmpty) {
          return 'Indica lo que el negocio vende';
        }
        return null;
      },
      onFieldSubmitted: (String val) {
        if(this._verMasInputs){
          FocusScope.of(this._context).requestFocus(this._domicilioFocus);
        }else{
          FocusScope.of(this._context).requestFocus(new FocusNode());
        }
      },
      onEditingComplete: () {
        if(this._verMasInputs){
          FocusScope.of(this._context).requestFocus(this._domicilioFocus);
        }else{
          FocusScope.of(this._context).requestFocus(new FocusNode());
        }
      },
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: '*Que Vende?:',
        labelStyle: TextStyle(
          fontSize: 14
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.help, color: Colors.blue.withAlpha(100), size: 30),
          onPressed: () => AyudaByCampos(this._context).verAyuda('queVende'),
        )
      ),
    );
  }

  ///
  Widget _inputDomicilio() {
    
    return TextFormField(
      controller: this._domicilioCtrl,
      focusNode: this._domicilioFocus,
      validator: (String val) {
        return null;
      },
      onFieldSubmitted: (String val) {
        FocusScope.of(this._context).requestFocus(this._referenciasFocus);
      },
      onEditingComplete: () {
        FocusScope.of(this._context).requestFocus(this._referenciasFocus);
      },
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: 'Domicilio del Comercio:',
        labelStyle: TextStyle(
          fontSize: 14
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.help, color: Colors.blue.withAlpha(100), size: 30),
          onPressed: () => AyudaByCampos(this._context).verAyuda('domicilio'),
        )
      ),
    );
  }

  ///
  Widget _inputReferencia() {
    
    return TextFormField(
      controller: this._referenciasCtrl,
      focusNode: this._referenciasFocus,
      validator: (String val) {
        return null;
      },
      onFieldSubmitted: (String val) {
        FocusScope.of(this._context).requestFocus(this._emailFocus);
      },
      onEditingComplete: () {
        FocusScope.of(this._context).requestFocus(this._emailFocus);
      },
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: 'Referencias de Ubicación:',
        labelStyle: TextStyle(
          fontSize: 14
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.help, color: Colors.blue.withAlpha(100), size: 30),
          onPressed: () => AyudaByCampos(this._context).verAyuda('referencia'),
        )
      ),
    );
  }

  ///
  Widget _inputEmail() {
    
    return TextFormField(
      controller: this._emailCtrl,
      focusNode: this._emailFocus,
      validator: (String val) {
        return null;
      },
      onFieldSubmitted: (String val) {
        FocusScope.of(this._context).requestFocus(new FocusNode());
      },
      onEditingComplete: () {
        FocusScope.of(this._context).requestFocus(new FocusNode());
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: 'Correo Electrónico:',
        labelStyle: TextStyle(
          fontSize: 14
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.help, color: Colors.blue.withAlpha(100), size: 30),
          onPressed: () => AyudaByCampos(this._context).verAyuda('email'),
        )
      ),
    );
  }

  ///
  Future<void> _sendDataContac() async {

    if(this._keyFrm.currentState.validate()) {

      alertsVarios.cargando(this._context, titulo: 'Procesando', body: 'Realizando operación');

      await _checkUnicUsername();
      if(this._usernameChk.startsWith('OK')){
        this._tdEntity.setUsername(this._usernameCtrl.text);
        this._tdEntity.setNombreCliente(this._nombreClienteCtrl.text);
        this._tdEntity.setNombreEmpresa(this._nombreEmpresaCtrl.text);
        this._tdEntity.setGiro(this._giroCtrl.text);
        this._tdEntity.setQueVende(this._queVendeCtrl.text);
        this._tdEntity.setDomicilio(this._domicilioCtrl.text);
        this._tdEntity.setReferencias(this._referenciasCtrl.text);
        this._tdEntity.setEmail(this._emailCtrl.text);
        this._tdEntity.setRequireFac(this._requireFacFocus);

        tdsSng.setDataContac(this._tdEntity);
        await emRoto.setProceso('FrmContac', 'td_data_links', tdsSng.dataTd);

        if(tdsSng.isEdit){
          tdsSng.isEdit = false;
          Navigator.of(this._context).pushReplacementNamed('td_data_send');
        }else{
          Navigator.of(this._context).pushReplacementNamed('td_data_links');
        }
      }else{
        _verSnackErroFrm('NOMBRE DE USUARIO OCUPADO');
      }

    }else{
      _verSnackErroFrm('ERROR EN EL FORMULARIO');
    }
  }

  ///
  Future<void> _verSnackErroFrm(String txt) async {

    widget.scaffoldParent.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              txt,
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      )
    );
  }

  ///
  Future<void> _checkUnicUsername() async {

    if(this._usernameCtrl.text.isEmpty){ return false; }
    this._usernameCtrl.text = textUtils.quitarAcentosToPalabras(this._usernameCtrl.text);
    this._usernameCtrl.text = textUtils.quitarEspaciosEnBlanco(this._usernameCtrl.text);

    setState(() {
      this._usernameChk = 'Checando Disponibilidad...';
    });

    bool existe = await emUser.checkUnicUsername(this._usernameCtrl.text);
    if(existe) {
      this._usernameChk = '!UPS!, Ya existe, coloca OTRO';
    }else{
      this._usernameChk = 'OK, Usuario disponible';
    }

    setState(() { });
  }
}