/*View - order base info*/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('orderBaseInfo') IS NOT NULL
    DROP VIEW orderBaseInfo;
GO

IF OBJECT_ID('BaseInfoOrders') IS NOT NULL
    DROP VIEW BaseInfoOrders;
GO

CREATE VIEW BaseInfoOrders
AS 
SELECT TOP 100 PERCENT st.StoreName, o.OrderNumberComplete AS "shipworkOrder#", o.rollupitemSKU, ps.packagingtype,s.ShipDate, o.Shipfirstname, o.shiplastname,o.shipStreet1, o.shipcity, o.ShipStateProvCode, o.ShipPostalCode
from dbo.shipment s JOIN [order] o
		ON s.orderID = o.OrderID
	JOIN dbo.store st
		ON o.storeID = st.storeID
    JOIN dbo.postalshipment ps
        ON s.shipmentID = ps.shipmentID
ORDER BY s.ShipDate;

