import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../entity/td_entity.dart';
import '../../widgets/box_input_rounded_widget.dart';
import '../../widgets/ayudas_by_campos.dart';
import '../../repository/prosroto_repository.dart';
import '../../repository/user_repository.dart';
import '../../singletons/tds_singleton.dart';

class FrmDisenio extends StatefulWidget {

  final ScaffoldState keySkffParent;

  FrmDisenio({Key key, this.keySkffParent}) : super(key: key);

  @override
  _FrmDisenioState createState() => _FrmDisenioState();
}

class _FrmDisenioState extends State<FrmDisenio> {

  TdsSingleton tdsSng = TdsSingleton();
  ProsRotoRepository emRoto = ProsRotoRepository();
  TdEntity tdEntity = TdEntity();
  UserRepository emUser = UserRepository();

  TextEditingController _descripLogoCtrl = TextEditingController();
  TextEditingController _colorFondoCtrl = TextEditingController();
  TextEditingController _colorTextoCtrl = TextEditingController();
  TextEditingController _colorIconosCtrl = TextEditingController();
  TextEditingController _notasAddsCtrl = TextEditingController();

  FocusNode _descripLogoFocus = FocusNode();
  FocusNode _colorFondoFocus = FocusNode();
  FocusNode _colorTextoFocus = FocusNode();
  FocusNode _colorIconosFocus = FocusNode();
  FocusNode _notasAddsFocus = FocusNode();

  GlobalKey<FormState> _keyFrm = GlobalKey<FormState>();
  bool _isInit = false;
  BuildContext _context;
  List<Map<String, dynamic>> _lstFotos = new List();
  int _thubFachadaX = 990;
  int _thubFachadaY = 750;
  String _txtFijo4Img  = 'Según Imágenes';
  String _txtFijo4None = 'A consideracion del Diseñador';

  @override
  void dispose() {
    this._descripLogoCtrl?.dispose();
    this._colorFondoCtrl?.dispose();
    this._colorTextoCtrl?.dispose();
    this._colorIconosCtrl?.dispose();
    this._notasAddsCtrl?.dispose();
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
    return Form(
      key: this._keyFrm,
      child: _widgets()
    );
  }

  ///
  Future<void> _initWidget(_) async {

    Map<String, dynamic> dataTd = tdsSng.dataTd;
    if(dataTd['lstFotos'] != null && dataTd['lstFotos'].length > 0) {
      this._lstFotos = new List<Map<String, dynamic>>.from(dataTd['lstFotos']);
    }

    if(dataTd['descriptLogo'] == null) {
      if(this._lstFotos.length > 0) {
        dataTd['descriptLogo'] = this._txtFijo4Img;
      }else{
        dataTd['descriptLogo'] = this._txtFijo4None;
      }
    }else{
      this._descripLogoCtrl.text= (dataTd['descriptLogo'].length > 3) ? dataTd['descriptLogo'] : '';
    }

    if(dataTd['colorFondo'] == null) {
      if(this._lstFotos.length > 0) {
        dataTd['colorFondo'] = this._txtFijo4Img;
      }else{
        dataTd['colorFondo'] = this._txtFijo4None;
      }
    }else{
      this._colorFondoCtrl.text = (dataTd['colorFondo'] != this._txtFijo4Img) ? dataTd['colorFondo'] : this._txtFijo4Img;
    }

    if(dataTd['colorTexto'] == null) {
      if(this._lstFotos.length > 0) {
        dataTd['colorTexto'] = this._txtFijo4Img;
      }else{
        dataTd['colorTexto'] = this._txtFijo4None;
      }
    }else{
      this._colorTextoCtrl.text = (dataTd['colorTexto'] != this._txtFijo4Img) ? dataTd['colorTexto'] : this._txtFijo4Img;
    }

    if(dataTd['colorIconos'] == null) {
      if(this._lstFotos.length > 0) {
        dataTd['colorIconos'] = this._txtFijo4Img;
      }else{
        dataTd['colorIconos'] = this._txtFijo4None;
      }
    }else{
      this._colorIconosCtrl.text= (dataTd['colorIconos'] != this._txtFijo4Img) ? dataTd['colorIconos'] : this._txtFijo4Img;
    }

    if(dataTd['notasAdds'] == null) {
      if(this._lstFotos.length > 0) {
        dataTd['notasAdds'] = this._txtFijo4Img;
      }else{
        dataTd['notasAdds'] = '';
      }
    }else{
      this._notasAddsCtrl.text= (dataTd['notasAdds'] != null) ? dataTd['notasAdds'] : '';
    }

    setState(() { });
  }

