# Galgje

Galgje voor twee of meer spelers, of alleen met woorden uit de Overhoren-lijsten. Tien foute letters en het mannetje hangt.

- Live: https://dspbrg.github.io/galgje/
- Claude-versie (samen live spelen op verschillende apparaten): https://claude.ai/artifact/VNSQJr4FLovmxEmxnRuS2W

## Bestanden

- `galgje.html` is de bron. Dit is de claude.ai-artifactversie, zonder eigen `<html>`/`<head>`.
- `build.sh` bouwt daaruit `index.html` voor GitHub Pages, met manifest, icoontjes, service worker en de woordenlijsten van Overhoren.
- `sw.js` zorgt dat de app offline werkt. De versie wordt bij elke build vervangen.

Na een wijziging in `galgje.html`: `./build.sh`, committen en pushen.

## Woordenlijsten

Op Pages laadt Galgje `../overhoren/lists.js`, dus nieuwe Overhoren-lijsten komen er vanzelf bij. Lijsten die iemand zelf in Overhoren heeft toegevoegd (in dezelfde browser) komen ook mee, omdat beide apps op `dspbrg.github.io` staan. Zonder verbinding met Overhoren valt Galgje terug op een ingebouwde kopie.

Samen spelen werkt op Pages op één scherm. Live samen spelen op verschillende apparaten kan alleen in de claude.ai-versie.
