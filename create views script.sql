DROP VIEW IF EXISTS vwqaanalysisdata;
CREATE VIEW vwqaanalysisdata as
SELECT a.dateactivity AS date_a,
    a.abtestgroup,
    a.platform,
    a.countrycode,
    a.userid AS user_a,
    b.userid AS user_b,
    b.dateactivity AS date_b,
    b.productid,
    b.cost::numeric AS cost
   FROM data_daily_activity a
     LEFT JOIN data_in_app_purchases b ON a.userid::text = b.userid::text;