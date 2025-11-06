

-- Netflix Project

CREATE TABLE netflix(
	show_id VARCHAR(6),
	type varchar(10),
	title varchar(150),
	director VARChAR(208),
	casts VARCHAR(900),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating	VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(105),
	description VARCHAR(250)

) 
alter table netflix
alter column listed_in type varchar(100);

select * from netflix;

select count(*) as total_count
from netflix;

SELECT DISTINCT type 
from netflix;



-- 15 business problem

-- 1.Count the number of movies vs shows
SELECT type,count(*) as total_content
from netflix 
group by type;


-- 2.Find the most common rating for movies and tv shows
SELECT 
     type,
	 rating
FROM
(
	SELECT 
	     type,
		 rating,
		 count(*),
		 RANK() OVER(PARTITION BY type  ORDER BY  COUNT(*) DESC) as ranking
	FROM netflix
	GROUP BY 1,2
) as t1
where ranking=1

-- 3. List all movies released in the year 2020
SELECT * FROM NETFLIX
WHERE 
     type='Movie'
	 AND 
	 release_year=2020
-- 4. Find the top 5 countries with the most content on netflix
SELECT 
      UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
	  COUNT(show_id) as total_content
FROM NETFLIX
GROUP BY 1
order by 2 desc
limit 5


-- 5. Identify the longest movie
SELECT * FROM netflix
WHERE 
     type='Movie'
	 AND 
	 duration=(SELECT MAX(duration) FROM netflix)


-- 6. Find content added in the last 5 years
SELECT * FroM netflix
WHERE 
     TO_DATE(date_added,'Month DD,YYYY') >=CURRENT_DATE- INTERVAL '5years'

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'.
SELECT * FROM netflix
WHERE director ILIKE  '%Rajiv Chilaka%'

-- 8. List al TV shows with more than 5 seasons
SELECT * FROM netflix
WHERE 
     type='TV Show'
	 AND 
	 SPLIT_PART(duration, ' ',1)::numeric > 5 

-- 9. Count the number of content item in each genre
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
	COUNT(show_id) as total_content
FROM netflix
group by 1

-- 10.Find each year and the average number of content release by india on netflix.
-- return top 5 years with highest avg content release.

SELECT 
      EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) as year,
	  COUNT(*) AS yearly_content,
	  ROUND(
	  COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country='India')::numeric *100,2) as avg_content_per_year

FROM netflix
WHERE country='India'
GROUP BY 1

-- 11. List all movies that are documentries
SELECT * FROM netflix
WHERE
	listed_in ILIKE '%documentaries%'

-- 12. Find all content without a director

SELECT * FROM netflix
WHERE 
	director IS NULL

-- 13. Find how many movies actor 'salman khan' appeared in last 10 years
SELECT * FROM netflix
where 
	casts ILIKE '%Salman Khan%'
	AND
	release_year>EXTRACT(YEAR FROM CURRENT_DATE)-10

-- 14. Find the topp 10 actors who have appeared in the highest number of movies produced in india.
SELECT 
	UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
	COUNT(*) as total_content
	FROM netflix
WHERE country ILIKE '%india%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' 
-- in the description field. Label content containing these keywords as 'Bad' and all 
-- other content as 'Good'. Count how many items fall into each category. 

WITH new_table
AS
(
SELECT *,
	CASE
	WHEN 
		description ILIKE '%kill%' OR
		description ILIKE '%violence%' THEN 'Bad_Content'
		ELSE 'Good Content'
	END category
FROM netflix
)
SELECT 
	category,
	count(*) AS total_content
FROM NEW_TABLE
GROUP BY 1
