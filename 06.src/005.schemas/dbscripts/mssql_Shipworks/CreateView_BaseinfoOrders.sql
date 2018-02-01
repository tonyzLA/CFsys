/*View - order(order items) base info*/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('BaseInfoOrders') IS NOT NULL
    DROP VIEW BaseInfoOrders;
GO

CREATE VIEW BaseInfoOrders
AS 
SELECT TOP 100 PERCENT st.StoreName AS 'Store', o.OrderNumberComplete AS "shipworkOrderNo", 
	ISNULL(eo.SellingManagerRecord,0) AS "eBayOrderNo", 
	ISNULL(ao.AmazonOrderID, 0) "AmazonOrderNo", o.OrderDate,
    s.ShipDate, s.voided, s.trackingNumber, s.ReturnShipment, 
    oi.Name, oi.SKU,oi.Quantity, 
    o.BillEmail,
    o.Shipfirstname, o.shiplastname,o.shipStreet1, o.shipcity, o.ShipStateProvCode, o.ShipPostalCode,
    ps.Memo1, s.ProcessedDate, upro.Username AS "ProcessedUser",cpro.Name AS "ProcessedComputer",
    s.VoidedDate, uvoid.Username AS "VoidedUser",cvoid.Name AS "VoidedComputer"
from dbo.[order] o LEFT JOIN dbo.shipment s 
		ON o.OrderID = s.orderID
    JOIN dbo.OrderItem oi
        ON o.OrderID = oi.OrderID
	JOIN dbo.store st
		ON o.storeID = st.storeID
    LEFT JOIN dbo.PostalShipment ps
        ON s.ShipmentID = ps.ShipmentID
	LEFT JOIN dbo.EbayOrder eo
		ON o.orderID = eo.orderID
	LEFT JOIN dbo.AmazonOrder ao
		ON o.orderID = ao.orderID
    LEFT JOIN dbo.[User] upro
        ON s.ProcessedUserID = upro.UserID 
    LEFT JOIN dbo.[User] uvoid
        ON s.VoidedUserID = uvoid.UserID
    LEFT JOIN dbo.Computer cpro
        ON s.ProcessedComputerID = cpro.ComputerID 
    LEFT JOIN dbo.Computer cvoid
        ON s.VoidedComputerID = cvoid.ComputerID
ORDER BY o.OrderNumberComplete, OrderDate;

