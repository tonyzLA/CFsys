DELIMITER $$

DROP PROCEDURE IF EXISTS cfsys.sku_partno$$
CREATE PROCEDURE cfsys.sku_partno()
BEGIN
	DECLARE	lnSKU VARCHAR(50);
    DECLARE lnPartNumber VARCHAR(35);
    DECLARE lnStoreName VARCHAR(25);
    DECLARE lnItemName VARCHAR(100);
    DECLARE lnItemCategory VARCHAR(100);
    DECLARE lnSKUType VARCHAR(100);

    CREATE TABLE IF NOT EXISTS cfsys.SKUPartNo (
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
    
    DECLARE curSPView CURSOR FOR
    SELECT SKU,PartNo,StoreName, ItemName,ItemCategory,SKUType 
    FROM cfsys.baseinfoallparts_listed_v;
    
    OPEN curSPView;
    view_loop:LOOP
        FETCH curSPView INTO lnSKU, lnPartNumber,lnStoreName, lnItemName,lnItemCategory, lnSKUType;
        SELECT lnSKU, lnPartNumber,lnStoreName, lnItemName,lnItemCategory, lnSKUType;
    END LOOP;
END$$