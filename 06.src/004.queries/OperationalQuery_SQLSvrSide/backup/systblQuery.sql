select objs.name, cols.name  from sys.columns AS cols JOIN sys.objects objs ON cols.object_id = objs.object_id
where cols.name = 'dimsProfileId'

select objs.name, cols.name  from sys.columns AS cols JOIN sys.objects objs ON cols.object_id = objs.object_id
where cols.name like '%memo%'

select * from sys.objects