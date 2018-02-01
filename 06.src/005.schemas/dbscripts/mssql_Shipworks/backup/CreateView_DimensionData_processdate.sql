/*View - history Dimension Data*/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('DimensionData') IS NOT NULL
    DROP VIEW DimensionData;
GO

CREATE VIEW DimensionData
AS
select base1.partno, base1.rollupitemQuantity, base1.totalWeight, base1.PackagingType, base1.DimsLength, Base1.DimsWidth, Base1.DimsHeight, base1.ProcessDate
from dbo.BaseInfoDims base1,
	(SELECT partno, rollupitemQuantity, MAX(ProcessDate) ProcessDate
	FROM dbo.BaseInfoDims 
	GROUP BY partno, rollupitemQuantity) base2
where base1.partno = base2.partno
AND base1.rollupitemQuantity = base2.rollupitemQuantity
AND base1.ProcessDate = base2.ProcessDate;




