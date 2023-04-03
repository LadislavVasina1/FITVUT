---------------------------------------------------------------------------------------------------------------
-- IDS PROJECT: PART 4
-- AUTHORS:
--         LADISLAV VASINA, XVASIN11
--         DOMINIK  VAGNER, XVAGNE10
---------------------------------------------------------------------------------------------------------------
drop table uzivatele cascade constraints purge;
drop table kategorie cascade constraints purge;
drop table kosik cascade constraints purge;
drop table objednavky cascade constraints purge;
drop table objednavky_ma_produkty cascade constraints purge;
drop table produkty cascade constraints purge;
drop table kosik_ma_produkty cascade constraints purge;
/

---------------------------------------------------------------------------------------------------------------
create table uzivatele
(
    id_uzivatele  int generated as identity
        constraint UZIVATELE_PK primary key,
    username      varchar2(45)   not null,
    jmeno         varchar2(45)   not null,
    prijmeni      varchar2(45)  not null,
    ico           char(8)      not null,
    email         varchar2(45)  not null,
    password      varchar2(60)  not null,
    opravneni     number(1) default 0 not null,
    ulice         varchar2(45)  not null,
    cislo_popisne varchar2(45)  not null,
    obec          varchar2(45)  not null,
    psc           varchar2(45)  not null
)
/

---------------------------------------------------------------------------------------------------------------
create table kategorie
(
    id_kategorie int generated as identity
    constraint KATEGORIE_PK primary key,
    nazev_kategorie varchar2(60) not null,
    nadrazena_kategorie int
)
/

---------------------------------------------------------------------------------------------------------------
create table kosik
(
    id_produktu  int not null,
    id_uzivatele int not null,
    constraint KOSIK_PK primary key (id_produktu, id_uzivatele)
)
/
---------------------------------------------------------------------------------------------------------------
create table objednavky
(
    id_objednavky    int generated as identity
        constraint OBJEDNAVKY_PK primary key,
    id_uzivatele     int                 not null,
    id_vyrizujiciho  int                 not null,
    cena_celkem      float               not null,
    datum_objednavky date                not null,
    datum_odeslani   date,
    druh_dopravy     varchar2(65)        not null CHECK( druh_dopravy IN ('slow','fast','blazing_fast') ),
    zaplacena        number(1) default 0 not null
)
/

---------------------------------------------------------------------------------------------------------------
create table objednavky_ma_produkty
(
    objednavky_id_objednavky int          not null,
    produkty_id_produktu     int          not null,
    constraint OBJEDNAVKA_MA_PRODUKTY_PK primary key (objednavky_id_objednavky, produkty_id_produktu),
    qty                      int          not null,
    cena_pri_objednani       number(8, 2) not null
)
/

---------------------------------------------------------------------------------------------------------------
create table produkty
(
    id_produktu          int generated as identity
        constraint PRODUKTY_PK primary key,
    nazev_produktu       varchar2(100) not null,
    cena_produktu        number(8, 2)  not null,
    popis_produktu       VARCHAR2(2048),
    pocet_skladem        int default 0 not null,
    pocet_prodanych_kusu int default 0 not null,
    kategorie_id         int           not null
)
/

---------------------------------------------------------------------------------------------------------------
create table kosik_ma_produkty
(
    kosik_id_produktu    int not null,
    kosik_id_uzivatele   int not null,
    produkty_id_produktu int not null,
    qty                  int not null,
    constraint KOSIK_MA_PRODUKTY_PK primary key (kosik_id_produktu, kosik_id_uzivatele, produkty_id_produktu)
)
/

---------------------------------------------------------------------------------------------------------------
alter table uzivatele
add constraint check_ico check(
        (regexp_like(ico, '^[0-9]{8}$')) and
        (to_number(substr(ico, 8, 1), '9')) =
            (mod(11 -
                mod(
                    (
                        (8 * to_number(substr(ico, 1, 1), '9')) +
                        (7 * to_number(substr(ico, 2, 1), '9')) +
                        (6 * to_number(substr(ico, 3, 1), '9')) +
                        (5 * to_number(substr(ico, 4, 1), '9')) +
                        (4 * to_number(substr(ico, 5, 1), '9')) +
                        (3 * to_number(substr(ico, 6, 1), '9')) +
                        (2 * to_number(substr(ico, 7, 1), '9'))
                    )
                ,11)
            ,10)
    ))
