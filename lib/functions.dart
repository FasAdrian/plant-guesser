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
    'b??bovit??','lipnicovit??','iskern??kovit??','ru??ovit??','bukovit??','??ajovn??kovit??','??aliovit??','konopovit??','kapustovit??','vstava??ovit??','hluchavkovit??','fialkovit??',
    'lieskovit??','brezovit??','klin??ekovit??','mrkvovit??','leknovit??','lipovit??','astrovit??',"amarylkovit??","p??h??avovit??","mrl??kovit??","stavikrvovit??","??u??kovit??",'makovit??','magn??liovit??',
    'ginkovit??','borovicovit??','cyprusovit??','tisovit??','??ronovit??','arekovit??','kosatcovit??',
  ];
  list.sort(((a, b) {return a.compareTo(b);}));
  return list;
}

Future<bool> confirmationBool(BuildContext context,  void Function() positiveAnswerFun, void Function() negativeAnswerFun ,{Widget title = const Text('Si si ist???'), Widget subtitle = const Text('Chce?? od??s??'), String positiveAnswer = '??no', String negativeAnswer = 'Nie',})async{
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

Future<dynamic> confirmationDynamic(BuildContext context,  void Function() positiveAnswerFun, void Function() negativeAnswerFun ,{Widget title = const Text('Si si ist???'), Widget subtitle = const Text('Chce?? od??s??'), String positiveAnswer = '??no', String negativeAnswer = 'Nie',})async{
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
    returnList.add(Plant('b??bovit??', "ag??t", "biely", "agat_biely", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ag??t_biely'));
    returnList.add(Plant('lipnicovit??', "bambus", "", "bambus", wikipediaLink: 'https://sk.wikipedia.org/wiki/Bambusovat??'));
    returnList.add(Plant('iskern??kovit??', "blysk????", "jarn??", "blyskac_jarny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Blysk????_jarn??'));
    returnList.add(Plant('ru??ovit??', "brosky??a", "oby??ajn??", "broskyna_obycajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Brosky??a_oby??ajn??'));
    returnList.add(Plant('bukovit??', "buk", "lesn??", "buk_lesny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Buk_lesn??'));
    returnList.add(Plant('??ajovn??kovit??', "??ajovn??k", "????nsky", "cajovnik_cinsky", wikipediaLink: 'https://sk.wikipedia.org/wiki/??ajovn??k_????nsky'));
    returnList.add(Plant('ru??ovit??', "??ere????a", "vt????ia", "ceresna_vtacia", wikipediaLink: 'https://sk.wikipedia.org/wiki/??ere????a_vt????ia'));
    returnList.add(Plant('??aliovit??', "cesnak", "cibu??ov??", "cesnak_cibulovy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Cesnak_cibu??ov??'));
    returnList.add(Plant('??aliovit??', "cesnak", "kuchynsk??", "cesnak_kuchynsky", wikipediaLink: 'https://sk.wikipedia.org/wiki/Cesnak_kuchynsk??'));
    returnList.add(Plant('??aliovit??', "cesnak", "pa??itkov??", "cesnak_pazitkovy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Cesnak_(rod)'));
    returnList.add(Plant('konopovit??', "chme??", "oby??ajn??", "chmel_obycajny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Chme??_oby??ajn??'));
    returnList.add(Plant('kapustovit??', "chren", "dedinsk??", "chren_dedinsky", wikipediaLink: 'https://sk.wikipedia.org/wiki/Chren_dedinsk??'));
    returnList.add(Plant('vstava??ovit??', "??rievi??n??k", "papu??kovit??", "crievicnik_papuckovity", wikipediaLink: 'None'));
    returnList.add(Plant('b??bovit??', "??atelina", "l????na", "datelina_lucna", wikipediaLink: 'https://sk.wikipedia.org/wiki/??atelina_l????na'));
    returnList.add(Plant('bukovit??', "dub", "letn??", "dub_letny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Dub_letn??'));
    returnList.add(Plant('hluchavkovit??', "d????ka", "materina", "duska_materina", wikipediaLink: 'https://sk.wikipedia.org/wiki/D????ka_materina'));
    returnList.add(Plant('b??bovit??', "fazu??a", "z??hradn??", "fazula_zahradna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Fazu??a_oby??ajn??'));
    returnList.add(Plant('fialkovit??', "fialka", "vo??av??", "fialka_vonava", wikipediaLink: 'https://sk.wikipedia.org/wiki/Fialka_vo??av??'));
    returnList.add(Plant('bukovit??', "ga??tan", "jedl??", "gastan_jedly", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ga??tan_jedl??'));
    returnList.add(Plant('ru??ovit??', "hloh", "jednosemenn??", "hloh_jednosemenny", wikipediaLink: 'None'));
    returnList.add(Plant('hluchavkovit??', "hluchavka", "??kvrnit??", "hluchavka_skvrnita", wikipediaLink: 'https://sk.wikipedia.org/wiki/Hluchavka'));
    returnList.add(Plant('kapustovit??', "hor??ica", "biela", "horcica_biela", wikipediaLink: 'https://sk.wikipedia.org/wiki/Hor??ica_biela'));
    returnList.add(Plant('lieskovit??', "hrab", "oby??ajn??", "hrab_obycajny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Hrab_oby??ajn??'));
    returnList.add(Plant('b??bovit??', "hrach", "siaty", "hrach_siaty", wikipediaLink: 'https://sk.wikipedia.org/wiki/Hrach_siaty'));
    returnList.add(Plant('ru??ovit??', "hru??ka", "oby??ajn??", "hruska_obycajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Hru??ka_oby??ajn??'));
    returnList.add(Plant('??aliovit??', "hyacint", "v??chodn??", "hyacint_vychodny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Hyacint_v??chodn??'));
    returnList.add(Plant('iskern??kovit??', "iskern??k", "prudk??", "iskernik_prudky", wikipediaLink: 'https://sk.wikipedia.org/wiki/Iskern??k_prudk??'));
    returnList.add(Plant('ru??ovit??', "jablo??", "dom??ca", "jablon_domaca", wikipediaLink: 'https://sk.wikipedia.org/wiki/Jablo??_dom??ca'));
    returnList.add(Plant('lipnicovit??', "ja??me??", "siaty", "jacmen_siaty", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ja??me??_siaty'));
    returnList.add(Plant('ru??ovit??', "jahoda", "oby??ajn??", "jahoda_obycajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Jahoda_oby??ajn??'));
    returnList.add(Plant('brezovit??', "jel??a", "lepkav??", "jelsa_lepkava", wikipediaLink: 'https://sk.wikipedia.org/wiki/Jel??a_lepkav??'));
    returnList.add(Plant('kapustovit??', "kapsi??ka", "pastierska", "kapsicka_pastierska", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kapsi??ka_pastierska'));
    returnList.add(Plant('kapustovit??', "kapusta", "hl??vkov??", "kapusta_hlavkova", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kapusta_oby??ajn??_hl??vkov??'));
    returnList.add(Plant('klin??ekovit??', "klin??ek", "", "klincek", wikipediaLink: 'https://sk.wikipedia.org/wiki/Klin??ekovec_vo??av??'));
    returnList.add(Plant('konopovit??', "konopa", "siata", "konope_siata", wikipediaLink: 'https://sk.wikipedia.org/wiki/Konopa_siata'));
    returnList.add(Plant('??aliovit??', "konvalinka", "vo??av??", "konvalinka_vonava", wikipediaLink: 'https://sk.wikipedia.org/wiki/Konvalinka_vo??av??'));
    returnList.add(Plant('mrkvovit??', "k??por", "vo??av??", "kopor_vonavy", wikipediaLink: 'https://sk.wikipedia.org/wiki/K??por_vo??av??'));
    returnList.add(Plant('lipnicovit??', "kukurica", "siata", "kukurica_siata", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kukurica_siata'));
    returnList.add(Plant('??aliovit??', "??alia", "biela", "lalia_biela", wikipediaLink: 'https://sk.wikipedia.org/wiki/??alia_biela'));
    returnList.add(Plant('makovit??', "lastovi??n??k", "v????????", "lastovicnik_vacsi", wikipediaLink: 'https://sk.wikipedia.org/wiki/Lastovi??n??k_v????????'));
    returnList.add(Plant('leknovit??', "lekno", "biele", "lekno_biele", wikipediaLink: 'https://sk.wikipedia.org/wiki/Lekno_biele'));
    returnList.add(Plant('lieskovit??', "lieska", "oby??ajna", "lieska_obycajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Lieska_oby??ajn??'));
    returnList.add(Plant('lipovit??', "lipa", "malolist??", "lipa_malolista", wikipediaLink: 'https://sk.wikipedia.org/wiki/Lipa_malolist??'));
    returnList.add(Plant('lipovit??', "lipa", "ve??kolist??", "lipa_velkolista", wikipediaLink: 'https://sk.wikipedia.org/wiki/Lipa_ve??kolist??'));
    returnList.add(Plant('lipnicovit??', "lipnica", "l????na", "lipnica_lucna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Lipnica_(rod_rastl??n)'));
    returnList.add(Plant('astrovit??', "lop??ch", "v????????", "lopuch_vacsi", wikipediaLink: 'None'));
    returnList.add(Plant('b??bovit??', "lucerna", "siata", "lucerna_siata", wikipediaLink: 'https://sk.wikipedia.org/wiki/Lucerna_siata'));
    returnList.add(Plant("??u??kovit??", "??u??kovec", "zlomocn??", "lulkovec_zlomocny", wikipediaLink: 'https://sk.wikipedia.org/wiki/??u??kovec_zlomocn??'));
    returnList.add(Plant("??u??kovit??", "??ulok", "zemiakov??", "lulok_zemiakovy", wikipediaLink: 'https://sk.wikipedia.org/wiki/??u??ok_zemiakov??'));
    returnList.add(Plant("magn??liovit??", "magn??lia", "ve??kokvet??", "magnolia_velkokveta", wikipediaLink: 'https://sk.wikipedia.org/wiki/Magn??lia'));
    returnList.add(Plant("makovit??", "mak", "vl????", "mak_vlci", wikipediaLink: 'https://sk.wikipedia.org/wiki/Mak_vl????'));
    returnList.add(Plant("astrovit??", "margar??ta", "biela", "margareta_biela", wikipediaLink: 'https://sk.wikipedia.org/wiki/Margar??ta_(rod)'));
    returnList.add(Plant("ru??ovit??", "marhu??a", "oby??ajn??", "marhula_obycajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Marhu??a_oby??ajn??'));
    returnList.add(Plant("hluchavkovit??", "m??ta", "prieporn??", "mata_prieporna", wikipediaLink: 'https://sk.wikipedia.org/wiki/M??ta_pieporn??'));
    returnList.add(Plant("mrkvovit??", "mrkva", "oby??ajn??", "mrkva_obycajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Mrkva_oby??ajn??'));
    returnList.add(Plant("amarylkovit??", "narcis", "??lt??", "narcis_zlty", wikipediaLink: 'https://sk.wikipedia.org/wiki/Narcis_(rod)'));
    returnList.add(Plant("ru??ovit??", "n??tr??n??k", "hus??", "natrznik_husi", wikipediaLink: 'None'));
    returnList.add(Plant("astrovit??", "necht??k", "lek??rsky", "nechtik_lekarsky", wikipediaLink: 'https://sk.wikipedia.org/wiki/Necht??k_lek??rsky'));
    returnList.add(Plant("ru??ovit??", "ostru??ina", "??ernicov??", "ostruzina_cernicova", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ostru??ina_??ernicov??'));
    returnList.add(Plant("ru??ovit??", "ostru??ina", "malinov??", "ostruzina_malinova", wikipediaLink: 'https://sk.wikipedia.org/wiki/Malina_(plod)'));
    returnList.add(Plant("lipnicovit??", "ovos", "siaty", "ovos_siaty", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ovos_siaty'));
    returnList.add(Plant("bukovit??", "paga??tan", "konsk??", "pagastan_konsky", wikipediaLink: 'https://sk.wikipedia.org/wiki/Paga??tan_konsk??'));
    returnList.add(Plant("??u??kovit??", "paprika", "ro??n??", "paprika_rocna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Paprika_ro??n??'));
    returnList.add(Plant("astrovit??", "pestrec", "mari??nsky", "pestrec_mariansky", wikipediaLink: 'https://sk.wikipedia.org/wiki/Pestrec_mari??nsky'));
    returnList.add(Plant("mrkvovit??", "petr??len", "z??hradn??", "petrzlen_zahradny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Petr??len_z??hradn??'));
    returnList.add(Plant("b??bovit??", "podzemnica", "olejn??", "podzemnica_olejna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Podzemnica_olejn??'));
    returnList.add(Plant("p??h??avovit??", "p??h??ava", "dvojdom??", "prhlava_dvojdoma", wikipediaLink: 'https://sk.wikipedia.org/wiki/P??h??ava_dvojdom??'));
    returnList.add(Plant("lipnicovit??", "p??enica", "letn??", "psenica_letna", wikipediaLink: 'https://sk.wikipedia.org/wiki/P??enica'));
    returnList.add(Plant("astrovit??", "p??pava", "lek??rska", "pupava_lekarska", wikipediaLink: 'https://sk.wikipedia.org/wiki/P??pava_lek??rska'));
    returnList.add(Plant("??u??kovit??", "raj??iak", "jedl??", "rajciak_jedly", wikipediaLink: 'https://sk.wikipedia.org/wiki/Raj??iak_jedl??'));
    returnList.add(Plant("mrkvovit??", "rasca", "l????na", "rasca_lucna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Rasca_l????na'));
    returnList.add(Plant("lipnicovit??", "ra??", "siata", "raz_siata", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ra??_siata'));
    returnList.add(Plant("kapustovit??", "repka", "olejn??", "repka_olejna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kapusta_repkov??_prav??'));
    returnList.add(Plant("lipnicovit??", "rezna??ka", "lalo??nat??", "reznacka_lalocnata", wikipediaLink: 'None'));
    returnList.add(Plant("astrovit??", "ruman??ek", "kamilkov??", "rumancek_kamilkovy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ruman??ek_kamilkov??'));
    returnList.add(Plant("ru??ovit??", "ru??a", "????pova", "ruza_sipova", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ru??a_????pov??'));
    returnList.add(Plant("lipnicovit??", "ry??a", "siata", "ryza_siata", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ry??a_siata'));
    returnList.add(Plant("astrovit??", "??al??t", "siaty", "salat_siaty", wikipediaLink: 'https://sk.wikipedia.org/wiki/??al??t_siaty'));
    returnList.add(Plant("hluchavkovit??", "??alvia", "lek??rska", "salvia_lekarska", wikipediaLink: 'https://sk.wikipedia.org/wiki/??alvia_lek??rska'));
    returnList.add(Plant("ru??ovit??", "slivka", "dom??ca", "slivka_domaca", wikipediaLink: 'https://sk.wikipedia.org/wiki/Slivka_dom??ca'));
    returnList.add(Plant("ru??ovit??", "slivka", "trnkov??", "slivka_trnkova", wikipediaLink: 'https://sk.wikipedia.org/wiki/Slivka_trnkov??'));
    returnList.add(Plant("astrovit??", "slne??nica", "ro??n??", "slnecnica_rocna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Slne??nica_ro??n??'));
    returnList.add(Plant("amarylkovit??", "sne??ienka", "jarn??", "snezienka_jarna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Sne??ienka_jarn??'));
    returnList.add(Plant("mrl??kovit??", "??pen??t", "siaty", "spenat_siaty", wikipediaLink: 'https://sk.wikipedia.org/wiki/??pen??t_siaty'));
    returnList.add(Plant("stavikrvovit??", "??tiav", "l????ny", "stiav_lucny", wikipediaLink: 'https://sk.wikipedia.org/wiki/??tiav_l????ny'));
    returnList.add(Plant("lipnicovit??", "timotejka", "l????na", "timotejka_lucna", wikipediaLink: 'https://cs.wikipedia.org/wiki/Boj??nek'));
    returnList.add(Plant("lipnicovit??", "trs??", "oby??ajn??", "trst_obycajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Trs??_oby??ajn??'));
    returnList.add(Plant("??aliovit??", "tulip??n", "", "tulipan", wikipediaLink: 'https://sk.wikipedia.org/wiki/Tulip??n'));
    returnList.add(Plant("iskern??kovit??", "veternica", "h??jna", "veternica_hajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Veternica_iskern??kovit??'));
    returnList.add(Plant("b??bovit??", "vika", "siata", "vika_siata", wikipediaLink: 'https://sk.wikipedia.org/wiki/Vika_(rod)'));
    returnList.add(Plant("vstava??ovit??", "vstava??", "oby??ajn??", "vstavac_obycajny", wikipediaLink: 'None'));
    returnList.add(Plant("iskern??kovit??", "z??ru??lie", "mo??iarne", "zaruzlie_mociarne", wikipediaLink: 'https://sk.wikipedia.org/wiki/Z??ru??lie_mo??iarne'));
    returnList.add(Plant("mrkvovit??", "zeler", "vo??av??", "zeler_vonavy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Zeler_vo??av??'));
    returnList.add(Plant("ginkovit??", "ginkgo", "dvojlalo??n??", "ginkgo_dvojlalocne", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ginko_dvojlalo??n??'));
    returnList.add(Plant("borovicovit??", "jed??a", "biela", "jedla_biela", wikipediaLink: 'https://sk.wikipedia.org/wiki/Jed??a_biela'));
    returnList.add(Plant("borovicovit??", "smrek", "oby??ajn??", "smrek_obycajny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Smrek_oby??ajn??'));
    returnList.add(Plant("borovicovit??", "smrek", "pich??av??", "smrek_pichlavy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Smrek_pich??av??'));
    returnList.add(Plant("borovicovit??", "duglaska", "tisolist??", "duglaska_tisolista", wikipediaLink: 'https://sk.wikipedia.org/wiki/Duglaska_tisolist??'));
    returnList.add(Plant("borovicovit??", "borovica", "lesn??", "borovica_lesna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Borovica_lesn??'));
    returnList.add(Plant("borovicovit??", "borovica", "??ierna", "borovica_cierna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Borovica_??ierna'));
    returnList.add(Plant("borovicovit??", "borovica", "kosodrevinov??", "borovica_kosodrevinova", wikipediaLink: 'https://sk.wikipedia.org/wiki/Borovica_horsk??'));
    returnList.add(Plant("borovicovit??", "borovica", "limbov??", "borovica_limbova", wikipediaLink: 'https://sk.wikipedia.org/wiki/Borovica_limbov??'));
    returnList.add(Plant("borovicovit??", "borovica", "hladk??", "borovica_hladka", wikipediaLink: 'None'));
    returnList.add(Plant("cyprusovit??", "sekvojovec", "mamut??", "sekvojovec_mamuti", wikipediaLink: 'https://sk.wikipedia.org/wiki/Sekvojovec'));
    returnList.add(Plant("cyprusovit??", "borievka", "oby??ajn??", "borievka_obycajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Borievka_oby??ajn??'));
    returnList.add(Plant("tisovit??", "tis", "oby??ajn??", "tis_obycajny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Tis_oby??ajn??'));
    returnList.add(Plant("cyprusovit??", "tuja", "z??padn??", "tuja_zapadna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Tuja_z??padn??'));
    returnList.add(Plant("borovicovit??", "smrekovec", "opadav??", "smrekovec_opadavy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Smrekovec_opadav??'));
    returnList.add(Plant("??ronovit??", "bre??tan", "pop??nav??", "brectan_popinavy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Bre??tan_pop??nav??'));
    returnList.add(Plant("brezovit??", "breza", "previsnut??", "breza_previsnuta", wikipediaLink: 'https://sk.wikipedia.org/wiki/Breza_previsnut??'));
    returnList.add(Plant("iskern??kovit??", "orl????ek", "oby??ajn??", "orlicek_obycajny", wikipediaLink: 'https://cs.wikipedia.org/wiki/Orl????ek'));
    returnList.add(Plant("iskern??kovit??", "ostr????ka", "po??n??", "ostrozka_polna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Ostr????ka_po??n??'));
    returnList.add(Plant("makovit??", "mak", "siaty", "mak_siaty", wikipediaLink: 'https://sk.wikipedia.org/wiki/Mak_siaty'));
    returnList.add(Plant("leknovit??", "lekno", "modr??", "lekno_modre", wikipediaLink: 'None'));
    returnList.add(Plant("bukovit??", "dub", "zimn??", "dub_zimny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Dub_zimn??'));
    returnList.add(Plant("fialkovit??", "fialka", "trojfarebn??", "fialka_trojfarebna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Fialka_trojfarebn??'));
    returnList.add(Plant("kapustovit??", "kel", "hl??vkov??", "kel_hlavkovy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kapusta_oby??ajn??_kelov??'));
    returnList.add(Plant("kapustovit??", "kel", "ru??i??kov??", "kel_ruzickovy", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kapusta_oby??ajn??_ru??i??kov??'));
    returnList.add(Plant("kapustovit??", "kaler??b", "", "kalerab", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kapusta_oby??ajn??_kaler??bov??'));
    returnList.add(Plant("kapustovit??", "karfiol", "", "karfiol", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kapusta_oby??ajn??_karfiolov??'));
    returnList.add(Plant("kapustovit??", "re??kev", "siata", "redkev_siata", wikipediaLink: 'https://sk.wikipedia.org/wiki/Re??kev_siata'));
    returnList.add(Plant("kapustovit??", "penia??tek", "ro??n??", "peniaztek_rolny", wikipediaLink: 'https://cs.wikipedia.org/wiki/Pen??zek_roln??'));
    returnList.add(Plant("kapustovit??", "??eru??nica", "l????na", "zeruznica_lucna", wikipediaLink: 'None'));
    returnList.add(Plant("ru??ovit??", "??ere????a", "vi????ov??", "ceresna_visnova", wikipediaLink: 'https://sk.wikipedia.org/wiki/??ere????a_vi????ov??'));
    returnList.add(Plant("b??bovit??", "??o??ovica", "jedl??", "sosovica_jedla", wikipediaLink: 'https://sk.wikipedia.org/wiki/??o??ovica_jedl??'));
    returnList.add(Plant("b??bovit??", "s??ja", "oby??ajn??", "soja_obycajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/S??ja'));
    returnList.add(Plant("mrkvovit??", "koriander", "siaty", "koriander_siaty", wikipediaLink: 'https://sk.wikipedia.org/wiki/Koriander_siaty'));
    returnList.add(Plant("mrkvovit??", "fenikel", "oby??ajn??", "fenikel_obycajny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Fenikel_oby??ajn??'));
    returnList.add(Plant("mrkvovit??", "bo????evn??k", "obrovsk??", "bolsevnik_obrovsky", wikipediaLink: 'https://sk.wikipedia.org/wiki/Bo????evn??k_obrovsk??'));
    returnList.add(Plant("mrkvovit??", "kozonoha", "hostcova", "kozonoha_hostcova", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kozonoha_hostcov??'));
    returnList.add(Plant("mrkvovit??", "bolehlav", "??kvrnit??", "bolehelav_skvrnity", wikipediaLink: 'https://sk.wikipedia.org/wiki/Bolehlav_??kvrnit??'));
    returnList.add(Plant("??u??kovit??", "tabak", "virg??nsky", "tabak_virginsky", wikipediaLink: 'https://cs.wikipedia.org/wiki/Tab??k_virginsk??'));
    returnList.add(Plant("??u??kovit??", "durman", "oby??ajn??", "durman_obycajny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Durman_oby??ajn??'));
    returnList.add(Plant("??u??kovit??", "blen", "??ierny", "blen_cierny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Blen_??ierny'));
    returnList.add(Plant("hluchavkovit??", "rozmar??n", "lek??rsky", "rozmarin_lekarsky", wikipediaLink: 'https://sk.wikipedia.org/wiki/Rozmar??n_lek??rsky'));
    returnList.add(Plant("hluchavkovit??", "levandu??a", "??zkolist??", "levandula_uskolista", wikipediaLink: 'https://sk.wikipedia.org/wiki/Levandu??a'));
    returnList.add(Plant("hluchavkovit??", "major??n", "z??hradn??", "majoran_zahradny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Major??n_z??hradn??'));
    returnList.add(Plant("hluchavkovit??", "bazalka", "prav??", "bazalka_prava", wikipediaLink: 'https://sk.wikipedia.org/wiki/Bazalka_prav??'));
    returnList.add(Plant("astrovit??", "bodliak", "oby??ajn??", "bodliak_obycajny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Bodliak'));
    returnList.add(Plant("astrovit??", "rebr????ek", "oby??ajn??", "rebricek_obycajny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Rebr????ek_oby??ajn??'));
    returnList.add(Plant("astrovit??", "sedmokr??ska", "oby??ajn??", "sedmokraska_obycajna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Sedmokr??ska_oby??ajn??'));
    returnList.add(Plant("astrovit??", "astry", "", "astry", wikipediaLink: 'https://sk.wikipedia.org/wiki/Astra_alp??nska'));
    returnList.add(Plant("astrovit??", "aksamietnice", "", "aksamietnice", wikipediaLink: 'https://cs.wikipedia.org/wiki/Aksamitn??k'));
    returnList.add(Plant("astrovit??", "c??nie", "", "cinie", wikipediaLink: 'None'));
    returnList.add(Plant("astrovit??", "georg??ny", "", "georginy", wikipediaLink: 'None'));
    returnList.add(Plant("??aliovit??", "modrica", "strapcovit??", "modrica_strapcovita", wikipediaLink: 'https://sk.wikipedia.org/wiki/Modrica'));
    returnList.add(Plant("??aliovit??", "??alia", "zlatohlav??", "lalia_zlatohlava", wikipediaLink: 'https://sk.wikipedia.org/wiki/??alia_zlatohlav??'));
    returnList.add(Plant("??aliovit??", "kokor??k", "mnohokvet??", "kokorik_mnohokvety", wikipediaLink: 'https://cs.wikipedia.org/wiki/Koko????k_mnohokv??t??'));
    returnList.add(Plant("??aliovit??", "vranovec", "??tvorlist??", "vranovec_stvorlisty", wikipediaLink: 'https://sk.wikipedia.org/wiki/Vranovec_??tvorlist??'));
    returnList.add(Plant("amarylkovit??", "bledu??a", "jarn??", "bledula_jarna", wikipediaLink: 'https://sk.wikipedia.org/wiki/Bledu??a_jarn??'));
    returnList.add(Plant("arekovit??", "dat??ovn??k", "oby??ajn??", "datlovnik_obycajny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Dat??ovn??k_oby??ajn??'));
    returnList.add(Plant("arekovit??", "kokosovn??k", "oby??ajn??", "kokosovnik_obycajny", wikipediaLink: 'https://sk.wikipedia.org/wiki/Kokosovn??k'));
    returnList.add(Plant("kosatcovit??", "me????k", "", "mecik", wikipediaLink: 'https://cs.wikipedia.org/wiki/Me????k'));
    returnList.add(Plant("kosatcovit??", "kosatec", "nemeck??", "kosatec_nemecky", wikipediaLink: 'https://cs.wikipedia.org/wiki/Kosatec'));
    returnList.add(Plant("lipnicovit??", "p??r", "plaziv??", "pyr_plazivy", wikipediaLink: 'https://sk.wikipedia.org/wiki/P??r_plaziv??'));
    returnList.add(Plant("lipnicovit??", "proso", "siate", "proso_siate", wikipediaLink: 'https://sk.wikipedia.org/wiki/Proso_siate'));
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

  var withDia = 'a????bc??d??e??fghi??jkl????mn??o????pqr??s??t??u??vwxy??z??';
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
