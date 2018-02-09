select setnumber, partnumber, quantity, 
       locate('*', partnumber), length(PartNumber), 
       trim(left(partnumber,locate('*', partnumber) -1)), 
       trim(substr(partnumber,locate('*', partnumber)+1, length(partnumber)))
from sets 
where locate('*', partnumber) > 1;

select setnumber, partnumber, quantity, 
       locate('*', partnumber), length(PartNumber), 
       trim(left(partnumber,locate('*', partnumber) -1)), 
       trim(substr(partnumber,locate('*', partnumber)+1, length(partnumber)))
from sets 
where locate('*', partnumber) > 1 
and length(partnumber) - locate('*', partnumber) - 1 >= 3;

update sets 
set partnumber = left(partnumber,locate('*', partnumber) -1) 
where locate('*', partnumber) = length(PartNumber);

update sets 
set partnumber = trim(left(partnumber,locate('*', partnumber) -1))
where locate('*', partnumber) > 1
AND length(partnumber) - locate('*', partnumber) - 1 < 3;

update sets 
set quantity = trim(substr(partnumber,locate('*', partnumber)+1, length(partnumber)))
where locate('*', partnumber) > 1
AND length(partnumber) - locate('*', partnumber) - 1 < 3;

select count(*) from sets where locate('*', partnumber) > 1;

select trim(left(partnumber,locate('*', partnumber) -1)),
	trim(substr(partnumber,locate('*', partnumber)+1, length(partnumber)))
from sets
where locate('*', partnumber) > 1;

select * from sets where locate('*', partnumber) = length(PartNumber);