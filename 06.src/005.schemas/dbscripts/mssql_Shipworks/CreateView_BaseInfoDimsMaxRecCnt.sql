/*View - history Dimension Data, max record cnt of same partno * qty */
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('BaseInfoDimsMaxRecCnt') IS NOT NULL
    DROP VIEW BaseInfoDimsMaxRecCnt;
GO

CREATE VIEW BaseInfoDimsMaxRecCnt
AS
SELECT mrcp.partno, mrcp.rollupitemQuantity, stdw.stdWeight, mrcp.PackagingType, mrcp.MaxRecordCnt
FROM	(SELECT partno, rollupitemQuantity, PackagingType, MAX(RecordCnt) MaxRecordCnt
        FROM dbo.BaseInfoDims
        GROUP BY partno, rollupitemQuantity, PackagingType) mrcp JOIN
		(SELECT mrc.partno, mrc.rollupitemQuantity, bid.totalWeight AS stdWeight, mrc.greatestCnt
		from dbo.BaseInfoDims bid JOIN
				(SELECT partno, rollupitemQuantity, MAX(RecordCnt) greatestCnt
		        FROM dbo.BaseInfoDims
		        GROUP BY partno, rollupitemQuantity) mrc       
		        	ON bid.partno = mrc.partno AND bid.rollupitemQuantity = mrc.rollupitemQuantity 
		        		AND bid.recordCnt = mrc.greatestCnt) stdw
		ON mrcp.partno = stdw.partno AND mrcp.rollupitemQuantity = stdw.rollupitemQuantity
;



