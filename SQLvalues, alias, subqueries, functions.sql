
----------------------------------------------------------------/wprowadzanie wartosci do tabel/--

select *
from HumanResources.Krewni

insert into HumanResources.Krewni
values(1, 'Michal', 'Kichal', 39,'19840101', 'brat');

insert into HumanResources.Krewni (imie, nazwisko, id, wiek)
values ('Katarzyna', 'Kulik', 2, 32)

insert into HumanResources.Krewni 
values
(3, 'Adam', 'Ukladam', 32, '19901127', 'syn'),
(4, 'Monika', 'Kichal', 32, '19901204', 'córka')

--/ustawienie aby w kolumnie byla wymagana wartosc, nie moze byc pusta/--
ALTER TABLE HumanResources.Krewni
ALTER COLUMN id int not null

--/ustawienie klucza glownego tabeli/--
ALTER TABLE HumanResources.Krewni
add CONSTRAINT klucz_nowa_tabela primary key(id)

--/nadanie wymogu unikatowosci kluczowi glownemu/--
ALTER TABLE HumanResources.Krewni
add UNIQUE(id)

--/autoinkrementacja - ustawienie automatycznego uxupelniania kolejnych wartosci unikalnych w nowych tabelach uzywajac :
--/IDENTITY i w nawiasie 1 i 1 co ozbacza ze ma zaczynac sie od 1 i dodawac do kazdego kolejnego rekordu 1 czyli do najwyzszej wartosci/--

CREATE TABLE HumanResources.Rodziny
(id int not null identity(1,1) CONSTRAINT klucz_rodzina primary key, imie varchar(50), nazwisko varchar(50), wiek int)

select * from HumanResources.Rodziny

----------------------------------------------------------------/Zmiana wartości wpisów/--

--/dodanie kolumny 'status' ktora z automatu jezeli nie ma nadanej wartosci w tej kolumnie uzupelni sie na 'do sprawdzenia'/--
ALTER TABLE HumanResources.Rodziny
add status VARCHAR(35) DEFAULT 'do sprawdzenia'

INSERT into HumanResources.Rodziny (imie, nazwisko, wiek) --/jezeli w nawiasie wypiszemy nazwy kolumn z tabeli do ktorej chcemy dodac wartosci, to tylko te kolumny uzupelniamy danymi po values w takiej samej kolejnosci jak wpisalismy przy tabeli, reszty kolumn nie uzupelnimy/--
values ('Bartek', 'Samel', 48)

INSERT into HumanResources.Rodziny (imie, nazwisko, wiek, status)
values ('Bartek', 'Samel', 48, 'sprawdzony')

--/zmiana wartosci w konkretnej kolumnie ale z filtrem WHERE o ktory wiersz dokladnie nam chodzi/--
update HumanResources.Rodziny
set nazwisko = 'Lemas', wiek = 25
where id = 2

update HumanResources.Rodziny
set status = 'ok'
where id = 1

--/usuniecie danych/--

delete from HumanResources.Rodziny
where imie = (select imie from HumanResources.Rodziny where id=1)

------------------------------------------------------------------/Aliasy dla podzapytań/--
select *
from HumanResources.Employee as EMP
INNER JOIN Person.Person as PP
on EMP.BusinessEntityID=PP.BusinessEntityID

--/ uzycie WITH nadaje nazwe tabeli ktora jest wynikiem naszego zapytania i nadajemy jej alias czyli nazwe do ktorej odnosimy sie w drugim selekcie/--
WITH Dane_pracownikow as (
select PP.FirstName + ' ' + PP.LastName as Nowa_nazwa, EMP.BirthDate
from HumanResources.Employee as EMP
INNER JOIN Person.Person as PP
on EMP.BusinessEntityID=PP.BusinessEntityID)

select *
from Dane_pracownikow
where BirthDate<'19900101'
ORDER by BirthDate

----------------------------------------------------------/Deklaracja zmiennych lokalnych/--

select BusinessEntityID, JobTitle, HireDate
from HumanResources.Employee
where HireDate > '20090101'
ORDER by HireDate


--/zadeklarowana wartosc dla daty - declare czyli deklarowac i @ przed zmienna, set ustawia wartosc dla tej zmiennej powyzszej/--
declare @data VARCHAR(20)
set @data = '20090101'

select BusinessEntityID, JobTitle, HireDate
from HumanResources.Employee
where HireDate > @data


DECLARE @pozycja VARCHAR(40)
set @pozycja = 'Design Engineer'

select BusinessEntityID, JobTitle
from HumanResources.Employee
where JobTitle = @pozycja