  ///
  Widget _widgets() {

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      children: [
        _takeFoto(),
        Padding(
          padding: EdgeInsets.only(left: 15, bottom: 10),
          child: Text(
            '¿Deseas colocar alguna indicación adicional al logotipo e imágenes?',
            textScaleFactor: 1,
          ),
        ),
        BoxInputRoundedWidget(
          bg: const Color(0xffFFFFFF),
          hasBorder: false,
          input: _inputDescripLogo(),
        ),
        const SizedBox(height: 10),
        BoxInputRoundedWidget(
          bg: const Color(0xffFFFFFF),
          hasBorder: false,
          input: _inputColorFondo(),
        ),
        const SizedBox(height: 10),
        BoxInputRoundedWidget(
          bg: const Color(0xffFFFFFF),
          hasBorder: false,
          input: _inputColorTexto(),
        ),
        const SizedBox(height: 10),
        BoxInputRoundedWidget(
          bg: const Color(0xffFFFFFF),
          hasBorder: false,
          input: _inputColorIconos(),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 15, bottom: 10),
          child: Text(
            'Coloca cualquier cosa que sea necesaria para enriquecer el desarrollo del diseño.',
            textScaleFactor: 1,
          ),
        ),
        BoxInputRoundedWidget(
          bg: const Color(0xffFFFFFF),
          hasBorder: false,
          input: _inputNotasAdds(),
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
  Widget _takeFoto() {

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        width: MediaQuery.of(this._context).size.width * 0.85,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
        decoration: BoxDecoration(
          color: const Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              spreadRadius: 1,
              color: Colors.blueGrey.withAlpha(200),
              offset: Offset(1,2)
            )
          ]
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () => _tomarFoto(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, color: Colors.blue),
                      Text(
                        'Tomar Foto',
                        textScaleFactor: 1,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seleccionadas: ${this._lstFotos.length}/4',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.grey[600]
                      ),
                    ),
                    Divider(
                      color: Colors.blue,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: (){
                            setState(() {
                              this._lstFotos.clear();
                            });
                          },
                          child: Text(
                            'BORRAR LISTA',
                            textScaleFactor: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: (){
                                showDialog(
                                  context: this._context,
                                  builder: (_) {
                                    return AlertDialog(
                                      insetPadding: EdgeInsets.all(0),
                                      contentPadding: EdgeInsets.all(3),
                                      content: _fotoViewer(),
                                    );
                                  }
                                );
                              },
                              child: Text(
                                'VER',
                                textScaleFactor: 1,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _inputDescripLogo() {
    
    return TextFormField(
      controller: this._descripLogoCtrl,
      focusNode: this._descripLogoFocus,
      validator: (String val) {
        if(val.isEmpty){
          return 'Coloca una descripción para el logo';
        }
        return null;
      },
      onEditingComplete: () {
        FocusScope.of(this._context).requestFocus(this._colorFondoFocus);
      },
      onFieldSubmitted: (String val) {
        FocusScope.of(this._context).requestFocus(this._colorFondoFocus);
      },
      maxLines: 4,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Indicaciones...',
        labelStyle: TextStyle(
          fontSize: 14
        ),
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: Icon(Icons.help, color: Colors.blue.withAlpha(100), size: 30),
          onPressed: () => AyudaByCampos(this._context).verAyuda('indiImg'),
        )
      ),
    );
  }

  ///
  Widget _inputColorFondo() {
    
    return TextFormField(
      controller: this._colorFondoCtrl,
      focusNode: this._colorFondoFocus,
      validator: (String val) {
        if(val.isEmpty){
          return 'Indica un color de fondo';
        }
        return null;
      },
      onEditingComplete: () {
        FocusScope.of(this._context).requestFocus(this._colorTextoFocus);
      },
      onFieldSubmitted: (String val) {
        FocusScope.of(this._context).requestFocus(this._colorTextoFocus);
      },
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: 'Color de Fondo:',
        labelStyle: TextStyle(
          fontSize: 14
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.help, color: Colors.blue.withAlpha(100), size: 30),
          onPressed: () => AyudaByCampos(this._context).verAyuda('colorBg'),
        )
      ),
    );
  }

