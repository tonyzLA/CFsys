/* database name - PROD environment*/
IF EXISTS DROP cfsys;
CREATE DATABASE cfsys CHARACTER SET utf8;

/* database name - DEVE environment*/
IF EXISTS DROP cfsys_test;
CREATE DATABASE cfsys_test CHARACTER SET utf8;


DROP TABLE cfsys.Inventory;
CREATE TABLE cfsys.Inventory(
    -- Reserver special shelf code for DropShip; "00FLWH" - FL WAREHOUSE; "00IMCW" - IMC WAREHOUSE; "00LOCL" - LOCAL NOT ON SHELF
    ShelfCode VARCHAR(8) NOT NULL,
    PartNumber VARCHAR(35) NOT NULL,
    DEACODE VARCHAR(8) NULL,
    Description VARCHAR(100),
    CateCode INT NOT NULL,
    PackTypeCode VARCHAR(6),
    Weight DECIMAL(7,2) DEFAULT 0,
    TotalQty INT DEFAULT 0, 
    ActiveFlg CHAR(1) DEFAULT '1',
    Remarks VARCHAR(100) NULL,
    PRIMARY KEY (ShelfCode, PartNumber),
    FOREIGN KEY(CateCode) REFERENCES PartCategory(CateCode)
);

--Need to back up Inventory periodically.
--Always insert or update Inventory but no delete allowed

DROP TABLE cfsys.Packinglists;
CREATE TABLE cfsys.Packinglists(
    PatchNo VARCHAR(6) NOT NULL, --"CF1701" --IDX
    PatchDesc VARCHAR(25),
    PalletNo INT(2), --previous int --IDX
    PartNumber VARCHAR(35) NOT NULL, --IDX
    CateCode INT NOT NULL, --IDX
    SupplierCode INTEGER,
    Quantity INTEGER DEFAULT 0, 
    ArriveDate DATE NOT NULL,
    OnShelf BOOLEAN DEFAULT 0,
    ShelfCode VARCHAR(8) NULL, --previous varchar6
    Remarks VARCHAR(100),
    PRIMARY KEY (PatchNo,PalletNo,PartNumber),
    FOREIGN KEY(SupplierCode) REFERENCES Suppliers(SupplierCode),
/*    FOREIGN KEY(PartNumber) REFERENCES Inventory(PartNumber) */
    FOREIGN KEY(CateCode) REFERENCES PartCategory(CateCode)
);

DROP TABLE cfsys.PartReferences;
CREATE TABLE cfsys.PartReferences(
    PartNumber VARCHAR(35) NOT NULL,
    InterChgNumber VARCHAR(25) NOT NULL,
    PRIMARY KEY (PartNumber, InterChgNumber),
    FOREIGN KEY (PartNumber) REFERENCES Inventory (PartNumber);
);


DROP TABLE cfsys.Sets;
    
CREATE TABLE cfsys.Sets(
    SetNumber VARCHAR(25) NOT NULL,
    PartNumber VARCHAR(35) NOT NULL,
    Quantity INTEGER DEFAULT 1 NOT NULL,
    CreateDate DATETIME NOT NULL Default '2017-08-01 12:00:00',
--    UpdateDate DATETIME NOT NULL Default '2017-06-08 12:00:00',
    UpdUsrName VARCHAR(35),
    UpdHstName VARCHAR(35),
    PRIMARY KEY (SetNumber, PartNumber,Quantity)
);


ALTER TABLE cfsys.Sets ADD COLUMN CreateDate DATETIME NOT NULL Default '2017-08-01 12:00:00';
ALTER TABLE cfsys.Sets ADD COLUMN UpdUsrName VARCHAR(35);
ALTER TABLE cfsys.Sets ADD COLUMN UpdHstName VARCHAR(35);
ALTER TABLE cfsys.Sets ADD COLUMN Verified BOOLEAN NOT NULL Default '1';
COMMIT;