/
---------------------------------------------------------------------------------------------------------------

alter table kosik
add constraint fk_kosik_uzivatele
foreign key (id_uzivatele) references uzivatele(id_uzivatele)
/

alter table kosik_ma_produkty
add constraint fk_kosik_ma_produkty_kosik
foreign key (kosik_id_produktu, kosik_id_uzivatele) references kosik(id_produktu, id_uzivatele)
/

alter table kosik_ma_produkty
add constraint fk_kosik_ma_produkty_produkty
foreign key (produkty_id_produktu) references produkty(id_produktu)
/

alter table produkty
add constraint fk_produkt_kategorie
foreign key (kategorie_id) references kategorie(id_kategorie)
/

alter table kategorie
add constraint fk_kategorie_kategorie
foreign key (nadrazena_kategorie) references kategorie(id_kategorie)
/

alter table objednavky_ma_produkty
add constraint fk_objednavky_ma_produkty_produkty
foreign key (produkty_id_produktu) references produkty(id_produktu)
/

alter table objednavky_ma_produkty
add constraint fk_objednavky_ma_produkty_objednavky
foreign key (objednavky_id_objednavky) references objednavky(id_objednavky)
/

alter table objednavky
add constraint fk_objednavky_uzivatele_uzivatel
foreign key (id_uzivatele) references uzivatele(id_uzivatele)
/

alter table objednavky
add constraint fk_objednavky_uzivatele_vyrizujici
foreign key (id_vyrizujiciho) references uzivatele(id_uzivatele)
/


---------------------------------------------------------------------------------------------------------------
create or replace trigger kontrola_pocet_skladem
    before insert or update on objednavky_ma_produkty
    for each row
    declare
        s_pocet_skladem int;
    begin
        if inserting then
            select pocet_skladem into s_pocet_skladem
            from produkty
            where produkty.id_produktu = :new.produkty_id_produktu;
            if s_pocet_skladem < :new.qty then
                RAISE_APPLICATION_ERROR(-20420, 'NELZE vlozit takoveto mnozstvi produktu - !!!nedostatek na sklade!!!');
            end if;
        end if;
    end;

create or replace trigger kontrola_data_objednani
    before insert or update on objednavky
    for each row
    declare
        s_ted date;
    begin
        if inserting then
            select CURRENT_DATE into s_ted from dual;
            if :new.datum_objednavky > s_ted then
                RAISE_APPLICATION_ERROR(-20420, 'NELZE vlozit datum objednavky v budoucnosti');
            end if;
        end if;
    end;


create or replace procedure druh_dopravy is
    p_celkem_objednavek int;
    p_vypocet number;
    cursor dopravy is
    select objednavky.druh_dopravy, count(*) pocet_daneho_druhu from objednavky group by objednavky.druh_dopravy;
    p_dopravy_row dopravy%rowtype;
    begin
       select COUNT(*) into p_celkem_objednavek from objednavky;
       DBMS_OUTPUT.PUT_LINE('Procentualni zastoupeni druhu dopravy u objednavek:');
       open dopravy;
       loop
            fetch dopravy into p_dopravy_row;
            exit when dopravy%notfound;
            p_vypocet := round(((p_dopravy_row.pocet_daneho_druhu / p_celkem_objednavek) * 100), 2);
            DBMS_OUTPUT.PUT_LINE('Druh: ' || p_dopravy_row.druh_dopravy || ' ' || p_vypocet || '%');
       end loop;
    exception
       when others then
        DBMS_OUTPUT.PUT_LINE('Chyba pri provadeni procedury druh_dopravy');
    end;

