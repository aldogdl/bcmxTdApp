class TextUtils {

  /*
   * Eliminamos los acentos de las palabras
   * @see AltaSistemaPalClasPage::_inputPalClas
  */
  String quitarAcentosToPalabras(String txt) {
    
    String result;

    List<String> newString = new List();
    Map<String, String> txtSinAcentos = {'á':'a','é':'e','í':'i','ó':'o','ú':'u'};

    List<String> palabras = txt.split(' ');
    palabras.forEach((palabra){
      RegExp exp = RegExp(r'[áéíóú]');
      palabra = palabra.replaceAllMapped(exp, (m){
        return txtSinAcentos[m.group(0)];
      });
      newString.add(palabra.trim().toLowerCase());
    });

    if(newString.length > 0){
      result = newString.join(' ');
    }

    return result;
  }

/*
   * Eliminamos los acentos de las palabras
   * @see AltaSistemaPalClasPage::_inputPalClas
  */
  String quitarAcentosToListPalabras(String txt) {
    
    String result;

    List<String> newString = new List();
    Map<String, String> txtSinAcentos = {'á':'a','é':'e','í':'i','ó':'o','ú':'u'};

    List<String> palabras = txt.split(',');
    palabras.forEach((palabra){
      RegExp exp = RegExp(r'[áéíóú]');
      palabra = palabra.replaceAllMapped(exp, (m){
        return txtSinAcentos[m.group(0)];
      });
      newString.add(palabra.trim().toLowerCase());
    });

    if(newString.length > 0){
      result = newString.join(',');
    }

    return result;
  }

  /*
   * Eliminamos los acentos de las palabras.
   * @see AltaSistemaPalClasPage::_inputPalClas
  */
  String quitarEspaciosEnBlanco(String txt) {
    String result;
    List<String> newString = new List();
    List<String> palabras = txt.split(' ');
    palabras.forEach((palabra){ newString.add(palabra.trim().toLowerCase()); });
    if(newString.length > 0) { result = newString.join(''); }
    return result;
  }
}