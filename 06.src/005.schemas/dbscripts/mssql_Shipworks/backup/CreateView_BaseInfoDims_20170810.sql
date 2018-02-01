/*View - Dimension base info*/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('DimsBaseInfo') IS NOT NULL
    DROP VIEW DimsBaseInfo;
GO

IF OBJECT_ID('BaseInfoDims') IS NOT NULL
    DROP VIEW BaseInfoDims;
GO

CREATE VIEW BaseInfoDims
AS 
select TOP 100 PERCENT orders.rollupitemSKU, orders.rollupitemQuantity, ship.totalWeight, postship.packagingtype, postship.DimsLength, postship.DimsWidth, postship.DimsHeight, count(*) AS RecordCnt
FROM dbo.PostalShipment postship JOIN dbo.Shipment ship 
		ON postship.shipmentID = ship.ShipmentID
	JOIN dbo.[order] orders ON ship.orderID = orders.orderID
	JOIN dbo.OrderItem orditem ON orders.orderID = orditem.orderID
WHERE   ship.processed = 'True' and ship.ReturnShipment = 'False'
		AND orders.rollupitemSKU IS NOT NULL
        AND LEN(RTRIM(LTRIM(orders.rollupitemSKU))) <> 0
GROUP BY orders.rollupitemSKU, orders.rollupitemQuantity, ship.totalWeight, postship.packagingtype, postship.DimsLength, postship.DimsWidth, postship.DimsHeight
ORDER BY orders.rollupitemSKU, orders.rollupitemQuantity DESC, count(*) DESC
;

