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


final List<Plant> plants = makePlantList();
final List<String> familyTypes = makefamilyTypesList();
ThemeColor themeColor = ThemeColor(themeColorMain: changeAppBarColor(2), themeColorBG: Color.fromARGB(255, 247, 247, 247), textColorMain: Colors.black );
bool guessFamily = true;
Map<String, List<int>> loadingCodes = {
  "gymlet poznávačka": [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109]
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadAllPreferences();
  runApp(const MyApp());
  debugPrint(plants.length.toString());
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


launchURL(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${substring(1)}";
    }
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

class ThemeColor{
  late Color themeColorMain;
  late Color themeColorBG;
  late Color textColorAppBar;
  late Color textColorMain;

  ThemeColor({required this.themeColorMain, this.themeColorBG = Colors.white, this.textColorMain = Colors.black, this.textColorAppBar = Colors.white}){
    loadFromPreferences();
  }
  
  factory ThemeColor.fromMap(Map<String, dynamic> json) => ThemeColor(
    themeColorMain: json['themeColorMain'],
  );

  Future<void> loadFromPreferences()async{
    final prefs = await SharedPreferences.getInstance();
    themeColorMain = changeAppBarColor(prefs.getInt('themeColorMain') ?? 2);
  }

  Map<String, dynamic> toMap(){
    return{ 
      'themeColorMain': themeColorMain,
    };
  }
}

Future<void> loadAllPreferences() async {
  plants.forEach((element)=> element.loadFromPreferences());
  await themeColor.loadFromPreferences();
}

class Plant{
  late String family;
  late String slovakFirstName;
  late String slovakLastName;
  late String path;
  String wikipediaLink;
  bool enabled = false;
  Plant(this.family, this.slovakFirstName, this.slovakLastName, this.path, {this.wikipediaLink = 'https://www.google.com'});

  Future<void> setToPreferences()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$slovakFirstName $slovakLastName', enabled);
  }

  Future<void> loadFromPreferences()async{
    final prefs = await SharedPreferences.getInstance();
    enabled = (prefs.getBool('$slovakFirstName $slovakLastName') ?? true);
  }

}

class StopWatch extends Stopwatch{
  int _starterMilliseconds = 0;

  StopWatch();

  get elapsedDuration{
    return Duration(
      microseconds: 
      elapsedMicroseconds + (_starterMilliseconds * 1000)
    );
  }

  get elapsedMillis{
    return elapsedMilliseconds + _starterMilliseconds;
  }

  get elapsedSecond{
    return ((elapsedMilliseconds + _starterMilliseconds)/1000).floor();
  }

  get elapsedMinutes{
    return ((elapsedMilliseconds + _starterMilliseconds)/60000).floor();
  }

  get elapsedHours{
    return ((elapsedMilliseconds + _starterMilliseconds)/3600000).floor();
  }

  set milliseconds(int timeInMilliseconds){
    _starterMilliseconds = timeInMilliseconds;
  }

}

class GameScore{
  int correct;
  int wrong;
  int hints;
  String time;
  String date;
  String stopWatch;
  String wrongAnswersList;
  GameScore({required this.correct, required this.wrong, required this.hints, required this.time, required this.date, required this.stopWatch, required this.wrongAnswersList});

  factory GameScore.fromMap(Map<String, dynamic> json) => GameScore(
    correct: json['correct'],
    wrong: json['wrong'],
    hints: json['hints'],
    time: json['time'],
    date: json['date'],
    stopWatch: json['stopWatch'],
    wrongAnswersList: json['wrongAnswersList'],
  );

  Map<String, dynamic> toMap(){
    return{
      'correct': correct, 
      'wrong': wrong,
      'hints': hints,
      'time': time,
      'date': date,
      'stopWatch': stopWatch,
      'wrongAnswersList': wrongAnswersList,
    };
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Poznávačka', 
      theme: ThemeData(
        
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        'learningScreen': (BuildContext context) => const LearningPage(title: 'scr4'),
        'settingsScreen': (BuildContext context) => const SettingsPage(),
        'plantEnablingScreen': (BuildContext context) => const PlantEnablingPage(),
        'gameHistoryScreen': (BuildContext context) => const GameHistoryPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}  
class _MyHomePageState extends State<MyHomePage> {
  final String homePagePlantLink = 'assets/images/homePagePlant.png';
  _getRequests()async{
    setState(() {
        
    });
  }
  @override
  void initState() {
    loadAllPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        setState(() {
          
        });
        return confirmationBool(
          context, 
          () {Navigator.of(context).pop(true);}, 
          () {Navigator.of(context).pop(false);},
          subtitle: Text('Chceš vypnút aplikáciu', style: TextStyle(color:themeColor.textColorMain)),
          title: Text('Si si istý?', style: TextStyle(color:themeColor.textColorMain)),
        );
      },
      child: Scaffold(
        backgroundColor: themeColor.themeColorBG,
        appBar: AppBar(
          backgroundColor: themeColor.themeColorMain,
          title: const Text('Poznávačka'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: (){
                Navigator.of(context).pushNamed('settingsScreen').then((val)=>{_getRequests()});
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Divider(thickness: 50, color: themeColor.themeColorBG, height: 50,),
            Image(
              image: AssetImage(homePagePlantLink),
            ),
            Divider(thickness: 70, color: themeColor.themeColorBG, height: 70,),
            TextButton(
              onPressed: ()async{
                int playedGameStopWatch = await loadFromPreferencesInt('playedGameStopWatch');
                int playedGameCorrect = await loadFromPreferencesInt('playedGameCorrect');
                int playedGameWrong = await loadFromPreferencesInt('playedGameWrong');
                int playedGameHints = await loadFromPreferencesInt('playedGameHints');
                if(playedGameCorrect != 0 || playedGameWrong != 0){
                  showDialog(context: context, 
                    builder: (context){
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(themeColor.themeColorBG),
                              ),
                              onPressed:() {
                                Navigator.of(context).pop();
                                startGuessingPage(true);
                              }, 
                              child: const Text('Nová hra', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black),)
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(themeColor.themeColorBG),
                                  ),
                                  onPressed:() {
                                    Navigator.of(context).pop();      
                                    startGuessingPage(false);
                                  }, 
                                  child: const Text('Pokračovať', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black),)
                                ),
                                Center(
                                  child: ListTile(
                                    title: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(height: 3, color: Colors.grey,),
                                        Center(child:Text(changeMillisecondsToTime(playedGameStopWatch), style: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500))),
                                        Container(color: Colors.white, height:20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                const Icon(Icons.done, color: Color.fromARGB(255, 1, 107, 7),size: 20,),
                                                Text(
                                                  '$playedGameCorrect',
                                                  style: const TextStyle(color: Color.fromARGB(255, 1, 107, 7), fontSize: 20),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Icon(Icons.close, color: Colors.red[800], size: 20,),
                                                Text(
                                                  '$playedGameWrong',
                                                  style: TextStyle(color: Colors.red[800], fontSize: 20),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Icon(Icons.lightbulb, color: Colors.yellow[700],size: 20,),
                                                Text(
                                                  '$playedGameHints',
                                                  style: TextStyle(color: Colors.yellow[700], fontSize: 20),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(color: Colors.white, height:5),
                                        Container(height: 3, color: Colors.grey,),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    }
                  );    
                } else {
                  
                  startGuessingPage(true);
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(themeColor.themeColorMain),
                minimumSize: MaterialStateProperty.all(const Size(200,40)),
              ),
              child: const Text('Hrať hru', style: TextStyle(color:Colors.white, fontSize: 20),),
            ),
            TextButton(
             onPressed: (){
               Navigator.of(context).pushNamed('learningScreen').then((val)=>{_getRequests()});
             },
             style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(themeColor.themeColorMain),
                minimumSize: MaterialStateProperty.all(const Size(200,40)),
              ), 
             child: const Text('Rastliny', style: TextStyle(color:Colors.white, fontSize: 20),),
            )
          ]
        )
      )
    );
  }

  void startGuessingPage(bool isNewGame){
    int plantsEnabled = 0;
    plants.forEach((element) {if(element.enabled == true){plantsEnabled++;}});
    if(plantsEnabled > 1){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => GuessingPage(isNew: isNewGame,))).then((val)=>{_getRequests()});
    } else {
      showDialog(
        context: context,
        builder:(context){
          return const AlertDialog(
            
            title: Center(
              child: Text(
                'Musíš si povoliť aspoň 2 rastliny',
                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red, fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            content: Text(
                'NASTAVENIA -> Povoliť rastliny',
                style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black, fontSize: 20),
                textAlign: TextAlign.center,
              ),
          );
        },
      );
    } 
  }
}

