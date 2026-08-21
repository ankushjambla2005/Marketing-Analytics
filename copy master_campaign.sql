truncate table master_campaign cascade;
truncate table master_exploded;

copy master_campaign
from 'C:\project placement\cleaned csv\master.csv'
delimiter ','
csv header;

copy master_exploded
from 'C:\project placement\cleaned csv\exploded_data_channel.csv'
delimiter ','
csv header;

select *
from master_campaign
limit 1;

select *from master_exploded
limit 1000
