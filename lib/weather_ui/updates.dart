import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shape_weather/weather_ui/widgets/controls.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../libs/version.dart';
import '../setting/configuration.dart';

class CheckUpdates extends StatefulWidget {
  const CheckUpdates({super.key});

  @override
  State<CheckUpdates> createState() => _CheckUpdatesState();
}

class _CheckUpdatesState extends State<CheckUpdates> {
  static const String uri =
      "https://api.github.com/repos/57UU/Shape_Weather/releases/latest";
  String? latestVersion;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    bool isNewVersion =
        latestVersion!=null &&
        currentVersion != latestVersion &&
        currentVersion != "$latestVersion.0";
    bool isLoading=!isError && latestVersion==null;
    //isNewVersion=false;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.checkUpdate),
      ),
      body: kIsWeb
          ? Column(
              children: [
                commonCard(
                    context: context,
                    title: AppLocalizations.of(context)!.currentVersion,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "${AppLocalizations.of(context)!.currentVersion} $currentVersion"),
                        Text(AppLocalizations.of(context)!.webIsLatest)
                      ],
                    )),
              ],
            )
          : SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  commonCard(
                      context: context,
                      title: AppLocalizations.of(context)!.currentVersion,
                      child: Text(currentVersion)),
                  commonCard(
                      context: context,
                      title: AppLocalizations.of(context)!.latestVersion,
                      icon: isNewVersion && latestVersion != null
                          ? const Icon(Icons.open_in_new)
                          : Container(),
                      onTap: (c) {
                        if (isNewVersion) {
                          launchUrl(Uri.parse(
                              "https://github.com/57UU/Shape_Weather/releases/latest"));
                        }
                      },
                      child: AnimatedSize(
                        duration: cardSizeAnimationDuration,
                        curve: Curves.easeInOutQuad,
                        child: isError
                            ? Text(AppLocalizations.of(context)!.failedToLoad)
                            : latestVersion == null
                                ? loading()
                                : isNewVersion
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .newVersionAvailable,
                                            textScaler:
                                                const TextScaler.linear(1.1),
                                          ),
                                          Text(
                                              "${AppLocalizations.of(context)!.latestVersion} $latestVersion"),
                                          Text(AppLocalizations.of(context)!
                                              .clickHere2Download),
                                        ],
                                      )
                                    : Text(AppLocalizations.of(context)!
                                        .currentVersionIsUpToDate),
                      )),
                  AboutLatestRelease(_detail,isFailed:isError,title: AppLocalizations.of(context)!.whatsNew,),
                  commonCard(
                      context: context,
                      title: AppLocalizations.of(context)!.allReleases,
                      child: Text(AppLocalizations.of(context)!.click2Check),
                      onTap: (c) {
                        launchUrl(Uri.parse(
                            "https://github.com/57UU/Shape_Weather/releases"));
                      },
                      icon: const Icon(Icons.open_in_new)),
                  
                  ElevatedButton(
                      onPressed: () {
                        fetch();
                      },
                      child: Text(AppLocalizations.of(context)!.checkUpdate))
                ],
              ),
          ),
    );
  }
  dynamic _detail;
  void fetch() async {
    setState(() {
      _detail=null;
      isError = false;
      latestVersion = null;
    });
    try {
      var request = json.decode(await http.read(Uri.parse(uri)));
      setState(() {
        latestVersion = request["tag_name"];
        _detail=request;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        isError = true;
      });
    }
  }
}
class AboutLatestRelease extends NullableCard<dynamic>{
  const AboutLatestRelease(super.parameter,  {super.key, super.isFailed,super.title="What's New"});
  static final DateFormat formatter = DateFormat('y-M-d H:m:s');
  @override
  Widget getIcon(){
    return const Icon(Icons.info_outline);
  }
  @override
  Widget child(BuildContext context, parameter) {
    var whatsNew=parameter["body"];
    String text="$whatsNew\n\n${AppLocalizations.of(context)!.tap2GetMoreInfo}";
    return Text(text);
  }
  @override
  Widget failedChild(BuildContext context) {
    return Text(AppLocalizations.of(context)!.failedToLoad);
  }
  @override
  void onTap(BuildContext context, parameter) {
    var time=DateTime.parse(parameter["created_at"]).toLocal();
    var author=parameter["author"];
    var authorName=author["login"];
    var authorAvatar=author["avatar_url"];
    var name=parameter["name"];
    var nodeId=parameter["node_id"];
    var tag=parameter["tag_name"];
    var branch=parameter["target_commitish"];
    var imageWidget=ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        authorAvatar,
        height: 60,
        //loadingBuilder: (context,widget,event){return loading();},
        errorBuilder: (context,widget,event){return const Text("unable to load avatar");},
      ),
    );
    var text=
        "Author: $authorName\n"
        "Branch: $branch\n"
        "Name: $name\n"
        "Tag: $tag\n"
        "ID: $nodeId\n"
        "Create Time: ${formatter.format(time)}";
    showDialog(context: context, builder: (builder){
      return AlertDialog(
        title: Text(AppLocalizations.of(builder)!.details),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(text)),
            imageWidget
          ],
        ),
        actions: [
          TextButton(onPressed: (){Navigator.of(builder).pop();}, child: const Text("OK"))
        ],
      );
    });
  }

  
}