class GuessingPage extends StatefulWidget {
  const GuessingPage({Key? key, required this.isNew}) : super(key: key);
  final bool isNew;

  @override
  State<GuessingPage> createState() => _GuessingPageState();
}
class _GuessingPageState extends State<GuessingPage> {
  List<int> lastIndexes = [];
  List<int> usingIndexes = [];
  int plantIndex = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  int hintsUsed = 0;
  List<int> hintsOnPlantUsed = [];
  int maxHintsOnPlant = 3;
  List<int> wrongAnswersList = [];
  TextEditingController slovakTermInput = TextEditingController();
  TextEditingController familyInput = TextEditingController();
  StopWatch stopWatch = StopWatch();
  bool thisGameGuessingFamily = guessFamily;
  late Widget familyInputterContainer = Container(width: 1,height: 1, color: Colors.white,);
  
  late String stopWatchTime = '00:00:00';
  late Timer everySecondTimer;

  @override
  void dispose() {
    everySecondTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    futureToInitState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(thisGameGuessingFamily == true){
      familyInputterContainer = Container(
        margin: const EdgeInsets.only(left: 20, top: 5, right: 20),
        child: TextField(
          controller: familyInput,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Čeľaď',
          ),
        ),
      );
    } else {
      familyInputterContainer = Container(width: 1,height: 1, color: Colors.white,);
    }
    return WillPopScope(
      onWillPop: ()async{
        return confirmationBool(
          context, 
          () {Navigator.of(context).pop(true);}, 
          () {Navigator.of(context).pop(false);},
          subtitle: Text('Chceš vypnút a opustiť hru', style: TextStyle(color:themeColor.textColorMain)),
          title: Text('Si si istý?', style: TextStyle(color:themeColor.textColorMain)),
        );
      },
      child:Scaffold(
        backgroundColor: themeColor.themeColorBG,
        appBar: AppBar( 
          backgroundColor: themeColor.themeColorMain,
          automaticallyImplyLeading: false,
          title: const Text('Uhádni rastlinu'),
          leadingWidth: 130,
          leading: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_left),
                onPressed: (){
                  confirmationBool(
                    context, 
                    () {
                      Navigator.of(context).pop(true);
                      Navigator.of(context).pop(true);
                    }, 
                    () {Navigator.of(context).pop(false);},
                    subtitle: Text('Chceš vypnút a opustiť hru', style: TextStyle(color:themeColor.textColorMain)),
                    title: Text('Si si istý?', style: TextStyle(color:themeColor.textColorMain)),
                  );
                }
              ),
              const Spacer(),
              Text(
                correctAnswers.toString(),
                style: const TextStyle(color: Color.fromARGB(255, 1, 107, 7), fontWeight: FontWeight.w900, fontSize: 20)
              ),
              const Spacer(flex: 3),
              Text(
                wrongAnswers.toString(),
                style: TextStyle(color: Colors.red[800], fontWeight: FontWeight.w900, fontSize: 20)
              ),
              const Spacer(flex: 3,),
              Text(
                hintsUsed.toString(),
                style: TextStyle(color: Colors.yellow[600], fontWeight: FontWeight.w900, fontSize: 20)
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.lightbulb),
              color: Colors.yellow[200],
              onPressed: showHintDialog,
            ),
            IconButton(
              icon: const Icon(Icons.next_plan_outlined),
              onPressed: (){
                confirmationDynamic(
                  context,
                  () {
                    wrongAnswersList.add(plantIndex);
                    wrongAnswers++;
                    familyInput = TextEditingController();
                    slovakTermInput = TextEditingController();
                    Navigator.of(context).pop(true);
                    showDialog(
                      context: context, 
                      builder: (context) => AlertDialog(
                        actions: [
                          IconButton(
                            onPressed: (){
                              slovakTermInput = TextEditingController();
                              familyInput = TextEditingController();
                              Navigator.pop(context);
                              setState((){});
                            }, 
                            icon: const Icon(Icons.keyboard_double_arrow_right),
                          ),
                        ],
                        backgroundColor: Colors.red,
                        buttonPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        title: Column(
                          children: [
                            const Text('Odpoveď bola:', style: TextStyle(fontSize: 25)),
                            const Divider(height: 15, thickness: 0,),
                            Text('${plants[lastIndexes[0]].slovakFirstName} ${plants[lastIndexes[0]].slovakLastName}'.toUpperCase(), style: const TextStyle(fontSize: 20)),
                            const Divider(height: 15, thickness: 0, color: Colors.red,),
                            Text(plants[lastIndexes[0]].family.toUpperCase(), style: const TextStyle(fontSize: 20)),
                          ],
                        ),
                      )
                    );
                    nextPlant(skipped:true);
                  },
                  (){
                    Navigator.of(context).pop(false);
                  },
                  subtitle: Text('Chceš preskočiť rastlinu', style: TextStyle(color: Colors.redAccent)),
                  title: Text('Si si istý?', style: TextStyle(color:themeColor.textColorMain)),
                );
              },
            ),
          ],
        ),
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(height: 20, color: themeColor.themeColorBG,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${lastIndexes.length+1}/${usingIndexes.length}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: themeColor.textColorMain),),
                      Text(
                        stopWatchTime,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: themeColor.themeColorMain,
                        ),
                      ),
                      Text('${lastIndexes.length+1}/${usingIndexes.length}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: themeColor.themeColorBG),),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
                    child: TextField(
                      controller: slovakTermInput,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Slovenský názov rastliny:',
                      ),
                    ),
                  ),
                  familyInputterContainer,
                  Container(height: 30, color: themeColor.themeColorBG,),
                  
                  Divider(color: themeColor.themeColorMain, thickness: 5, indent: 20, endIndent: 20,),
                  InteractiveViewer(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRect(
                        child: Image(
                          image: AssetImage('assets/images/${plants[plantIndex].path}.png'),
                          width: 300,
                        ),
                      ),
                    ),
                  ),
                  Divider(color: themeColor.themeColorMain, thickness: 5, indent: 20, endIndent: 20,),
                ]
              )
            ),
            Positioned(
              right: 50,
              bottom: 50,
              child: FloatingActionButton(
                focusColor: themeColor.themeColorMain,
                backgroundColor: themeColor.themeColorMain,
                splashColor: themeColor.themeColorMain,
                onPressed: (){
                  showDialog(context: context,
                    builder: (context){
                      late Color bgcolor;
                      bool correctPlant = false;
                      bool correctFamily = false;
                      if(removeDiacritics(slovakTermInput.text).replaceAll(' ', '') == removeDiacritics('${plants[plantIndex].slovakFirstName} ${plants[plantIndex].slovakLastName}').replaceAll(' ', '')){
                        correctPlant = true;
                      }
                      if(removeDiacritics(familyInput.text).replaceAll(' ', '') == removeDiacritics(plants[plantIndex].family).replaceAll(' ', '')){
                        correctFamily = true;
                      }
                      if(thisGameGuessingFamily == false){
                        if(correctPlant){
                          bgcolor = Colors.green;
                          return AlertDialog(  
                            backgroundColor: bgcolor,
                            buttonPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            actions: [
                              IconButton(
                                onPressed: (){
                                  correctAnswers++;
                                  nextPlant();
                                  slovakTermInput = TextEditingController();
                                  familyInput = TextEditingController();
                                  Navigator.pop(context);
                                  setState((){});
                                }, 
                                icon: const Icon(Icons.keyboard_double_arrow_right),
                              ),
                            ],
                            title: Column(
                              children: [
                                const Text('Správne!', style: TextStyle(fontSize: 25)),
                                const Divider(height: 15, thickness: 0,),
                                Text('${plants[plantIndex].slovakFirstName} ${plants[plantIndex].slovakLastName}'.toUpperCase(), style: const TextStyle(fontSize: 20)),
                              ],
                            )
                          );
                        } else {
                          bgcolor = Colors.red;
                          return AlertDialog(
                            backgroundColor: bgcolor,
                            title: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Skús to znova!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
                                  const Divider(height: 15, thickness: 0,),
                                  Text('Nesprávny názov rastliny!'),
                                ]
                              ),
                            ) 
                          );
                        }
                      } else {
                        if(correctPlant && correctFamily){
                          bgcolor = Colors.green;
                          return AlertDialog(  
                            backgroundColor: bgcolor,
                            buttonPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            actions: [
                              IconButton(
                                onPressed: (){
                                  correctAnswers++;
                                  nextPlant();
                                  slovakTermInput = TextEditingController();
                                  familyInput = TextEditingController();
                                  Navigator.pop(context);
                                  setState((){});
                                }, 
                                icon: const Icon(Icons.keyboard_double_arrow_right),
                              ),
                            ],
                            title: Column(
                              children: [
                                const Text('Správne!', style: TextStyle(fontSize: 25)),
                                const Divider(height: 15, thickness: 0,),
                                Text('${plants[plantIndex].slovakFirstName} ${plants[plantIndex].slovakLastName}'.toUpperCase(), style: const TextStyle(fontSize: 20)),
                                Divider(height: 15, thickness: 0, color: bgcolor,),
                                Text(plants[plantIndex].family.toUpperCase(), style: const TextStyle(fontSize: 20)),
                              ],
                            )
                          );
                        } else {
                          bgcolor = Colors.red;
                          Widget returnText = Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Skús to znova!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
                                const Divider(height: 15, thickness: 0,),
                                Text('Nesprávny názov rastliny'),
                                Container(color: bgcolor, height: 5,),
                                Text('nesprávny názov čeľade'),
                              ],
                            ), 
                          );  
                          if(correctPlant == true && correctFamily == false){
                            bgcolor = Colors.orange;
                            returnText = Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Skús to znova!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
                                  const Divider(height: 15, thickness: 0,),
                                  Text('Správny názov rastliny'),
                                  Container(color: bgcolor, height: 5,),
                                  Text('nesprávny názov čeľade'),
                                ],
                              ), 
                            ); 
                          } else if(correctPlant == false && correctFamily == true){
                            bgcolor = Colors.orange;
                            returnText = Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Skús to znova!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
                                  const Divider(height: 15, thickness: 0,),
                                  Text('Správny názov čeľade'),
                                  Container(color: bgcolor, height: 5,),
                                  Text('nesprávny názov rastliny'),
                                ],
                              ),
                            ); 
                          }
                          return AlertDialog(
                            backgroundColor: bgcolor,
                            title: returnText,
                          );
                        }
                      }
                    },
                  );
                },
                child: const Icon(Icons.done), 
              )
            ),
          ],
        )
      ),
    );
  }
   
  Future<void> loadGameFromPreferences()async{
    lastIndexes = [];
    usingIndexes = [];
    correctAnswers = await loadFromPreferencesInt('playedGameCorrect');
    wrongAnswers = await loadFromPreferencesInt('playedGameWrong');
    hintsUsed = await loadFromPreferencesInt('playedGameHints');
    stopWatch.milliseconds = await loadFromPreferencesInt('playedGameStopWatch');
    plantIndex = await loadFromPreferencesInt('playedGameUsingPlantIndex');
    hintsOnPlantUsed = changeToIntList(await loadFromPreferencesListOfStrings('playedGameUsingPlantHints'));
    lastIndexes = changeToIntList(await loadFromPreferencesListOfStrings('playedGameLastIndexes'));
    usingIndexes = changeToIntList(await loadFromPreferencesListOfStrings('playedGameUsingIndexes'));
    wrongAnswersList = changeToIntList(await loadFromPreferencesListOfStrings('playedGameWrongAnswersList'));
    thisGameGuessingFamily= await loadFromPreferencesBool('playedGameGuessingFamily');
  }

  List<int> findUsingIndexes(){
    List<int> returnList = [];
    plants.forEach((element) { 
      if(element.enabled == true){returnList.insert(0,plants.indexOf(element));}
    });
    return returnList;
  }
  
  bool wasPlantUsed(){
    if(usingIndexes.every((element)=>element != plantIndex)){
      return true;
    }
    return lastIndexes.any((index) => index == plantIndex);
  }

  void showHintDialog(){
    Widget ongoingHintFirstName = Text(' ${prepareHints(hintsOnPlantUsed[0], plants[plantIndex].slovakFirstName)}', style: const TextStyle(fontSize: 20,),);
    Widget ongoingHintLastName = Text('');
    
    Widget ongoingHintFamily = Text('');
    Widget familyHintText = Text('');
    Widget hintString = Text('Nápoveda: ${hintsOnPlantUsed.reduce((a, b) => a + b)}/$maxHintsOnPlant', style: const TextStyle(fontSize: 20,),);
    if(prepareHints(hintsOnPlantUsed[0], plants[plantIndex].slovakFirstName) == '?'){
      ongoingHintFirstName = GestureDetector(
        child: Text('  ---?--- ', style: TextStyle(fontSize: 30,color: themeColor.themeColorMain),),
        onTap: (){
          confirmationDynamic(
            context,
            (){
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              hintsOnPlantUsed[0] = 1;
              hintsUsed ++;
              showHintDialog();
            },
            (){
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            subtitle: Text('Chceš použiť nápovedu \npre prvý názov rastliny', style: TextStyle(fontSize: 20, color: themeColor.textColorMain),),
            title: Text('Si si istý?', style: TextStyle(color:themeColor.textColorMain)),
          );
        },
      );
    }
    if(plants[plantIndex].slovakLastName != ''){
      ongoingHintLastName = Text('    ${prepareHints(hintsOnPlantUsed[1], plants[plantIndex].slovakLastName)}', style: const TextStyle(fontSize: 20,),);
      if(prepareHints(hintsOnPlantUsed[1], plants[plantIndex].slovakLastName) == '?'){
        ongoingHintLastName = GestureDetector(
          child: Text(' ---?---', style:  TextStyle(fontSize: 30,color: themeColor.themeColorMain),),
          onTap: (){
            confirmationDynamic(
              context,
              (){
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                hintsOnPlantUsed[1] = 1;
                hintsUsed ++;
                showHintDialog();
              },
              (){
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              subtitle: Text('Chceš použiť nápovedu \npre druhý názov rastliny', style: TextStyle(fontSize: 20, color: themeColor.textColorMain),),
              title: Text('Si si istý?', style: TextStyle(color:themeColor.textColorMain)),
            );
          },
        );
      }
    }
    if(thisGameGuessingFamily == true){
      familyHintText = Text('Čeľad:', style: const TextStyle(fontSize: 20,),);
      ongoingHintFamily = Text(' ${prepareHints(hintsOnPlantUsed[2], plants[plantIndex].family)}', style: const TextStyle(fontSize: 20,),);
      if(prepareHints(hintsOnPlantUsed[2], plants[plantIndex].family) == '?'){
        ongoingHintFamily = GestureDetector(
          child: Text('  ---?---', style: TextStyle(fontSize: 30,color: themeColor.themeColorMain),),
          onTap: (){
            confirmationDynamic(
              context,
              (){
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                hintsOnPlantUsed[2] = 1;
                hintsUsed ++;
                showHintDialog();
              },
              (){
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              subtitle: Text('Chceš použiť nápovedu \npre čeľad rastliny', style: TextStyle(fontSize: 20,color:themeColor.textColorMain),),
              title: Text('Si si istý?', style: TextStyle(color:themeColor.textColorMain)),
            );
          },
        );
      }
    }
    
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Nápoveda', style: const TextStyle(fontSize: 30,),),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rastlina:', style: const TextStyle(fontSize: 20,),),
                ongoingHintFirstName,
                ongoingHintLastName,
              ],
            ),
            Container(height: 10, width: 10, color: themeColor.themeColorBG,),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                familyHintText,
                ongoingHintFamily,
              ],
            ),
            Container(height: 10, width: 10, color: themeColor.themeColorBG,),
            hintString,
          ],
        ),
      )
    );
    setState((){});
  }

  String prepareHints(int numberOfHint, String string){
    String returnString = '';
    if(numberOfHint == 0){
      returnString = '?';
    }else if(numberOfHint == 1){
      returnString = string[0];
      for (var i = 1; i < string.length; i++) {
        returnString += ' _';
      }
    }
    return returnString;
  }

  Future<void> futureToInitState()async{
    stopWatch.start();
    if(widget.isNew == false){
      await loadGameFromPreferences();
    }
    if(widget.isNew == true){
      usingIndexes = findUsingIndexes();
      nextPlant();
      lastIndexes = [];
    }

    everySecondTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      stopWatchTime = changeMillisecondsToTime(stopWatch.elapsedMillis);
      setUnEndedGameToPreferences(correctAnswers, wrongAnswers, hintsUsed, stopWatch.elapsedMillis, plantIndex, changeToStringList(lastIndexes), changeToStringList(usingIndexes), changeToStringList(hintsOnPlantUsed), thisGameGuessingFamily, changeToStringList(wrongAnswersList));
      setState((){
      });
    });


    if(thisGameGuessingFamily == false && plants[plantIndex].slovakLastName == ''){
      maxHintsOnPlant = 1;
    } else if (thisGameGuessingFamily == false || plants[plantIndex].slovakLastName == ''){
      maxHintsOnPlant = 2;
    } else {
      maxHintsOnPlant = 3;
    }
    setState((){});
  }

  void nextPlant({bool skipped = false}){
    int usingPlants = usingIndexes.length;
    if(lastIndexes.length + 2<= usingPlants){
      lastIndexes.insert(0, plantIndex);
      plantIndex = Random().nextInt(plants.length);
      hintsOnPlantUsed = [0,0,0];
      while(wasPlantUsed()){
        plantIndex = Random().nextInt(plants.length);
      }
      if(thisGameGuessingFamily == false && plants[plantIndex].slovakLastName == ''){
        maxHintsOnPlant = 1;
      } else if (thisGameGuessingFamily == false || plants[plantIndex].slovakLastName == ''){
        maxHintsOnPlant = 2;
      } else {
        maxHintsOnPlant = 3;
      }
      setUnEndedGameToPreferences(correctAnswers, wrongAnswers, hintsUsed, stopWatch.elapsedMillis, plantIndex, changeToStringList(lastIndexes), changeToStringList(usingIndexes), changeToStringList(hintsOnPlantUsed), thisGameGuessingFamily, changeToStringList(wrongAnswersList));
    } else {
      endGame(skipped: skipped);
    }
    setState(() {});
  }

  void endGame({bool skipped = false}) async {
    DateTime now = DateTime.now();
    String nowDate = '${now.day}.${now.month}.${now.year}';
    String nowTime = '${now.hour}:${now.minute}';
    await DatabaseHelper.instance.addGameScore(
      GameScore(correct: correctAnswers, wrong: wrongAnswers, hints: hintsUsed, time: nowTime, date: nowDate, stopWatch: stopWatchTime, wrongAnswersList: changeFromIntListToString(wrongAnswersList))
    );
    everySecondTimer.cancel();
    Navigator.of(context).pop();
    if(skipped == true){
      Navigator.of(context).pop();
    }
    
    showDialog(context: context, 
      builder: (context){
        return AlertDialog(
          backgroundColor: themeColor.themeColorBG,
          title: const Center(
            child: Text(
              'Hra skončila!',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 30),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Tvoje score:',
                style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.w400),
              ),
              Text(
                'Správne odpovede: $correctAnswers',
                style: const TextStyle(color: Color.fromARGB(255, 1, 107, 7), fontSize: 20),
              ),
              Text(
                'Preskočené rastliny: $wrongAnswers',
                style: TextStyle(color: Colors.red[800], fontSize: 20),
              ),
              Text(
                'Použité nápovedy: $hintsUsed',
                style: TextStyle(color: Colors.yellow[700], fontSize: 20),
              ),
              Container(
                color: themeColor.themeColorBG,
                height: 10,
              ),
              Text(
                "Čas: $stopWatchTime",
                style: const TextStyle(fontSize: 20, color: Colors.black),
              )
            ],
          ),
        );
      }
    );
    if(skipped == true){
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          actions: [
            IconButton(
              onPressed: (){
                slovakTermInput = TextEditingController();
                familyInput = TextEditingController();
                Navigator.pop(context);
                setState((){});
              }, 
              icon: const Icon(Icons.keyboard_double_arrow_right),
            ),
          ],
          backgroundColor: Colors.red,
          buttonPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          title: Column(
            children: [
              const Text('Odpoveď bola:', style: TextStyle(fontSize: 25)),
              const Divider(height: 15, thickness: 0,),
              Text('${plants[plantIndex].slovakFirstName} ${plants[plantIndex].slovakLastName}'.toUpperCase(), style: const TextStyle(fontSize: 20)),
              const Divider(height: 15, thickness: 0, color: Colors.red,),
              Text(plants[plantIndex].family.toUpperCase(), style: const TextStyle(fontSize: 20)),
            ],
          ),
        )
      );
    }
    setUnEndedGameToPreferences(0, 0, 0, 0, 0, [], [], [], guessFamily, []);
  }
}

