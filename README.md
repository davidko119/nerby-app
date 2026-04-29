# Nerby

Nerby je iOS aplikácia na rýchle spojenie ľudí, ktorí majú problém, s ľuďmi v okolí, ktorí ho vedia vyriešiť osobne.

Príklad: používateľ potrebuje opraviť sifón, nastaviť Wi-Fi alebo vyriešiť defekt. Zadá problém, appka mu ukáže dostupných providerov v okolí a umožní mu napísať, zavolať alebo sa dohodnúť na stretnutí tvárou v tvár.

## Cieľ appky

- nájsť pomoc nablízku podľa typu problému,
- ukázať profil providera, služby, hodnotenie a dostupnosť,
- umožniť rýchly kontakt cez správu alebo volanie,
- podporiť osobné stretnutie medzi používateľom a providerom,
- dať providerovi možnosť zapnúť alebo vypnúť svoju dostupnosť.

## Aktuálny stav

Toto je prvý SwiftUI MVP prototyp s mock dátami. Backend, reálny chat, prihlasovanie a poloha ešte nie sú napojené.

Hotové obrazovky:

- onboarding,
- registrácia a výber role,
- domov pre používateľa, ktorý hľadá pomoc,
- domov pre providera,
- vytvorenie nového dopytu,
- zoznam odporúčaných providerov,
- detail providera,
- mapa s provider kartami,
- správy,
- detail chatu,
- aktivita,
- profil a základné nastavenia.

## Technológie

- Swift
- SwiftUI
- Xcode
- iOS Simulator

## Spustenie projektu

1. Otvor projekt v Xcode:

```bash
open "nerby app.xcodeproj"
```

2. Vyber simulátor, napríklad iPhone 17.
3. Spusti appku cez `Run`.

Projekt je možné overiť aj cez terminál:

```bash
xcodebuild -project "nerby app.xcodeproj" -scheme "nerby app" -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 17' build
```

## Roadmap

Najbližšie kroky:

- rozdeliť veľký SwiftUI súbor na samostatné obrazovky a komponenty,
- pridať Firebase Auth,
- pridať Firestore modely pre používateľov, providerov, dopyty a správy,
- napojiť reálny chat,
- napojiť polohu cez CoreLocation a mapu cez MapKit,
- pridať notifikácie,
- pripraviť bezpečnostné pravidlá a privacy texty.

## Poznámka

Presné párovanie na meter cez Bluetooth nie je v MVP garantované. Pre neskoršiu verziu dáva zmysel kombinovať GPS, Bluetooth proximity a na podporovaných zariadeniach UWB cez Nearby Interaction.
