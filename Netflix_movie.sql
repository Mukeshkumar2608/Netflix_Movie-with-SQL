create database  Netflix;
use Netflix;
select * from netflix_data;

-- 1.	What is the total number of 'Movies' and 'TV Shows' on Netflix?
SELECT 
    type, COUNT(type) AS total_count
FROM
    netflix_data
GROUP BY type;

-- List all unique ratings available in the dataset.
SELECT DISTINCT
    rating
FROM
    netflix_data;


-- Retrieve all movies released after the year 2020.
SELECT 
    title 
FROM
    netflix_data
WHERE
    release_year > 2020
 ;
  
  -- Display the top 10 movies with the highest duration.
SELECT 
    title , duration
FROM
    netflix_data
    where type = 'Movie'
ORDER BY cast( replace(duration, 'min','')as unsigned) DESC
LIMIT 10;
 
 -- Find the number of titles available from each country.
 SELECT 
    country, COUNT(title) AS total_movies
FROM
    netflix_data
GROUP BY Country;
 
 -- Determine the most frequently used rating in the dataset
SELECT 
    rating, COUNT(*) AS total_rating
FROM
    netflix_data
GROUP BY rating
ORDER BY total_rating DESC
LIMIT 3; 

-- List all movies produced in India.
SELECT 
    type, COUNT(*) AS total_movies
FROM
    netflix_data
WHERE
    country = 'India' AND type = 'Movie'
GROUP BY country , type;


-- Display all TV shows that have more than one season
SELECT 
    title, duration
FROM
    netflix_data
WHERE
    type = 'TV Show'
        AND duration != '1 Season';
        
-- Find the number of titles released each year.
SELECT 
    release_year, COUNT(title) AS titles_released
FROM
    netflix_data
GROUP BY release_year;

-- Count how many titles belong to each category in the listed in column.
SELECT 
    listed_in, COUNT(*) AS total_shows
FROM
    netflix_data
GROUP BY listed_in
ORDER BY total_shows DESC;

-- Find the top 10 directors with the highest number of titles.
SELECT 
    director, COUNT(title) AS total_title
FROM
    netflix_data
GROUP BY director
ORDER BY total_title DESC
LIMIT 10;

-- Calculate the average duration of movies.
SELECT 
    type,
    AVG(CAST(REPLACE(duration, 'min', '') AS UNSIGNED)) AS avg_duration
FROM
    netflix_data
WHERE
    type = 'Movie';

-- Find the percentage of Movies and TV Shows in the dataset.
SELECT 
    type,
    ROUND(((COUNT(*) * 100) / (SELECT 
                    COUNT(*)
                FROM
                    netflix_data)),
            2) AS total_shows
FROM
    netflix_data
GROUP BY type;


-- Find movies whose duration is greater than the average movie duration.
SELECT 
    title, duration
FROM
    netflix_data
WHERE
    type = 'Movie'
        AND CAST(REPLACE(duration, 'min', '') AS UNSIGNED) > (SELECT 
            AVG(CAST(REPLACE(duration, 'min', '') AS UNSIGNED))
        FROM
            netflix_data
        WHERE
            type = 'Movie');

 -- Create a view named Indian_Content containing all content from India.
CREATE VIEW Indian_content AS
    SELECT 
        *
    FROM
        netflix_data
    WHERE
        country = 'India';
 
select * from Indian_content;

-- Create a stored procedure that returns all content based on a given country
create procedure content (
 in country_nm varchar(50) )
 
 select * from netflix_data where country = country_nm 
 ;
 
 call content('France');
 
-- find directors who have directed more titles than the average number of titles directed by all directors.
WITH director_count AS
(
    SELECT
        director,
        COUNT(*) AS total_titles
    FROM netflix_data
    WHERE director IS NOT NULL
      AND director <> ''
    GROUP BY director
)

SELECT
    director,
    total_titles
FROM director_count
WHERE total_titles >
(
    SELECT AVG(total_titles)
    FROM director_count
);