-- Lab 1

-- 1. Ile jest produkt�w w bazie? Ile kategorii i podkategorii?

SELECT COUNT(*) FROM Production.Product;
SELECT COUNT(*) FROM Production.ProductCategory;
SELECT COUNT(*) FROM Production.ProductSubcategory;


-- 2. Wypisz produkty, kt�re nie maj� zdefiniowanego koloru.

SELECT ProductNumber 'Produkt' FROM Product	WHERE Color IS NULL;
