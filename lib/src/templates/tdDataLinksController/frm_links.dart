import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/alerts_varios.dart';
import '../../entity/td_entity.dart';
import '../../repository/prosroto_repository.dart';
import '../../singletons/tds_singleton.dart';
import '../../widgets/ayudas_by_campos.dart';
import '../../widgets/box_input_rounded_widget.dart';

class FrmLinks extends StatefulWidget {

  final ScaffoldState keySkffParent;

  FrmLinks({Key key, this.keySkffParent}) : super(key: key);

  @override
  _FrmLinksState createState() => _FrmLinksState();
}

class _FrmLinksState extends State<FrmLinks> {

  TdEntity tdEntity   = TdEntity();
  TdsSingleton tdsSng = TdsSingleton();
  ProsRotoRepository emRoto = ProsRotoRepository();
  AlertsVarios alertsVarios = AlertsVarios();

  TextEditingController _whatsappCtrl = TextEditingController();
  TextEditingController _telCtrl = TextEditingController();
  TextEditingController _redesCtrl = TextEditingController();

  FocusNode _whatsappFocus = FocusNode();
  FocusNode _telFocus = FocusNode();
  FocusNode _redesFocus = FocusNode();

  GlobalKey<FormState> _keyFrm = GlobalKey<FormState>();

  bool _isInit = false;
  bool _rsSeleccionada = false;
  int _editLinkIndex = -1;
  BuildContext _context;
  String _titInputLink = 'Selecciona la Red Social';
  String _linkForWhatsapp = 'https://wa.me/';
  String _linkForCall     = 'tel://';
  Map<String, dynamic> _linkCurrent = new Map();
  List<Map<String, dynamic>> _listLinkAdds = new List();
  String _valSelecInDrop;

  Map<String, dynamic> _getMapOfWhatsapp() {

    return  {
        'titulo': 'Whatsapp',
        'value': 'whatsapp',
        'url'  : '${this._linkForWhatsapp}',
        'urlCliente': '${this._linkForWhatsapp}',
        'select': true,
        'icon' : FontAwesomeIcons.whatsapp,
        'color': 0xff4caf50
      };
  }

  ///
  Map<String, dynamic> _getMapOfTel() {

    return  {
        'titulo': 'Llamada',
        'value': 'llamada',
        'url'  : '${this._linkForCall}',
        'urlCliente': '${this._linkForCall}',
        'select': true,
        'icon' : FontAwesomeIcons.phoneVolume,
        'color': 0xff000000
      };
  }

  ///
  List<Map<String, dynamic>> _getLink() {

    return [
      {
        'titulo': 'FaceBook',
        'value': 'facebook',
        'url'  : 'https://m.facebook.com/',
        'icon' : FontAwesomeIcons.facebook,
        'color': 0xff1976d2
      },
      {
        'titulo': 'Instagram',
        'value': 'instagram',
        'url'  : 'https://instagram.com',
        'icon' : FontAwesomeIcons.instagram,
        'color': 0xfff44336
      },
      {
        'titulo': 'Twitter',
        'value': 'twitter',
        'url'  : 'https://twitter.com',
        'icon' : FontAwesomeIcons.twitter,
        'color': 0xff2196f3
      },
      {
        'titulo': 'YouTube',
        'value': 'youtube',
        'url'  : 'https://youtube.com',
        'icon' : FontAwesomeIcons.youtube,
        'color': 0xfff44336
      },
      {
        'titulo': 'Google Maps',
        'value': 'google_maps',
        'url'  : 'https://www.google.com.mx/maps/preview',
        'icon' : FontAwesomeIcons.mapMarkedAlt,
        'color': 0xff4caf50
      },
      {
        'titulo': 'Página Web',
        'value': 'pagina_web',
        'url'  : '',
        'icon' : FontAwesomeIcons.globe,
        'color': 0xff03a9f4
      },
      {
        'titulo': 'Otros',
        'value': 'otros',
        'url'  : '',
        'icon' : FontAwesomeIcons.link,
        'color': 0xffff9800
      },
    ];
  }

