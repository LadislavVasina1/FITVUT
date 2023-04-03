# Čtečka novinek ve formátu Atom a RSS s podporou TLS
**Autor:** Ladislav Vašina\
**Login:** xvasin11\
**Email:** xvasin11@stud.fit.vutbr.cz\
**Datum vytvoření:** 08.10.2022

## Popis programu feedreader
Uživatel může programu `feedreader` zadat jako argument jednu url (či soubor s více url), ze které chce získat
feed novinek ve formátu [RSS 2.0](https://www.rssboard.org/rss-specification) nebo [Atom](https://www.rfc-editor.org/rfc/rfc4287).
Url ze které chce uživatel získat feed novinek může být jak http, tak https.

## Možnosti spuštění programu
`./feedreader <URL | -f <feedfile>> [-c <certfile>] [-C <certaddr>] [-T] [-a] [-u]`
* `URL` url ze které chce uživatel získat feed novinek
* `-f <feedfile>` <feedfile> je soubor obsahující url, ze kterých chceme získat feed novinek. Každá url je na samostatném řádku.
* `-c <cerfile>`  <certfile> je soubor obsahující certifikát pro ověření.
* `-C <certaddr>` <certaddr> je adresář obsahující certifikáty pro ověření.
* `-T` zobrazí pro každý záznam informaci o **čase, kdy byl záznam změněn**.
* `-a` zobrazí pro každý záznam informaci o **jeho autorovi**.
* `-u` zobrazí pro každý záznam informaci o **jeho url**.
* `-h` a  `--help` zobrazí nápovědu.

## Příklady použití programu
Pro spuštění naší čtečky je nutné v terminálu spustit následující příkazy:
\
1. Přikaz `make` přeloží aplikaci.
```
$ make
```
2. Teď již můžeme spustit náš program. Níže můžete vidět pár příkladů použití:
```
$ ./feedreader "https://what-if.xkcd.com/feed.atom" -u -a
*** what if? ***
Transatlantic Car Rental
Aktualizace: 2022-09-06T00:00:00Z
URL: https://what-if.xkcd.com/160/

Hailstones
Aktualizace: 2022-07-06T00:00:00Z
URL: https://what-if.xkcd.com/159/

...výstup zanedbán...

$ ./feedreader "https://news.yahoo.com/rss/" -u -a -T -C /etc/ssl/certs
*** Yahoo News - Latest News & Headlines ***
Town employee quietly lowered fluoride in water for years
URL: https://news.yahoo.com/town-employee-quietly-lowered-fluoride-114045478.html
Aktualizace: 2022-10-08T11:40:45Z

Family dogs kill 2 Tennessee children, injure mom who tried to stop mauling
URL: https://news.yahoo.com/family-dogs-kill-2-tennessee-155341839.html
Aktualizace: 2022-10-08T19:37:25Z           

...výstup zanedbán...                                                                              
```

## Seznam odevzdaných souborů
```
xvasin11.tar
    |---------- feedreader.cpp
    |---------- README.md
    |---------- manual.pdf
    |---------- Makefile
```