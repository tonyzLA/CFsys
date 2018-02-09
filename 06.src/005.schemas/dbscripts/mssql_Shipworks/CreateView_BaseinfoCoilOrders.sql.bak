/*View - sales info of ignition coils*/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('BaseInfoCoilSales') IS NOT NULL
    DROP VIEW BaseInfoCoilSales;
GO

CREATE VIEW VIEW BaseInfoCoilSales
AS select  sto.storename,
		ord.ordernumbercomplete AS SWOrderNo,
		ISNULL(eo.SellingManagerRecord,ao.AmazonOrderID) AS ebayAmazonOrderNo,
		DATEADD(hour,-8,ord.OrderDate) AS OrderDateTime,
		shpmt.ShipDate,shpmt.ShipFirstName, shpmt.ShipLastName,
        shpmt.ShipStreet1,shpmt.ShipCity,shpmt.ShipStateProvCode,shpmt.ShipPostalCode,shpmt.ShipCountryCode,
		ori.Name AS ITEMNAME,        
        ori.SKU,
        ISNULL(skupt.partno,LTRIM(RTRIM(RIGHT(ord.RollupItemName,6)))) PartNo,
        ori.UnitPrice,
        ori.quantity,
        (ori.UnitPrice * ori.quantity) AS Total,
        shpmt.ShipmentCost,
        Orc.Amount AS SalesTax,
        (ori.UnitPrice * ori.quantity - ShipmentCost - Orc.Amount) AS NetAmount
from dbo.[Order] ord LEFT JOIN dbo.OrderItem ori
        				ON ord.OrderID = ori.OrderID 
                    LEFT JOIN (SELECT OrderID,[Type],Description,Amount FROM dbo.OrderCharge WHERE TYPE = 'TAX') orc    
                        ON ord.OrderID = orc.OrderID
					LEFT JOIN dbo.EbayOrder eo
						ON ord.orderID = eo.orderID
					LEFT JOIN dbo.AmazonOrder ao
						ON ord.orderID = ao.orderID
        			LEFT JOIN (SELECT DISTINCT sku, partno FROM dbo.baseinfoSKUPartNO WHERE itemname LIKE '%COIL%') skupt
        				ON ori.SKU = skupt.SKU 
        			LEFT JOIN dbo.store sto
        				ON ord.storeID = sto.storeID
        			JOIN dbo.Shipment shpmt
        				ON ord.OrderID = shpmt.OrderID
where ori.Name LIKE '%COIL%'
AND ord.OnlineStatus <> 'Cancelled'
AND shpmt.ProcessedDate IS NOT NULL;