  @override
  void initState() {
    _listLinkAdds.add(_getMapOfWhatsapp());
    _listLinkAdds.add(_getMapOfTel());
    WidgetsBinding.instance.addPostFrameCallback(_initWidget);
    super.initState();
  }

  @override
  void dispose() {
    this._whatsappCtrl?.dispose();
    this._telCtrl?.dispose();
    this._redesCtrl?.dispose();
    super.dispose();
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
  Future<void> _initWidget(_) async {

    Map<String, dynamic> dataLink = tdsSng.dataTd;

    if(dataLink['whatsapp'] != null && dataLink['whatsapp'].length > 0) {
      this._whatsappCtrl.text = dataLink['whatsapp'];
    }
    if(dataLink['telfijo'] != null && dataLink['telfijo'].length > 0) {
      this._telCtrl.text = dataLink['telfijo'];
    }
    if(dataLink['lstLinks'] != null && dataLink['lstLinks'].length > 2) {
      List<Map<String, dynamic>> linkLista = _getLink();
      List<Map<String, dynamic>> linkMins = List<Map<String, dynamic>>.from(dataLink['lstLinks']);

      for (var i = 0; i < linkMins.length; i++) {
        int indexSelec = linkLista.indexWhere((element) => (element['value'] == linkMins[i]['value']));
        if(indexSelec > -1) {
          linkLista[indexSelec]['url'] = linkMins[i]['urlCliente'];
          linkLista[indexSelec]['urlCliente'] = linkMins[i]['urlCliente'];
          linkLista[indexSelec]['select'] = linkMins[i]['select'];
          this._listLinkAdds.add(linkLista[indexSelec]);
        }
      }

      for (var i = 0; i < linkMins.length; i++) {
        int indexSelec =  this._listLinkAdds.indexWhere((element) => (element['value'] == linkMins[i]['value']));
        if(indexSelec > -1) {
          this._listLinkAdds[indexSelec]['url'] = linkMins[i]['urlCliente'];
          this._listLinkAdds[indexSelec]['urlCliente'] = linkMins[i]['urlCliente'];
          this._listLinkAdds[indexSelec]['select'] = linkMins[i]['select'];
        }
      }
    }
    setState(() { });
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
          input: _inputWhatsapp(),
        ),
        _btnCopyPhone(),
        BoxInputRoundedWidget(
          bg: const Color(0xffFFFFFF),
          hasBorder: false,
          input: _inputTel(),
        ),
        const SizedBox(height: 10),
        BoxInputRoundedWidget(
          bg: const Color(0xffFFFFFF),
          hasBorder: false,
          input: _inputSelectLinks(),
        ),
        _btnOpenLinks(),
        BoxInputRoundedWidget(
          bg: const Color(0xffFFFFFF),
          hasBorder: false,
          input: _inputSetLinkRs(),
        ),
        const SizedBox(height: 10),
        _btnNext(),
        const SizedBox(height: 10),
        FlatButton(
          onPressed: (){
            this._listLinkAdds = new List();
            tdsSng.dataTd['lstLinks'] = new List();
            tdEntity.setAllLink(new List());
            setState(() {});
          },
          child: Text(
            'LIMPAR LISTA DE LINKS',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red
            ),
          )
        )
      ],
    );
  }

  ///
  Widget _btnCopyPhone() {

    return FlatButton.icon(
      onPressed: () async {
        this._telCtrl.text = this._whatsappCtrl.text;
        FocusScope.of(this._context).requestFocus(this._redesFocus);
      },
      icon: FaIcon(FontAwesomeIcons.copy),
      label: Text(
        'Copiar y Pegar el Celular',
        textScaleFactor: 1,
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.purple
        ),
      )
    );
  }

  ///
  Widget _btnOpenLinks() {

    return FlatButton.icon(
      onPressed: () async {
        if(this._linkCurrent.isEmpty){ return false; }
        if(this._linkCurrent['url'].startsWith('http')) {
          await _launchURL('');
        }
      },
      icon: FaIcon(FontAwesomeIcons.chrome),
      label: Text(
        (this._linkCurrent.isNotEmpty) ? 'Abrir ${this._linkCurrent['titulo']}' : 'Primero Selecciona una R.S.',
        textScaleFactor: 1,
      )
    );
  }

  ///
  Widget _btnNext() {

    return RaisedButton.icon(
      onPressed: () async => await _verListaDeLink(),
      icon: Icon(Icons.arrow_forward, color: Colors.purple),
      label: Text(
        'SIGUIENTE',
        textScaleFactor: 1,
      )
    );
  }

  ///
  Widget _inputWhatsapp() {
    
    return TextFormField(
      controller: this._whatsappCtrl,
      focusNode: this._whatsappFocus,
      validator: (String val) {
        if(val.isEmpty) {
          return 'El Celular de contacto, es obligatorio';
        }
        return null;
      },
      onEditingComplete: () {
        FocusScope.of(this._context).requestFocus(this._telFocus);
      },
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: '*Whatsapp (Celular):',
        labelStyle: TextStyle(
          fontSize: 14
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.help, color: Colors.blue.withAlpha(100), size: 30),
          onPressed: () => AyudaByCampos(this._context).verAyuda('movil'),
        )
      ),
    );
  }

  ///
  Widget _inputTel() {
    
    return TextFormField(
      controller: this._telCtrl,
      focusNode: this._telFocus,
      validator: (String val) {
        if(val.isEmpty) {
          return 'El giro de la empresa, es obligatorio';
        }
        return null;
      },
      onFieldSubmitted: (String val) {
        FocusScope.of(this._context).requestFocus(this._redesFocus);
      },
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: '*Llamar a (Teléfono):',
        labelStyle: TextStyle(
          fontSize: 14
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.help, color: Colors.blue.withAlpha(100), size: 30),
          onPressed: () => AyudaByCampos(this._context).verAyuda('fijo'),
        )
      ),
    );
  }

  ///
  Widget _inputSelectLinks() {

    return DropdownButtonFormField(
      value: this._valSelecInDrop,
      dropdownColor: Colors.grey[100],
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
      hint: Text(
        'Lista de Enlaces',
        textScaleFactor: 1,
      ),
      items: _createWidgetOfLink(),
      onChanged: (val) {
        setState(() {
          this._rsSeleccionada = true;
          this._titInputLink = 'Link de $val';
        });
      },
    );
  }
  
  ///
  List<DropdownMenuItem> _createWidgetOfLink() {

    List<Map<String, dynamic>> links = _getLink();
    List<DropdownMenuItem> linksWidgets = new List();

    links.forEach((linkRs) {
      linksWidgets.add(
        DropdownMenuItem(
          value: linkRs['value'],
          onTap: (){
            this._linkCurrent = linkRs;
          },
          child: Row(
            children: [
              FaIcon(linkRs['icon'], size: 20, color: Color(linkRs['color'])),
              const SizedBox(width: 10),
              Text(
                '${linkRs['titulo']}',
                textScaleFactor: 1,
              )
            ],
          ),
        )
      );
    });

    return linksWidgets.toList();
  }

  ///
  Widget _inputSetLinkRs() {
    
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: TextFormField(
        controller: this._redesCtrl,
        focusNode: this._redesFocus,
        validator: (String val) {
          return null;
        },
        onFieldSubmitted: (String val) {
          FocusScope.of(this._context).requestFocus(new FocusNode());
        },
        keyboardType: TextInputType.url,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: this._titInputLink,
          labelStyle: TextStyle(
            fontSize: 14
          ),
          helperText: '   -> Agregadas ${this._listLinkAdds.length}',
          suffixIcon: (this._rsSeleccionada)
          ?
          IconButton(
            icon: FaIcon(FontAwesomeIcons.solidCaretSquareDown, color: Colors.purple),
            onPressed: () => _addLinkSeleccionadoToList(),
          )
          :
          const SizedBox(height: 0)
        ),
      ),
    );
  }

  ///
  Future<void> _addLinkSeleccionadoToList() async {

    if(this._editLinkIndex != -1) {
      await _editLinkSeleccionadoToList();
      return;
    }

    Map<String, dynamic> has = this._listLinkAdds.firstWhere((element){
      if(element.containsKey('urlCliente')){
        return element['urlCliente'] == this._redesCtrl.text;
      }
      return false;
    }, orElse: () => new Map());

    if(has.isEmpty) {
      if(this._redesCtrl.text.length > 5) {

        await _gestionarTelsComoLinks();
        Map<String, dynamic> newMap = new Map<String, dynamic>.from(this._linkCurrent);
        newMap['urlCliente'] = this._redesCtrl.text;
        newMap['select'] = true;
        this._listLinkAdds.add(newMap);
        tdEntity.setAllLink(this._listLinkAdds);
        tdsSng.setDataLinks(tdEntity);
        tdEntity.setAllLink(new List());
        newMap = null;
        this._redesCtrl.text = '';
        setState(() { });
      }
    }
  }

  ///
  Future<void> _editLinkSeleccionadoToList() async {

    if(this._redesCtrl.text.length > 5) {
      this._listLinkAdds[this._editLinkIndex]['url'] = this._redesCtrl.text;
      this._listLinkAdds[this._editLinkIndex]['urlCliente'] = this._redesCtrl.text;
      this._redesCtrl.text = '';
      this._editLinkIndex = -1;
      FocusScope.of(this._context).requestFocus(new FocusNode());
      await _verListaDeLink();
    }
  }

  ///
  Future<void> _verListaDeLink() async {

    if(!this._keyFrm.currentState.validate()) { return false; }
    await _gestionarTelsComoLinks();

    showModalBottomSheet(
      context: this._context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return _contenidoDeListaSeleccionada(setState);
          },
        );
      }
    );
  }

  ///
  Future<void> _gestionarTelsComoLinks() async {

    int hasIndex = this._listLinkAdds.indexWhere((link) {
      return (link['value'] == 'whatsapp');
    });

    Map<String, dynamic> mapLink = new Map();

    if(hasIndex == -1) {
      mapLink = _getMapOfWhatsapp();
      mapLink['url'] = '${mapLink['url']}52${this._whatsappCtrl.text}';
      mapLink['urlCliente'] = mapLink['url'];
      this._listLinkAdds.add(mapLink);
    }else{
      this._listLinkAdds[hasIndex]['url'] = '${this._linkForWhatsapp}52${this._whatsappCtrl.text}';
      this._listLinkAdds[hasIndex]['urlCliente'] = this._listLinkAdds[hasIndex]['url'];
    }

    hasIndex = this._listLinkAdds.indexWhere((link) {
      return (link['value'] == 'llamada');
    });

    if(hasIndex == -1) {
      mapLink = _getMapOfTel();
      mapLink['url'] = '${mapLink['url']}${this._telCtrl.text}';
      mapLink['urlCliente'] = mapLink['url'];
      this._listLinkAdds.add(mapLink);
    }else{
      this._listLinkAdds[hasIndex]['url'] = '${this._linkForCall}${this._telCtrl.text}';
      this._listLinkAdds[hasIndex]['urlCliente'] = this._listLinkAdds[hasIndex]['url'];
    }
  }

  ///
  Widget _contenidoDeListaSeleccionada(StateSetter refreshPage) {

    return Container(
      height: MediaQuery.of(context).size.height * 0.60,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LINKS PARA COLOCAR',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.blue
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.help),
                  onPressed: () => AyudaByCampos(this._context).verAyuda('listRss')
                )
              ],
            ),
          ),
          const Divider(),
          Flexible(
            flex: 5,
            child: ListView.builder(
              itemCount: this._listLinkAdds.length,
              itemBuilder: (BuildContext context, int index) {

                String subTitle = (this._listLinkAdds[index]['urlCliente'].toString().length >= 27)
                ? this._listLinkAdds[index]['urlCliente'].toString().substring(0, 24) + '...'
                : this._listLinkAdds[index]['urlCliente'].toString();

                return InkWell(
                  onLongPress: (){
                    _launchURL(this._listLinkAdds[index]['urlCliente']);
                  },
                  child: Dismissible(
                    confirmDismiss: (DismissDirection direction) async {

                      if(direction == DismissDirection.endToStart) {
                        String body = '¿Estas segur@ de querere eliminar el link de la lista?';
                        bool res = await alertsVarios.aceptarAndCancelar(this._context, titulo: 'ELIMINAR LINK', body: body);
                        
                        if(res) {
                          this._listLinkAdds.removeAt(index);
                          Navigator.of(this._context).pop(true);
                          _verListaDeLink();
                          return true;
                        }else{
                          return false;
                        }
                      }else{
                        bool edit = true;
                        if(this._listLinkAdds[index]['value'] == 'whatsapp') {
                          edit = false;
                          Navigator.of(this._context).pop(true);
                        }
                        if(this._listLinkAdds[index]['value'] == 'llamada') {
                          edit = false;
                          Navigator.of(this._context).pop(true);
                        }
                        if(edit) {
                          this._valSelecInDrop = this._listLinkAdds[index]['value'];
                          this._redesCtrl.text = this._listLinkAdds[index]['url'];
                          this._editLinkIndex = index;
                          setState(() { });
                          this._rsSeleccionada = true;
                          Navigator.of(this._context).pop(true);
                        }
                      }
                      return false;
                    },
                    background: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.edit, color: Colors.blue, size: 30),
                          Icon(Icons.delete, color: Colors.orange[900], size: 30),
                        ],
                      ),
                    ),
                    key: Key('$index'),
                    child: CheckboxListTile(
                      subtitle: Text(
                        '$subTitle'
                      ),
                      title: Row(
                        children: [
                          FaIcon(this._listLinkAdds[index]['icon'], size: 20, color: Color(this._listLinkAdds[index]['color'])),
                          const SizedBox(width: 5),
                          Text(
                            this._listLinkAdds[index]['titulo']
                          )
                        ],
                      ),
                      onChanged: (bool val){
                        refreshPage(() {
                          this._listLinkAdds[index]['select'] = val;
                        });
                      },
                      value: this._listLinkAdds[index]['select'],
                    ),
                  ),
                );
              }
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  RaisedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      'CANCELAR'
                    ),
                  ),
                  RaisedButton.icon(
                    icon: Icon(Icons.arrow_forward, color: Colors.blue),
                    onPressed: () => _sendDataLinks(),
                    label: Text(
                      'CONTINUAR'
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 7)
        ],
      ),
    );
  }

  ///
  Future<void> _launchURL(String url) async {
    
    String urlLaunch;
    if(url.isNotEmpty) {
      urlLaunch = url;
    }else{
      urlLaunch = this._linkCurrent['url'];
    }
    await _saveProsRoto('td_data_links');
    if (await canLaunch(urlLaunch)) {
      await launch(urlLaunch);
    } else {
      setState(() {
        this._titInputLink = 'No se puedo abrir el Link';
      });
    }
  }

  ///
  Future<void> _saveProsRoto(String ruta) async {

    tdEntity.setTelFiijo(this._telCtrl.text);
    tdEntity.setWhatsapp(this._whatsappCtrl.text);

    tdEntity.resetLstLink();
    await tdEntity.setAllLink(this._listLinkAdds);
    tdsSng.setDataLinks(tdEntity);
    await emRoto.setProceso('FrmLinks', ruta, tdsSng.dataTd);
  }

  ///
  Future<void> _sendDataLinks() async {

    await _saveProsRoto('td_data_disenio');
    if(tdsSng.isEdit){
      tdsSng.isEdit = false;
      Navigator.of(this._context).pushReplacementNamed('td_data_send');
    }else{
      Navigator.of(this._context).pushReplacementNamed('td_data_disenio');
    }
  }

}