--Begin Delete 20170811 --
DROP TABLE cfsys.PackingTypes;
--CREATE TABLE cfsys.PackingTypes (
--    PackTypeCode VARCHAR(6) NOT NULL,
--    DimsLength INTEGER DEFAULT 0,
--    DimsWidth INTEGER DEFAULT 0,
--    DimsHeight INTEGER DEFAULT 0,
--    PRIMARY KEY (PackTypeCode)
-- );
--End Delete 20170811 --

DROP TABLE cfsys.PackagingTypes;
CREATE TABLE cfsys.PackagingTypes (
    PackagingType INT NOT NULL,
    Packaging VARCHAR(50),
    PRIMARY KEY (SupplierCode) --Add pk@20170815
 );
 

DROP TABLE cfsys.Suppliers;
CREATE TABLE cfsys.Suppliers(
    SupplierCode INTEGER NOT NULL,
    SupplierName VARCHAR(20),
    PRIMARY KEY (SupplierCode)
);

DROP TABLE cfsys.PartCategory;
CREATE TABLE cfsys.PartCategory (
    CateCode INT NOT NULL,
    CategoryName VARCHAR(50),
    PRIMARY KEY (CateCode)
);

DROP TABLE cfsys.Shipping;
CREATE TABLE cfsys.Shipping(
    ShippingID VARCHAR(12) NOT NULL UNIQUE, /* YYYYMMDD9999 */
    OrderPatchNumber INT(2) NOT NULL,
    TrackingNumber VARCHAR(35) NOT NULL UNIQUE,
    OperatorID INT(2) NULL,
    PackDate DATETIME NULL,
    ShippingDate DATETIME NULL,
    ValidFlag TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (ShippingID)
);

DROP TABLE cfsys.ShippingLines;
CREATE TABLE cfsys.ShippingLines(
    ShippingID VARCHAR(12) NOT NULL,
    ShippingLineNo INT(2) NOT NULL,
    PartNumber VARCHAR(35) NOT NULL, /* IDX */
    Quantity INT NOT NULL DEFAULT 1,
    PRIMARY KEY (ShippingID, ShippingLineNo)
);

DROP TABLE cfsys.PackingDims;
CREATE TABLE cfsys.PackingDims(
SKU VARCHAR(50) NOT NULL,
Quantity INT NOT NULL,
TotalWeight FLOAT NOT NULL,
PackagingType INT NOT NULL,
DimsLength FLOAT NOT NULL,
DimsWidth FLOAT NOT NULL,
DimsHeight FLOAT NOT NULL,
PRIMARY KEY (SKU,Quantity)
);

DROP TABLE cfsys.SpecialTrack;
CREATE TABLE cfsys.SpecialTrack(
SerialNumber INT NOT NULL,
CreateDate DATE NOT NULL,
OrderNumber VARCHAR(35) NOT NULL,
StoreName VARCHAR(25) NOT NULL,
UserName VARCHAR(50) NOT NULL,
EmailAddr VARCHAR(50) NULL,
MemoType CHAR(2) NOT NULL,
SpecialMemo VARCHAR(255) NOT NULL,
Status CHAR(2) NOT NULL,
Creator VARCHAR(25) NULL,
Remarks VARCHAR(255) NULL,
PRIMARY KEY (SerialNumber),
/* MemoType */
/* ES - exchange w/ shipping charge , EN - exchange w/o shipping charge,
   PR - partial refund, BO - back order, OT -  others */
CHECK (MemoType IN ('ES','EN','PR','BO','OT')), 
/* Status */
/* IN - Initial , RT - returning, RW - receive return but waiting for customer's response, 
   PD - Processed , WT - Waiting for shipping */
CHECK (Status IN ('IN','RT','RW','PD','WT')) 
);

/* add table on 08/25/2017 begin*/*/
DROP TABLE cfsys.OrderInfo;
CREATE TABLE cfsys.OrderInfo(
    StoreName VARCHAR(25) NOT NULL, 
    SWsOrderNo VARCHAR(35) NOT NULL, 
	eBayOrderNo VARCHAR(35) NOT NULL, 
	AmazonOrderNo VARCHAR(35) NOT NULL,
    ShipDate DATETIME, 
    trackingNumber VARCHAR(30) ,
    RollupItemSKU VARCHAR(50), 
    Shipfirstname VARCHAR(35), 
    shiplastname VARCHAR(35),
    shipStreet1 VARCHAR(35), 
    shipcity VARCHAR(35), 
    ShipStateProvCode VARCHAR(2), 
    ShipPostalCode VARCHAR(15),
    PRIMARY KEY (SWsOrderNo)
);

