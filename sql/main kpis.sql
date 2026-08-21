create view brand_kpis as(
select brand,sum(revenue) as total_revenue,
round(sum(conversions*acquisition_cost),2) as total_campaign_spend,
round(sum(revenue) - sum(conversions*acquisition_cost),2) as net_profit,
round(sum(revenue)/nullif(sum(conversions*acquisition_cost),0),2) as overall_roas,
count(distinct campaign_id) as total_campaigns
from master_campaign
group by brand);
select * from brand_kpis;
drop view brand_kpis;

drop view brand_kpis_monthly;

create view brand_kpis_monthly as(
select brand,count(*) as total_campaign_monthly,
DATE_TRUNC('month', date)::DATE AS month_start_date,
extract(month from date) as month,
extract(year from date) as year,
sum(revenue) as monthly_revenue,
round(sum(conversions*acquisition_cost),2) as monthly_campaign_spend,
round(sum(revenue) - sum(conversions*acquisition_cost),2) as monthly_net_profit,
round(sum(revenue)/nullif(sum(conversions*acquisition_cost),0),2) as monthly_roas
from master_campaign
group by brand,extract(month from date),extract(year from date),date
order by brand,year,month);


select * from brand_kpis_monthly limit 100;

select * from master_exploded

select brand,channel_used,count(campaign_id)
from master_exploded
group by brand,channel_used



create view channel_summary as(
with campaign_type as (
select campaign_id, count(*) as channels_per_campaign,
case when count(*) = 1 then 'Single Channel' else 'Multi Channel' end as campaign_type
from master_exploded
group by campaign_id
)
select m.campaign_id,count(*) as channel_per_campaign,master_exploded.channel_used,m.brand,round(sum(m.revenue)/sum(campaign_type.channels_per_campaign),2) as revenue_per_campaign_channel,
round(sum(conversions*acquisition_cost)/sum(campaign_type.channels_per_campaign),2) as spend_per_campaign_channel,
round((sum(m.revenue)/sum(campaign_type.channels_per_campaign)) - (sum(conversions*acquisition_cost)/sum(campaign_type.channels_per_campaign)),2) as profit_per_campaign_channel,
round((sum(m.clicks)/sum(campaign_type.channels_per_campaign)),2) as clicks_per_campaign_channel,
round((sum(m.impressions)/sum(campaign_type.channels_per_campaign)),2) as impressions_per_campaign_channel,
round((sum(m.conversions)/sum(campaign_type.channels_per_campaign)),2) as conversions_per_campaign_channel,
round((sum(m.clicks)/sum(m.impressions))*100,2) as ctr_per_campaign_channel,
round((sum(m.conversions)::numeric/nullif(sum(m.clicks),0))*100,2) as cvr_per_campaign_channel,
round((sum(conversions*acquisition_cost)::numeric/nullif(sum(m.clicks),0)),2) as cpc_per_campaign_channel
from master_campaign as m
join campaign_type on m.campaign_id = campaign_type.campaign_id
join master_exploded on m.campaign_id = master_exploded.campaign_id
group by m.campaign_id,master_exploded.channel_used,m.brand
);



create view total_channel_summary as(
select brand,channel_used,count(channel_per_campaign) as total_campaigns,
round(sum(revenue_per_campaign_channel),2) as total_revenue,
round(sum(spend_per_campaign_channel),2) as total_spend,
round(sum(profit_per_campaign_channel),2) as total_profit,
round(sum(clicks_per_campaign_channel),2) as total_clicks,
round(sum(impressions_per_campaign_channel),2) as total_impressions,
round(sum(conversions_per_campaign_channel),2) as total_conversions,
round(sum(clicks_per_campaign_channel)/sum(impressions_per_campaign_channel)*100,2) as overall_ctr,
round(sum(conversions_per_campaign_channel)/sum(clicks_per_campaign_channel)*100,2) as overall_cvr,
round(sum(spend_per_campaign_channel)/sum(clicks_per_campaign_channel),2) as overall_cpc
from channel_summary
group by brand,channel_used);

select * from total_channel_summary limit 100;