class LearningPage extends StatefulWidget {
  const LearningPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<LearningPage> createState() => _LearningPageState();
}
class _LearningPageState extends State<LearningPage>{
  final _biggerFont = const TextStyle(fontSize: 30, color: Colors.black);
  Widget customSearchBar = const Text('Čeľade');
  Icon searchIcon = const Icon(Icons.search);
  TextEditingController searchInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor.themeColorMain,
        title: customSearchBar,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: (){
              List<String> resultList = [];
              plants.forEach((element) { 
                resultList.insert(0,'${element.slovakFirstName} ${element.slovakLastName}');
              });
              familyTypes.forEach((element) {
                resultList.insert(0, element);
              });
              
              showSearch(
                context: context,
                delegate: MySearchDelegate(searchResults: resultList),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: familyTypes.length*2,
        itemBuilder: (context, index) {
          return buildFamilyListTileWidget(context,index);
        },
      )
    );
  }
  
  Widget buildFamilyRoutePage(BuildContext context, int index){
    List<Plant> chosenFamilyPlantList = [];
    plants.forEach((plant) => {
      if(plant.family == familyTypes[index ~/ 2]){
        chosenFamilyPlantList.insert(0, plant)
      }
    });
    chosenFamilyPlantList.sort(((a, b) {return '${a.slovakFirstName} ${a.slovakLastName}'.compareTo('${b.slovakFirstName} ${b.slovakLastName}');}));
    return Scaffold(
        appBar: AppBar(
        title: Text(familyTypes[index ~/ 2]),
      ),
      body: ListView.builder(
        itemCount: chosenFamilyPlantList.length,
        itemBuilder: (context, i){
          return buildPlantListTile(context, chosenFamilyPlantList[i]);
        },
      )
    );
  }

  Widget buildPlantListTile(BuildContext context, Plant plant){
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('${plant.slovakFirstName} ${plant.slovakLastName}', style: _biggerFont,),
        Image(
          image: AssetImage('assets/images/${plant.path}.png'),
          fit: BoxFit.fitWidth,
        ),
      ],
    );
  }

  Widget buildFamilyListTileWidget(BuildContext context, int index){
    Color? listTileColor = themeColor.themeColorBG; 
    if(index % 4 == 0){
      listTileColor = Colors.grey[200];
    }
    if(index.isOdd){
      return const Divider(thickness: 1, color: Colors.grey, height: 5,);
    }
    return ListTile(
      title: Center(child: Text(familyTypes[index ~/ 2], style: _biggerFont,)),
      tileColor: listTileColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      onTap: (){
        List<Plant> chosenFamilyPreparedList = [];
        plants.forEach((plant) => {
          if(plant.family == familyTypes[index ~/ 2]){
            chosenFamilyPreparedList.insert(0, plant)
          }
        });
        chosenFamilyPreparedList.sort(((a, b) {return '${a.slovakFirstName} ${a.slovakLastName}'.compareTo('${b.slovakFirstName} ${b.slovakLastName}');}));
        Navigator.push(context, 
          MaterialPageRoute(builder: (context) => PlantTile(chosenFamilyPlantList: chosenFamilyPreparedList,)
          )
        );
        setState((){});
      },
    );
  }
}

