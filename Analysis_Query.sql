CREATE TABLE `applestore_analytics.appleStore_description_combined` AS
SELECT * FROM `applestore_analytics.appleStore_description1`
UNION ALL
SELECT * FROM `applestore_analytics.appleStore_description2`
UNION ALL
SELECT * FROM `applestore_analytics.appleStore_description3`
UNION ALL
SELECT * FROM `applestore_analytics.appleStore_description4`;



-- Exploratory Data Analysis

-- App volume comparison
SELECT COUNT(DISTINCT id)
FROM `applestore_analytics.appleStore_description_combined`;
-- 7197 unique apps
SELECT COUNT(DISTINCT id)
FROM `applestore_analytics.AppleStore`;
-- 7197 unique apps
-- Both tables contain the same number of unique apps


-- Data quality check
SELECT
  COUNTIF(track_name IS NULL) AS missing_apps_count,
  COUNTIF(user_rating IS NULL) AS missing_ratings_count,
  COUNTIF(prime_genre IS NULL) AS missing_genre_count
FROM `applestore_analytics.AppleStore`;
-- No missing values were found in key fields
SELECT COUNTIF(app_desc IS NULL) AS missing_apps_desc_count,
FROM `applestore_analytics.appleStore_description_combined`;
-- No missing values were found in app descriptions

-- Genre distribution
SELECT
  prime_genre,
  COUNT(*) AS apps_count
FROM `applestore_analytics.AppleStore`
GROUP BY 1
ORDER BY 2 DESC;
 -- The dataset contains 23 genres
 -- Games account for more than half of all apps, with Entertainment and Education being the next most common categories


-- Rating check
SELECT
  MIN(user_rating) AS min_user_rating,
  MAX(user_rating) AS max_user_rating,
  AVG(user_rating) AS avg_user_rating
FROM `applestore_analytics.AppleStore`;
-- The minimum user rating is 0, the maximum is 5 and the average user rating is approximately 3.5



-- Business Data Analysis

-- Monetization vs Satisfaction
SELECT
  CASE
    WHEN price > 0 THEN 'Paid app'
    ELSE 'Free app'
  END AS app_type,
  ROUND(COUNT(*) / SUM(COUNT(*)) OVER(), 2) as pct_of_total,
  ROUND(AVG(user_rating), 2) AS avg_user_rating
FROM `applestore_analytics.AppleStore`
GROUP BY 1;
-- Paid apps represent 44% of the App Store and receive higher average ratings (3.72) than free apps (3.38) which account for 56% of the store


-- Available languages analysis
SELECT
  CASE
    WHEN lang_num < 10 THEN '<10 languages'
    WHEN lang_num <= 30 THEN '10-30 languages'
    ELSE '>30 languages'
  END AS languages_group,
  ROUND(AVG(user_rating), 2) AS avg_user_rating
FROM `applestore_analytics.AppleStore`
GROUP BY 1;
-- Apps available in 10–30 languages receive the highest user ratings (average of 4.13)
-- Apps supporting more than 30 languages perform slightly worse (average of 3.78)
-- Apps with fewer than 10 available languages have the lowest rating (average of 3.37)


-- Lowest-rated app genres
SELECT
  prime_genre,
  ROUND(AVG(user_rating), 2) AS avg_user_rating,
  COUNT(*) AS total_count,
  ROUND((COUNT(*) / SUM(COUNT(*)) OVER()) * 100, 2) AS pct_of_total
FROM `applestore_analytics.AppleStore`
GROUP BY 1
ORDER BY 2 
LIMIT 10;
-- The lowest-rated app genres include Catalogs, Finance, Book, Navigation, Lifestyle, Sports, News, and Social Networking, with average ratings below 3.0
-- These categories represent a relatively small share of the App Store


-- Description impact
SELECT
  CASE
    WHEN LENGTH(dc.app_desc) < 500 THEN 'Short'
    WHEN LENGTH(dc.app_desc) <= 1000 THEN 'Medium'
    ELSE 'Long'
  END AS app_desc_type,
  ROUND(AVG(store.user_rating), 2) AS avg_user_rating
FROM `applestore_analytics.AppleStore` store
JOIN `applestore_analytics.appleStore_description_combined` dc
  ON store.id = dc.id
GROUP BY 1
ORDER BY
  CASE
    WHEN app_desc_type = 'Short' THEN 1
    WHEN app_desc_type = 'Medium' THEN 2
    WHEN app_desc_type = 'Long' THEN 3
  END;
-- Longer descriptions are associated with higher ratings, with Long descriptions average of 3.86, compared to 3.24 for Medium descriptions and 2.53 for Short descriptions


-- Market leaders
SELECT 
  prime_genre,
  track_name,
  user_rating,
  rating_count_tot
FROM (
  SELECT
    prime_genre,
    track_name,
    user_rating,
    rating_count_tot,
    ROW_NUMBER() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) n
  FROM `applestore_analytics.AppleStore`
) sub
WHERE n = 1
ORDER BY 1;
-- Each genre has at least one app with a perfect 5.0 rating, but user engagement differs significantly
-- Some top apps have received hundreds of thousands of ratings while others have very limited review volume
-- Navigation (1 rating) and Travel (188 ratings) top-rated apps should be interpreted cautiously because a perfect rating based on very few reviews is less reliable

