import 'package:bcmxtds/src/repository/data_server_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/data_shared.dart';
import '../../entity/td_entity.dart';
import '../../widgets/box_input_rounded_widget.dart';
import '../../widgets/ayudas_by_campos.dart';
import '../../repository/prosroto_repository.dart';
import '../../repository/user_repository.dart';
import '../../singletons/tds_singleton.dart';
import '../../singletons/franqs_cats_singleton.dart';

class FrmFranqCatsCost extends StatefulWidget {

  final ScaffoldState keySkffParent;

  FrmFranqCatsCost({Key key, this.keySkffParent}) : super(key: key);

  @override
  _FrmFranqCatsCostState createState() => _FrmFranqCatsCostState();
}

class _FrmFranqCatsCostState extends State<FrmFranqCatsCost> {

  TdsSingleton tdsSng = TdsSingleton();
  FranqCatsSng franqCatsSng = FranqCatsSng();
  ProsRotoRepository emRoto = ProsRotoRepository();
  TdEntity tdEntity = TdEntity();
  UserRepository emUser = UserRepository();
  DataServerRepository emServer = DataServerRepository();

  TextEditingController _costoCtrl = TextEditingController();
  TextEditingController _divCtrl = TextEditingController();

  FocusNode _costoFocus = FocusNode();
  FocusNode _franFocus = FocusNode();
  FocusNode _divFocus = FocusNode();

  GlobalKey<FormState> _keyFrm = GlobalKey<FormState>();
  bool _isInit = false;
  bool _checkCatgos = false;
  bool _recoveryData = true;
  BuildContext _context;
  String _tokenServer = '';
  String _recoveryDataTxt = 'Recuperando Datos';
  int _categoId = 0;
  int _subcategoId = 0;
  Widget _dropSubCatego;
  List<Map<String, dynamic>> _categosSelect = new List();

  @override
  void dispose() {
    this._costoCtrl?.dispose();
    this._divCtrl?.dispose();
    super.dispose();
  }

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback(_initWidget);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(!this._isInit) {
      this._isInit = true;
      this._context = context;
      context = null;
    }

