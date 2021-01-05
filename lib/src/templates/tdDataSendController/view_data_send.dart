import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:photo_view/photo_view.dart';


import '../../widgets/alerts_varios.dart';
import '../../singletons/franqs_cats_singleton.dart';
import '../../singletons/tds_singleton.dart';
import '../../entity/td_entity.dart';

class ViewDataSend extends StatefulWidget {
  ViewDataSend({Key key}) : super(key: key);

  @override
  _ViewDataSendState createState() => _ViewDataSendState();
}

class _ViewDataSendState extends State<ViewDataSend> {

  TdsSingleton tdsSng = TdsSingleton();
  TdEntity tdEntity = TdEntity();
  AlertsVarios alertsVarios = AlertsVarios();
  FranqCatsSng franqCatsSng = FranqCatsSng();
  
  bool _isInit = false;
  BuildContext _context;

  @override
  Widget build(BuildContext context) {

    if(!this._isInit) {
      this._isInit = true;
      this._context = context;
      context = null;
    }

    return ListView(
      padding: EdgeInsets.only(
        top: 20, right: 20, left: 20
      ),
      shrinkWrap: true,
      children: [
        Text(
          '   DATOS GENERALES',
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16
          ),
        ),
        const SizedBox(height: 10),
        _containerDeDatos(
          datos: _generarLstDatosOf(
            editTo: () {
              tdsSng.isEdit = true;
              Navigator.of(this._context).pushNamedAndRemoveUntil('td_data_fr_ca_co', (route) => false);
            },
            campos: tdEntity.mapDataGenerales(),
            datos: tdsSng.toJsonDataGenerales(),
            tipoDato: 'grales'
          )
        ),
        const SizedBox(height: 20),
        Text(
          '   DATOS DE CONTACTO',
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16
          ),
        ),
        const SizedBox(height: 10),
        _containerDeDatos(
          datos: _generarLstDatosOf(
            editTo: (){
              tdsSng.isEdit = true;
              Navigator.of(this._context).pushNamedAndRemoveUntil('td_data_contac', (route) => false);
            },
            campos: tdEntity.mapDataContac(),
            datos: tdsSng.toJsonDataContac(),
            tipoDato: 'contact'
          )
        ),
        const SizedBox(height: 20),
        Text(
          '   LINKS DE CONTACTO',
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16
          ),
        ),
        const SizedBox(height: 10),
        _containerDeDatos(
          datos: _generarLstDatosOf(
            editTo: () {
              tdsSng.isEdit = true;
              Navigator.of(this._context).pushNamedAndRemoveUntil('td_data_links', (route) => false);
            },
            campos: tdEntity.mapDataLinks(),
            datos: tdsSng.toJsonDataLinks(),
            tipoDato: 'links'
          )
        ),
        const SizedBox(height: 20),
        Text(
          '   INFORMACIÓN DEL DISEÑO',
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16
          ),
        ),
        const SizedBox(height: 10),
        _containerDeDatos(
          datos: _generarLstDatosOf(
            editTo: () {
              tdsSng.isEdit = true;
              Navigator.of(this._context).pushNamedAndRemoveUntil('td_data_disenio', (route) => false);
            },
            campos: tdEntity.mapDataDisenio(),
            datos: tdsSng.toJsonDataDisenio(),
            tipoDato: 'disenio'
          )
        ),
        const SizedBox(height: 20),
        Text(
          '   LISTA DE FOTOGRAFÍAS',
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          child: Text(
            'Para Eliminar una fotografía deja presionada la indicada',
            textScaleFactor: 1,
          ),
        ),
        _lstFotografias(),
        const SizedBox(height: 90),
      ],
    );
  }

  ///
  Widget _containerDeDatos({
    List<Widget> datos
  }) {

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: datos,
      ),
    );
  }

  ///
  Widget _btnEditFor({
    Function editTo
  }) {

    return Align(
      alignment: Alignment.centerRight,
      child: FlatButton.icon(
        padding: EdgeInsets.all(0),
        height: 10,
        onPressed: () => editTo(),
        icon: Icon(Icons.edit, size: 14),
        label: Text(
          'EDITAR',
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.purple
          ),
        ),
      ),
    );
  }

  ///
  List<Widget> _generarLstDatosOf({
    @required Function editTo,
    @required List<Map<String, dynamic>> campos,
    @required Map<String, dynamic> datos,
    String tipoDato
  }) {

    List<Widget> lstWidget = new List();

    lstWidget.add(_btnEditFor(
      editTo: editTo
    ));
    campos.forEach((campo) {

      lstWidget.add(
        Text(
          '  ${campo['subTit']}',
          textScaleFactor: 1,
          style: _styleSubTitulos()
        )
      );

      lstWidget.add(Divider(thickness: 20, height: 1, color: Colors.grey.withAlpha(30)));
      lstWidget.add(SizedBox(height: 5));

      if(datos[campo['campo']] is List) {

        if(tipoDato == 'links') {
          datos[campo['campo']].forEach((link){
            lstWidget.add(
              Row(
                children: [
                  (link['select'])
                  ? Icon(Icons.check, color: Colors.green, size: 14)
                  : Icon(Icons.close, color: Colors.red, size: 14),
                  const SizedBox(width: 5),
                  Text(
                    '${link['value']}',
                    textScaleFactor: 1,
                    style: _styleTitulos()
                  )
                ],
              )
            );
            lstWidget.add(Divider(height: 1, color: Colors.grey[600]));
            lstWidget.add(SizedBox(height: 5));
            lstWidget.add(
              Text(
                '${link['urlCliente']}',
                textScaleFactor: 1,
                style: _styleSubTitulos(color: Colors.green)
              )
            );
          });
        }
        
      }else{

        var txtTit = (datos[campo['campo']] is bool ) ? (datos[campo['campo']]) ? 'Verdadero' : 'Falso' : datos[campo['campo']];
        
        if(tipoDato == 'grales') {

          if(campo['campo'] == 'franq'){
            Map<String, dynamic> franq = franqCatsSng.franquicias.firstWhere(
              (element) => (element['f_id'] == datos[campo['campo']]),
              orElse: () => new Map()
            );
            if(franq.isNotEmpty){
              txtTit = franq['f_nombre'];
            }
          }
          if(campo['campo'] == 'scat'){
            if(datos[campo['campo']] != 0 || datos[campo['campo']] != '0') {
              Map<String, dynamic> catego = franqCatsSng.subCategos.firstWhere(
                (element) => (element['ct_id'] == datos[campo['campo']]),
                orElse: () => new Map()
              );
              if(catego.isNotEmpty){
                txtTit = catego['ct_nombre'];
              }else{
                txtTit = 'No seleccionada';
              }
            }
          }
          if(campo['campo'] == 'costo'){
            txtTit = '\$ ${datos[campo['campo']]}';
          }
        }

        lstWidget.add(
          Text(
            '$txtTit',
            textScaleFactor: 1,
            style: _styleTitulos()
          )
        );
      }
      
      lstWidget.add(SizedBox(height: 20));
    });
    
    return lstWidget.toList();
  }

  ///
  TextStyle _styleTitulos() {

    return TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontSize: 16
    );
  }

  ///
  TextStyle _styleSubTitulos({Color color}) {

    return TextStyle(
      fontSize: 13,
      color: (color == null) ? Colors.grey[600] : color
    );
  }

  ///
  Widget _lstFotografias() {

    List<Map<String, dynamic>> fotosVer = List<Map<String, dynamic>>.from(tdsSng.lstFotos);

    int idFoto = 1;
    List<Widget> lstFotosWidget = new List();

    fotosVer.forEach((foto) {
      foto['id'] = idFoto.toString();
      idFoto = idFoto +1;
      lstFotosWidget.add(_foto(foto));
    });

    return Container(
      width: MediaQuery.of(this._context).size.width * 0.9,
      height: MediaQuery.of(this._context).size.height * 0.5,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: lstFotosWidget.toList(),
      ),
    );
  }

  ///
  Widget _foto(Map<String, dynamic> foto) {

    Asset asset = Asset(
      foto['identifier'],
      foto['name'],
      foto['originalWidth'],
      foto['originalHeight'],
    );

    return InkWell(
      onLongPress: () async {
        String body = 'Segur@ de querer eliminar permanentemente la fotografía No. ${foto['id']}';
        final res = await alertsVarios.aceptarAndCancelar(this._context, titulo: 'ELIMINAR FOTO', body: body);
        if(res == true){
          bool res = await tdsSng.deleteFotoById(foto['id']);
          if(res){
            setState(() { });
          }
        }
      },
      child: Container(
        width: MediaQuery.of(this._context).size.width * 0.9,
        height: MediaQuery.of(this._context).size.height * 0.4,
        color: Colors.white,
        child: PhotoView(
          imageProvider: AssetThumbImageProvider(asset, width: foto['originalWidth'], height: foto['originalHeight']),
          loadingBuilder: (_, ImageChunkEvent chunkEvent) {
            if(chunkEvent == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Text('Imagen Cargada');
          },
          loadFailedChild: Center(
            child: SizedBox(
              width: 40, height: 20,
              child: CircularProgressIndicator(),
            )
          ),
        ),
      ),
    );
  }

}