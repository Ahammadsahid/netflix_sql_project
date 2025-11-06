🎬 Netflix Movies and TV Shows Data Analysis using SQL

📖 Project Overview

This project focuses on performing an in-depth SQL-based analysis of Netflix’s movies and TV shows dataset.
The goal is to uncover valuable business insights, explore global content patterns, and answer analytical questions using SQL queries.
This document outlines the project’s purpose, data structure, analytical queries, insights, and conclusions.

🎯 Project Objectives

Compare the distribution between Movies and TV Shows.

Identify the most frequent content ratings for both categories.

Analyze titles by release year, country, and duration.

Explore genre-based trends and keyword-driven categorization.

Derive insights on content production and growth patterns.

🗂 Dataset Information

The dataset used in this project was obtained from Kaggle.

Dataset Source: Netflix Movies and TV Shows

🧩 Database Schema
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix (
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

💡 Business Questions and SQL Solutions
1️⃣ Movie vs TV Show Distribution
SELECT type, COUNT(*) 
FROM netflix 
GROUP BY type;


Goal: Understand the proportion of Movies and TV Shows available on Netflix.

2️⃣ Most Common Rating per Category
WITH RatingStats AS (
    SELECT type, rating, COUNT(*) AS total
    FROM netflix
    GROUP BY type, rating
),
Ranked AS (
    SELECT type, rating, total,
           RANK() OVER (PARTITION BY type ORDER BY total DESC) AS rank
    FROM RatingStats
)
SELECT type, rating AS most_common_rating
FROM Ranked
WHERE rank = 1;


Goal: Determine which rating appears most frequently in each content type.

3️⃣ Movies Released in 2020
SELECT * 
FROM netflix 
WHERE release_year = 2020;


Goal: Retrieve all movie titles released in 2020.

4️⃣ Top 5 Content-Producing Countries
SELECT * FROM (
    SELECT UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
           COUNT(*) AS content_count
    FROM netflix
    GROUP BY country
) AS c
WHERE country IS NOT NULL
ORDER BY content_count DESC
LIMIT 5;


Goal: Identify countries contributing the most content on Netflix.

5️⃣ Longest Movie
SELECT * 
FROM netflix 
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC
LIMIT 1;


Goal: Find the movie with the maximum duration.

6️⃣ Content Added in the Last 5 Years
SELECT * 
FROM netflix 
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';


Goal: Retrieve recently added Netflix content within the past five years.

7️⃣ Content by Director 'Rajiv Chilaka'
SELECT * FROM (
    SELECT *, UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';


Goal: Display all titles directed by Rajiv Chilaka.

8️⃣ TV Shows with More Than 5 Seasons
SELECT * 
FROM netflix 
WHERE type = 'TV Show' 
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;


Goal: Identify long-running TV shows.

9️⃣ Genre-Wise Content Count
SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
       COUNT(*) AS total_titles
FROM netflix
GROUP BY genre;


Goal: Calculate the total number of titles in each genre.

🔟 Top 5 Years with Highest Average Content Released in India
SELECT country, release_year, COUNT(show_id) AS total_titles,
       ROUND(
           COUNT(show_id)::numeric /
           (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
       ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;


Goal: Find the top 5 years with the most Indian content releases on Netflix.

1️⃣1️⃣ Movies Classified as Documentaries
SELECT * 
FROM netflix 
WHERE listed_in LIKE '%Documentaries%';


Goal: Retrieve all documentary movies.

1️⃣2️⃣ Titles Without a Director
SELECT * 
FROM netflix 
WHERE director IS NULL;


Goal: List all entries that have missing director information.

1️⃣3️⃣ Salman Khan Movies Released in the Last 10 Years
SELECT * 
FROM netflix 
WHERE casts LIKE '%Salman Khan%' 
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


Goal: Display Salman Khan’s movies from the last decade.

1️⃣4️⃣ Top 10 Indian Actors by Movie Count
SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
       COUNT(*) AS movie_count
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY movie_count DESC
LIMIT 10;


Goal: Find the most featured Indian actors in Netflix’s collection.

1️⃣5️⃣ Categorize Content Based on Keywords
SELECT category, COUNT(*) AS total
FROM (
    SELECT CASE 
             WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Sensitive'
             ELSE 'Neutral'
         END AS category
    FROM netflix
) AS t
GROUP BY category;


Goal: Classify content as “Sensitive” or “Neutral” based on keywords in the description.

📊 Insights and Conclusion

Content Mix: Netflix’s library shows a strong balance between movies and TV shows.

Rating Trends: Common ratings reveal Netflix’s content preferences and target audience segments.

Regional Focus: The analysis highlights India’s growing content output and its significant contribution to Netflix’s catalog.

Keyword Analysis: Keyword-based categorization helps in identifying potentially sensitive or violent content.

Overall, this project provides an analytical overview of Netflix’s catalog and demonstrates how SQL can extract actionable insights from raw data.

👨‍💻 Author

Patan Ahammad Sahid (Zero Analyst)
This project is part of my data analytics portfolio, showcasing SQL proficiency for data analysis and business insight generation.
