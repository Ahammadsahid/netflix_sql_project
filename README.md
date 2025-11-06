# 🎬 Netflix Movies and TV Shows Data Analysis using SQL  

![Netflix Logo](https://github.com/najirh/netflix_sql_project/blob/main/logo.png)

---

## 📖 Overview  
This project focuses on analyzing Netflix's Movies and TV Shows dataset using **SQL** to extract meaningful business insights.  
The analysis answers key questions related to content distribution, genres, ratings, and country-based trends to understand Netflix’s content landscape better.

---

## 🎯 Objectives  
- Compare the number of Movies and TV Shows.  
- Identify the most common content ratings for each type.  
- Retrieve and analyze titles based on release year, country, and duration.  
- Explore content by genres and keyword-based categorization.  
- Find insights about Indian content growth on Netflix.

---

## 🗂 Dataset  
The dataset used for this project was sourced from **Kaggle**.  

- **Dataset Link:** [Netflix Movies and TV Shows Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

---

## 🧩 SQL Schema  
```sql
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
💡 Business Problems and SQL Queries
1️⃣ Movies vs TV Shows Count
sql
Copy code
SELECT type, COUNT(*) 
FROM netflix 
GROUP BY type;
Objective: Determine the distribution between Movies and TV Shows.

2️⃣ Most Common Rating per Type
sql
Copy code
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
Objective: Find the most frequent rating for each type of content.

3️⃣ Movies Released in 2020
sql
Copy code
SELECT * 
FROM netflix 
WHERE release_year = 2020;
Objective: Retrieve all movies released in 2020.

4️⃣ Top 5 Countries with Most Content
sql
Copy code
SELECT * FROM (
    SELECT UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
           COUNT(*) AS content_count
    FROM netflix
    GROUP BY country
) AS c
WHERE country IS NOT NULL
ORDER BY content_count DESC
LIMIT 5;
Objective: Identify the top 5 countries contributing the most content to Netflix.

5️⃣ Longest Movie
sql
Copy code
SELECT * 
FROM netflix 
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC
LIMIT 1;
Objective: Find the movie with the longest duration.

6️⃣ Content Added in the Last 5 Years
sql
Copy code
SELECT * 
FROM netflix 
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
Objective: Retrieve recently added content within the past 5 years.

7️⃣ Content Directed by 'Rajiv Chilaka'
sql
Copy code
SELECT * FROM (
    SELECT *, UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';
Objective: List all movies or shows directed by Rajiv Chilaka.

8️⃣ TV Shows with More Than 5 Seasons
sql
Copy code
SELECT * 
FROM netflix 
WHERE type = 'TV Show' 
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;
Objective: Find TV shows that have more than five seasons.

9️⃣ Number of Titles by Genre
sql
Copy code
SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
       COUNT(*) AS total_titles
FROM netflix
GROUP BY genre;
Objective: Count how many titles fall into each genre category.

🔟 Top 5 Years with Highest Average Indian Content Release
sql
Copy code
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
Objective: Identify the top 5 years with the highest number of Indian releases.

1️⃣1️⃣ Documentaries
sql
Copy code
SELECT * 
FROM netflix 
WHERE listed_in LIKE '%Documentaries%';
Objective: Retrieve all titles categorized as Documentaries.

1️⃣2️⃣ Content Without Director
sql
Copy code
SELECT * 
FROM netflix 
WHERE director IS NULL;
Objective: Find titles that have missing director information.

1️⃣3️⃣ Salman Khan Movies in Last 10 Years
sql
Copy code
SELECT * 
FROM netflix 
WHERE casts LIKE '%Salman Khan%' 
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
Objective: Find all movies featuring Salman Khan released within the last decade.

1️⃣4️⃣ Top 10 Indian Actors by Appearances
sql
Copy code
SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
       COUNT(*) AS movie_count
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY movie_count DESC
LIMIT 10;
Objective: Identify the top 10 Indian actors with the most Netflix appearances.

1️⃣5️⃣ Categorizing Content by Keywords
sql
Copy code
SELECT category, COUNT(*) AS total
FROM (
    SELECT CASE 
             WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Sensitive'
             ELSE 'Neutral'
         END AS category
    FROM netflix
) AS t
GROUP BY category;
Objective: Classify content as “Sensitive” or “Neutral” based on keywords in the description.

📊 Findings and Insights
Content Ratio: Netflix features a balanced variety of Movies and TV Shows.

Ratings: Certain ratings dominate, giving insight into audience preferences.

Geographical Data: India and the USA rank high in content contribution.

Genre Analysis: Drama and Comedy remain dominant genres.

Keyword Categorization: Helps identify potentially sensitive or violent content.

✅ Conclusion
This SQL-based analysis provides a detailed overview of Netflix’s global and regional content trends.
By leveraging SQL queries, we gain actionable insights into Netflix’s catalog that can assist in content strategy, marketing, and audience targeting decisions.

👨‍💻 Author
Patan Ahammad Sahid (Zero Analyst)
This project is part of my Data Analytics portfolio, demonstrating SQL querying, analytical thinking, and problem-solving skills