/* add table on 08/25/2017 end*/
/* Indexes are necessary for orderInfo*/

INSERT INTO cfsys.SpecialTrack VALUES (1,'2017-06-21','19668','sunautomotive','richie200011',NULL,
    'BO','Back order, pls notify customer and ship order once DS491(69220-52010,69210-52010,69240-52010,69230-52010) is replenished', 'WT','TZ',NULL);
INSERT INTO cfsys.SpecialTrack VALUES (2,'2017-06-21','17553','cf auto','wj7792_gunnwsa',NULL,
    'ES','exchange for B458, need to pay $4 reshipping fee', 'IN','MICHAEL',NULL);

/* add table on 10/20/2017 begin */
DROP TABLE cfsys.PartNumberMatrix;
CREATE TABLE cfsys.PartNumberMatrix(
    CompPartNo1	    VARCHAR(35) NOT NULL,
    DEAPartNo	    VARCHAR(35) NOT NULL,
    ANCHORPartNo	VARCHAR(35) NOT NULL,
    WestarPartNo1	VARCHAR(35) NOT NULL,
    WestarPartNo2	VARCHAR(35) NOT NULL,
    CompPartNo2	    VARCHAR(35),
    InterChgPartNo	VARCHAR(35),
    Note	        VARCHAR(64),
    CateCode	    INT,
    hostname	    VARCHAR(32),
    username	    VARCHAR(32),
    LastUpdDate	    datetime,
    delFlag         BOOLEAN DEFAULT 0,
    PRIMARY KEY (CompPartNo1,DEAPartNo,ANCHORPartNo,WestarPartNo1,WestarPartNo2)
);
/* add table on 10/20/2017 end */
/*  01/05/2018 BEGIN */
ALTER TABLE `cfsys`.`partnumbermatrix` 
DROP PRIMARY KEY,
ADD PRIMARY KEY (`CompPartNo1`);
/*  01/05/2018 END */

/*11/10/2017 PartSKUDef*/
DROP TABLE cfsys.ActiveListing;
CREATE TABLE cfsys.ActiveListing(
SKU VARCHAR(50) NOT NULL,
StoreName VARCHAR(25) NOT NULL,
ItemName VARCHAR(100),
ItemCategory VARCHAR(100),
SKUType VARCHAR(100),
BundleComponents VARCHAR(100),
ItemCreateDate DATETIME,
InventoryManageFlag BOOLEAN DEFAULT 0,
RecordUpdDate DATETIME,
PRIMARY KEY (SKU)
);

/*
Description TEXT,
Compatibility TEXT,
*/

/*11/10/2017*/

/*11/17/2017 SKUCategory*/
DROP TABLE cfsys.SKUCategory;
CREATE TABLE cfsys.SKUCategory (
    SKU VARCHAR(50) NOT NULL,
    CateCode INT NOT NULL,
    CategoryName VARCHAR(50),
    PRIMARY KEY (CateCode)
);
/*11/17/2017 SKUCategory*/

/*12/29/2017 SKUPartNo*/
DROP TABLE cfsys.SKUPartNo;
CREATE TABLE cfsys.SKUPartNo (
    SKU VARCHAR(50) NOT NULL,
    PartNumber VARCHAR(35) NOT NULL,
    StoreName VARCHAR(25) NOT NULL,
    ItemName VARCHAR(100),
    ItemCategory VARCHAR(100),
    SKUType VARCHAR(100),
    UpdateSource VARCHAR(35),
    UpdateDate DATETIME,
    ValidationFlag BOOLEAN DEFAULT 0,
    ValidateDate DATETIME,
    PRIMARY KEY (SKU)
);
/*12/29/2017 SKUPartNo*/

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