-- Get all Business Entities

SELECT *

FROM Person.BusinessEntity AS [EveryEntityID]

	-- Add Address Reference of Business Entity
	LEFT JOIN Person.BusinessEntityAddress AS [BusinessAddressRef]
	ON [EveryEntityID].BusinessEntityID = [BusinessAddressRef].BusinessEntityID

	-- Add Contact of Business Entity. Filter Out Non Business Contacts
	RIGHT JOIN Person.BusinessEntityContact AS [BusinessContact]
	ON [EveryEntityID].BusinessEntityID = [BusinessContact].BusinessEntityID

	-- Add Address Location of Business Entity
	LEFT JOIN Person.Address AS [BusinessAddress]
	ON [BusinessAddressRef].AddressID = [BusinessAddress].AddressID
