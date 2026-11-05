# Forever Friends Setup

Komplet UI- og addonpakke til WoW Forever med skrifttyper, profiler og valgfri import af tastebindinger.

## Download

Hent den komplette pakke fra [seneste release](https://github.com/mtthsnc/forever-friends-setup/releases/latest):

- **Forever-Friends-Setup-Core-2026-11-05.2.zip**
- **Forever-Friends-Setup-Audio-2026-11-05.zip**

Pak begge ZIP-filer ud i samme midlertidige mappe. De er selvstændige arkiver, der tilsammen udgør den fulde pakke. Audio er uændret fra tidligere udgaver; har du allerede den samme audiofil, kan den genbruges. Der udgives fremover hele pakker, ikke små fix-installationer.

GitHubs automatiske **Source code**-downloads indeholder dokumentation og kompatibilitetsaddonernes kode. De er ikke den komplette UI-pakke.

## Opdatering af en eksisterende installation

1. Tag en sikkerhedskopi af dine eksisterende `Interface`-, `Fonts`- og `WTF`-mapper under `_forever_`.
2. Pak den fulde udgave ud som beskrevet ovenfor.
3. Kopiér `Interface` og `Fonts` fra `COPY_INTO_FOREVER` til din `_forever_`-mappe. Flet mapper, og erstat overlappende filer.
4. **Kopiér ikke pakkens WTF-skabeloner igen ved en opdatering.** Behold dine eksisterende konto-, karakter- og addonindstillinger.
5. Er du allerede inde i spillet, skriv `/reload`. Den eksisterende **Forever Friends Setup**-fil indlæser kompatibilitetsrettelserne uden et fuldt klientstop. Nye separate addons bliver også tilgængelige, når klienten opdager dem ved næste normale start.

Lad **Forever Friends Setup**, **Forever Combat Mode - Bags** og **Forever UI Layout Fixes** være aktiveret, når de vises i addonlisten. Kør kun `/friendbinds`, hvis du bevidst vil anvende pakkens tastebindinger igen.

## Installation

1. Luk WoW, og pak begge ZIP-filer ud i samme midlertidige mappe.
2. Tag en sikkerhedskopi af dine eksisterende `Interface`-, `Fonts`- og `WTF`-mapper under `_forever_`.
3. Kopiér `Interface` og `Fonts` fra `COPY_INTO_FOREVER` til din `_forever_`-mappe. Flet mapper, og erstat overlappende filer.
4. Find din egen kontomappe under `_forever_/WTF/Account/`. Navnet er ikke nødvendigvis dit BattleTag.
5. Åbn `COPY_INTO_FOREVER/WTF/Account/REPLACE_WITH_YOUR_ACCOUNT` i den udpakkede pakke. Kopiér indholdet til din kontomappe, men lad `REPLACE_WITH_YOUR_REALM_FOLDER` ligge indtil videre.
6. Start WoW. Kontrollér under **AddOns**, at **Forever Friends Setup** er aktiveret. Behold også **Forever Combat Mode - Bags** og **Forever UI Layout Fixes** aktiveret.
7. Vil du bruge pakkens tastebindinger, skal **Forever Friends Setup - Keybindings** være aktiveret. Vil du beholde dine egne, skal du slå dette valgfrie addon fra **og** undlade at kopiere `bindings-cache.wtf` i trin 5.
8. Log ind på din karakter. Addonindstillingerne og de valgte tastebindinger importeres automatisk. En ny installation kræver ingen kommandoer, genindlæsning eller logout for selve importen.

Importen huskes pr. karakter og addon, så efterfølgende ændringer bliver bevaret. Vent med at opdatere de migrerede addons, til de ønskede karakterer har fuldført den oprindelige import: en opdatering kan erstatte de lokale importfiler. De separate bag- og layoutrettelser ligger uden for de oprindelige addonmapper.

Har du endnu ingen kontomappe, kan du åbne Forever til login-/karakterskærmen og derefter lukke spillet før installation. Du behøver ikke gå ind i verden for at installere pakken.

### Valgfrie karakterfiler

`REPLACE_WITH_YOUR_REALM_FOLDER` og `REPLACE_WITH_YOUR_CHARACTER_FOLDER` indeholder spillets egne chat- og layout-cachefiler. Brug kun de præcise mappenavne, som din klient opretter. Gæt ikke et realmnavn eller et nummer. Addonimporten virker uden disse valgfrie cachefiler. `__SETUP_...`-teksten i Lua-filerne håndteres automatisk og skal ikke redigeres.

## Rettelser i denne udgave

### Glass og personlig castbar

**Forever UI Layout Fixes** sørger for, at Glass' indtastningsfelt følger chatvinduet efter forsinkede layoutændringer på nye karakterer. Det respekterer Glass' Above/Below-indstilling, afstand og vinduets aktuelle bredde. Det bruger widgettens native HookScript, fordi Glass også indlejrer AceHook med en anden metode af samme navn.

Personal World Plates castbar hæftes til den personlige ramme med ensartet skalering. Anker-, bredde- og skalaændringer repareres, når det er sikkert. Beskyttede rammer flyttes ikke under kamp, og Edit Mode får lov til at afslutte, før vedhæftningen gendannes. Rettelsen ligger i et separat addon; Glass og PersonalWorldPlate ændres ikke på disken.

### Tasker og action mode

**Forever Combat Mode - Bags** er et separat addon. Uden for kamp frigiver åbne tasker musemarkøren; når alle tasker lukkes, kan action mode fortsætte. I kamp afbryder tasker ikke action mode. Manuelle toggles og andre åbne vinduer respekteres.

### Tastebindinger

Separate fornavne og efternavne håndteres. De 114 inkluderede bindinger kan importeres automatisk på første login. `/friendbinds status` viser fejl eller konflikter. `/friendbinds` anvender dem igen uden for kamp og kan dermed overskrive dine senere bindinger.

## Kontrol og gendannelse

Pakken indeholder ikke ophavsmandens kontonavne, karakteroversigter, chatlogfiler, personlige makroer eller migrationsbackups. Servergemte actionbars kan ikke installeres med ZIP-filerne.

Import og layoutrettelser er testet med Lua 5.1, separate navne, Unicode-tegn, forsinket chatlayout, skala- og ankerændringer, kamp, beskyttede rammer og Edit Mode. Den faktiske klientoplevelse skal stadig kontrolleres i spillet. Arkiverne CRC-kontrolleres, og SHA-256-kontrolsummer medfølger.

Ved problemer kan du gendanne din sikkerhedskopi med WoW lukket. Tredjepartsaddonernes medfølgende ophavsrets- og licensoplysninger gælder fortsat. Fremtidige inkompatible addon-API-ændringer kan kræve opdatering af de separate kompatibilitetsaddons.

Kildekode: [`addons/ForeverUILayoutFixes`](addons/ForeverUILayoutFixes) og [`addons/ForeverCombatModeBags`](addons/ForeverCombatModeBags).
