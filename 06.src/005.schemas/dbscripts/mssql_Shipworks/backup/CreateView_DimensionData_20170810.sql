IF OBJECT_ID('DimensionData') IS NOT NULL
    DROP VIEW DimensionData;
GO

CREATE VIEW DimensionData
AS
select TOP 100 PERCENT base1.rollupitemSKU, base1.rollupitemQuantity, base1.totalWeight, base1.PackagingType, base1.DimsLength, Base1.DimsWidth, Base1.DimsHeight
from BaseInfoDims base1,
	(SELECT rollupitemSKU, rollupitemQuantity, MAX(RecordCnt) MaXRecCnt
	FROM BaseInfoDims 
	GROUP BY rollupitemSKU, rollupitemQuantity) base2
where base1.rollupitemSKU = base2.rollupitemSKU
AND base1.rollupitemQuantity = base2.rollupitemQuantity
AND base1.RecordCnt = base2.MaXRecCnt
ORDER BY base1.rollupitemSKU, base1.rollupitemQuantity DESC;