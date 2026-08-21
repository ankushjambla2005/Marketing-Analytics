CREATE TABLE master_campaign (
    campaign_id VARCHAR(50) PRIMARY KEY,
    campaign_type VARCHAR(50),
    target_audience VARCHAR(100),
    duration INT,
    channel_used VARCHAR(200),
    impressions BIGINT,
    clicks INT,
    leads INT,
    conversions INT,
    revenue BIGINT,
    acquisition_cost DECIMAL(10,2),
    roi DECIMAL(10,2),
    language VARCHAR(50),
    engagement_score DECIMAL(5,2),
    customer_segment VARCHAR(100),
    date DATE,
    brand VARCHAR(50)
);

create table master_exploded(campaign_id varchar(50) references master_campaign(campaign_id),
channel_used varchar(50),
brand varchar(50)
);
