# Apple Store App Analytics

## **Situation**

In this business scenario, the product analytics team wanted to better understand what characteristics were associated with higher user ratings in the AppleStore. With thousands of apps across multiple categories, languages and pricing models, the business needed a clearer view of which factors could potentially contribute to user satisfaction and where there might be opportunities for improvement.

The available data was split across a main Apple Store table containing app-level metrics and four separate tables containing app descriptions. This made it difficult to analyse app characteristics alongside user ratings in a single dataset.

The analysis was intended to help answer questions such as:

- Whether paid apps tend to receive higher user ratings than free apps.
- Whether the number of supported languages is associated with user satisfaction.
- Which app categories have the weakest average ratings and could represent improvement opportunities.
- Whether description length is associated with higher ratings.
- Which apps appear to be market leaders within each genre, while taking review volume into account.


## **Task**

As the Data Analyst, my task was to consolidate and validate the available AppStore data and use SQL to identify patterns that could help inform product, localisation and app marketing decisions. The analysis was performed in Google BigQuery and focused on data preparation, exploratory data analysis and business-oriented SQL queries using UNION ALL, JOIN, CASE statements, aggregation and window functions. The goal was not only to identify highly rated apps, but to understand which app characteristics were associated with stronger user ratings and translate these findings into practical recommendations.


## **Action**

I first consolidated the four separate app description tables into a single dataset using UNION ALL. I then compared the resulting dataset with the main Apple Store table to verify that the datasets covered the same population of apps.

As part of the data quality assessment, I checked key fields for missing values and reviewed the overall structure of the dataset. The analysis covered 7,197 unique apps across 23 genres, with no missing values identified in the key fields analysed.

Then, I explored the dataset to establish a baseline for app ratings and understand the distribution of apps across genres.

For the business analysis, I used SQL to investigate several potential drivers of user ratings:

- Monetisation: compared average ratings of free and paid apps.
- Localisation: grouped apps by the number of supported languages to identify whether broader language coverage was associated with higher ratings.
- Genre performance: identified the lowest-rated app categories and considered their relative size within the AppStore.
- App descriptions: joined the app and description datasets and grouped descriptions into short, medium and long categories to assess their relationship with user ratings.
- Market leaders: used ROW_NUMBER() and partitioning by genre to identify the highest-rated app in each category, using total rating volume as a secondary ranking criterion to make comparisons more meaningful.

I also considered review volume when interpreting top-rated apps, as a perfect rating based on a very small number of reviews is less representative than the same rating supported by a large user base.


## **Results**

The analysis highlighted several patterns that could be used to help shape product and app marketing strategies.

Paid apps were associated with higher average ratings than free apps. Paid apps represented approximately 44% of the dataset and had an average rating of 3.72, compared with 3.38 for free apps. This suggests that paid apps in the dataset tended to receive more positive user feedback, although the analysis does not establish that the pricing model itself causes higher satisfaction.

The relationship between localisation and ratings was not linear. Apps supporting 10-30 languages had the highest average rating of 4.13, compared with 3.37 for apps supporting fewer than 10 languages and 3.78 for apps supporting more than 30 languages. This suggests that expanding localisation may be beneficial up to a certain point, while simply supporting a very large number of languages does not necessarily correspond to higher ratings.

Several smaller app categories showed particularly low average ratings. Categories including Catalogs, Finance, Books, Navigation, Lifestyle, Sports, News and Social Networking were among the lowest-rated genres, with average ratings below 3.0. As these categories represent a relatively small proportion of the overall AppStore, they could provide targeted opportunities for improving user experience rather than requiring broad changes across the entire portfolio.

Description length showed one of the strongest associations with ratings. Apps with long descriptions had an average rating of 3.86, compared with 3.24 for medium descriptions and 2.53 for short descriptions. This indicates that apps with more detailed descriptions tended to receive higher ratings. From a product marketing perspective, improving the amount and quality of information provided to potential users could be worth testing, although further analysis would be required to determine whether description quality directly influences ratings.

Finally, the market leader analysis showed that every genre contained at least one app with a perfect 5.0 rating. However, the reliability of these ratings varied significantly. For example, the highest-rated app in Navigation had only 1 rating, while the top-rated Travel app had 188 ratings. This highlighted the importance of considering review volume alongside rating scores when benchmarking competitors.


## **Recommendations**

Based on these findings, I would recommend three key actions:

- Improve and test app descriptions: prioritise clearer and more comprehensive descriptions and A/B test changes in messaging, structure and level of detail to determine whether they improve user engagement and ratings.
- Adopt a targeted localisation strategy: instead of maximising the number of supported languages, prioritise the languages and markets with the strongest potential and test whether expansion towards the 10-30 language range improves app performance.
- Prioritise product improvements in low-rated genres: use the identified categories as a starting point for deeper analysis of user feedback, product experience and competitor performance to understand the factors contributing to lower satisfaction.
