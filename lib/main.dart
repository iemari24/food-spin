import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'dart:math';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FoodSpinApp(),
  ));
}

class FoodSpinApp extends StatefulWidget {
  const FoodSpinApp({super.key});
  @override
  State<FoodSpinApp> createState() => _FoodSpinAppState();
}

class _FoodSpinAppState extends State<FoodSpinApp> {
  String lang = 'en';

  final List<Map<String, Map<String, String>>> meals = [
    {
      "en": {
        "name": "🍗 Chicken",
        "recipe": "Marinate chicken breast, airfry at 180°C for 15 min. Flip halfway."
      },
      "tr": {
        "name": "🍗 Tavuk",
        "recipe": "Tavuk göğsünü marine et, 180°C’de 15 dk pişir. Yarıda çevir."
      }
    },
    {
      "en": {
        "name": "🐟 Salmon",
        "recipe": "Season salmon, airfry at 180°C for 10-12 min. Add lemon."
      },
      "tr": {
        "name": "🐟 Somon",
        "recipe": "Somonu baharatla, 180°C’de 10-12 dk pişir. Limon ekle."
      }
    },
    {
      "en": {
        "name": "🥩 Meatballs",
        "recipe": "Mix ground beef, make balls, airfry at 180°C for 12-14 min."
      },
      "tr": {
        "name": "🥩 Köfte",
        "recipe": "Kıymayı yoğur, köfte yap, 180°C’de 12-14 dk pişir."
      }
    },
    {
      "en": {
        "name": "🦃 Turkey",
        "recipe": "Form turkey patties, airfry at 180°C for 12 min. Flip halfway."
      },
      "tr": {
        "name": "🦃 Hindi",
        "recipe": "Hindi köftesi yap, 180°C’de 12 dk pişir. Yarıda çevir."
      }
    },
    {
      "en": {
        "name": "🧀 Halloumi",
        "recipe": "Skewer halloumi and veggies, airfry at 190°C for 8-10 min."
      },
      "tr": {
        "name": "🧀 Hellim",
        "recipe": "Hellim ve sebzeleri şişe diz, 190°C’de 8-10 dk pişir."
      }
    },
    {
      "en": {
        "name": "🥦 Tofu Bowl",
        "recipe": "Toss tofu & broccoli, airfry at 190°C for 10-12 min."
      },
      "tr": {
        "name": "🥦 Tofu Kase",
        "recipe": "Tofu ve brokoliyi baharatla, 190°C’de 10-12 dk pişir."
      }
    },
    {
      "en": {
        "name": "🍗 Wings",
        "recipe": "Coat wings, airfry at 200°C for 20 min. Shake every 7 min."
      },
      "tr": {
        "name": "🍗 Kanat",
        "recipe": "Kanatları baharatla, 200°C’de 20 dk pişir. Ara ara karıştır."
      }
    },
    {
      "en": {
        "name": "🍤 Shrimp",
        "recipe": "Season shrimp, airfry at 200°C for 6-7 min. Add lemon."
      },
      "tr": {
        "name": "🍤 Karides",
        "recipe": "Karidesi baharatla, 200°C’de 6-7 dk pişir. Limon ekle."
      }
    },
  ];
  final selected = StreamController<int>();
  int? lastSelected;
  int? _lastSelectedIndex;
  final player = AudioPlayer();

  Map<String, Map<String, String>> labels = {
    "en": {
      "title": "Food-Spin",
      "spin": "Spin!",
      "today": "Today's meal:",
      "chooseLang": "Choose language:",
      "en": "English",
      "tr": "Turkish"
    },
    "tr": {
      "title": "Yemek Çarkı",
      "spin": "Çevir!",
      "today": "Bugün:",
      "chooseLang": "Dil seç:",
      "en": "İngilizce",
      "tr": "Türkçe"
    }
  };

  @override
  void dispose() {
    selected.close();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWheel = 320;
    double wheelSize = MediaQuery.of(context).size.width * 0.85;
    if (wheelSize > maxWheel) wheelSize = maxWheel;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/background.png', fit: BoxFit.cover),
        Scaffold(
          backgroundColor: Colors.black.withOpacity(0.13),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Dil seçici
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        labels[lang]!["chooseLang"]!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          shadows: [Shadow(color: Colors.black38, blurRadius: 6)],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ChoiceChip(
                        label: Text(labels[lang]!["en"]!),
                        selected: lang == "en",
                        onSelected: (_) => setState(() => lang = "en"),
                        labelStyle: TextStyle(
                          color: lang == "en" ? Colors.white : Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                        selectedColor: Colors.deepPurple,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: Text(labels[lang]!["tr"]!),
                        selected: lang == "tr",
                        onSelected: (_) => setState(() => lang = "tr"),
                        labelStyle: TextStyle(
                          color: lang == "tr" ? Colors.white : Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                        selectedColor: Colors.deepPurple,
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Başlık
                  Text(
                    labels[lang]!["title"]!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.5,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 12,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Çark
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(160),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.13),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: wheelSize,
                      width: wheelSize,
                      child: FortuneWheel(
                        selected: selected.stream,
                        indicators: const <FortuneIndicator>[
                          FortuneIndicator(
                            alignment: Alignment.topCenter,
                            child: TriangleIndicator(
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                        items: [
                          for (var m in meals)
                            FortuneItem(
                              child: Text(
                                m[lang]!["name"]!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                              style: FortuneItemStyle(
                                color: Colors.purpleAccent.shade100,
                                borderColor: Colors.deepPurple.shade300,
                                borderWidth: 2,
                              ),
                            ),
                        ],
                        onAnimationEnd: () async {
                          await player.play(AssetSource('sounds/ding.mp3'));
                          setState(() {
                            lastSelected = _lastSelectedIndex;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Buton
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
                    ),
                    onPressed: () async {
                      final index = Random().nextInt(meals.length);
                      await player.play(AssetSource('sounds/spin.mp3'));
                      selected.add(index);
                      setState(() {
                        lastSelected = null;
                        _lastSelectedIndex = index;
                      });
                    },
                    child: Text(
                      labels[lang]!["spin"]!,
                      style: const TextStyle(fontSize: 21, color: Colors.white, letterSpacing: 1.2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Sonuç
                  if (lastSelected != null)
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: 1.0,
                      child: Column(
                        children: [
                          Text(
                            "${labels[lang]!["today"]!} ${meals[lastSelected!][lang]!["name"]!}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(color: Colors.black38, blurRadius: 10),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 7,
                                )
                              ]
                            ),
                            child: Text(
                              meals[lastSelected!][lang]!["recipe"]!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.deepPurple,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