create or replace procedure drazsi_nez (p_cena number) as
    cursor cursor_produkty is
    select * from produkty;
    p_produkty cursor_produkty%rowtype;
    begin
        DBMS_OUTPUT.PUT_LINE('Produkty drazsi nez: ' || p_cena || ' Kc');
        open cursor_produkty;
        loop
            fetch cursor_produkty into p_produkty;
            exit when cursor_produkty%notfound;
            if p_produkty.cena_produktu > p_cena then
                DBMS_OUTPUT.PUT_LINE('ID: ' || p_produkty.id_produktu || ' nazev: ' || p_produkty.nazev_produktu);
            end if;
        end loop;
    exception when others then
        DBMS_OUTPUT.PUT_LINE('Chyba pri provadeni procedury drazsi_nez');
    end;

---------------------------------------------------------------------------------------------------------------



insert into uzivatele (username, jmeno, prijmeni, ico, email, password, opravneni, ulice, cislo_popisne, obec, psc)
values ('xvagne10', 'Dominik', 'Vagner', '25596641', 'xvagne@stud.fit.vutbr.cz', '12345', 0, 'Kounicova', '46', 'Brno', '602 00');
insert into uzivatele (username, jmeno, prijmeni, ico, email, password, opravneni, ulice, cislo_popisne, obec, psc)
values ('xvasin11', 'Ladislav', 'Vasina', '25099213', 'xvasin11@stud.fit.vutbr.cz', '98765', 1, 'Kounicova', '46', 'Brno', '602 00');
insert into uzivatele (username, jmeno, prijmeni, ico, email, password, opravneni, ulice, cislo_popisne, obec, psc)
values ('xnovak16', 'Jan', 'Novak', '44992785', 'xnovak16@stud.fit.vutbr.cz', '0123812937', 0, 'Pepikova', '22', 'Ostrava', '602 33');
insert into uzivatele (username, jmeno, prijmeni, ico, email, password, opravneni, ulice, cislo_popisne, obec, psc)
values ('xhajek36', 'Vojtech', 'Hajek', '60350725', 'xhajek36@stud.fit.vutbr.cz', '99999999', 0, 'U zdi', '13', 'As', '123 55');
insert into uzivatele (username, jmeno, prijmeni, ico, email, password, opravneni, ulice, cislo_popisne, obec, psc)
values ('xpoliv07', 'Tomas', 'Polivka', '65181646', 'xpoliv07@stud.fit.vutbr.cz', '111111222', 1, 'Bozetechova', '2', 'Brno', '827 88');
insert into uzivatele (username, jmeno, prijmeni, ico, email, password, opravneni, ulice, cislo_popisne, obec, psc)
values ('xcervi05', 'Vaclav', 'Cervinka', '70124388', 'xcervi05@stud.fit.vutbr.cz', '99887766', 0, 'Pavlova', '666', 'Olomouc', '123 33');
insert into uzivatele (username, jmeno, prijmeni, ico, email, password, opravneni, ulice, cislo_popisne, obec, psc)
values ('xpavel09', 'Petr', 'Pavel', '68396201', 'xpavel09@stud.fit.vutbr.cz', '55667532', 0, 'Masarykova', '987', 'Praha', '555 22');
/

insert into kategorie (nazev_kategorie, nadrazena_kategorie) values ('Komponenty', NULL);
/

insert into kategorie (nazev_kategorie, nadrazena_kategorie) values ('Procesory', 1);
/

insert into kategorie (nazev_kategorie, nadrazena_kategorie) values ('Graficke karty', 1);
/

insert into kategorie (nazev_kategorie, nadrazena_kategorie) values ('Notebooky', NULL);
insert into kategorie (nazev_kategorie, nadrazena_kategorie) values ('Mobily', NULL);
insert into kategorie (nazev_kategorie, nadrazena_kategorie) values ('Prislusenstvi', NULL);
insert into kategorie (nazev_kategorie, nadrazena_kategorie) values ('Televize', NULL);
/

