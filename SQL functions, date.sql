--/Kolumna warunkowa / warunki w SQL/--

select Name,
case name when 'French' then 'Francuski' --/nadanie nazw wskazanym frazom w konkretnej kolumnie/--
when 'Spanish' then 'Hiszpański'
when 'Thai' then 'Tajski'
when 'Hebrew' then cast(GETDATE() as char) --/konwertowanie z wartosci liczbowej daty na tekstowa, bo wszystkie wartosci musza miec taki sam typ/--
end as "Nazwa języka po polsku" --/nazwa kolumny/--
from Production.Culture

SELECT BusinessEntityID, MaritalStatus, VacationHours, --/jezeli MaritalStatus = M to dodaj 8h do VacationHours, jezeli jest S to wyswietl VacationHours/--
case MaritalStatus when 'M' then VacationHours + 8
else VacationHours --/else oznacza jezeli, wiec jezeli nie M, to wyswietl VacationHours/--
end as "Liczba wolnych godzin po bonusie"
from HumanResources.Employee

select [Description], DiscountPct, --/dodanie kolumny opisujacej rozmiar promocji/--
case
when DiscountPct <=0.1 then 'mała'
when DiscountPct <=0.2 then 'średnia'
when DiscountPct <=0.35 then 'super'
when DiscountPct <=0.45 then 'skandalicznie niska cena'
else 'taniej juz nie bedzie'
end as "Opis promocji"
from sales.SpecialOffer

SELECT BusinessEntityID, Gender, SickLeaveHours, --/dodanie kolumny warunkowej, gdzie okreslamy czy osoby ze wzgledu na plec i ilosc dni na L4 sa zdrowi czy nalezy te osoby wyslac na badania/--
case
when Gender = 'M' and SickLeaveHours <= 40 then 'Zdrów jak ryba'
when Gender = 'F' and SickLeaveHours <= 30 then 'Zdrowa jak ryba'
else 'wysłać na badania BHP'
end as "Opis stanu zdrowia"
from HumanResources.Employee

--/Funkcje tekstowe/--

select right('Lubię SQL',1) as 'Prawy 1' --/wyświetlenie jednego znaku z prawej strony (funkcja 'right') z frazy 'Lubię SQL'/--

select left('Lubię SQL',1) as 'Lewy 1' --/wyświetlenie jednego znaku z lewej strony (funkcja 'left' z frazy 'Lubię SQL'/--

select lower('Lubię SQL') as 'Male litery' --/wyświetlenie frazy 'Lubię SQL' z małych liter za pomoca funkcji 'lower'/--

select upper('Lubię SQL') as 'Duze litery' --/wyświetlenie frazy 'Lubię SQL' z duzych liter za pomoca funkcji 'upper'/--

select SUBSTRING('Lubię SQL',3,4) as 'Fragment tekstu' --/wyświetlenie fragmentu frazy za pomoca funkcji 'Substring'. W nawiasie mamy fraze, ktora chcemy wyswietlic, numer znaku od ktorego ma zaczac wyswietlanie i ilosc znakow do wyswietlenie z frazy/--

select LEN('Lubię SQL') as 'Długosc tekstu' --/Funkcja 'Len' okresla ilosc znaków w podanej frazie w nawiasie/--

select CHARINDEX('e', 'Lubię ten SQL', 6) as 'Pozycja znaku w tekscie'  --/funkcja ktora mowi na jakiej pozycji jest wyszukiwany znak w podanym tekscie/--

select REVERSE('Lubię SQL') as 'Odrocony tekst'  --/odwrocenie kolejnosci znakow w tekscie podanym/--

select REPLACE('Lubię bardzo ekstremalnie SQL', 'bardzo', 'super') as 'zmiana wyrazu'  --/podmiana wskazanego wyrazenia na inne, najpierw jest tekst bazowy, druga wartosc to wartosc ktora chcemy zamienic, trzecia wartosc to ta na ktora chcemy zamienic/--

select REPLICATE('Lubie SQL ', 2) as 'Zwielokrotnienie' --/zwielokrotnienie frazy, podajemy ile razy/--

select LTRIM('  Lubie SQL   ') as 'usuniecie zbędnych odstępów' --/usuniecie zbednych odstepow (spacje wiodace i z konca)/--

select STUFF('Lubie SQL', 3, 2, 'Bardzo') as 'Podmiana frazy' --/funckja stuff z podanej frazy usuwa od wskazanego miejsca np 3ciego, wskazana ilosc znaków np 2 znaki do zastapienia i w to miejsce dodaje fraze podana na koncu np bardzo./--

--/Daty/--

set Dateformat dmy; --/zmiana formatu daty na: europejski (dmy), amerykanski (mdy)/--
select MONTH('12-02-2023') as 'miesiac', day('12-02-2023') as 'dzien', year('12-02-2023') as 'rok'  --/funkcje month, day, year do wyciagania z daty tylko tej konkretnej wartosci daty ktora nas interesuje (amerykanski format)/--

select DATEDIFF(DAY, '1994-08-31', GETDATE()) as 'Ile mam lat'

select DATEADD(day, 10, GETDATE()) as 'data za 10 dni'  --/dodanie wartosci do daty. Podajemy najpierw format czyli w jakim wymierze chcemy wynik; dni, miesiace, lata, ile dodac do daty np 10, do jakiej wartosci - getdate to wartosc ruchoma, zawsze pobiera biezaca date/--

select DATEPART(WEEKDAY, GETDATE()) as 'dzien tygodnia' --/ pokazujemy czesc daty, nalezy wskazac co chcemy wyswietlic np dzien tygodnia, od jakiej daty/--

select DATENAME(WEEKDAY, GETDATE()) as 'dzien tygodnia slownie' --/pokazujemy dzien tygodnia ale slownie/--

select 
    DAY(GETDATE()) as 'dzien', 
    MONTH(GETDATE()) as 'miesiac', 
    YEAR(GETDATE()) as 'rok', 
    DATENAME(WEEKDAY, GETDATE()) as 'dzien tygodnia slownie'

select DATEFROMPARTS(2020,09,30) as 'data'