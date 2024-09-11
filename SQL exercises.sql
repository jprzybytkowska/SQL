--/Zadania SQL/--

--/Zad.1. Wyświetl tabele HumanResources.Employee i posortuj po kolumnie JobTitle rosnąco.

select *
from HumanResources.Employee
order by JobTitle

--/Zad.2. Wybierz tabele Person.Person i pokaz wszystkie BusinessEntityID oraz LastName. Nadaj alias pierwszej kolumnie id_praconika a calosc zapytania przesortuj wg drugiej kolumny rosnaco.

select BusinessEntityID as 'id_pracownika', LastName
from Person.Person
order by LastName

--/Zad.3. wybierz tabele Person.Person i pokaz wszystkie BusinessEntityID oraz LastName, dodaj warunek mowiacy ze kolumna Title nie moze zawierac wartosci null. Nadaj alias pierwszej kolumnie 'id/-pracownika' aa calosc zapytania posortuj wg drugiej kolumny rosnaco.

select BusinessEntityID as 'id_pracownika', LastName
from Person.Person
where Title is not null
order by LastName

--/zad.4. z tabeli sales.salesorderheader wyciagnij liste unikatowych wartosci customerid oraz oblicz wartosc frachtu dla kazdego klienta (zagregowanej kolumnie nadaj alias). wynik posortuj rosnaco wg kolumny customerid

select customerid, sum(Freight) as sum_freight
from Sales.SalesOrderHeader
group by CustomerID
order by CustomerID

--/zad.5. z tabeli sales.salesorderheader wyciagnij liste zawierajaca customerid, salespersonid oraz sume i srednia z kolumny subtotal dla kazdej kombinacji klienta i sprzedawcy. calosc posortuj rosnaco wedlug customerid.

SELECT CustomerID, SalesPersonID, sum(SubTotal) as suma_subtotal, AVG(SubTotal) as srednia_subtotal
from Sales.SalesOrderHeader
GROUP by CustomerID, SalesPersonID
order by CustomerID desc

---Modul 2.
--zad. 1. z tabeli production.productinventory wyswietl:
--/ sume z quantity dla kazdego produktu ktory znajduje sie na polkach shelf a,c,h.
--/ wyfiltruj wyniki gdzie suma jest wieksza niz 500. wyswiel tylko sume z quantity oraz productid
--/ posortuj calosc wg productid malejaco

select ProductID, SUM(Quantity) as suma
from Production.ProductInventory
where Shelf in ('A', 'C', 'H')
GROUP by ProductID
having sum(Quantity)>500
order by ProductID desc

--zad.2. z tabel person.person i person.personphone wyswietl bussinesentityid, firstname, lastname, phonenumber.
--/wyswietl tylko osoby ktorych nazwisko naczyna sie od litery k,
--/posortuj calosc rosnaco wg imienia oraz nazwiska
--/zwroc uwage na to, ze musisz wykonac polaczenie miedzy tabelami.


select pp.BusinessEntityID, FirstName, LastName, PhoneNumber as tel_prac
from Person.Person as PP
join Person.PersonPhone as PPH
on pp.BusinessEntityID = pph.BusinessEntityID
where LastName like 'k%'
order by LastName, FirstName

--/zad.3. z tabeli person.businessentityaddress oraz z tabeli person.address policz ilu pracownikow zamieszuje kazde z miast. Wylistuj miasta i liczbe pracownikow. calosc posortuj rosnaco.

select pa.City, count(BusinessEntityID) as suma_pracownikow
from Person.Address as PA
inner join Person.BusinessEntityAddress as PBEA
on PBEA.AddressID=PA.AddressID
GROUP by City
order by City

--/zad.4. z tabeli sales.salesorderdetail wygeneruj liste sume wartosci zamowien. Podpowiedz; wartosc zamowienia to iloraz liczby sztuk oraz kosztu. calosc zgrupuj wedlug id zamowienia, posortuj wg tej samej wartosci malejaco

select *
from Sales.SalesOrderDetail
--/wersja 1
SELECT SalesOrderID, sum(LineTotal) as suma_wartosci_zamowienia
from Sales.SalesOrderDetail
GROUP by SalesOrderID
ORDER by SalesOrderID asc
--wersja 2
SELECT SalesOrderID, sum(OrderQty * UnitPrice) as suma_wartosci_zamowienia
from Sales.SalesOrderDetail
GROUP by SalesOrderID
ORDER by SalesOrderID asc

--/Modul 3
--zad 1. z tabeli production.product wybierz kolumny productid, name, color i wyswietl raport;
--pokaz wszystkie produkty majace jakas wartosc w kolumnie color,
--posortuj wg koloru i ceny.


select ProductID, Name, Color
from Production.Product
where Color is not NULL
order by Color, ListPrice

--zad.2. z tabeli person.person wybierz kolumny lastname i firstname. wybierz osoby ktorych imie zaczyna sie od litery R. Posortuj rosnaco wg kolumny z lastname.

select FirstName, LastName
from Person.Person
where FirstName like 'r%'
order by FirstName asc, LastName desc

--zad.3. z tabeli sales.vsalesperson wyswietl kokumny bussinessentityid, lastname, territoryname, countryregionname
--na ich podstawie zbuduj raport wyswietlajacy wartosci w kolejnosci wedlug kolumny territoryname, gdy kolumna countryregionanme jest rowna 'stany zjednoczone'
--oraz wedlug countryregionanme dla wszystkich pozostalych wierszy.

select BusinessEntityID, LastName, TerritoryName, CountryRegionName
from Sales.vSalesPerson
where TerritoryName is not null 
order by case CountryRegionName when 'United States' then TerritoryName else CountryRegionName end 


--zad. 4. Z tabeli humanResources.department wyswietl kolumny departmentid, name, groupname. Nastepnie zbuduj raport ktory posortuje wynik wg departmentid pomijajc 5 pierwszych wierszy. 

select DepartmentID, Name, GroupName
from HumanResources.Department
ORDER by DepartmentID
OFFSET 5 ROWS

--Modul 4
--zad.1. z tabeli production.product oraz sales.salesorderdetail wyswietl raport w ktorym polaczysz tabele wg kolumn salesorderdetail oraz productid. Jako rezultat pokaz raport zawierajacy nazwe produktu oraz salesorderid

select * 
FROM Production.Product

select *
from Sales.SalesOrderDetail

select PP.Name, SSOD.SalesOrderID
from Production.Product as PP
join Sales.SalesOrderDetail as SSOD
on PP.ProductID=SSOD.ProductID
ORDER by PP.Name

--/Zad.2. Z tabeli person.address oraz person.stateprovince stworz raport ktory wyswietli adres korespondencyjny dowolnej firmy znajdujacej sie poza US i w miescie ktorego nazwa zaczyna sie na "Pa".
--/zwróc kolumny: addressline1, addressline2, city, postalcode, countryregioncode

select *
from Person.Address

select *
from Person.StateProvince

select PA.AddressLine1, PA.AddressLine2, PA.City, PA.PostalCode, PSP.CountryRegionCode
from Person.Address as PA
join Person.StateProvince as PSP
on PA.StateProvinceID=PSP.StateProvinceID
where PA.City like 'Pa%' and PSP.CountryRegionCode != 'US'