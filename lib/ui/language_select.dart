import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:thefirstone/resources/language_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSelect extends StatelessWidget {
  const LanguageSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 15.0),
              child: Text(
                AppLocalizations.of(context)!.languageWord,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: Provider.of<LanguageModel>(context, listen: false)
                    .locales
                    .map((e) => InkWell(
                          onTap: () {
                            Provider.of<LanguageModel>(context, listen: false)
                                .setLocale = e["locale"];
                            Navigator.of(context).pop();
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                child: Text(
                                  e["lang"],
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
