# IPK PROJEKT 1 (2022)
**Autor:** Ladislav Vašina\
**Login:** xvasin11\
**Email:** xvasin11@stud.fit.vutbr.cz


## Popis aplikace

Tato aplikace implementuje jednoduchý server, který komunikuje pomocí protokolu HTTP.\
Uživatel má možnost pomocí 3 předdefinovaných dotazů získat různé informace o systému \
(síťové jméno počítače, informace o CPU, aktuální zátěž CPU).\
Pro implementaci aplikace byl použit jazyk C.


## Spuštění aplikace

Pro spuštění našeho serveru je nutné v terminálu spustit následující příkazy: \
\
Přikaz *make* přeloží aplikaci.
```
$ make
```
Samotné spuštění serveru se provede příkazem s jediným argumentem, který značí port, na kterém bude server naslouchat. \
*./hinfosvc <číslo portu>*

```
$ ./hinfosvc 12345
```

Po spuštění tohoto příkazu máme spuštěný server a uživateli se zobrazí hláška o zvoleném portu, na kterém má server naslouchat.
```
USER DEFINED PORT: 12345
```
## Zasílání dotazů serveru

**Následují příklady zasílání dotazů na server.**
* Příklad získání síťového jména počítače
```
$ curl http://localhost:12345/hostname
asus-dash-f15
```
![Pouziti prohlizece pro zaslani dotazu k ziskani sitoveho jmena pocitace](https://i.imgur.com/g1KNIRR.png)
* Příklad získnání informací o CPU
```
$ curl http://localhost:12345/cpu-name
11th Gen Intel(R) Core(TM) i7-11370H @ 3.30GHz
```
![Pouziti prohlizece pro zaslani dotazu k ziskani infa o CPU](https://i.imgur.com/UCckDzs.png)
* Příklad získání aktuální zatěže CPU
```
$ curl http://localhost:12345/load
2%
```
![Pouziti prohlizece pro ziskani aktualni zateze CPU](https://i.imgur.com/2NPdzRW.png)
