# Forever Friends Setup

En delt UI- og addonopsætning til WoW Forever med skrifttyper, profiler og valgfri import af tastebindinger.

## Download

Åbn [seneste release](https://github.com/mtthsnc/forever-friends-setup/releases/latest).

- **Ny installation:** Hent både `Forever-Friends-Setup-Core-2026-11-05.zip` og `Forever-Friends-Setup-Audio-2026-11-05.zip`.
- **Har du allerede pakken fra 4. november?** Hent kun `Forever-Friends-Keybinding-Update-2026-11-05.zip`, og følg dens `README_UPDATE.txt`.
- GitHubs automatiske **Source code**-downloads indeholder kun denne dokumentation. De er ikke addonpakken.

De to fulde ZIP-filer er selvstændige arkiver. De skal ikke sammenføjes som binære fildele. Pak dem ud i samme midlertidige mappe, så indholdet bliver samlet.

## Installation

1. Luk WoW, og pak begge ZIP-filer ud i samme midlertidige mappe.
2. Tag en sikkerhedskopi af dine eksisterende `Interface`-, `Fonts`- og `WTF`-mapper under `_forever_`.
3. Kopiér `Interface` og `Fonts` fra `COPY_INTO_FOREVER` til din `_forever_`-mappe. Flet mapper, og erstat overlappende filer.
4. Find din egen kontomappe under `_forever_/WTF/Account/`. Kontomappens navn er ikke nødvendigvis dit BattleTag.
5. Åbn `COPY_INTO_FOREVER/WTF/Account/REPLACE_WITH_YOUR_ACCOUNT` i den udpakkede pakke. Kopiér indholdet til din kontomappe, men lad `REPLACE_WITH_YOUR_REALM_FOLDER` ligge indtil videre.
6. Start WoW. Kontrollér under **AddOns**, at **Forever Friends Setup** er aktiveret.
7. Vil du bruge pakkens tastebindinger, skal **Forever Friends Setup - Keybindings** også være aktiveret. Vil du beholde dine egne, skal du slå dette valgfrie addon fra **og** undlade at kopiere `bindings-cache.wtf` i trin 5.
8. Log ind på din karakter. Addonindstillingerne og de valgte tastebindinger importeres automatisk. Du behøver ikke skrive kommandoer, genindlæse brugerfladen eller logge ud ved en ny installation.

Importen huskes pr. karakter og addon, så efterfølgende ændringer bliver bevaret. Lad opsætningsaddonnet være aktiveret, mens du bruger pakkens importfiler. Vent med at opdatere addons, til de ønskede karakterer er importeret, da en opdatering kan erstatte de lokale importfiler.

Har du endnu ingen kontomappe, kan du først åbne Forever til login-/karakterskærmen og derefter lukke spillet før installation. Du behøver ikke gå ind i verden for at installere pakken.

### Valgfrie karakterfiler

`REPLACE_WITH_YOUR_REALM_FOLDER` og `REPLACE_WITH_YOUR_CHARACTER_FOLDER` indeholder spillets egne chat- og layout-cachefiler. Brug kun de præcise mappenavne, som din egen klient opretter. Gæt ikke et realmnavn eller et nummer. Forever bruger rulesets/megaservere, selv om klienten stadig har interne mapper.

Addonimporten virker uden disse cachefiler. Du skal ikke redigere `__SETUP_...`-teksten i Lua-filer; addonnet håndterer det selv.

## Opdatering af en eksisterende installation

Pak den lille opdaterings-ZIP ud, og kopiér indholdet af `COPY_INTO_FOREVER` til din `_forever_`-mappe. Er du allerede inde i spillet, kan den eksisterende importfil genindlæses med `/reload`. Skriv derefter `/friendbinds` uden for kamp for at anvende de delte tastebindinger. Den kommando overskriver de inkluderede bindinger, også hvis automatisk bindingimport er slået fra.

`/friendbinds status` viser eventuelle bindinger, som et manglende addon eller andre indstillinger forhindrede i at blive anvendt.

## Indhold og kontrol

Pakken indeholder ikke ophavsmandens kontonavne, karakteroversigter, chatlogfiler, personlige makroer eller migrationsbackups. Servergemte actionbars kan ikke installeres med ZIP-filerne.

Importfilerne er testet med Lua 5.1, separate fornavne/efternavne, Unicode-tegn og valgfri bindingimport. Arkiverne har bestået CRC-kontrol. `SHA256SUMS-RELEASE.txt` giver SHA-256-kontrolsummer for downloadfilerne; det interne `SHA256SUMS.txt` dækker indholdet af den samlede pakke.

Ved problemer kan du gendanne din sikkerhedskopi med WoW lukket. Pakken distribuerer eksisterende tredjepartsaddons; deres medfølgende ophavsrets- og licensoplysninger gælder fortsat.
