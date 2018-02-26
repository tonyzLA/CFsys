CREATE OR REPLACE VIEW ValidShippingRecs_V
AS 
SELECT ShippingID, OrderPatchNumber, TrackingNumber, ShippingLineNo, PartNumber, Quantity, OperatorID, DATE(PackDate) PackDateShorten, PackDate, ShippingDate, ValidFlag 
FROM Shipping JOIN shippinglines USING (ShippingID)
WHERE Shipping.ValidFlag <> 0;

CREATE OR REPLACE VIEW ValidShippingCnt_V
AS 
SELECT DATE(PackDate) PackDateShorten, OrderPatchNumber, count(*) AS PackageCnt
FROM Shipping
WHERE Shipping.ValidFlag <> 0
GROUP BY DATE(PackDate), OrderPatchNumber WITH ROLLUP;


CREATE OR REPLACE VIEW AllShippingRecs_V
AS 
SELECT ShippingID, OrderPatchNumber, TrackingNumber, ShippingLineNo, PartNumber, Quantity, OperatorID, DATE(PackDate) PackDateShorten, PackDate, ShippingDate, ValidFlag
FROM Shipping JOIN shippinglines USING (ShippingID);

DROP VIEW PackingLst_Inf_V;
CREATE OR REPLACE VIEW PackingLst_Inf_V
AS SELECT PatchNo, PatchDesc, PalletNo, PartNumber, CateCode, CategoryName, SupplierName,ArriveDate, Quantity,ShelfCode, Remarks
FROM cfsys.Packinglists JOIN cfsys.PartCategory USING (CateCode)
        JOIN cfsys.Suppliers USING (SupplierCode);

DROP VIEW PackingDims_Inf_V;
CREATE OR REPLACE VIEW PackingDims_Inf_V
AS 
SELECT pds.SKU, pds.Quantity, pds.PackagingType, pts.Packaging, 
        pds.TotalWeight, pds.DimsLength, pds.DimsWidth, pds.DimsHeight
FROM cfsys.PackingDims pds JOIN cfsys.PackagingTypes pts USING(PackagingType)
;

DROP VIEW OrderTracking_V;
CREATE OR REPLACE VIEW OrderTracking_V
AS 
SELECT bio.Store,bio.shipworkOrderNo, bio.eBayOrderNo, 
bio.AmazonOrderNo, bio.ShipDate, bio.voided, 
bio.trackingNumber, bio.ReturnShipment, 
bio.Name, bio.SKU,bio.Quantity,
bio.Shipfirstname, bio.Shiplastname,bio.shipStreet1,
bio.shipcity, bio.ShipStateProvCode, bio.ShipPostalCode, 
bio.Memo1
FROM cfsys.baseinfoorders bio
;

/*to see if this view is necessary @ 10/23/2017*/
DROP VIEW WartyRtn_V;
CREATE OR REPLACE VIEW WartyRtn_V
AS 
select  base1.*
from baseinfoorders base1,
(select base2.shipworkOrderNo, base2.eBayOrderNo, base2.AmazonOrderNo, base2.Shipfirstname, base2.shiplastname, count(*) AS shippingCnt
from baseinfoorders base2
where base2.voided = 'false'
group by base2.shipworkOrderNo, base2.eBayOrderNo, base2.AmazonOrderNo, base2.Shipfirstname, base2.shiplastname
having shippingCnt > 1) base3
where base3.shipworkOrderNo = base1.shipworkOrderNo
and base3.eBayOrderNo = base1.eBayOrderNo
and base3.AmazonOrderNo = base1.AmazonOrderNo
and base3.Shipfirstname = base1.Shipfirstname
and base3.shiplastname = base1.shiplastname;

DROP VIEW SetsDef_V;
CREATE OR REPLACE VIEW SetsDef_V
AS 
SELECT ss.SetNumber,
       ss.PartNumber, 
       ss.Quantity,
       ss.CreateDate
FROM cfsys.Sets ss
;

DROP VIEW PartNumberMatrix_V;
CREATE OR REPLACE VIEW PartNumberMatrix_V
AS 
SELECT 
    pnm.CompPartNo1,
    pnm.DEAPartNo,
    pnm.ANCHORPartNo,
    pnm.WestarPartNo1,
    pnm.WestarPartNo2,
    pnm.CompPartNo2,
    pnm.InterChgPartNo,
    pnm.CateCode,
    pca.CategoryName,
    pnm.Note,
    LastUpdDate
FROM cfsys.PartNumberMatrix pnm JOIN cfsys.PartCategory pca
        ON pnm.CateCode = pca.CateCode
WHERE pnm.delFlag <> '1'
;

DROP VIEW baseinfoallparts_listed_v;
CREATE OR REPLACE VIEW baseinfoallparts_listed_v
AS 
SELECT 
 actlst.SKU,
 CASE
    when locate('/', transinfo.TransPartNo) > 0 then left(transinfo.TransPartNo,locate('/', transinfo.TransPartNo)-1)
    else transinfo.TransPartNo
 END AS PartNo, 
 actlst.StoreName,
 actlst.ItemName,
 actlst.ItemCategory,
 actlst.SKUType,
 actlst.BundleComponents,
 concat(year(actlst.ItemCreateDate) , lpad(MONTH(actlst.ItemCreateDate), 2,'0')) ItemCreateYM
FROM cfsys.activelisting actlst JOIN cfsys.transinfoallparts_listed_v transinfo
                                    ON actlst.SKU = transinfo.SKU;

DROP VIEW transinfoallparts_listed_v;
CREATE OR REPLACE VIEW transinfoallparts_listed_v
AS 
SELECT 
 SKU,
 CASE
	when LEFT(sku,7) IN ('CAVA-VA', 'CECF-CA', 'CESA-SA', 'CWSU-SU') then right(sku, length(sku)-7)
    when locate('/', SKU) > 0 then left(SKU,locate('/', SKU)-1)
    else SKU
 END AS TransPartNo
FROM cfsys.activelisting;