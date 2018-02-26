select * from sys.tables where name like '%ebay%'

select obj.name,  obj.type, obj.type_desc, col.name from sys.columns col, sys.objects obj where col.name like '%Quantity%' and obj.type ='U' order by obj.name

select * from sys.schemas


select * from dbo.[Order] where orderId = '184587006'


select * from dbo.OrderItem where SKU like '%6232%'
select * from dbo.OrderItem where SKU like '%62006%'
select * from dbo.OrderItem where orderId = '171917006'

--online orders count
select ISNULL(ord.RollupItemName,ori.Name) AS ItemName, 
        ori.SKU, 
        sum(ori.Quantity) RealSalesCnt 
from dbo.[Order] ord JOIN dbo.OrderItem ori 
        ON ord.OrderID = ori.OrderID 
where ord.OrderDate BETWEEN '20170101' AND '20170701' 
AND ord.OnlineStatus <> 'Cancelled'
group by ord.RollupItemName,ori.Name,ori.SKU
order by RealSalesCnt desc, ori.SKU desc

select ori.name, ori.SKU,
       sum(ori.Quantity) RealSalesCnt 
from dbo.[Order] ord JOIN dbo.OrderItem ori 
        ON ord.OrderID = ori.OrderID 
where ord.OrderDate BETWEEN '20170101' AND '20170701' 
AND ord.OnlineStatus <> 'Cancelled'
group by ori.name, ori.SKU
order by RealSalesCnt desc, ori.SKU

--online orders details
select ord.OrderDate, ori.SKU from dbo.[Order] ord, dbo.OrderItem ori 
where ord.OrderID = ori.OrderID and ord.OrderDate between '2016-09-01 00:00:00' and '2017-02-28 23:59:59'


select ord.OrderDate, ord.RollupItemSKU  from dbo.[Order] ord
where ord.OrderDate between '2016-09-01 00:00:00' and '2017-02-28 23:59:59' order by ord.OrderDate

select *  from dbo.[Order] ord
where ord.orderID in ('150570006','171917006','173144006') order by ord.OrderDate


select ISNULL(ord.RollupItemName,ori.Name),        
        ori.SKU, 
        ord.OrderDate
from dbo.[Order] ord JOIN dbo.OrderItem ori 
        ON ord.OrderID = ori.OrderID 
where ord.OrderDate BETWEEN '20170101' AND '20170701' 
AND ord.OnlineStatus <> 'Cancelled'
order by ord.OrderDate


--order detail particular search
SELECT  ord.OrderDate, ord.orderID, ord.BillFirstName, ord.BillLastName, ord.RollupItemName, ord.RollupItemSKU, ori.SKU, ord.RollupItemQuantity, ori.Quantity 
FROM dbo.[Order] ord JOIN dbo.OrderItem ori 
        ON ord.OrderID = ori.OrderID 
WHERE ori.SKU in ('B3779','B3780') 
AND ord.OrderDate between '2016-09-01 00:00:00' and '2017-05-31 23:59:59' 
and  ord.orderID in ('184587006')

--order detail particular search null SKU
SELECT  ord.OrderDate, ord.orderID, ord.BillFirstName, ord.BillLastName, ord.RollupItemName, ord.RollupItemSKU, ori.SKU, ord.RollupItemQuantity, ori.Quantity 
FROM dbo.[Order] ord JOIN dbo.OrderItem ori 
        ON ord.OrderID = ori.OrderID 
WHERE ori.SKU IS NULL
AND ord.OrderDate between '2016-12-01 00:00:00' and '2017-05-31 23:59:59' 
