-- YouTube Channel Performance Analysis | PostgreSQL
-- Synthetic video analytics sample; not connected to a real channel.
DROP TABLE IF EXISTS videos;
CREATE TABLE videos (
 video_id INT PRIMARY KEY, publish_date DATE, title VARCHAR(100), content_type VARCHAR(20),
 views INT, likes INT, comments INT, subscribers_gained INT, duration_minutes NUMERIC(5,2)
);
INSERT INTO videos VALUES
(1,'2026-01-02','Excel Tips for Beginners','Tutorial',12500,820,64,145,8.5),
(2,'2026-01-06','SQL Joins Explained','Tutorial',18200,1250,105,220,12.0),
(3,'2026-01-10','Power BI Dashboard Build','Long-form',9600,710,58,118,18.5),
(4,'2026-01-14','3 Excel Shortcuts','Short',45200,3100,92,390,.6),
(5,'2026-01-18','Python Data Cleaning','Tutorial',14300,990,88,175,14.2),
(6,'2026-02-02','Analyst Interview Questions','Long-form',22100,1800,210,410,21.0),
(7,'2026-02-07','SQL Window Functions','Tutorial',16700,1320,142,260,16.0),
(8,'2026-02-12','Power BI DAX Trick','Short',58300,4200,130,510,.5),
(9,'2026-02-18','Data Analyst Roadmap','Long-form',30500,2450,320,620,24.0),
(10,'2026-03-01','Pivot Table in 60 Seconds','Short',39100,2800,76,330,.7);
-- 1. Channel KPIs
SELECT COUNT(*) AS uploads, SUM(views) AS total_views, SUM(likes) AS total_likes,
 SUM(subscribers_gained) AS subscribers_gained FROM videos;
-- 2. Engagement rate
SELECT title, views, likes, comments,
 ROUND(100.0*(likes+comments)/NULLIF(views,0),2) AS engagement_rate_pct
FROM videos ORDER BY engagement_rate_pct DESC;
-- 3. Content format performance
SELECT content_type, COUNT(*) AS uploads, SUM(views) AS views,
 ROUND(AVG(views),0) AS avg_views, SUM(subscribers_gained) AS subscribers
FROM videos GROUP BY content_type ORDER BY avg_views DESC;
-- 4. Monthly views and subscriber growth
SELECT DATE_TRUNC('month',publish_date)::date AS month,
 SUM(views) AS views, SUM(subscribers_gained) AS subscribers
FROM videos GROUP BY 1 ORDER BY 1;
-- 5. Subscriber conversion per 1,000 views
SELECT title, ROUND(1000.0*subscribers_gained/NULLIF(views,0),2) AS subs_per_1000_views
FROM videos ORDER BY subs_per_1000_views DESC;
-- 6. Upload frequency
SELECT DATE_TRUNC('week',publish_date)::date AS week, COUNT(*) AS uploads
FROM videos GROUP BY 1 ORDER BY 1;
-- 7. Top videos by views
SELECT title, content_type, views, DENSE_RANK() OVER (ORDER BY views DESC) AS view_rank
FROM videos ORDER BY view_rank;
-- 8. Correlation between video length and views (descriptive)
SELECT content_type, ROUND(AVG(duration_minutes),2) AS avg_duration,
 ROUND(AVG(views),0) AS avg_views FROM videos GROUP BY content_type;