insert into produkty (nazev_produktu, cena_produktu, popis_produktu, pocet_skladem, pocet_prodanych_kusu, kategorie_id)
values ('Intel Core i7-10610U', 3333.00, 'Lepsi procesor do NTB.', 500, 16, 2);
insert into produkty (nazev_produktu, cena_produktu, popis_produktu, pocet_skladem, pocet_prodanych_kusu, kategorie_id)
values ('Intel Core i7-10510U', 2222.00, 'Procesor do NTB.', 100, 23, 2);
insert into produkty (nazev_produktu, cena_produktu, popis_produktu, pocet_skladem, pocet_prodanych_kusu, kategorie_id)
values ('Nvidia RTX 3090', 50000.00, 'Draha gpu', 9, 0, 3);
insert into produkty (nazev_produktu, cena_produktu, popis_produktu, pocet_skladem, pocet_prodanych_kusu, kategorie_id)
values ('ASUS TUF F15', 30000.00, 'Herni notebook', 27, 5, 4);
insert into produkty (nazev_produktu, cena_produktu, popis_produktu, pocet_skladem, pocet_prodanych_kusu, kategorie_id)
values ('iPhone 69 PRO MAX TURBO ULTRA MEGA', 40000.00, 'jablicko', 420, 42, 5);
insert into produkty (nazev_produktu, cena_produktu, popis_produktu, pocet_skladem, pocet_prodanych_kusu, kategorie_id)
values ('Logitech MX3', 2000.00, 'Kolecko u mysi goes brrr', 69, 12, 6);
insert into produkty (nazev_produktu, cena_produktu, popis_produktu, pocet_skladem, pocet_prodanych_kusu, kategorie_id)
values ('Samsung 4k TV', 20000.00, 'Velka televize', 80, 30, 7);
/

insert into kosik (id_produktu, id_uzivatele) values (1, 1);
insert into kosik (id_produktu, id_uzivatele) values (2, 1);
/

insert into kosik_ma_produkty (kosik_id_produktu, kosik_id_uzivatele, produkty_id_produktu, qty)
values (1, 1, 1, 3);
insert into kosik_ma_produkty (kosik_id_produktu, kosik_id_uzivatele, produkty_id_produktu, qty)
values (2, 1, 2, 9);
/

insert into objednavky(id_uzivatele, id_vyrizujiciho, cena_celkem, datum_objednavky, datum_odeslani, druh_dopravy, zaplacena)
values (1, 2, 34441.00, TO_DATE('2022/03/22 7:00:00', 'yyyy/mm/dd hh:mi:ss'), TO_DATE('2022/03/22 12:00:00', 'yyyy/mm/dd hh:mi:ss'), 'blazing_fast', 1);
insert into objednavky(id_uzivatele, id_vyrizujiciho, cena_celkem, datum_objednavky, datum_odeslani, druh_dopravy, zaplacena)
values (1, 2, 32000.00, TO_DATE('2022/04/20 8:46:59', 'yyyy/mm/dd hh:mi:ss'), TO_DATE('2022/04/21 11:00:00', 'yyyy/mm/dd hh:mi:ss'), 'fast', 1);
insert into objednavky(id_uzivatele, id_vyrizujiciho, cena_celkem, datum_objednavky, datum_odeslani, druh_dopravy, zaplacena)
values (3, 5, 40000.00, TO_DATE('2021/04/06 4:20:00', 'yyyy/mm/dd hh:mi:ss'), TO_DATE('2021/04/12 07:00:00', 'yyyy/mm/dd hh:mi:ss'), 'slow', 0);
insert into objednavky(id_uzivatele, id_vyrizujiciho, cena_celkem, datum_objednavky, datum_odeslani, druh_dopravy, zaplacena)
values (7, 2, 74000.00, TO_DATE('2021/05/29 07:38:00', 'yyyy/mm/dd hh:mi:ss'), TO_DATE('2022/06/03 8:10:00', 'yyyy/mm/dd hh:mi:ss'), 'fast', 1);
/

