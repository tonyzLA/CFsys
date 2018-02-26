select SWsOrder#,ProcessDate,CONCAT('#',TrackingNumber) as TrackingNo,PackagingType,ShipmentCost from baseinfoshippinglabels
where shipmenttype = 15
AND ProcessDate BETWEEN '2017-01-01 00:00:01' AND '2017-03-31 23:59:59'
ORDER BY ProcessDate;