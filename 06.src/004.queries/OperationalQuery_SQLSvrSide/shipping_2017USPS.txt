select pkgingtype, ShipYM, count(*) AS pkgCnt from BaseInfoShippingLabels
WHERE shipdate between '2017-01-01 00:00:00' AND '2017-12-31 23:59:59'
AND ReturnLbl = 'False'
AND shiptypename like '%USPS'
group by cube(pkgingtype,ShipYM);