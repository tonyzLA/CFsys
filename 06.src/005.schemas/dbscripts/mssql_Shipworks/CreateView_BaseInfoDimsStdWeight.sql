/*View - history Dimension Data, max record cnt of same partno * qty */
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('BaseInfoDimsStdWeight') IS NOT NULL
    DROP VIEW BaseInfoDimsStdWeight;
GO

CREATE VIEW BaseInfoDimsStdWeight
AS
SELECT bid.partno, bid.rollupitemQuantity, bid.totalWeight AS stdWeight
FROM dbo.BaseInfoDims bid JOIN 
	(SELECT partno, rollupitemquantity, Max(maxrecordcnt) AS greatestCnt
	from baseinfodimsmaxreccnt
	group by partno, rollupitemquantity
	) grt
	ON bid.partno = grt.partno AND bid.rollupitemQuantity = grt.rollupitemquantity
		AND bid.recordcnt = grt.greatestCnt
		;