insert into objednavky_ma_produkty(objednavky_id_objednavky, produkty_id_produktu, qty, cena_pri_objednani)
values (1, 1, 7, 3333.00);
insert into objednavky_ma_produkty(objednavky_id_objednavky, produkty_id_produktu, qty, cena_pri_objednani)
values (1, 2, 5, 2222.00);
insert into objednavky_ma_produkty(objednavky_id_objednavky, produkty_id_produktu, qty, cena_pri_objednani)
values (2, 4, 1, 30000.00);
insert into objednavky_ma_produkty(objednavky_id_objednavky, produkty_id_produktu, qty, cena_pri_objednani)
values (2, 6, 1, 2000.00);
insert into objednavky_ma_produkty(objednavky_id_objednavky, produkty_id_produktu, qty, cena_pri_objednani)
values (3, 5, 1, 40000.00);
insert into objednavky_ma_produkty(objednavky_id_objednavky, produkty_id_produktu, qty, cena_pri_objednani)
values (4, 3, 1, 50000.00);
insert into objednavky_ma_produkty(objednavky_id_objednavky, produkty_id_produktu, qty, cena_pri_objednani)
values (4, 7, 1, 20000.00);
insert into objednavky_ma_produkty(objednavky_id_objednavky, produkty_id_produktu, qty, cena_pri_objednani)
values (4, 6, 2, 4000.00);
/




SELECT username, SUM(cena_celkem) suma FROM uzivatele
JOIN objednavky o ON uzivatele.id_uzivatele = o.id_uzivatele
GROUP BY uzivatele.username
ORDER BY suma DESC;
-- index optimalizujici vypis utraty vsech uzivatelu
create index utrata_index on objednavky(cena_celkem);

SELECT username, SUM(cena_celkem) suma FROM uzivatele
JOIN objednavky o ON uzivatele.id_uzivatele = o.id_uzivatele
GROUP BY uzivatele.username
ORDER BY suma DESC;
drop index utrata_index;



-- prvni prubeh zobrazovani poctu produktu v danych kategoriich
explain plan for
SELECT nazev_kategorie, COUNT(id_produktu) pocet_produtku_v_kategorii FROM produkty
JOIN kategorie k ON id_kategorie = kategorie_id
GROUP BY nazev_kategorie;
select plan_table_output from table(DBMS_XPLAN.DISPLAY());

drop index produkty_kat_count_index;
drop index kat_nazev_index;
create index produkty_kat_count_index on produkty (id_produktu, kategorie_id);
create index kat_nazev_index on kategorie (nazev_kategorie);

-- druhy porovnavaci beh
explain plan for
SELECT nazev_kategorie, COUNT(id_produktu) pocet_produtku_v_kategorii FROM produkty
JOIN kategorie k ON id_kategorie = kategorie_id
GROUP BY nazev_kategorie;
select plan_table_output from table(DBMS_XPLAN.DISPLAY());



GRANT ALL ON kategorie TO XVASIN11;
GRANT ALL ON kosik TO XVASIN11;
GRANT ALL ON kosik_ma_produkty TO XVASIN11;
GRANT ALL ON objednavky TO XVASIN11;
GRANT ALL ON objednavky_ma_produkty TO XVASIN11;
GRANT ALL ON produkty TO XVASIN11;
GRANT ALL ON uzivatele TO XVASIN11;


drop materialized view mobily;
create materialized view mobily
refresh on commit as
SELECT P.nazev_produktu, P.cena_produktu, P.popis_produktu, K.nazev_kategorie FROM XVAGNE10.produkty P
JOIN XVAGNE10.kategorie K ON P.kategorie_id = K.id_kategorie
WHERE nazev_kategorie = 'Mobily';

select * from mobily;

-- insert into objednavky_ma_produkty(objednavky_id_objednavky, produkty_id_produktu, qty, cena_pri_objednani)
-- values (1, 5, 69, 3333.00);

-- insert into objednavky(id_uzivatele, id_vyrizujiciho, cena_celkem, datum_objednavky, datum_odeslani, druh_dopravy, zaplacena)
-- values (1, 2, 34441.00, TO_DATE('2021/03/22 7:00:00', 'yyyy/mm/dd hh:mi:ss'), TO_DATE('2021/03/22 12:00:00', 'yyyy/mm/dd hh:mi:ss'), 'blazing_fast', 1);

begin
    druh_dopravy();
end;

begin
    drazsi_nez('5000');
end;

