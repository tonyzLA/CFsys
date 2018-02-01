/*View - DIMENSIONS base info*/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('BaseInfoDims') IS NOT NULL
    DROP VIEW BaseInfoDims;
GO

CREATE VIEW BaseInfoDims
AS 
select TOP 100 PERCENT skuprt.partno, orders.rollupitemQuantity, ship.totalWeight, postship.packagingtype, postship.DimsLength, postship.DimsWidth, postship.DimsHeight, count(*) AS RecordCnt
FROM dbo.PostalShipment postship JOIN dbo.Shipment ship 
		ON postship.shipmentID = ship.ShipmentID
	JOIN dbo.[order] orders ON ship.orderID = orders.orderID
	JOIN dbo.OrderItem orditem ON orders.orderID = orditem.orderID
    JOIN dbo.BaseInfoSKUPartNo skuprt ON orders.rollupitemSKU = skuprt.SKU
WHERE   ship.processed = 'True' 
        AND ship.ReturnShipment = 'False'
        AND ship.voided = 'False'
        AND postship.Memo1 <> 'Warranty'
		AND orders.rollupitemSKU IS NOT NULL
        AND LEN(RTRIM(LTRIM(orders.rollupitemSKU))) <> 0
GROUP BY skuprt.partno, orders.rollupitemQuantity, ship.totalWeight, postship.packagingtype, postship.DimsLength, postship.DimsWidth, postship.DimsHeight
ORDER BY skuprt.partno, orders.rollupitemQuantity DESC, count(*) DESC