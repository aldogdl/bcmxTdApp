import 'package:flutter/material.dart';

class AyudaByCampos extends StatelessWidget {

  final String nombreCampo;
  final BuildContext contextParent;

  AyudaByCampos(this.contextParent, {Key key, this.nombreCampo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(height: 0);
  }

  ///
  Future<void> verAyuda(String campo) {

    return showDialog(
      context: contextParent,
      builder: (contextParent) {

        Map<String, dynamic> texto = _getAyudaTextByCampo(campo);

        return AlertDialog(
          insetPadding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          title: Row(
            children: [
              Icon(Icons.help, size: 40, color: Colors.blue),
              const SizedBox(width: 7),
              Expanded(
                flex: 3,
                child: Text(
                  '${texto['titulo']}',
                  maxLines: 2,
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue
                  ),
                ),
              )
            ],
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${texto['ayuda']}',
                textScaleFactor: 1,
                style: TextStyle(
                ),
              )
            ],
          ),
        );
      }
    );
  }

  ///
  Map<String, dynamic> _getAyudaTextByCampo(String campo) {

    switch (campo) {

      case 'username':
        return _helpUsername();
        break;
      case 'nombreCliente':
        return _helpNombreCliente();
        break;
      case 'nombreEmpresa':
        return _helpNombreEmpresa();
        break;
      case 'giroEmpresa':
        return _helpGiroEmpresa();
        break;
      case 'queVende':
        return _helpQueVende();
        break;
      case 'domicilio':
        return _helpDomicilio();
        break;
      case 'referencia':
        return _helpReferencia();
        break;
      case 'email':
        return _helpEmail();
        break;
      case 'movil':
        return _helpMovil();
        break;
      case 'fijo':
        return _helpFijo();
        break;
      case 'indiImg':
        return _helpIndiImg();
        break;
      case 'colorBg':
        return _helpColorBg();
        break;
      case 'colorTxt':
        return _helpColorTxt();
        break;
      case 'colorIcos':
        return _helpColorIcnos();
        break;
      case 'notasAdd':
        return _helpNotasAdd();
        break;
      case 'costoServ':
        return _helpCostoServ();
        break;
      case 'division':
        return _helpDivision();
        break;
      default:
        return new Map();
    }
  }

  ///
  Map<String, dynamic> _helpNombreCliente() {
    String txt = 'Escribe el nombre Completo del Cliente.';

    return {
      'titulo': 'Nombre del Cliente',
      'ayuda' : txt
    };
  }

  ///
  Map<String, dynamic> _helpUsername() {
    String txt = 'Es necesario crear una cuenta para el nuevo Cliente, '+
    'coloca un nombre sin espacios, ni comas, no coloques acentos ni signos extraños.';

    return {
      'titulo': 'Nombre de Usuario',
      'ayuda' : txt
    };
  }

  ///
  Map<String, dynamic> _helpNombreEmpresa() {

    String txt = 'Coloca la Razón Social del Negocio, el nombre descrito en el '+
    'logotipo o como normalmente los clientes del negocio identifican el comercio';

    return {
      'titulo': 'Nombre de la Empresa',
      'ayuda' : txt
    };
  }

  ///
  Map<String, dynamic> _helpGiroEmpresa() {

    String txt = 'Una pequeña descripción que defina lo más preciso posible '+
    'lo que hace el negocio para realizar un intercambio comercial con sus clientes.';

    return {
      'titulo': 'Giro del Negocio',
      'ayuda' : txt
    };
  }

  ///
  Map<String, dynamic> _helpQueVende() {

    String txt = 'Indica productos y/o servicios claves separados por coma(,).\n\n'+
    'Este campo es utilizado por el motor de búsqueda, por lo tanto coloca palabras '+
    'que relacionen al negocio para que los usuarios puedan encontrar con facilidad '+
    'las Tarjetas Digitales que necesita de una manera más precisa.';

    return {
      'titulo': '¿Que vende el Negocio?',
      'ayuda' : txt
    };
  }

  ///
  Map<String, dynamic> _helpDomicilio() {

    String txt = 'La ubicación fisica de la empresa, Calle, Edificio y Número.';

    return {
      'titulo': 'Domicilio del Negocio',
      'ayuda' : txt
    };
  }

  ///
  Map<String, dynamic> _helpReferencia() {

    String txt = 'Indica más información que enrriquezcan al usuario para ubicar '+
    'con mejor presición el Local Comercial, como: Piso, Interiores, Entre Calles etc.';

    return {
      'titulo': 'La Referencia',
      'ayuda' : txt
    };
  }

  ///
  Map<String, dynamic> _helpEmail() {

    String txt = 'Correo Eléctronico del contacto principal, este debe ser valido '+
    'ya se enviarán documentación y avisos importantes con frecuencia.';

    return {
      'titulo': 'Email',
      'ayuda' : txt
    };
  }

  ///
  Map<String, dynamic> _helpMovil() {

    String txt = 'Escribe los 10 dígitos del número de Celular del negocio.\n\n'+
    'No dejes espacios en blanco ni coloques ningun tipo de signos.';

    return {
      'titulo': 'WhatsApp',
      'ayuda' : txt
    };
  }

  ///
  Map<String, dynamic> _helpFijo() {

    String txt = 'Escribe los 10 dígitos del teléfono fijo del negocio. '+
    'Éste puede ser el mismo teléfono que el campo anterior.\n\n'+
    'No dejes espacios en blanco ni coloques ningun tipo de signos.';

    return {
      'titulo': 'Teléfono FIJO',
      'ayuda' : txt
    };
  }

    ///
  Map<String, dynamic> _helpIndiImg() {

    String txt = 'Por cada foto que tomes especifica qué debe tomar en cuenta el '+
    'diseñador, ejemplo: foto fachada para que veas los colores corporativos del '+
    'negocio, foto de la tarjeta ver logotipo, etc.';

    return {
      'titulo': 'Indicaciones de Imágenes',
      'ayuda' : txt
    };
  }

  ///
  Map<String, dynamic> _helpColorBg() {

    String txt = 'Indica la preferencia de tonos que el cliente desea para el fondo de su '+
    'Tarjeta Digital, puede ser un solo tono, degradado o imágenes en marca de agua etc.';

    return {
      'titulo': 'Color de Fondo',
      'ayuda' : txt
    };
  }

  ///
  Map<String, dynamic> _helpColorTxt() {

    String txt = 'Indica la preferencia de tonos que el cliente desea para el color de '+
    'las letras.';

    return {
      'titulo': 'Color de Texto',
      'ayuda' : txt
    };
  }

  ///
  Map<String, dynamic> _helpColorIcnos() {

    String txt = 'Indica la preferencia de tonos que el cliente desea para el color de '+
    'los iconos que se usan para enlazar sus Redes Sociales y más.';

    return {
      'titulo': 'Color de Iconos',
      'ayuda' : txt
    };
  }

  ///
  Map<String, dynamic> _helpNotasAdd() {

    String txt = 'Las Notas adicionales describen con precisión las preferencias del cliente sobre el Diseño y Logotipo.\n'+
    'Si el cliente desea alguna frase, o la colocación de logotipos extras, etc.\n\n'+
    'Si no colocas Imágenes, se tomará la información de este campo para crear algún logotipo.';

    return {
      'titulo': 'Notas Adicionales',
      'ayuda' : txt
    };
  }

  ///
  Map<String, dynamic> _helpCostoServ() {

    String txt = 'Es el monto final que se tiene que cobrar al cliente por la totalidad de su servicio contratado.\n';

    return {
      'titulo': 'Costo por Servicio',
      'ayuda' : txt
    };
  }

  ///
  Map<String, dynamic> _helpDivision() {

    String txt = 'La DIVISIÓN es una Meta Categoría para organizarán los negocios de una manera más '+
    'específica dentro de la sub categoría principal, es decir, cada negocio estará ubicado dentro de:\n\n'+
    'CATEGORÍA\nSUB CATEGORÍA y\nDIVISIÓN\n\n'+
    'Coloca una palabra donde puedas ubicar categoricamente al negocio y que describa lo que vende o su giro principal.\n\n'+
    'Por Ejemplo: Tenis, Ropa, Buffete, Lonches, Miselaneos etc...';

    return {
      'titulo': 'División de la Empresa',
      'ayuda' : txt
    };
  }


}