  ///
  Widget _inputColorTexto() {
    
    return TextFormField(
      controller: this._colorTextoCtrl,
      focusNode: this._colorTextoFocus,
      validator: (String val) {
        if(val.isEmpty) {
          return 'Sugiere un color para el Texto';
        }
        return null;
      },
      onEditingComplete: () {
        FocusScope.of(this._context).requestFocus(this._colorIconosFocus);
      },
      onFieldSubmitted: (String val){
        FocusScope.of(this._context).requestFocus(this._colorIconosFocus);
      },
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: 'Color del Texto:',
        labelStyle: TextStyle(
          fontSize: 14
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.help, color: Colors.blue.withAlpha(100), size: 30),
          onPressed: () => AyudaByCampos(this._context).verAyuda('colorTxt'),
        )
      ),
    );
  }

  ///
  Widget _inputColorIconos() {
    
    return TextFormField(
      controller: this._colorIconosCtrl,
      focusNode: this._colorIconosFocus,
      validator: (String val) {
        if(val.isEmpty){
          return 'Sugiere el color para los Iconos';
        }
        return null;
      },
      onEditingComplete: () {
        FocusScope.of(this._context).requestFocus(this._notasAddsFocus);
      },
      onFieldSubmitted: (String val){
        FocusScope.of(this._context).requestFocus(this._notasAddsFocus);
      },
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: 'Color de los Iconos:',
        labelStyle: TextStyle(
          fontSize: 14
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.help, color: Colors.blue.withAlpha(100), size: 30),
          onPressed: () => AyudaByCampos(this._context).verAyuda('colorIcos'),
        )
      ),
    );
  }

  ///
  Widget _inputNotasAdds() {
    
    return TextFormField(
      controller: this._notasAddsCtrl,
      focusNode: this._notasAddsFocus,
      validator: (String val) {
        return null;
      },
      onEditingComplete: () {
        FocusScope.of(this._context).requestFocus(new FocusNode());
      },
      onFieldSubmitted: (String val) {
        FocusScope.of(this._context).requestFocus(new FocusNode());
      },
      maxLines: 4,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Enriquece los detalles:',
        labelStyle: TextStyle(
          fontSize: 14
        ),
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: Icon(Icons.help, color: Colors.blue.withAlpha(100), size: 30),
          onPressed: () => AyudaByCampos(this._context).verAyuda('notasAdd'),
        )
      ),
    );
  }

  ///
  Future<void> _tomarFoto() async {

    List<Asset> resultList;
    int cantTomadas = (this._lstFotos.length == 0) ? 4 : (4 - this._lstFotos.length);
    if(cantTomadas < 0) {
      cantTomadas = 0;
    }
    if(this._lstFotos.length >= 4) {
      return false;
    }
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: cantTomadas,
        enableCamera: true,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
        ),
        materialOptions: MaterialOptions(
          actionBarTitle: 'Tomar Logotipo',
          allViewTitle:   "Todas las Fotos",
          selectionLimitReachedText: 'Haz llegado al limite',
          textOnNothingSelected: 'No se ha seleccionado nada',
          lightStatusBar: false,
          useDetailsView: false,
          startInAllView: true,
          autoCloseOnSelectionLimit: true,
          actionBarColor: "#7C0000",
          statusBarColor: "#7C0000",
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }

    if (!mounted) return;

    if(resultList.length > 0) {
      for (var i = 0; i < resultList.length; i++) {
        if(this._lstFotos.length == 0) {
          
          if(this._descripLogoCtrl.text == this._txtFijo4None) {
            this._descripLogoCtrl.text = this._txtFijo4Img;
          }
          if(this._colorFondoCtrl.text == this._txtFijo4None) {
            this._colorFondoCtrl.text = this._txtFijo4Img;
          }
          if(this._colorTextoCtrl.text == this._txtFijo4None) {
            this._colorTextoCtrl.text = this._txtFijo4Img;
          }
          if(this._colorIconosCtrl.text == this._txtFijo4None) {
            this._colorIconosCtrl.text = this._txtFijo4Img;
          }
        }

        await _calcularProporciones(
          originalWidth: resultList[i].originalWidth,
          originalHeight: resultList[i].originalHeight,
          isLandscape: resultList[i].isLandscape
        );
        this._lstFotos.add({
          'identifier': resultList[i].identifier,
          'name': resultList[i].name,
          'originalWidth': this._thubFachadaX,
          'originalHeight': this._thubFachadaY,
        });
      }
      setState(() {});
    }
  }

  ///
  Widget _fotoViewer() {

    return Container(
      width: MediaQuery.of(this._context).size.width,
      height: MediaQuery.of(this._context).size.height,
      child: PhotoViewGallery.builder(
        backgroundDecoration: BoxDecoration(
          color: Colors.black
        ),
        builder: (BuildContext context, int index) {

          Asset asset = Asset(
            this._lstFotos[index]['identifier'],
            this._lstFotos[index]['name'],
            this._lstFotos[index]['originalWidth'],
            this._lstFotos[index]['originalHeight'],
          );
          
          return PhotoViewGalleryPageOptions(
            imageProvider: AssetThumbImageProvider(asset, width: this._lstFotos[index]['originalWidth'], height: this._lstFotos[index]['originalHeight']),
            initialScale: PhotoViewComputedScale.contained * 0.9,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        itemCount: this._lstFotos.length,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes,
            ),
          ),
        ),
      )
    );

  }

   ///
  Future<void> _calcularProporciones({@required originalWidth, @required int originalHeight, @required bool isLandscape}) async {

    int x = 0;
    int y = 0; 
   
    if(isLandscape) {
      // dejar el alto de la imagen a _thubFachadaY (300)
      y = this._thubFachadaY;
      double cx = this._thubFachadaY*originalWidth/originalHeight;
      x = cx.toInt();
    }else{
       // dejar el alto de la imagen a _thubFachadaX (533)
      x = this._thubFachadaX;
      double cy = this._thubFachadaX*originalHeight/originalWidth;
      y = cy.toInt();
    }
    this._thubFachadaX = x;
    this._thubFachadaY = y;
  }

  ///
  Future<void> _saveProsRoto(String ruta) async {

    await tdEntity.setAllFotos(this._lstFotos);
    tdsSng.setAllfotos(tdEntity);

    tdEntity.setDescriptLogo(this._descripLogoCtrl.text);
    tdEntity.setColorFondo(this._colorFondoCtrl.text);
    tdEntity.setColorTexto(this._colorTextoCtrl.text);
    tdEntity.setColorIconos(this._colorIconosCtrl.text);
    tdEntity.setNotasAdds(this._notasAddsCtrl.text);
    tdsSng.setDataDisenio(tdEntity);

    await emRoto.setProceso('FrmDisenio', ruta, tdsSng.dataTd);
  }

  ///
  Future<void> _sendDataDisenio() async {

    bool save = false;
    if(this._lstFotos.length > 0){
      save = true;
    }else{
      if(this._keyFrm.currentState.validate()){
        save = true;
      }
    }
    
    if(save){
      await _saveProsRoto('td_data_fr_ca_co');
      if(tdsSng.isEdit){
        tdsSng.isEdit = false;
        Navigator.of(this._context).pushReplacementNamed('td_data_send');
      }else{
        Navigator.of(this._context).pushReplacementNamed('td_data_fr_ca_co');
      }
    }
  }
}