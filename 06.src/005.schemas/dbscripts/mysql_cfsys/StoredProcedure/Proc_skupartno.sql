DELIMITER $$

DROP PROCEDURE IF EXISTS cfsys.sku_partno$$
CREATE PROCEDURE cfsys.sku_partno()
BEGIN
	DECLARE	l_sku VARCHAR(50);
    DECLARE l_partno VARCHAR(35);
    DECLARE l_storename VARCHAR(25);
    DECLARE l_itemname VARCHAR(100);
    DECLARE l_itemcategory VARCHAR(100);
    DECLARE l_skutype VARCHAR(100);
    DECLARE done INT DEFAULT 0;

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
    
    DECLARE curSPNotValidated CURSOR FOR
        SELECT SKU,PartNo,StoreName, ItemName,ItemCategory,SKUType
        FROM cfsys.baseinfoallparts_listed_v
        WHERE SKU IN (SELECT DISTINCT SKU 
                        FROM skupartno 
                        WHERE ValidationFlag = '0');
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN curSPNotValidated;
    upd_loop:LOOP
        FETCH curSPNotValidated INTO l_sku, l_partno,l_storename, l_itemname,l_itemcategory, l_skutype;
        IF done THEN LEAVE upd_loop; END IF;
        UPDATE skupartno 
        SET PartNumber = l_partno,StoreName = l_storename,ItemCategory = l_itemcategory,SkuType = l_skutype,
                                UpdateSource = 'SP_SKUPT',UpdateDate = sysdate(),ValidationFlag = '1', ValidationDate = sysdate()
        WHERE SKU = l_sku;
    END LOOP;

    INSERT INTO skupartno
    SELECT SKU,PartNo,StoreName, ItemName,ItemCategory,SKUType,'SP_SKUPT',sysdate(),'1',sysdate()
    FROM cfsys.baseinfoallparts_listed_v
    WHERE SKU NOT IN (SELECT DISTINCT SKU FROM skupartno);
END$$