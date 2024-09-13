--/Dodawanie nowych tabel do istniejącej bazy danych/--

CREATE TABLE HumanResources.Rodzina
(id int,
imie varchar(50),
nazwisko varchar(50),
data_urodzenia date,
stopien_pokrewienstwa varchar(100),)

select * from HumanResources.Rodzina

--/dodanie kolumny/--
ALTER TABLE HumanResources.Rodzina
add kod_pocztowy varchar(6);

--/usuniecie kolumny/--
ALTER TABLE HumanResources.Rodzina
drop COLUMN kod_pocztowy;

--/zmiana nazwy tabeli/--
sp_rename 'HumanResources.Rodzina', 'Krewni'

select * from HumanResources.Krewni

--/zmiana nazwy kolumny/--

sp_rename 'HumanResources.Krewni.stopien_pokrewienstwa', 'pokrewienstwo', 'column'