class PlantTile extends StatefulWidget {
  const PlantTile({Key? key, required this.chosenFamilyPlantList, this.index = 0}) : super(key: key);
  final int index;
  final List<Plant> chosenFamilyPlantList;

  @override
  State<PlantTile> createState() => _PlantTileState();
}
class _PlantTileState extends State<PlantTile>{
  late int index;
  late Widget floatingActionButton1;
  late Widget floatingActionButton2;
  

  @override
  void initState() {
    index = widget.index;
    initFloatingButtons();
    super.initState();
  }

  void initFloatingButtons(){
    if(index != 0){
      floatingActionButton1 = Positioned(
        bottom: 50,
        left: 30,
        child: FloatingActionButton(
          heroTag: 'btn1',
          onPressed: (){
            previousPlant();
          },
          backgroundColor: themeColor.themeColorMain,
          child: const Icon(Icons.arrow_circle_left_outlined),
        ),
      );
    } else {
      floatingActionButton1 = Positioned(
        bottom: 50,
        left: 30,
        child: Text('', style: TextStyle(color: themeColor.themeColorBG))
      );
    }

    if(index != widget.chosenFamilyPlantList.length-1){
      floatingActionButton2 = Positioned(
        bottom: 50,
        right: 30,
        child: FloatingActionButton(
          heroTag: 'btn2',
          onPressed: (){
            nextPlant();
          },
          backgroundColor: themeColor.themeColorMain,
          child: const Icon(Icons.arrow_circle_right_outlined),
        ),
      );
    } else {
      floatingActionButton2 = Positioned(
        bottom: 50,
        right: 30,
        child: Text('', style: TextStyle(color: themeColor.themeColorBG))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String? swipeDirection;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor.themeColorMain,
        title: Text(widget.chosenFamilyPlantList[index].family, style: const TextStyle(fontSize: 20, color: Colors.white),),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          if(details.delta.dx < -10){
            swipeDirection = 'left';
          } else if ( details.delta.dx > 10){
            swipeDirection = 'right';
          }
        },
        onPanEnd: (details){
          if (swipeDirection == null) {
          return;
          }
          if (swipeDirection == 'left') {
            nextPlant();
          }
          if (swipeDirection == 'right') {
            previousPlant();
          }
        },
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 30,
              child: Text(
                '${widget.chosenFamilyPlantList[index].slovakFirstName} ${widget.chosenFamilyPlantList[index].slovakLastName}'.toUpperCase(), 
                style: const TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
            Image(
              image: AssetImage('assets/images/${widget.chosenFamilyPlantList[index].path}.png'),
              fit: BoxFit.fitWidth,
            ),
            Positioned(
              top: 70,
              child: GestureDetector(
                onTap: (){
                  if(widget.chosenFamilyPlantList[index].wikipediaLink != 'None'){
                    launchUrl(Uri.parse(widget.chosenFamilyPlantList[index].wikipediaLink));
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          alignment: Alignment.center,
                          title: Text(
                            'Slovenská wikipedia sa nenašla',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30, color:Colors.red, ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    );
                  }
                },
                child: Row(
                  children: const [
                    Text(
                      'wikipedia',
                      style: TextStyle(fontSize: 30, color: Colors.blue, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, decoration: TextDecoration.underline),
                      textAlign: TextAlign.center,
                    ),
                    Icon(Icons.link, color:Colors.blue),
                  ],
                )
              ),
            ),
            floatingActionButton1,
            floatingActionButton2,
          ],
        ),
      )
    );
  }
  

  void nextPlant(){
    if(index+1 >= widget.chosenFamilyPlantList.length){
    } else {
      index++;
    }
    initFloatingButtons();
    setState(() {});
  }
  void previousPlant(){
    if(index-1 < 0){
    } else {
      index--;
    }
    initFloatingButtons();
    setState(() {});
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage ({Key? key}) : super(key: key);

  @override
  State<SettingsPage > createState() => _SettingsState();
}
class _SettingsState extends State<SettingsPage > {
  int _changeColorRadioValue = 0;
  TextStyle customTextStyle = const TextStyle(fontWeight: FontWeight.w500, fontSize: 30, );
  Color activeTrackColorCustom = Color.fromARGB(255, themeColor.themeColorMain.red, themeColor.themeColorMain.green, themeColor.themeColorMain.blue);
  TextEditingController codeController = TextEditingController();

  
  @override
  void initState(){
    if(themeColor.themeColorMain == Colors.red){
      _changeColorRadioValue = 1;
    } else if(themeColor.themeColorMain == Colors.blue){
      _changeColorRadioValue = 2;
    } else if(themeColor.themeColorMain == Colors.green){
      _changeColorRadioValue = 3;
    }
    if(_changeColorRadioValue == 1){
      activeTrackColorCustom = Color.fromARGB(255, 250, 153, 147);
    } else if(_changeColorRadioValue == 2){
      activeTrackColorCustom = Color.fromARGB(255, 106, 183, 245);
    } else if(_changeColorRadioValue == 3){
      activeTrackColorCustom = Color.fromARGB(255, 95, 220, 99);
    }
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if(_changeColorRadioValue == 1){
      activeTrackColorCustom = Color.fromARGB(255, 250, 153, 147);
    } else if(_changeColorRadioValue == 2){
      activeTrackColorCustom = Color.fromARGB(255, 106, 183, 245);
    } else if(_changeColorRadioValue == 3){
      activeTrackColorCustom = Color.fromARGB(255, 95, 220, 99);
    }
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor.themeColorMain,
        title: const Text('Nastavenia'),
      ),
      backgroundColor: themeColor.themeColorBG,
      body: ListView(
        children: [
          ExpansionTile(
            title: Center(child: Text('Zmeniť farby aplikácie', style: customTextStyle,)),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    color: Colors.red,
                  ),
                  Radio(
                    value: 1,
                    groupValue: _changeColorRadioValue,
                    onChanged: (value) async {
                      setState(() {
                        _changeColorRadioValue = 1;
                        themeColor.themeColorMain = changeAppBarColor(_changeColorRadioValue);                
                      });
                      setState(() { });
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setInt('themeColorMain', _changeColorRadioValue);
                    },
                  ),
                  Container(
                    width: 20,
                    height: 10,
                    color: themeColor.themeColorBG,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    color: Colors.blue,
                  ),
                  Radio(
                    value: 2,
                    groupValue: _changeColorRadioValue,
                    onChanged: (value) async {
                      setState(() {
                        _changeColorRadioValue = 2;
                        themeColor.themeColorMain = changeAppBarColor(_changeColorRadioValue); 

                      });
                      setState(() { });
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setInt('themeColorMain', _changeColorRadioValue);
                    },
                  ),
                  Container(
                    width: 20,
                    height: 10,
                    color: themeColor.themeColorBG,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    color: Colors.green,
                  ),
                  
                  Radio(
                    value: 3,
                    groupValue: _changeColorRadioValue,
                    onChanged: (value) async {
                      setState(() {
                        _changeColorRadioValue = 3;
                        themeColor.themeColorMain = changeAppBarColor(_changeColorRadioValue); 
                      });
                      setState(() { });
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setInt('themeColorMain', _changeColorRadioValue);
                    },
                  ),
                  Container(
                    width: 20,
                    height: 10,
                    color: themeColor.themeColorBG,
                  ),
                ],
              )
            ],
          ),
          ListTile(
            title: Center(child: Text('Povoliť rastliny', style: customTextStyle,)),
            trailing: IconButton(
              icon: const Icon(Icons.keyboard_arrow_right_rounded),
              onPressed: (){
                Navigator.of(context).pushNamed('plantEnablingScreen');
              },
            ),
          ),
          ListTile(
            title: Center(child: Text('História hier', style: customTextStyle,)),
            trailing: IconButton(
              icon: const Icon(Icons.keyboard_arrow_right_rounded),
              onPressed: (){
                Navigator.of(context).pushNamed('gameHistoryScreen');
              },
            ),
          ),
          ListTile(
            title: Center(child:Text('Hádať aj čeľaď', style: customTextStyle)),
            trailing: Switch(
              value: guessFamily,
              onChanged: (value){
                setState((){
                  guessFamily = value;
                });
              },
              activeTrackColor: activeTrackColorCustom,
              activeColor: themeColor.themeColorMain,
            ),
          ),
          // Divider(color: themeColor.themeColorBG, thickness:1),
          // Divider(color: Colors.black, thickness:2),
          // ListTile(
          //   title: TextField(
          //     maxLength: 25,
          //     controller: codeController,
          //     decoration: const InputDecoration(
          //       border: OutlineInputBorder(),
          //       hintText: 'Kód:',
          //     ),
          //   ),
          //   trailing: IconButton(
          //     icon: Icon(Icons.open_in_new_sharp),
          //     onPressed: (){
          //       loadingCodes.forEach((key, value) {
          //         if(codeController.text == key){
          //           confirmationDynamic(
          //             context, 
          //             () { 
          //               Navigator.of(context).pop();
          //               value.forEach((element) { 
          //                 plants[element].enabled = true;
          //               });
          //             }, 
          //             () { 
          //               Navigator.of(context).pop();
          //             },
          //             subtitle: Text('Chceš zmeniť všetky povolenia rastlín podľa kódu ${codeController.text}', style: TextStyle(color:themeColor.textColorMain)),
          //             title: Text('Si si istý?', style: TextStyle(color:themeColor.textColorMain)),
          //           );
          //         } else {
          //           showDialog(context: context, 
          //             builder: (context){
          //               return AlertDialog(
          //                 alignment: Alignment.center,
          //                 backgroundColor: Colors.red,
          //                 title: Column(
          //                   children: [
          //                     Text("Nenašiel sa kód s názvom", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
          //                     Divider(color: Colors.red, thickness:5),
          //                     Text('" ${codeController.text} "', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic,),),
          //                   ],
          //                 ),
          //               );
          //             }
          //           );
          //         }
          //       });
          //     },
          //   ),
          // ),
          // Divider(color: Colors.black, thickness:2),
        ],
      )
    );
  }
}

