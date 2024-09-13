select cast(NationalIDNumber as bigint) Nowy --/funkcja zmieniajaca rodzaj danych na zmiennoprzecinkowe/--
from HumanResources.Employee
order by NationalIDNumber 

select cast(VacationHours as float)/8, VacationHours --/funkcja zmieniajaca rodzaj danych na zmiennoprzecinkowe/--
from HumanResources.Employee

select GETDATE() as "Data i godzina teraz", --/funkcja zwracajaca date i godzine aktualna/--
cast(GETDATE() as date) as "Data aktualna"

select HireDate as "Data zatrudnienia", cast(GETDATE() as date) as "Aktualna data", --/obliczenie roznicy miedzy data zatrudnienia a dzisiejsza data (lata)/--
DATEDIFF(year,HireDate,cast(GETDATE() as date)) as "Zatrudnienie w latach"
from HumanResources.Employee

select HireDate as "Data zatrudnienia", cast(GETDATE() as date) as "Aktualna data", --/obliczenie roznicy miedzy data zatrudnienia a dzisiejsza data (miesiace)/--
DATEDIFF(month,HireDate,cast(GETDATE() as date)) as "Zatrudnienie w miesiącach"
from HumanResources.Employee

select 'Dziś jest ' + DATENAME(weekday,GETDATE()) + ', ' + CONVERT(varchar(10),GETDATE(),105) --/ciąg tekstowy z datami/--

select ISNUMERIC(BusinessEntityID) --/sprawdzenie typu danych, czy kolumna jest numeryczna/--
from HumanResources.Employee

select ISDATE(cast(HireDate as char)) --/sprawdzenie typu danych, czy kolumna jest data + zamiana kolumny HireDate na tekst/--
from HumanResources.Employee

select StartDate, ISNULL(EndDate,GETDATE()) --/dopisanie daty do End Date--/
from HumanResources.EmployeeDepartmentHistory

select JobCandidateID, isnull(cast(BusinessEntityID as char), 'Kandydat nie przyjety') as BussinessEntityID --/przeksztalcenie kolumny BusinessEntityID w tekst tam gdzie wartość wynosi NULL/--
from HumanResources.JobCandidate

SELECT BusinessEntityID, Rate, --/operacje matematyczne na kwotach/--
rate + 10,
rate - 10,
rate * 4,
rate /2
from HumanResources.EmployeePayHistory

select 350 % 200 --/reszta z dzielenia/--

select cast(3500 as float) / 1000 --/zmiana liczby 3500 na zmiennoprzecinkowa/--

select BusinessEntityID, Rate,
round(rate,2) as "Dwa miejsca po przecinku", --/zaokragla liczbe biorac pod uwage jaka liczba jest na 3 miesjcu/--
round(rate,2,2) as "Pseudozaokrąglenie" --/bierze pod uwage tylko dwa pierwsze miejsca po przecinku i reszte ucina/--
round(rate, -1) as "Zaokraglenie 1 msc po przecinku" --/zaokragla liczbe biorac pod uwage pierwsze miejsce po przecinku/--
from HumanResources.EmployeePayHistory

select BusinessEntityID, Rate,
floor(rate) as "Zaokrąglenie w dół", --/zaokraglenie wartosci z kolumny RATE w dół/--
CEILING(rate) as "Zaokrąglenie w górę" --/zaokrąglenie wartośco w kolumnu RATE w górę/--
from HumanResources.EmployeePayHistory

SELECT SUM(VacationHours)/24 as "Suma dni wolnych", SUM(VacationHours) as "Suma godzin wolnych"
FROM HumanResources.Employee

SELECT max(BirthDate) --/najwyzsza wartosc z kolumny Data urodzenia, najmlodszy pracownik/--
FROM HumanResources.Employee

SELECT min(BirthDate) --/najnizsza wartosc z kolumny Data urodzenia, najstarszy pracownik/--
FROM HumanResources.Employee

SELECT MAX(HireDate) as "Najkrócej pracujący pracownik", MIN(HireDate) as "Najdłuzej pracujący pracownik"
from HumanResources.Employee

SELECT COUNT(*) as "Liczba wierszy" --/ile jest wierszy w tabeli/--
from HumanResources.Employee

select COUNT(OrganizationLevel) as "Liczba wierszy z pominieciem wartosci NULL"
FROM HumanResources.Employee

select COUNT(DISTINCT JobTitle) --/ile jest unikatowych nazw pozycji w tabeli/--
FROM HumanResources.Employee

select SUM(OrganizationLevel)/COUNT(OrganizationLevel) as "Policzona ręcznie średnia",
AVG(OrganizationLevel) as "Średnia" --/fukcja AVG dla obliczenia średniej/--
FROM HumanResources.Employee

select AVG(VacationHours) as "średnia ilość godzin spędzonych na urlopie",
AVG(SickLeaveHours) as "średnia ilość godzin spędzonych n zwolnieniu lekarskim"
FROM HumanResources.Employee

select JobTitle as "Stanowisko" ,SUM(VacationHours)/8 as "Suma dni wolnych" --/podzielenie ilosci dni wolnych per stanowisko/--
from HumanResources.Employee
GROUP by JobTitle

SELECT TerritoryID ,AVG(SalesYTD) as "średnia wartość", MAX(SalesYTD) as "Max wartosc", MIN(SalesYTD) as "Min wartosc"
From Sales.SalesPerson
GROUP by TerritoryID