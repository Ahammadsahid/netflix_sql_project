# 🎬 Netflix Movies and TV Shows Data Analysis using SQL  

![](https://github.com/najirh/netflix_sql_project/blob/main/logo.png)

## Overview  
This project presents an end-to-end SQL analysis of Netflix Movies and TV Shows data. The main objective is to extract business insights such as content trends, regional performance, and rating patterns.  

---

## Objectives  
- Analyze the proportion of Movies and TV Shows.  
- Identify most common content ratings.  
- Explore content distribution by year, country, and duration.  
- Categorize and filter content based on genres or keywords.  

---

## Dataset  
The dataset is taken from Kaggle.  
- **Dataset Link:** [Netflix Movies and TV Shows Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

---

## SQL Schema  
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
```

---

## Business Problems and SQL Solutions  

### 1️⃣ Count the Number of Movies vs TV Shows  
```sql
SELECT     
    type,     
    COUNT(*) 
FROM netflix 
GROUP BY 1;
```
**Objective:** Determine the distribution of content types on Netflix.

---

### 2️⃣ Find the Most Common Rating for Movies and TV Shows  
```sql
WITH RatingCounts AS (     
    SELECT          
        type,         
        rating,         
        COUNT(*) AS rating_count     
    FROM netflix     
    GROUP BY type, rating 
), 
RankedRatings AS (     
    SELECT          
        type,         
        rating,         
        rating_count,         
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank     
    FROM RatingCounts 
) 
SELECT      
    type,     
    rating AS most_frequent_rating 
FROM RankedRatings 
WHERE rank = 1;
```
**Objective:** Identify the most frequent rating for each type.

---

### 3️⃣ List All Movies Released in a Specific Year (e.g., 2020)  
```sql
SELECT *  
FROM netflix 
WHERE release_year = 2020;
```
**Objective:** Retrieve all movies released in 2020.

---

### 4️⃣ Find the Top 5 Countries with the Most Content  
```sql
SELECT *  
FROM (     
    SELECT          
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,         
        COUNT(*) AS total_content     
    FROM netflix     
    GROUP BY 1 
) AS t1 
WHERE country IS NOT NULL 
ORDER BY total_content DESC 
LIMIT 5;
```
**Objective:** Identify top 5 content-producing countries.

---

### 5️⃣ Identify the Longest Movie  
```sql
SELECT * 
FROM netflix 
WHERE type = 'Movie' 
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;
```
**Objective:** Find the movie with the longest duration.

---

### 6️⃣ Find Content Added in the Last 5 Years  
```sql
SELECT * 
FROM netflix 
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```
**Objective:** Retrieve content added in the last five years.

---

### 7️⃣ Find All Movies/TV Shows by Director 'Rajiv Chilaka'  
```sql
SELECT * 
FROM (     
    SELECT *,         
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name     
    FROM netflix 
) AS t 
WHERE director_name = 'Rajiv Chilaka';
```
**Objective:** List content directed by Rajiv Chilaka.

---

### 8️⃣ List All TV Shows with More Than 5 Seasons  
```sql
SELECT * 
FROM netflix 
WHERE type = 'TV Show'   
AND SPLIT_PART(duration, ' ', 1)::INT > 5;
```
**Objective:** Identify TV shows with more than 5 seasons.

---

### 9️⃣ Count the Number of Content Items in Each Genre  
```sql
SELECT      
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,     
    COUNT(*) AS total_content 
FROM netflix 
GROUP BY 1;
```
**Objective:** Count content items in each genre.

---

### 🔟 Find Each Year and Average Content Release in India (Top 5 Years)  
```sql
SELECT      
    country,     
    release_year,     
    COUNT(show_id) AS total_release,     
    ROUND(         
        COUNT(show_id)::numeric /         
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2     
    ) AS avg_release 
FROM netflix 
WHERE country = 'India' 
GROUP BY country, release_year 
ORDER BY avg_release DESC 
LIMIT 5;
```
**Objective:** Show top 5 years with highest average content releases in India.

---

### 1️⃣1️⃣ List All Movies That Are Documentaries  
```sql
SELECT *  
FROM netflix 
WHERE listed_in LIKE '%Documentaries';
```
**Objective:** Retrieve all documentary movies.

---

### 1️⃣2️⃣ Find All Content Without a Director  
```sql
SELECT *  
FROM netflix 
WHERE director IS NULL;
```
**Objective:** Show titles without a director.

---

### 1️⃣3️⃣ Find How Many Movies Actor 'Salman Khan' Appeared in Last 10 Years  
```sql
SELECT *  
FROM netflix 
WHERE casts LIKE '%Salman Khan%'   
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```
**Objective:** Count Salman Khan’s movies in the past decade.

---

### 1️⃣4️⃣ Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India  
```sql
SELECT      
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,     
    COUNT(*) 
FROM netflix 
WHERE country = 'India' 
GROUP BY actor 
ORDER BY COUNT(*) DESC 
LIMIT 10;
```
**Objective:** Identify top 10 Indian actors by movie appearances.

---

### 1️⃣5️⃣ Categorize Content Based on 'Kill' or 'Violence' Keywords  
```sql
SELECT      
    category,     
    COUNT(*) AS content_count 
FROM (     
    SELECT          
        CASE              
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'             
            ELSE 'Good'         
        END AS category     
    FROM netflix 
) AS categorized_content 
GROUP BY category;
```
**Objective:** Classify content as 'Bad' if containing 'kill' or 'violence', otherwise 'Good'.

---

## Findings and Conclusion  
- Netflix offers a balanced mix of movies and TV shows.  
- The most common ratings reveal audience preferences.  
- Top content-producing countries include India and the USA.  
- The dataset shows trends in genres, durations, and sensitive content.  

This project demonstrates how **SQL** can be used for business-oriented data analysis and insight generation.  

---

## Author  
**(Patan Ahammad Sahid)**  
This project is part of my portfolio showcasing SQL and data analytics skills.  



> 💬 Thank you for visiting this project! Feedback and collaboration are always welcome.