class MySearchDelegate extends SearchDelegate{
  MySearchDelegate({required this.searchResults});
  List<String> searchResults;
  bool buildedResult = false;

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: ()=> close(context, null),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context){
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if(query.isEmpty){
            close(context, null);
          } else {
            query ='';
          }
          if(buildedResult){
            Navigator.of(context).pop();
          }
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context){
    buildedResult = true;
    List<Plant> listToInsert = [];
    List<String> unDiacriticedFamilyTypes = [];
    List<String> unDiacriticedPlants = [];
    plants.forEach((element) {unDiacriticedPlants.insert(0, removeDiacritics('${element.slovakFirstName}${element.slovakLastName}'));});
    familyTypes.forEach((element) {unDiacriticedFamilyTypes.insert(0, removeDiacritics(element));});
    if(unDiacriticedFamilyTypes.contains(removeDiacritics(query.replaceAll(' ', '')))){
      plants.forEach((element){
        if(removeDiacritics(element.family) == removeDiacritics(query.replaceAll(' ', ''))){
          listToInsert.insert(0, element);
        }
      });
      return PlantTile(chosenFamilyPlantList: listToInsert);
    } else if (unDiacriticedPlants.contains(removeDiacritics(query.replaceAll(' ', '')))){
      Plant chosenPlant = findInputtedFamily(removeDiacritics(query.replaceAll(' ', '')));
      
      plants.forEach((element){
        if(element.family == chosenPlant.family){
          listToInsert.insert(listToInsert.length, element);
        }
      });

      return PlantTile(chosenFamilyPlantList: listToInsert, index: listToInsert.indexOf(chosenPlant),);
    } else {
      return Center( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Pre hľadaný výraz', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 30)),
            Text( '"$query"', style: const TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.w600, color: Colors.red, fontSize: 30)),
            const Text(' sa nič nenašlo', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 30))
          ],
        )
      );
    }
  }

  Plant findInputtedFamily(input){
    late Plant returnFamily;
    plants.forEach((element){
      if(removeDiacritics('${element.slovakFirstName}${element.slovakLastName}') == input){
        returnFamily = element;
      }
    });
    return returnFamily;
  }

  @override
  Widget buildSuggestions(BuildContext context){
    List<String> suggestions = searchResults.where((searchResult){
      final result = removeDiacritics(searchResult);
      final input = removeDiacritics(query.replaceAll(' ', ''));

      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index){
        final suggestion = suggestions[index];

        return ListTile(
          title: Text(suggestion),
          onTap: (){
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }
}

class PlantEnablingPage extends StatefulWidget {
  const PlantEnablingPage({Key? key}) : super(key: key);

  @override
  State<PlantEnablingPage> createState() => _PlantEnablingPageState();
}
class _PlantEnablingPageState extends State<PlantEnablingPage> {
  bool appBarCheckBoxValue = plants.every((element) => element.enabled == true);
  TextStyle customTextStyle = const TextStyle(fontWeight: FontWeight.w500, fontSize: 30);
  TextStyle customTextStyled = const TextStyle(fontWeight: FontWeight.w400, fontSize: 20);

  @override
  void setState(VoidCallback fn) {
    appBarCheckBoxValue = plants.every((element) => element.enabled == true);
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: themeColor.themeColorBG,
      appBar: AppBar(
        backgroundColor: themeColor.themeColorMain,
        title: const Text(
          'Použité rastliny',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        actions: [
          Checkbox(
            activeColor: Colors.black,
            
            value: appBarCheckBoxValue, 
            onChanged: (value){
              plants.forEach((element) {element.enabled = (value ?? false);});
              setState(() { });
            }
          ),
        ],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: familyTypes.length,
        itemBuilder: (context, index){
          final List<Plant> indexFamilyList = [];
          plants.forEach((element) {
            if(element.family == familyTypes[index]){
              indexFamilyList.insert(indexFamilyList.length, element);
            }
          });
          bool allEnabled = indexFamilyList.every((element) => element.enabled
          );
          return ExpansionTile(
            leading: Checkbox(
              value: allEnabled,
              onChanged: (value){
                if(value == true){
                  indexFamilyList.forEach((element) {
                    element.enabled = true;
                    element.setToPreferences();
                  });
                } else if(value == false){
                  indexFamilyList.forEach((element) {
                    element.enabled = false;
                    element.setToPreferences();
                  });
                }
                
                setState((){});
              },
            ),
            title: Text(familyTypes[index], style: customTextStyle),
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: indexFamilyList.length,
                itemBuilder: (context, index){
                  return ListTile(
                    leading: Container(width: 30, height: 10, color: themeColor.themeColorBG,),
                    title: Text(
                      '${indexFamilyList[index].slovakFirstName} ${indexFamilyList[index].slovakLastName}', 
                      style: customTextStyled,
                    ),
                    trailing: Checkbox(
                      value: indexFamilyList[index].enabled,
                      onChanged: (value){
                        if(value == true){
                          indexFamilyList[index].enabled = true;
                        } else if (value == false){
                          indexFamilyList[index].enabled = false;
                        }
                        indexFamilyList[index].setToPreferences();
                        setState(() {});
                      },
                    )
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class WrongAnswersPage extends StatefulWidget {
  WrongAnswersPage({Key? key, required this.wrongAnswersList}): super(key: key);
  final List<int> wrongAnswersList;

  @override
  State<WrongAnswersPage> createState() => _WrongAnswersPageState();
}
class _WrongAnswersPageState extends State<WrongAnswersPage> {
  int index = 0;
  late Widget floatingActionButton1;
  late Widget floatingActionButton2;

  
  @override
  void initState() {
    initFloatingButtons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? swipeDirection;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor.themeColorMain,
        title: const Text(
          'Zlé odpovede',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          if(details.delta.dx < -10){
            swipeDirection = 'left';
          } else if ( details.delta.dx > 10){
            swipeDirection = 'right';
          }
        },
        onPanEnd: (details){
          if (swipeDirection == null) {
          return;
          }
          if (swipeDirection == 'left') {
            nextPlant();
          }
          if (swipeDirection == 'right') {
            previousPlant();
          }
        },
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 30,
              child: Text(
                plants[widget.wrongAnswersList[index]].family.toUpperCase(), 
                style: const TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              top: 80,
              child: Text(
                '${plants[widget.wrongAnswersList[index]].slovakFirstName} ${plants[widget.wrongAnswersList[index]].slovakLastName}'.toUpperCase(), 
                style: const TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
            Divider(color: themeColor.themeColorBG, thickness: 10,),
            Image(
              image: AssetImage('assets/images/${plants[widget.wrongAnswersList[index]].path}.png'),
              fit: BoxFit.fitWidth,
            ),
            
            Positioned(
              top: 120,
              child: GestureDetector(
                onTap: (){
                  if(plants[widget.wrongAnswersList[index]].wikipediaLink != 'None'){
                    launchUrl(Uri.parse(plants[widget.wrongAnswersList[index]].wikipediaLink));
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          alignment: Alignment.center,
                          title: Text(
                            'Slovenská wikipedia sa nenašla',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30, color:Colors.red, ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    );
                  }
                },
                child: Row(
                  children: const [
                    Text(
                      'wikipedia',
                      style: TextStyle(fontSize: 30, color: Colors.blue, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, decoration: TextDecoration.underline),
                      textAlign: TextAlign.center,
                    ),
                    Icon(Icons.link, color:Colors.blue),
                  ],
                )
              ),
            ),
            floatingActionButton1,
            floatingActionButton2,
          ],
        ),
      )
    );
  }
  void initFloatingButtons(){
    if(index != 0){
      floatingActionButton1 = Positioned(
        bottom: 50,
        left: 30,
        child: FloatingActionButton(
          heroTag: 'btn1',
          onPressed: (){
            previousPlant();
          },
          backgroundColor: themeColor.themeColorMain,
          child: const Icon(Icons.arrow_circle_left_outlined),
        ),
      );
    } else {
      floatingActionButton1 = Positioned(
        bottom: 50,
        left: 30,
        child: Text('', style: TextStyle(color: themeColor.themeColorBG))
      );
    }

    if(index != widget.wrongAnswersList.length-1){
      floatingActionButton2 = Positioned(
        bottom: 50,
        right: 30,
        child: FloatingActionButton(
          heroTag: 'btn2',
          onPressed: (){
            nextPlant();
          },
          backgroundColor: themeColor.themeColorMain,
          child: const Icon(Icons.arrow_circle_right_outlined),
        ),
      );
    } else {
      floatingActionButton2 = Positioned(
        bottom: 50,
        right: 30,
        child: Text('', style: TextStyle(color: themeColor.themeColorBG))
      );
    }
  }

  void nextPlant(){
    if(index+1 >= widget.wrongAnswersList.length){
    } else {
      index++;
    }
    initFloatingButtons();
    setState(() {});
  }
  void previousPlant(){
    if(index-1 < 0){
    } else {
      index--;
    }
    initFloatingButtons();
    setState(() {});
  }

}

class GameHistoryPage extends StatefulWidget {
  const GameHistoryPage({Key? key}) : super(key: key);

  @override
  State<GameHistoryPage> createState() => _GameHistoryPageState();
}
class _GameHistoryPageState extends State<GameHistoryPage> {
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor.themeColorBG,
      appBar: AppBar(
        backgroundColor: themeColor.themeColorMain,
        title: const Text(
          'História hier',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<List<GameScore>>(
          future: DatabaseHelper.instance.getGameHistory(),
          builder: (BuildContext context, AsyncSnapshot<List<GameScore>> snapshot){
            if(!snapshot.hasData){
              return const Center(child: Text('loading'),);
            }
            return snapshot.data!.isEmpty
            ? const Center(child: Text('Prázdna história hier', style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.w600, fontStyle: FontStyle.normal),))
            : ListView(
              children: snapshot.data!.map((gameScore){
                return Center(
                  child: ListTile(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => WrongAnswersPage(wrongAnswersList: changeFromStringToIntList(gameScore.wrongAnswersList),)   
                        )
                      );
                    },
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:[
                                Text(gameScore.date, style: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500)),
                                Text(gameScore.time, style: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500)),
                              ]
                            ),
                            Text(gameScore.stopWatch, style: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500)),
                          ]
                        ),
                        Container(color: themeColor.themeColorBG, height:20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Icon(Icons.done, color: Color.fromARGB(255, 1, 107, 7),size: 20,),
                                Text(
                                  '${gameScore.correct}',
                                  style: const TextStyle(color: Color.fromARGB(255, 1, 107, 7), fontSize: 20),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                 Icon(Icons.close, color: Colors.red[800], size: 20,),
                                Text(
                                  '${gameScore.wrong}',
                                  style: TextStyle(color: Colors.red[800], fontSize: 20),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.lightbulb, color: Colors.yellow[700],size: 20,),
                                Text(
                                  '${gameScore.hints}',
                                  style: TextStyle(color: Colors.yellow[700], fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(color: themeColor.themeColorBG, height:5),
                        Container(height: 3, color: Colors.grey,),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = path_dart.join(documentsDirectory.path, 'gameHistory.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE gameHistory(
        correct INTEGER,
        wrong INTEGER,
        hints INTEGER,
        time TEXT,
        date TEXT,
        stopWatch TEXT,
        wrongAnswersList TEXT
      )
    ''');
  }

  Future<List<GameScore>> getGameHistory() async {
    Database db = await instance.database;
    var gameHistoryVar = await db.query('gameHistory');
    List<GameScore> gameHistory = gameHistoryVar.isNotEmpty
     ? gameHistoryVar.map((e)=>GameScore.fromMap(e)).toList()
     : [];
    return gameHistory.reversed.toList();
  }

  Future<int> addGameScore(GameScore gameScore)async{
    Database db = await instance.database;
    return await db.insert('gameHistory', gameScore.toMap());
  }
}

