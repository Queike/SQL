-- Lab 1

-- 1. Ile jest produktów w bazie? Ile kategorii i podkategorii?

SELECT COUNT(*) 'Liczba produktow' FROM AdventureWorks2014.Production.Product;
SELECT COUNT(*) 'Liczba kategorii' FROM AdventureWorks2014.Production.ProductCategory;
SELECT COUNT(*) 'Liczba podkategorii' FROM AdventureWorks2014.Production.ProductSubcategory;


-- 2. Wypisz produkty, które nie maj¹ zdefiniowanego koloru.

SELECT ProductNumber 'Nr produktu', Name 'Nazwa' 
	FROM AdventureWorks2014.Production.Product
		WHERE Color IS NULL;


-- 3. Podaj roczny obrót sklepu w poszczególnych latach.

SELECT YEAR(OrderDate) 'Rok', SUM(TotalDue - TaxAmt) 'Obrot'
	FROM AdventureWorks2014.Sales.SalesOrderHeader
	GROUP BY YEAR(OrderDate)
	ORDER BY 1;

-- 4. Ilu jest klientów, a ilu sprzedawców w sklepie?

SELECT COUNT(*) 'Liczba klientow' FROM AdventureWorks2014.Sales.Customer;
SELECT COUNT(*) 'Liczba sprzedawcow' FROM AdventureWorks2014.Sales.SalesPerson;


-- 5. Ile by³o wykonanych transakcji w poszczególnych latach?

SELECT COUNT(*) 'Liczba transakcji', YEAR(TransactionDate) "Rok"
FROM (
	SELECT TransactionID, TransactionDate 
		FROM AdventureWorks2014.Production.TransactionHistory
	UNION
	SELECT TransactionID, TransactionDate 
		FROM AdventureWorks2014.Production.TransactionHistoryArchive) temp
GROUP BY YEAR(TransactionDate);


-- 6. Podaj produkty, które nie zosta³y kupione przez ¿adnego klienta. Zestawienie pogrupuj wed³ug kategorii.

SELECT pc.Name 'Nazwa kategorii', COUNT(p.ProductID) 'Liczba produktow'
	FROM AdventureWorks2014.Production.Product p LEFT JOIN AdventureWorks2014.Production.ProductSubcategory ps
		ON p.ProductSubcategoryID = ps.ProductSubcategoryID
			LEFT JOIN AdventureWorks2014.Production.ProductCategory pc
				ON ps.ProductCategoryID = pc.ProductCategoryID
					LEFT JOIN AdventureWorks2014.Sales.SalesOrderDetail sod
						ON p.ProductID = sod.ProductID
WHERE sod.SalesOrderID IS NULL
GROUP BY pc.Name;

SELECT p.ProductID, Name
FROM AdventureWorks2014.Production.Product p LEFT JOIN AdventureWorks2014.Sales.SalesOrderDetail sod
ON p.ProductID = sod.ProductID  
WHERE SalesOrderID IS NULL
ORDER BY p.ProductSubcategoryID


SELECT p.ProductID 'Id produktu', p.Name 'Nazwa produktu', pc.Name 'Kategoria'
FROM AdventureWorks2014.Production.Product p LEFT JOIN AdventureWorks2014.Sales.SalesOrderDetail s ON p.ProductID = s.ProductID 
	  JOIN AdventureWorks2014.Production.ProductSubcategory ps ON ps.ProductSubcategoryID = p.ProductSubcategoryID
	  JOIN AdventureWorks2014.Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
WHERE SalesOrderID IS NULL
ORDER BY pc.Name;


-- 7. Oblicz minimaln¹ i maksymaln¹ kwotê rabatu udzielonego na produkty w poszczególnych podkategoriach.

SELECT ps.Name 'Podkategoria',
	MIN(UnitPriceDiscount * UnitPrice) 'Min rabat', 
	MAX(UnitPriceDiscount * UnitPrice) 'Max rabat'
FROM AdventureWorks2014.Sales.SalesOrderDetail sod JOIN AdventureWorks2014.Production.Product p 
ON p.ProductID = sod.ProductID
JOIN AdventureWorks2014.Production.ProductSubcategory ps
ON p.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE UnitPriceDiscount != 0
GROUP BY ps.Name;

-- 8. Podaj produkty, których cena jest wy¿sza od œredniej ceny produktów w sklepie.

SELECT * FROM AdventureWorks2014.Production.Product
WHERE ListPrice > 
	(SELECT AVG(ListPrice)
	FROM AdventureWorks2014.Production.Product)

-- 9. Ile œrednio produktów sprzedaje siê w poszczególnych miesi¹cach?

SELECT AVG(Suma) 'Srednia sprzedaz', Miesiac
FROM (
	SELECT SUM(OrderQty) "Suma", MONTH(OrderDate) 'Miesiac'
	FROM AdventureWorks2014.Sales.SalesOrderHeader soh LEFT JOIN AdventureWorks2014.Sales.SalesOrderDetail sod
	ON soh.SalesOrderID = sod.SalesOrderID
	GROUP BY MONTH(OrderDate), YEAR(OrderDate)) temp
GROUP BY Miesiac;

-- 10. Ile œrednio czasu klient czeka na dostawê zamówionych produktów? Przygotuj zestawienie w zale¿noœci od pañstwa.

SELECT AVG(DATEDIFF(day, OrderDate, DueDate)) 'Sredni czas', CountryRegionCode 'Panstwo'
FROM AdventureWorks2014.Sales.SalesOrderHeader soh LEFT JOIN AdventureWorks2014.Sales.SalesTerritory st
ON soh.TerritoryID = st.TerritoryID
GROUP BY CountryRegionCode;