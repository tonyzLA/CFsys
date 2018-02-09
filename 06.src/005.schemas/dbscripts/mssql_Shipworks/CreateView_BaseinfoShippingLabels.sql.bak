/*View - Shipping lables*/
IF OBJECT_ID('BaseInfoShippingLabels') IS NOT NULL
    DROP VIEW BaseInfoShippingLabels;
GO

CREATE VIEW BaseInfoShippingLabels
AS select ord.OrderNumberComplete AS SWsOrder#, shp.ShipmentType,shpp.Name AS ShiptypeName,
	dateadd(hour,-8,ProcessedDate) ProcessDate, dateadd(hour,-8,ShipDate) ShipDate, 
	TrackingNumber,
	CASE
	WHEN shp.shipmentType = 15 AND pstshp.PackagingType = 0 AND shp.TotalWeight < 1 THEN 'USPS First Class' 
	WHEN shp.shipmentType = 15 AND pstshp.PackagingType = 0 AND shp.TotalWeight >= 1 THEN 'USPS Priority' 
	WHEN shp.shipmentType = 15 AND pstshp.PackagingType <> 0  THEN 'USPS Priority' 
	ELSE CAST(pstshp.PackagingType AS VARCHAR(50))
	END AS PackagingType
	, 
	shp.TotalWeight,
	shp.ShipmentCost
from dbo.Shipment shp JOIN dbo.[order] ord
						ON shp.OrderID = ord.OrderID
					JOIN dbo.ShippingProfile shpp
						ON shp.ShipmentType = shpp.ShipmentType
					JOIN dbo.PostalShipment pstshp
						ON shp.ShipmentID = pstshp.ShipmentID
					
where shp.processed = 'True'
AND shp.voided <> 'True';