-----------------------------------------------------------/Funkcje rankingu - jak wartosci wypadaja na tle innych, nie przyjmuja zadnych argumentow w nawiasie, moga byc uzywane dla liczb, dat i tekstow /--

--/rank 

select BusinessEntityID, JobTitle, VacationHours,
rank() over (order by VacationHours desc) as "Ranking wolnego"
from HumanResources.Employee

select BusinessEntityID, JobTitle, sickleavehours,
rank() over (order by sickleavehours desc) as "Ranking L4"
from HumanResources.Employee

--/ dense rank - wraz ze zdbulowanymi wartosciami

select BusinessEntityID, JobTitle, SickLeaveHours,
DENSE_RANK() over (order by sickleavehours desc) as "Ranking l4 z duplikatami"
from HumanResources.Employee

--/ row number - nie uwzglednia miejsc egzekwo wiec mimo, ze w kol sickleavehours sa te same wartosci to nadaje im inny numer w row number

select BusinessEntityID, JobTitle, SickLeaveHours,
ROW_NUMBER() over (order by sickleavehours desc) as "row number wynik"
from HumanResources.Employee

--/ ntile - potrzebuje argumentu bo dzieli zbior na czesci jaka zadeklarujemy w nawiasie np na 6

select BusinessEntityID, JobTitle, SickLeaveHours,
NTILE(6) over (order by sickleavehours desc) as "ntile wynik"
from HumanResources.Employee

select BusinessEntityID, HireDate,
DENSE_RANK() over (order by HireDate desc) as "najkrocej pracujacy"
from HumanResources.Employee

select BusinessEntityID, HireDate,
RANK() over (order by HireDate asc) as "najdluzej pracujacy"
from HumanResources.Employee

select BusinessEntityID, JobTitle,
DENSE_RANK() over (ORDER by JobTitle desc) as "pozycja wg funkcji w firmie"
from HumanResources.Employee

----------------------------------------------------------------/Transakcje w SQL 
--/ integruje kilka operacji w jedna calosc, ktora jest wykonywana w komplecie albo wcale. umozliwiqaja cofnecie operacji w tej samej bazie

--/ PRZYKLAD TRANSAKCJI przelew srodkow z jednego konta na drugie, najpierw sciagamy z konta A a potem dodajemy do konta B.

--/ponizej przyklad stworzenia dwoch tabel i dodania do nich wartosci, w transakcji i cofniecie jej:

create TABLE sales.Przyjecia
(id int, produkt varchar(50), cena int)

CREATE TABLE sales.Wydania
(id int, produkt varchar(50), cena int)

insert into Sales.Przyjecia (id, produkt, cena)
values (1, 'ciasteczko', 5)

begin TRAN --/ rozpoczecie transakcji/--
select *
from Sales.Przyjecia --/wyswietlenie tabeli/--

INSERT into Sales.Przyjecia (id, produkt, cena)  --/ dodanie pozycji do tabeli/--
values (2, 'cukierek', 1)

update Sales.Przyjecia   --/ zmiana parametru w tabeli/--
set produkt = 'pierniczek'
where id = 1

ROLLBACK TRAN  --/ cofniecie transakcji/--


---------------------------------------------------------------------------/Złączenia pionowe/--

select *
from Sales.Przyjecia

select *
from Sales.Wydania

insert into Sales.Wydania (id, produkt, cena)
values (1, 'ciasteczko', 5),
(2, 'pierniczek', 2)

select id, produkt, cena 
from Sales.Przyjecia
union   --/ klauzula UNION laczy pionowo dwie tabele tworzac jedna z suma wierszy ALE eliminuje duplikaty, wiec nie zostana one wyswietlone
SELECT id, produkt, cena 
from Sales.Wydania

select id, produkt, cena 
from Sales.Przyjecia
union ALL   --/ klauzula UNION ALL laczy pionowo dwie tabele tworzac jedna z suma wierszy WRAZ Z duplikatami
SELECT id, produkt, cena 
from Sales.Wydania

select id, produkt, cena 
from Sales.Przyjecia
INTERSECT   --/ klauzula INTERSECT laczy tabele i zwraca wszystkie duplikaty czyli wspolne elementy. 
SELECT id, produkt, cena 
from Sales.Wydania

select id, produkt, cena 
from Sales.Przyjecia
EXCEPT  --/ klauzula except laczy tabele i zwraca wszystkie rekordy z pierwszego zapytania ktore nie znajduja sie w drugim zapytania
SELECT id, produkt, cena 
from Sales.Wydania