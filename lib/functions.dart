import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path_dart;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'classes.dart';
import 'main.dart';


launchURL(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<int> loadFromPreferencesInt(key)async{
  final prefs = await SharedPreferences.getInstance();
  return await( prefs.getInt(key) ?? 0);
}
Future<List<String>> loadFromPreferencesListOfStrings(key)async{
  final prefs = await SharedPreferences.getInstance();
  return await (prefs.getStringList(key) ?? []);
}
Future<String> loadFromPreferencesString(key) async {
  final prefs = await SharedPreferences.getInstance();
  return await (prefs.getString(key) ?? '');
}
Future<bool> loadFromPreferencesBool(key) async {
  final prefs = await SharedPreferences.getInstance();
  return await (prefs.getBool(key) ?? false);
}
Future<void> setUnEndedGameToPreferences(int correct, int wrong, int hints, int stopWatchTime,  int plantIndex, List<String> lastIndexes, List<String> usingIndexes, List<String> usingPlantHints, bool guessingFamily, List<String> wrongAnswersList)async{
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('playedGameCorrect', correct);
  await prefs.setInt('playedGameWrong', wrong);
  await prefs.setInt('playedGameHints', hints);
  await prefs.setInt('playedGameStopWatch', stopWatchTime);
  await prefs.setInt('playedGameUsingPlantIndex', plantIndex);
  await prefs.setStringList('playedGameLastIndexes', lastIndexes);
  await prefs.setStringList('playedGameUsingIndexes', usingIndexes);
  await prefs.setStringList('playedGameUsingPlantHints', usingPlantHints);
  await prefs.setStringList('playedGameWrongAnswersList', wrongAnswersList);
  await prefs.setBool('playedGameGuessingFamily', guessingFamily);
}
List<String> changeToStringList(List<int> intList){
  List<String> returnList = [];
  intList.forEach((element) { 
    returnList.add(element.toString());
  });
  return returnList;
}
List<int> changeToIntList(List<String> stringList){
  List<int> returnList = [];
  stringList.forEach((element) {
    if(element != ''){
      returnList.add(int.parse(element));
    } 
  });
  return returnList;
}
String changeFromIntListToString(List<int> intList){
  String returnString = '';
  intList.forEach((element) { 
    returnString = '$returnString$element,';
  });
  return returnString;
}
List<int> changeFromStringToIntList(String string){
  return changeToIntList(string.split(','));
}

List<String> makefamilyTypesList (){
  List<String> list = [
    'bôbovité','lipnicovité','iskerníkovité','ružovité','bukovité','čajovníkovité','ľaliovité','konopovité','kapustovité','vstavačovité','hluchavkovité','fialkovité',
    'lieskovité','brezovité','klinčekovité','mrkvovité','leknovité','lipovité','astrovité',"amarylkovité","pŕhľavovité","mrlíkovité","stavikrvovité","ľuľkovité",'makovité','magnóliovité',
    'ginkovité','borovicovité','cyprusovité','tisovité','áronovité','arekovité','kosatcovité',
  ];
  list.sort(((a, b) {return a.compareTo(b);}));
  return list;
}

Future<bool> confirmationBool(BuildContext context,  void Function() positiveAnswerFun, void Function() negativeAnswerFun ,{Widget title = const Text('Si si istý?'), Widget subtitle = const Text('Chceš odísť'), String positiveAnswer = 'Áno', String negativeAnswer = 'Nie',})async{
  return (await showDialog(context: context, 
    builder: (context) => AlertDialog(
      title: title,
      content: subtitle,
      backgroundColor: themeColor.themeColorBG,
      actions: [
        TextButton(
          onPressed: negativeAnswerFun,
          child: Text(negativeAnswer),
        ),
        TextButton(
          onPressed: positiveAnswerFun,
          child: Text(positiveAnswer),
        ),
      ],
    ) 
  ));
}

Future<dynamic> confirmationDynamic(BuildContext context,  void Function() positiveAnswerFun, void Function() negativeAnswerFun ,{Widget title = const Text('Si si istý?'), Widget subtitle = const Text('Chceš odísť'), String positiveAnswer = 'Áno', String negativeAnswer = 'Nie',})async{
  return (await showDialog(context: context, 
    builder: (context) => AlertDialog(
      title: title,
      content: subtitle,
      backgroundColor: themeColor.themeColorBG,
      actions: [
        TextButton(
          onPressed: negativeAnswerFun,
          child: Text(negativeAnswer),
        ),
        TextButton(
          onPressed: positiveAnswerFun,
          child: Text(positiveAnswer),
        ),
      ],
    ) 
  ));
}

List<Plant> makePlantList(){ 
    List<Plant> returnList = [];
    returnList.add(Plant('bôbovité', "agát", "biely", "agat_biely", wikipediaLink: 'https://sk.wikipedia.org/wiki/Agát_biely'));
    returnList.add(Plant('lipnicovité', "bambus", "", "bambus", wikipediaLink: 'https://sk.wikipedia.org/wiki/Bambusovaté'));
    returnList.add(Plant('iskerníkovité', "blyskáč", "jarný", "blyskac_jarny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Blyskáč_jarný'));
    returnList.add(Plant('ružovité', "broskyňa", "obyčajná", "broskyna_obycajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Broskyňa_obyčajná'));
    returnList.add(Plant('bukovité', "buk", "lesný", "buk_lesny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Buk_lesný'));
    returnList.add(Plant('čajovníkovité', "čajovník", "čínsky", "cajovnik_cinsky", wikipediaLink: 'https://sk.wikipedia.org/wiki/Čajovník_čínsky'));
    returnList.add(Plant('ružovité', "čerešňa", "vtáčia", "ceresna_vtacia", wikipediaLink: 'https://sk.wikipedia.org/wiki/Čerešňa_vtáčia'));
    returnList.add(Plant('ľaliovité', "cesnak", "cibuľový", "cesnak_cibulovy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Cesnak_cibuľový'));
    returnList.add(Plant('ľaliovité', "cesnak", "kuchynský", "cesnak_kuchynsky", wikipediaLink: 'https://sk.wikipedia.org/wiki/Cesnak_kuchynský'));
    returnList.add(Plant('ľaliovité', "cesnak", "pažitkový", "cesnak_pazitkovy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Cesnak_(rod)'));
    returnList.add(Plant('konopovité', "chmeľ", "obyčajný", "chmel_obycajny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Chmeľ_obyčajný'));
    returnList.add(Plant('kapustovité', "chren", "dedinský", "chren_dedinsky", wikipediaLink: 'https://sk.wikipedia.org/wiki/Chren_dedinský'));
    returnList.add(Plant('vstavačovité', "črievičník", "papučkovitý", "crievicnik_papuckovity", wikipediaLink: 'None'));
    returnList.add(Plant('bôbovité', "ďatelina", "lúčna", "datelina_lucna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ďatelina_lúčna'));
    returnList.add(Plant('bukovité', "dub", "letný", "dub_letny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Dub_letný'));
    returnList.add(Plant('hluchavkovité', "dúška", "materina", "duska_materina", wikipediaLink: 'https://sk.wikipedia.org/wiki/Dúška_materina'));
    returnList.add(Plant('bôbovité', "fazuľa", "záhradná", "fazula_zahradna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Fazuľa_obyčajná'));
    returnList.add(Plant('fialkovité', "fialka", "voňavá", "fialka_vonava", wikipediaLink: 'https://sk.wikipedia.org/wiki/Fialka_voňavá'));
    returnList.add(Plant('bukovité', "gaštan", "jedlý", "gastan_jedly", wikipediaLink: 'https://sk.wikipedia.org/wiki/Gaštan_jedlý'));
    returnList.add(Plant('ružovité', "hloh", "jednosemenný", "hloh_jednosemenny", wikipediaLink: 'None'));
    returnList.add(Plant('hluchavkovité', "hluchavka", "škvrnitá", "hluchavka_skvrnita", wikipediaLink: 'https://sk.wikipedia.org/wiki/Hluchavka'));
    returnList.add(Plant('kapustovité', "horčica", "biela", "horcica_biela", wikipediaLink: 'https://sk.wikipedia.org/wiki/Horčica_biela'));
    returnList.add(Plant('lieskovité', "hrab", "obyčajný", "hrab_obycajny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Hrab_obyčajný'));
    returnList.add(Plant('bôbovité', "hrach", "siaty", "hrach_siaty", wikipediaLink: 'https://sk.wikipedia.org/wiki/Hrach_siaty'));
    returnList.add(Plant('ružovité', "hruška", "obyčajná", "hruska_obycajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Hruška_obyčajná'));
    returnList.add(Plant('ľaliovité', "hyacint", "východný", "hyacint_vychodny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Hyacint_východný'));
    returnList.add(Plant('iskerníkovité', "iskerník", "prudký", "iskernik_prudky", wikipediaLink: 'https://sk.wikipedia.org/wiki/Iskerník_prudký'));
    returnList.add(Plant('ružovité', "jabloň", "domáca", "jablon_domaca", wikipediaLink: 'https://sk.wikipedia.org/wiki/Jabloň_domáca'));
    returnList.add(Plant('lipnicovité', "jačmeň", "siaty", "jacmen_siaty", wikipediaLink: 'https://sk.wikipedia.org/wiki/Jačmeň_siaty'));
    returnList.add(Plant('ružovité', "jahoda", "obyčajná", "jahoda_obycajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Jahoda_obyčajná'));
    returnList.add(Plant('brezovité', "jelša", "lepkavá", "jelsa_lepkava", wikipediaLink: 'https://sk.wikipedia.org/wiki/Jelša_lepkavá'));
    returnList.add(Plant('kapustovité', "kapsička", "pastierska", "kapsicka_pastierska", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kapsička_pastierska'));
    returnList.add(Plant('kapustovité', "kapusta", "hlávková", "kapusta_hlavkova", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kapusta_obyčajná_hlávková'));
    returnList.add(Plant('klinčekovité', "klinček", "", "klincek", wikipediaLink: 'https://sk.wikipedia.org/wiki/Klinčekovec_voňavý'));
    returnList.add(Plant('konopovité', "konopa", "siata", "konope_siata", wikipediaLink: 'https://sk.wikipedia.org/wiki/Konopa_siata'));
    returnList.add(Plant('ľaliovité', "konvalinka", "voňavá", "konvalinka_vonava", wikipediaLink: 'https://sk.wikipedia.org/wiki/Konvalinka_voňavá'));
    returnList.add(Plant('mrkvovité', "kôpor", "voňavý", "kopor_vonavy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kôpor_voňavý'));
    returnList.add(Plant('lipnicovité', "kukurica", "siata", "kukurica_siata", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kukurica_siata'));
    returnList.add(Plant('ľaliovité', "ľalia", "biela", "lalia_biela", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ľalia_biela'));
    returnList.add(Plant('makovité', "lastovičník", "väčší", "lastovicnik_vacsi", wikipediaLink: 'https://sk.wikipedia.org/wiki/Lastovičník_väčší'));
    returnList.add(Plant('leknovité', "lekno", "biele", "lekno_biele", wikipediaLink: 'https://sk.wikipedia.org/wiki/Lekno_biele'));
    returnList.add(Plant('lieskovité', "lieska", "obyčajna", "lieska_obycajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Lieska_obyčajná'));
    returnList.add(Plant('lipovité', "lipa", "malolistá", "lipa_malolista", wikipediaLink: 'https://sk.wikipedia.org/wiki/Lipa_malolistá'));
    returnList.add(Plant('lipovité', "lipa", "veľkolistá", "lipa_velkolista", wikipediaLink: 'https://sk.wikipedia.org/wiki/Lipa_veľkolistá'));
    returnList.add(Plant('lipnicovité', "lipnica", "lúčna", "lipnica_lucna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Lipnica_(rod_rastlín)'));
    returnList.add(Plant('astrovité', "lopúch", "väčší", "lopuch_vacsi", wikipediaLink: 'None'));
    returnList.add(Plant('bôbovité', "lucerna", "siata", "lucerna_siata", wikipediaLink: 'https://sk.wikipedia.org/wiki/Lucerna_siata'));
    returnList.add(Plant("ľuľkovité", "ľuľkovec", "zlomocný", "lulkovec_zlomocny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ľuľkovec_zlomocný'));
    returnList.add(Plant("ľuľkovité", "ľulok", "zemiakový", "lulok_zemiakovy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ľuľok_zemiakový'));
    returnList.add(Plant("magnóliovité", "magnólia", "veľkokvetá", "magnolia_velkokveta", wikipediaLink: 'https://sk.wikipedia.org/wiki/Magnólia'));
    returnList.add(Plant("makovité", "mak", "vlčí", "mak_vlci", wikipediaLink: 'https://sk.wikipedia.org/wiki/Mak_vlčí'));
    returnList.add(Plant("astrovité", "margaréta", "biela", "margareta_biela", wikipediaLink: 'https://sk.wikipedia.org/wiki/Margaréta_(rod)'));
    returnList.add(Plant("ružovité", "marhuľa", "obyčajná", "marhula_obycajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Marhuľa_obyčajná'));
    returnList.add(Plant("hluchavkovité", "mäta", "prieporná", "mata_prieporna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Mäta_pieporná'));
    returnList.add(Plant("mrkvovité", "mrkva", "obyčajná", "mrkva_obycajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Mrkva_obyčajná'));
    returnList.add(Plant("amarylkovité", "narcis", "žltý", "narcis_zlty", wikipediaLink: 'https://sk.wikipedia.org/wiki/Narcis_(rod)'));
    returnList.add(Plant("ružovité", "nátržník", "husí", "natrznik_husi", wikipediaLink: 'None'));
    returnList.add(Plant("astrovité", "nechtík", "lekársky", "nechtik_lekarsky", wikipediaLink: 'https://sk.wikipedia.org/wiki/Nechtík_lekársky'));
    returnList.add(Plant("ružovité", "ostružina", "černicová", "ostruzina_cernicova", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ostružina_černicová'));
    returnList.add(Plant("ružovité", "ostružina", "malinová", "ostruzina_malinova", wikipediaLink: 'https://sk.wikipedia.org/wiki/Malina_(plod)'));
    returnList.add(Plant("lipnicovité", "ovos", "siaty", "ovos_siaty", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ovos_siaty'));
    returnList.add(Plant("bukovité", "pagaštan", "konský", "pagastan_konsky", wikipediaLink: 'https://sk.wikipedia.org/wiki/Pagaštan_konský'));
    returnList.add(Plant("ľuľkovité", "paprika", "ročná", "paprika_rocna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Paprika_ročná'));
    returnList.add(Plant("astrovité", "pestrec", "mariánsky", "pestrec_mariansky", wikipediaLink: 'https://sk.wikipedia.org/wiki/Pestrec_mariánsky'));
    returnList.add(Plant("mrkvovité", "petržlen", "záhradný", "petrzlen_zahradny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Petržlen_záhradný'));
    returnList.add(Plant("bôbovité", "podzemnica", "olejná", "podzemnica_olejna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Podzemnica_olejná'));
    returnList.add(Plant("pŕhľavovité", "pŕhľava", "dvojdomá", "prhlava_dvojdoma", wikipediaLink: 'https://sk.wikipedia.org/wiki/Pŕhľava_dvojdomá'));
    returnList.add(Plant("lipnicovité", "pšenica", "letná", "psenica_letna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Pšenica'));
    returnList.add(Plant("astrovité", "púpava", "lekárska", "pupava_lekarska", wikipediaLink: 'https://sk.wikipedia.org/wiki/Púpava_lekárska'));
    returnList.add(Plant("ľuľkovité", "rajčiak", "jedlý", "rajciak_jedly", wikipediaLink: 'https://sk.wikipedia.org/wiki/Rajčiak_jedlý'));
    returnList.add(Plant("mrkvovité", "rasca", "lúčna", "rasca_lucna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Rasca_lúčna'));
    returnList.add(Plant("lipnicovité", "raž", "siata", "raz_siata", wikipediaLink: 'https://sk.wikipedia.org/wiki/Raž_siata'));
    returnList.add(Plant("kapustovité", "repka", "olejná", "repka_olejna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kapusta_repková_pravá'));
    returnList.add(Plant("lipnicovité", "reznačka", "laločnatá", "reznacka_lalocnata", wikipediaLink: 'None'));
    returnList.add(Plant("astrovité", "rumanček", "kamilkový", "rumancek_kamilkovy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Rumanček_kamilkový'));
    returnList.add(Plant("ružovité", "ruža", "šípova", "ruza_sipova", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ruža_šípová'));
    returnList.add(Plant("lipnicovité", "ryža", "siata", "ryza_siata", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ryža_siata'));
    returnList.add(Plant("astrovité", "šalát", "siaty", "salat_siaty", wikipediaLink: 'https://sk.wikipedia.org/wiki/Šalát_siaty'));
    returnList.add(Plant("hluchavkovité", "šalvia", "lekárska", "salvia_lekarska", wikipediaLink: 'https://sk.wikipedia.org/wiki/Šalvia_lekárska'));
    returnList.add(Plant("ružovité", "slivka", "domáca", "slivka_domaca", wikipediaLink: 'https://sk.wikipedia.org/wiki/Slivka_domáca'));
    returnList.add(Plant("ružovité", "slivka", "trnková", "slivka_trnkova", wikipediaLink: 'https://sk.wikipedia.org/wiki/Slivka_trnková'));
    returnList.add(Plant("astrovité", "slnečnica", "ročná", "slnecnica_rocna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Slnečnica_ročná'));
    returnList.add(Plant("amarylkovité", "snežienka", "jarná", "snezienka_jarna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Snežienka_jarná'));
    returnList.add(Plant("mrlíkovité", "špenát", "siaty", "spenat_siaty", wikipediaLink: 'https://sk.wikipedia.org/wiki/Špenát_siaty'));
    returnList.add(Plant("stavikrvovité", "štiav", "lúčny", "stiav_lucny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Štiav_lúčny'));
    returnList.add(Plant("lipnicovité", "timotejka", "lúčna", "timotejka_lucna", wikipediaLink: 'https://cs.wikipedia.org/wiki/Bojínek'));
    returnList.add(Plant("lipnicovité", "trsť", "obyčajná", "trst_obycajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Trsť_obyčajná'));
    returnList.add(Plant("ľaliovité", "tulipán", "", "tulipan", wikipediaLink: 'https://sk.wikipedia.org/wiki/Tulipán'));
    returnList.add(Plant("iskerníkovité", "veternica", "hájna", "veternica_hajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Veternica_iskerníkovitá'));
    returnList.add(Plant("bôbovité", "vika", "siata", "vika_siata", wikipediaLink: 'https://sk.wikipedia.org/wiki/Vika_(rod)'));
    returnList.add(Plant("vstavačovité", "vstavač", "obyčajný", "vstavac_obycajny", wikipediaLink: 'None'));
    returnList.add(Plant("iskerníkovité", "záružlie", "močiarne", "zaruzlie_mociarne", wikipediaLink: 'https://sk.wikipedia.org/wiki/Záružlie_močiarne'));
    returnList.add(Plant("mrkvovité", "zeler", "voňavý", "zeler_vonavy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Zeler_voňavý'));
    returnList.add(Plant("ginkovité", "ginkgo", "dvojlaločné", "ginkgo_dvojlalocne", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ginko_dvojlaločné'));
    returnList.add(Plant("borovicovité", "jedľa", "biela", "jedla_biela", wikipediaLink: 'https://sk.wikipedia.org/wiki/Jedľa_biela'));
    returnList.add(Plant("borovicovité", "smrek", "obyčajný", "smrek_obycajny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Smrek_obyčajný'));
    returnList.add(Plant("borovicovité", "smrek", "pichľavý", "smrek_pichlavy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Smrek_pichľavý'));
    returnList.add(Plant("borovicovité", "duglaska", "tisolistá", "duglaska_tisolista", wikipediaLink: 'https://sk.wikipedia.org/wiki/Duglaska_tisolistá'));
    returnList.add(Plant("borovicovité", "borovica", "lesná", "borovica_lesna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Borovica_lesná'));
    returnList.add(Plant("borovicovité", "borovica", "čierna", "borovica_cierna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Borovica_čierna'));
    returnList.add(Plant("borovicovité", "borovica", "kosodrevinová", "borovica_kosodrevinova", wikipediaLink: 'https://sk.wikipedia.org/wiki/Borovica_horská'));
    returnList.add(Plant("borovicovité", "borovica", "limbová", "borovica_limbova", wikipediaLink: 'https://sk.wikipedia.org/wiki/Borovica_limbová'));
    returnList.add(Plant("borovicovité", "borovica", "hladká", "borovica_hladka", wikipediaLink: 'None'));
    returnList.add(Plant("cyprusovité", "sekvojovec", "mamutí", "sekvojovec_mamuti", wikipediaLink: 'https://sk.wikipedia.org/wiki/Sekvojovec'));
    returnList.add(Plant("cyprusovité", "borievka", "obyčajná", "borievka_obycajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Borievka_obyčajná'));
    returnList.add(Plant("tisovité", "tis", "obyčajný", "tis_obycajny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Tis_obyčajný'));
    returnList.add(Plant("cyprusovité", "tuja", "západná", "tuja_zapadna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Tuja_západná'));
    returnList.add(Plant("borovicovité", "smrekovec", "opadavý", "smrekovec_opadavy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Smrekovec_opadavý'));
    returnList.add(Plant("áronovité", "brečtan", "popínavý", "brectan_popinavy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Brečtan_popínavý'));
    returnList.add(Plant("brezovité", "breza", "previsnutá", "breza_previsnuta", wikipediaLink: 'https://sk.wikipedia.org/wiki/Breza_previsnutá'));
    returnList.add(Plant("iskerníkovité", "orlíček", "obyčajný", "orlicek_obycajny", wikipediaLink: 'https://cs.wikipedia.org/wiki/Orlíček'));
    returnList.add(Plant("iskerníkovité", "ostrôžka", "poľná", "ostrozka_polna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ostrôžka_poľná'));
    returnList.add(Plant("makovité", "mak", "siaty", "mak_siaty", wikipediaLink: 'https://sk.wikipedia.org/wiki/Mak_siaty'));
    returnList.add(Plant("leknovité", "lekno", "modré", "lekno_modre", wikipediaLink: 'None'));
    returnList.add(Plant("bukovité", "dub", "zimný", "dub_zimny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Dub_zimný'));
    returnList.add(Plant("fialkovité", "fialka", "trojfarebná", "fialka_trojfarebna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Fialka_trojfarebná'));
    returnList.add(Plant("kapustovité", "kel", "hlávkový", "kel_hlavkovy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kapusta_obyčajná_kelová'));
    returnList.add(Plant("kapustovité", "kel", "ružičkový", "kel_ruzickovy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kapusta_obyčajná_ružičková'));
    returnList.add(Plant("kapustovité", "kaleráb", "", "kalerab", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kapusta_obyčajná_kalerábová'));
    returnList.add(Plant("kapustovité", "karfiol", "", "karfiol", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kapusta_obyčajná_karfiolová'));
    returnList.add(Plant("kapustovité", "reďkev", "siata", "redkev_siata", wikipediaLink: 'https://sk.wikipedia.org/wiki/Reďkev_siata'));
    returnList.add(Plant("kapustovité", "peniažtek", "roľný", "peniaztek_rolny", wikipediaLink: 'https://cs.wikipedia.org/wiki/Penízek_rolní'));
    returnList.add(Plant("kapustovité", "žerušnica", "lúčna", "zeruznica_lucna", wikipediaLink: 'None'));
    returnList.add(Plant("ružovité", "čerešňa", "višňová", "ceresna_visnova", wikipediaLink: 'https://sk.wikipedia.org/wiki/Čerešňa_višňová'));
    returnList.add(Plant("bôbovité", "šošovica", "jedlá", "sosovica_jedla", wikipediaLink: 'https://sk.wikipedia.org/wiki/Šošovica_jedlá'));
    returnList.add(Plant("bôbovité", "sója", "obyčajná", "soja_obycajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Sója'));
    returnList.add(Plant("mrkvovité", "koriander", "siaty", "koriander_siaty", wikipediaLink: 'https://sk.wikipedia.org/wiki/Koriander_siaty'));
    returnList.add(Plant("mrkvovité", "fenikel", "obyčajný", "fenikel_obycajny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Fenikel_obyčajný'));
    returnList.add(Plant("mrkvovité", "boľševník", "obrovský", "bolsevnik_obrovsky", wikipediaLink: 'https://sk.wikipedia.org/wiki/Boľševník_obrovský'));
    returnList.add(Plant("mrkvovité", "kozonoha", "hostcova", "kozonoha_hostcova", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kozonoha_hostcová'));
    returnList.add(Plant("mrkvovité", "bolehlav", "škvrnitý", "bolehelav_skvrnity", wikipediaLink: 'https://sk.wikipedia.org/wiki/Bolehlav_škvrnitý'));
    returnList.add(Plant("ľuľkovité", "tabak", "virgínsky", "tabak_virginsky", wikipediaLink: 'https://cs.wikipedia.org/wiki/Tabák_virginský'));
    returnList.add(Plant("ľuľkovité", "durman", "obyčajný", "durman_obycajny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Durman_obyčajný'));
    returnList.add(Plant("ľuľkovité", "blen", "čierny", "blen_cierny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Blen_čierny'));
    returnList.add(Plant("hluchavkovité", "rozmarín", "lekársky", "rozmarin_lekarsky", wikipediaLink: 'https://sk.wikipedia.org/wiki/Rozmarín_lekársky'));
    returnList.add(Plant("hluchavkovité", "levanduľa", "úzkolistá", "levandula_uskolista", wikipediaLink: 'https://sk.wikipedia.org/wiki/Levanduľa'));
    returnList.add(Plant("hluchavkovité", "majorán", "záhradný", "majoran_zahradny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Majorán_záhradný'));
    returnList.add(Plant("hluchavkovité", "bazalka", "pravá", "bazalka_prava", wikipediaLink: 'https://sk.wikipedia.org/wiki/Bazalka_pravá'));
    returnList.add(Plant("astrovité", "bodliak", "obyčajný", "bodliak_obycajny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Bodliak'));
    returnList.add(Plant("astrovité", "rebríček", "obyčajný", "rebricek_obycajny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Rebríček_obyčajný'));
    returnList.add(Plant("astrovité", "sedmokráska", "obyčajná", "sedmokraska_obycajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Sedmokráska_obyčajná'));
    returnList.add(Plant("astrovité", "astry", "", "astry", wikipediaLink: 'https://sk.wikipedia.org/wiki/Astra_alpínska'));
    returnList.add(Plant("astrovité", "aksamietnice", "", "aksamietnice", wikipediaLink: 'https://cs.wikipedia.org/wiki/Aksamitník'));
    returnList.add(Plant("astrovité", "cínie", "", "cinie", wikipediaLink: 'None'));
    returnList.add(Plant("astrovité", "georgíny", "", "georginy", wikipediaLink: 'None'));
    returnList.add(Plant("ľaliovité", "modrica", "strapcovitá", "modrica_strapcovita", wikipediaLink: 'https://sk.wikipedia.org/wiki/Modrica'));
    returnList.add(Plant("ľaliovité", "ľalia", "zlatohlavá", "lalia_zlatohlava", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ľalia_zlatohlavá'));
    returnList.add(Plant("ľaliovité", "kokorík", "mnohokvetý", "kokorik_mnohokvety", wikipediaLink: 'https://cs.wikipedia.org/wiki/Kokořík_mnohokvětý'));
    returnList.add(Plant("ľaliovité", "vranovec", "štvorlistý", "vranovec_stvorlisty", wikipediaLink: 'https://sk.wikipedia.org/wiki/Vranovec_štvorlistý'));
    returnList.add(Plant("amarylkovité", "bleduľa", "jarná", "bledula_jarna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Bleduľa_jarná'));
    returnList.add(Plant("arekovité", "datľovník", "obyčajný", "datlovnik_obycajny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Datľovník_obyčajný'));
    returnList.add(Plant("arekovité", "kokosovník", "obyčajný", "kokosovnik_obycajny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kokosovník'));
    returnList.add(Plant("kosatcovité", "mečík", "", "mecik", wikipediaLink: 'https://cs.wikipedia.org/wiki/Mečík'));
    returnList.add(Plant("kosatcovité", "kosatec", "nemecký", "kosatec_nemecky", wikipediaLink: 'https://cs.wikipedia.org/wiki/Kosatec'));
    returnList.add(Plant("lipnicovité", "pýr", "plazivý", "pyr_plazivy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Pýr_plazivý'));
    returnList.add(Plant("lipnicovité", "proso", "siate", "proso_siate", wikipediaLink: 'https://sk.wikipedia.org/wiki/Proso_siate'));
    return returnList;
  } 

Color changeAppBarColor(int value){
  if(value == 1){
    return Colors.red;
  } else if(value == 2){
    return Colors.blue;
  } else if(value == 3){
    return Colors.green;
  } else {
    return Colors.grey;
  }
}

String removeDiacritics(String str) {

  var withDia = 'aáäbcčdďeéfghiíjklĺľmnňoóôpqrŕsštťuúvwxyýzž';
  var withoutDia = 'aaabccddeefghiijklllmnnooopqrrssttuuvwxyyzz'; 

  for (int i = 0; i < withDia.length; i++) {      
    str = str.toLowerCase().replaceAll(withDia[i], withoutDia[i]);
  }

  return str;

}

String changeMillisecondsToTime(int milliseconds){
  int seconds = (milliseconds/1000).floor();
  int minutes = (milliseconds/60000).floor();
  int hours = (milliseconds/3600000).floor();
  
  String stopWatchTime = '${hours%24}:${minutes%60}:${seconds%60}';
  if(hours%24 < 10){
    stopWatchTime = '0${hours%24}:';
  } else {
    stopWatchTime = '${hours%24}:';
  }
  if(minutes%60 < 10){
    stopWatchTime = '${stopWatchTime}0${minutes%60}:';
  } else {
    stopWatchTime = '$stopWatchTime${minutes%60}:';
  }
  if(seconds%60 < 10){
    stopWatchTime = '${stopWatchTime}0${seconds%60}';
  } else {
    stopWatchTime = '$stopWatchTime${seconds%60}';
  }
  return stopWatchTime;
}

Future<void> loadAllPreferences() async {
  plants.forEach((element) => element.loadFromPreferences());
  guessFamily = await loadFromPreferencesBool('guessFamily');
  await themeColor.loadFromPreferences();
}
