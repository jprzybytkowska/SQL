
--/Łączenie tabel po przez filtrowanie czyli WHERE./--
select EDP.BusinessEntityID,ZM.Name
from HumanResources.EmployeeDepartmentHistory as EDP,HumanResources.Shift as ZM
where EDP.ShiftID=ZM.ShiftID
order by BusinessEntityID;

--/Łączenie tabel po przez INNER JOIN/--
select EDP.BusinessEntityID,ZM.Name
from HumanResources.EmployeeDepartmentHistory as EDP
INNER JOIN HumanResources.Shift as ZM on EDP.ShiftID=ZM.ShiftID
order by BusinessEntityID;


select EDP.BusinessEntityID,ZM.Name,PP.FirstName, PP.LastName
from HumanResources.EmployeeDepartmentHistory as EDP
INNER JOIN HumanResources.Shift as ZM on EDP.ShiftID=ZM.ShiftID
INNER JOIN Person.Person as PP on PP.BusinessEntityID=EDP.BusinessEntityID
order by LastName;

--/operacja która łączy wiersze z dwóch lub więcej tabel na podstawie wspólnego kryterium. 
--/Innymi słowy, INNER JOIN zwraca wiersze z każdej tabeli, gdy istnieje dopasowanie między określonymi kolumnami obu tabel
select HRE.OrganizationNode, PD.*
from HumanResources.Employee as HRE
INNER JOIN Production.Document as PD on HRE.OrganizationNode=PD.DocumentNode

--/left join, right join, cross join/--

--/mamy wszystkie wartości z pierwszej tabeli ("lewej") i te, które udało się połączyć z drugiej ("prawej"), w przypadku braku zlaczenia mamy NULL/--
select HRE.OrganizationNode, PD.*
from HumanResources.Employee as HRE
LEFT JOIN Production.Document as PD on HRE.OrganizationNode=PD.DocumentNode

--/zwraca wszystkie wiersze z drugiej tabeli ("prawej") i pasujące wiersze z lewej ("pierwszej)"). Podobnie, jeśli nie ma dopasowania, wynikiem po stronie lewej jest NULL./--
select HRE.OrganizationNode, PD.*
from HumanResources.Employee as HRE
RIGHT JOIN Production.Document as PD on HRE.OrganizationNode=PD.DocumentNode

--/po połączeniu dwóch tabel otrzymujemy jedną, gdzie mamy wszystkie wszystkie możliwe kombinacje z obu tabel/--
select HRE.OrganizationNode, PD.*
from HumanResources.Employee as HRE
FULL JOIN Production.Document as PD on HRE.OrganizationNode=PD.DocumentNode

--/iloczyn kartezjanski obu tabel, mnozymy wiersze przez siebie/--
select HRE.OrganizationNode, PD.*
from HumanResources.Employee as HRE
CROSS JOIN Production.Document as PD

--/Podzapytania/--
--/zagniezdzanie
select *
from HumanResources.Employee
where SickLeaveHours>= (select SickLeaveHours
                        from HumanResources.Employee
                        where JobTitle='Chief Executive Officer');

select BusinessEntityID, VacationHours
from HumanResources.Employee
where VacationHours>(select VacationHours
                        from HumanResources.Employee
                        where BusinessEntityID=21)
                        and MaritalStatus=(select MaritalStatus
                            from HumanResources.Employee
                            where BusinessEntityID = 21)


select BusinessEntityID, VacationHours, JobTitle 
from HumanResources.Employee
where VacationHours<(select AVG(VacationHours)
                        from HumanResources.Employee)

select *
from (select BusinessEntityID, SickLeaveHours
        from HumanResources.Employee) as Podzapytanie
where SickLeaveHours BETWEEN 30 and 65

--/Podzapytania wielowiersoze (oeratory in, any, all)/--

--/ in = rowne dowolnemu elementowi z listy wartosci 
--/ any = musi byc poprzedzony operatorem -> mniejszy, wiekszy, mniejszy badz rowny, wiekszy badz rowny itp... porownuje wartosci z kazdym z elementow z listy, zwroci false jak zaden element nie zostanie dopasowany
--/all = musi byc poprzedzony operatorem matematycznym jak ANY, zwraca false jak po porownaniu nie zwroci zadnego wiersza 

select distinct NumberEmployees
from Sales.vStoreWithDemographics
where YearOpened = '1990'
order by NumberEmployees

select Name, AnnualSales, YearOpened, NumberEmployees
from sales.vStoreWithDemographics
where NumberEmployees in (select distinct NumberEmployees  --/distinct by zwrocic wartosc unikatowa dla numberemployess/--
                            from Sales.vStoreWithDemographics
                            where YearOpened = '1990')
and YearOpened <> '1990'
order by NumberEmployees

select Name, AnnualSales, YearOpened, NumberEmployees
from sales.vStoreWithDemographics
where NumberEmployees < ANY (select distinct NumberEmployees  --/podzapytanie szuka tylko wartosci mniejsze od 76, poniewaz zapis "< any" szuka po tabeli sklepow ktorej liczba pracownikow bedzie mniejsza od najwyzszej wartosci liczby pracownikow czyli 76/--
                            from Sales.vStoreWithDemographics
                            where YearOpened = '1990')
and YearOpened <> '1990'
order by NumberEmployees

select Name, AnnualSales, YearOpened, NumberEmployees
from sales.vStoreWithDemographics
where NumberEmployees < ALL (select distinct NumberEmployees  --/podzapytanie szuka wartosci gdzie beda mniejsze od 9 bo szuka od najmniejszej wartosci w tabeli pracownikow gdzie najmniejsza wartosc to 9/--
                            from Sales.vStoreWithDemographics
                            where YearOpened = '1990')
and YearOpened <> '1990'
order by NumberEmployees