    return Stack(
      children: [
        Form(
          key: this._keyFrm,
          child: _widgets()
        ),
        (this._recoveryData) ?
        Container(
          width: MediaQuery.of(this._context).size.width,
          height: MediaQuery.of(this._context).size.height,
          decoration: BoxDecoration(
            color: Color(0xff0070B3).withAlpha(100),
          ),
          child: Center(
            child: Container(
              width: MediaQuery.of(this._context).size.width * 0.65,
              height: MediaQuery.of(this._context).size.height * 0.15,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xff0070B3),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  Text(
                    this._recoveryDataTxt,
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white)
                    )
                  )
                ]
              ),
            ),
          ),
        )
        : SizedBox(height: 0)
      ],
    );
  }

  ///
  Future<void> _initWidget(_) async {

    this._dropSubCatego = _dropDwBacio('Selecciona Categoría');
    Map<String, dynamic> dataTd = tdsSng.toJsonDataGenerales();

    if(dataTd['costo'] != null) {

      this._costoCtrl.text = dataTd['costo'].toString();
      this._divCtrl.text = dataTd['div'];
      franqCatsSng.setFranqSelect(dataTd['franq']);
      dataTd = null;
      if(tdsSng.isEdit){
        this._recoveryData = false;
      }
      await _selectCategoriaExistente();
    }else{
      this._recoveryData = false;
    }
    setState(() { });
  }

  ///
  Widget _widgets() {

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      children: [
        const SizedBox(height: 30),
        BoxInputRoundedWidget(
          bg: const Color(0xffFFFFFF),
          hasBorder: false,
          input: _inputCosto(),
        ),
        const SizedBox(height: 10),
        BoxInputRoundedWidget(
          bg: const Color(0xffFFFFFF),
          hasBorder: false,
          input: _dropDwFranqs(),
        ),
        const SizedBox(height: 10),
        FutureBuilder(
          future: _getCategos(),
          builder: (_, AsyncSnapshot snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              
              return BoxInputRoundedWidget(
                bg: const Color(0xffFFFFFF),
                hasBorder: false,
                input: _dropDwCategos(),
              );
            }
            return BoxInputRoundedWidget(
              bg: const Color(0xffFFFFFF),
              hasBorder: false,
              input:  _dropDwBacio('Cargando Categorías...'),
            );
          },
        ),
        const SizedBox(height: 10),
        BoxInputRoundedWidget(
          bg: const Color(0xffFFFFFF),
          hasBorder: false,
          input: this._dropSubCatego,
        ),
         const SizedBox(height: 10),
        BoxInputRoundedWidget(
          bg: const Color(0xffFFFFFF),
          hasBorder: false,
          input: _inputDivision(),
        ),
        const SizedBox(height: 10),
       
        RaisedButton.icon(
          onPressed: () => _sendDataDisenio(),
          icon: Icon(Icons.arrow_forward, color: Colors.blue),
          label: Text(
            'SIGUIENTE',
            textScaleFactor: 1,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  ///
  Widget _inputCosto() {
    
    return TextFormField(
      controller: this._costoCtrl,
      focusNode: this._costoFocus,
      validator: (String val) {
        if(val.isEmpty){
          return 'Indica el costo final del Servicio';
        }
        return null;
      },
      onEditingComplete: () {
        FocusScope.of(this._context).requestFocus(this._franFocus);
      },
      onFieldSubmitted: (String val) {
        FocusScope.of(this._context).requestFocus(this._franFocus);
      },
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: 'Costo del Servicio:',
        labelStyle: TextStyle(
          fontSize: 14
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.help, color: Colors.blue.withAlpha(100), size: 30),
          onPressed: () => AyudaByCampos(this._context).verAyuda('costoServ'),
        )
      ),
    );
  }

  ///
  Widget _dropDwFranqs() {

    List<DropdownMenuItem> franquicias = new List();

    if(franqCatsSng.franquicias.isEmpty) {
      franquicias.add( _dropItemInit('Sin FRANQUICIAS', Colors.red) );
    }else{
      franquicias.add( _dropItemInit('Lista de FRANQUICIAS', Colors.blue) );

      franqCatsSng.franquicias.forEach((element) {
        franquicias.add(
          DropdownMenuItem(
            value: element['f_id'],
            child: Text(
              '${ element['f_nombre'] }',
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.grey[600]
              ),
            ),
          )
        );
      });
    }

    return DropdownButtonFormField(
      focusNode: this._franFocus,
      icon: Icon(Icons.arrow_downward),
      elevation: 1,
      value: franqCatsSng.franqSelect,
      validator: (val) {
        if(val == '0' || val == 0) {
          return 'Selecciona una Franquicia.';
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xffFFFFFF),
        border: InputBorder.none
      ),
      items: franquicias.toList(),
      onChanged: (val) {
        franqCatsSng.setFranqSelect(val);
      }
    );
  }

  ///
  Widget _dropDwCategos() {

    if(franqCatsSng.categos.isNotEmpty) {

      List<DropdownMenuItem> categorias = new List();

      if(franqCatsSng.categos.isEmpty) {

        categorias.add( _dropItemInit('Sin CATEGORÍAS', Colors.red) );
      }else{

        categorias.add( _dropItemInit('Lista de CATEGORÍAS', Colors.blue) );

        franqCatsSng.categos.forEach((element) {

          String txt = element['c_nombre'].toString();
          txt = (txt.length >= 20) ? txt.substring(0, 19) + '...' : txt;
          categorias.add(
            DropdownMenuItem(
              value: element['c_id'],
              child: Text(
                '$txt',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.grey[600]
                ),
              ),
            )
          );
        });
      }      
      
      return DropdownButtonFormField(
        icon: Icon(Icons.arrow_downward),
        value: this._categoId,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xffFFFFFF),
          border: InputBorder.none
        ),
        items: categorias,
        onChanged: (val) async {
          setState(() {
            this._categoId = val;
            this._subcategoId = 0;
            this._dropSubCatego = _dropDwBacio('Buscando Sub Categoría');
          });
          await _getSubCategos();
        }
      );

    }else{
      return _dropDwBacio('Sin Categorías');
    }
  }

  ///
  void _dropDwSubCategos() {

    if(this._categosSelect.isNotEmpty) {

      List<DropdownMenuItem> subcategorias = new List();

      subcategorias.add( _dropItemInit('Lista de Sub CATEGORÍAS', Colors.blue) );

      this._categosSelect.forEach((element) {

        String txt = element['ct_nombre'].toString();
        txt = (txt.length >= 20) ? txt.substring(0, 19) + '...' : txt;
        subcategorias.add(
          DropdownMenuItem(
            value: element['ct_id'],
            child: Text(
              '${ txt.toUpperCase() }',
              textScaleFactor: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[600]
              ),
            ),
          )
        );
      });

      if(subcategorias.toList().isEmpty) {

        this._dropSubCatego = _dropDwBacio('ERROR AL CARGAR');

      }else{
        this._dropSubCatego = DropdownButtonFormField(
          icon: Icon(Icons.arrow_downward),
          value: this._subcategoId,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xffFFFFFF),
            border: InputBorder.none
          ),
          items: subcategorias,
          onChanged: (val) async {
            this._subcategoId = val;
          }
        );
      }

    }else{
      this._dropSubCatego = _dropDwBacio('Sin Sub Categorías');
    }

    setState(() { });
  }

  ///
  Widget _inputDivision() {
    
    return TextFormField(
      controller: this._divCtrl,
      focusNode: this._divFocus,
      validator: (String val) {
        if(val.isEmpty) {
          return 'La división es Requerida';
        }
        if(val.length <= 3) {
          return 'Sé más específico en la división';
        }
        return null;
      },
      onEditingComplete: () {
        FocusScope.of(this._context).requestFocus( new FocusNode() );
      },
      onFieldSubmitted: (String val){
        FocusScope.of(this._context).requestFocus(new FocusNode());
      },
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: 'División 1 Palabra:',
        labelStyle: TextStyle(
          fontSize: 14
        ),
        helperText: 'Su producto principal',
        suffixIcon: IconButton(
          icon: Icon(Icons.help, color: Colors.blue.withAlpha(100), size: 30),
          onPressed: () => AyudaByCampos(this._context).verAyuda('division'),
        )
      ),
    );
  }

  ///
  Widget _dropDwBacio(String titulo) {

    return DropdownButtonFormField(
      icon: Icon(Icons.arrow_downward),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xffFFFFFF),
        border: InputBorder.none
      ),
      items: [
        DropdownMenuItem(
          child: Text(
            '$titulo',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.green
            ),
          ),
        )
      ],
      onChanged: (int) {
        
      }
    );
  }

  ///
  Widget _dropItemInit(String titulo, Color txtColor) {

    return DropdownMenuItem(
      value: 0,
      child: Text(
        '$titulo',
        textScaleFactor: 1,
        style: TextStyle(
          color: txtColor
        ),
      ),
    );
  }

  ///
  Future<void> _getCategos() async {

    this._tokenServer = Provider.of<DataShared>(this._context, listen: false).tokenServer;
    if(franqCatsSng.categos.isEmpty) {
      setState(() {
        this._recoveryDataTxt = 'Buscando Categorías';
      });
      franqCatsSng.setCategos( await emServer.getCategos(this._tokenServer) );
      await _selectCategoriaExistente();
      if(!this._recoveryData) {
        setState(() {
          this._recoveryDataTxt = 'Recuperando Datos';
        });
      }
    }
  }

  ///
  Future<void> _getSubCategos() async {

    this._categosSelect = new List();
    bool irServer = false;

    if(franqCatsSng.categos.isNotEmpty) {
      if(franqCatsSng.subCategos.isEmpty) {
        irServer = true;
      }else{
        this._categosSelect = franqCatsSng.subCategos.where((element) => (element['c_id'] == this._categoId) ).toList();
        if(this._categosSelect.isEmpty) {
          irServer = true;
        }
      }

      if(irServer) {
        setState(() {
          this._recoveryDataTxt = 'Recuperando Sub Categorías';
        });
        this._categosSelect = await emServer.getSubCategos(this._tokenServer, this._categoId);
        if(this._categosSelect.isNotEmpty){
          franqCatsSng.setSubCategos(this._categosSelect);
          this._recoveryData = false;
        }
      }else{
        this._recoveryData = false;
      }

      if(this._categosSelect.isNotEmpty) {
        if(this._subcategoId == 0) {
          this._subcategoId = this._categosSelect[0]['ct_id'];
        }
      }
      _dropDwSubCategos();
    }else{
      setState(() {
        this._dropSubCatego = _dropDwBacio('Buscando Categorías');
      });
      await _getCategos();
    }
  }

  ///
  Future<void> _selectCategoriaExistente() async {

    if(this._checkCatgos) { return; }
    this._checkCatgos = true;

    Map<String, dynamic> dataTd = tdsSng.toJsonDataGenerales();
    int idScat = (dataTd['scat'] is String) ? int.tryParse(dataTd['scat']) : dataTd['scat'];
    if(idScat != 0) {

      if(franqCatsSng.subCategos.length > 0) {
        Map<String, dynamic> scategoSelect = franqCatsSng.subCategos.firstWhere(
          (element) => (element['ct_id'] == dataTd['scat']), orElse: () => new Map()
        );
        if(scategoSelect.isNotEmpty) {
          this._categoId = scategoSelect['c_id'];
          this._subcategoId = idScat;
          await _getSubCategos();
        }
      }else{
        await _getIdCategoByIdSubCatego(dataTd['scat']);
        this._subcategoId = idScat;
        await _getSubCategos();
      }
    }else{
      this._categoId = 0;
      this._recoveryData = false;
    }

    dataTd = null;
  }

  ///
  Future<void> _getIdCategoByIdSubCatego(int idSub) async {

    if(idSub != 0) {
      this._categoId = await emServer.getIdCategoByIdSubCatego(this._tokenServer, idSub);
      if(this._categoId != 0) {
        setState(() { });
      }
    }
  }

  ///
  Future<void> _saveProsRoto(String ruta) async {

    tdEntity.setCosto(double.tryParse(this._costoCtrl.text));
    tdEntity.setFranquicia(franqCatsSng.franqSelect);
    tdEntity.setSubCat(this._subcategoId);
    tdEntity.setDivision(this._divCtrl.text);
    tdsSng.setDataFranqCostoCategos(tdEntity);

    await emRoto.setProceso('FrmFranqCatCos', ruta, tdsSng.dataTd);
  }

  ///
  Future<void> _sendDataDisenio() async {

    if(this._keyFrm.currentState.validate()) {

      _saveProsRoto('td_data_fr_ca_co');

      if(tdsSng.isEdit){
        tdsSng.isEdit = false;
        Navigator.of(this._context).pushReplacementNamed('td_data_send');
      }else{
        Navigator.of(this._context).pushReplacementNamed('td_data_send');
      }
    }

  }

}