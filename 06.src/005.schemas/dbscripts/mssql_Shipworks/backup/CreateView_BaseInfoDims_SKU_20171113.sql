/*View - DIMENSIONS base info*/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('BaseInfoDims_SKU') IS NOT NULL
    DROP VIEW BaseInfoDims_SKU;
GO

CREATE VIEW BaseInfoDims_SKU
AS 
select TOP 100 PERCENT orders.rollupitemSKU, orders.rollupitemQuantity, ship.totalWeight, postship.packagingtype, postship.DimsLength, postship.DimsWidth, postship.DimsHeight, count(*) AS RecordCnt
FROM dbo.PostalShipment postship JOIN dbo.Shipment ship 
		ON postship.shipmentID = ship.ShipmentID
	JOIN dbo.[order] orders ON ship.orderID = orders.orderID
	JOIN dbo.OrderItem orditem ON orders.orderID = orditem.orderID
WHERE   ship.processed = 'True' 
        AND ship.ReturnShipment = 'False'
        AND ship.voided = 'False'
        AND postship.Memo1 <> 'Warranty'
		AND orders.rollupitemSKU IS NOT NULL
        AND LEN(RTRIM(LTRIM(orders.rollupitemSKU))) <> 0
GROUP BY orders.rollupitemSKU, orders.rollupitemQuantity, ship.totalWeight, postship.packagingtype, postship.DimsLength, postship.DimsWidth, postship.DimsHeight
ORDER BY orders.rollupitemSKU, orders.rollupitemQuantity DESC, count(*) DESC