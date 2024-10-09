show databases;
show tables;

create database ZeroAnalyst_Netflix_9thOct2024;

Use ZeroAnalyst_Netflix_9thOct2024;

drop table netflix;

CREATE TABLE netflix (
    show_id VARCHAR(255) PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    director VARCHAR(255),
    cast TEXT,
    country VARCHAR(100),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(50),
    listed_in TEXT,
    description TEXT
);

-- Data is loaded from the netflix's csv file, hence not using the insert statement.

desc netflix;

select * from netflix;

select count(*) from netflix;

select cast from netflix
where show_id = 's13';

SELECT 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', 2), ',', -1)) AS second_string,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', 10), ',', -1)) AS tenth_string
    from netflix
    where show_id='s13';  -- statement to extract the strings from a column full of strings.

-- Q#1 : Count the number of Movies vs TV Shows?
select * from netflix;

select type, count(*) from netflix
group by type;  -- 55 movies, 45 tv shows

-- Q#2 : Find the most common rating for movies and TV shows?
(select type,rating,count(*) as Most_Common_Rating
from netflix
where type = 'Movie'
group by rating)  -- "TV-PG" is the most common rating for Movies

UNION

(select type,rating,count(*) as Most_Common_Rating
from netflix
where type = 'TV Show'
group by rating)  -- "TV-MA" is the most common rating for TV Shows
order by 3 desc
limit 2;

-- Q#3 : List all the movies released in a specific year (Eg : 2022)
desc netflix;
select release_year from netflix
order by release_year;

select count(distinct release_year) from netflix;

select type, title, release_year from netflix
where type='Movie'
group by type, title, release_year
order by 3 desc;

-- Q#4 : Find the top 5 countries with the most content on Netflix
select distinct country from netflix; -- 22 countries
select type, country, count(*) from netflix
group by type, country
order by 3 desc;

-- Q#5 : Identify the longest Movie of TV Show duration?
select type, title, cast(duration as time) from netflix
where type='Movie'
order by 3 desc;

-- Q#6 : Find content added in the last 5 years
select * from netflix;

select type, date_added
from netflix
group by type, date_added
order by date_added desc;

-- Q#7 : Find all the movies/TV Shows by director 'Rajiv Chilaka'
select distinct director from netflix;

select * from netflix
where director like '%Rajiv%';

-- Q#8 : List all TV Shows with more than 5 seasons
select * from netflix
where type='TV Show';

select type,title,duration
from netflix
where type='TV Show' and duration > concat(5,' ','Seasons')
order by duration desc;

-- Q#9 : Count the number of content items in each genre?
select type, listed_in, count(*) from netflix 
group by type, listed_in
order by 3 desc;

-- Q#10 : Find the average release_year of content produced in a specific country
-- Q11 : List all movies that are documentaries
select type, title, listed_in
from netflix
where lower(listed_in) like lower('%Documentaries%')
order by title;

-- Q#12 : Find all the content without a director
select director from netflix;

select *
from netflix
where director is null;

-- Q#13 : Find how many movies the actor 'John' appeared in the last 10 years
select cast from netflix;

select count(*)
from netflix
where lower(cast) like lower("%John%");

-- Q#14 : 'kill' and 'violence' are bad words. Include a column to add that for all those movies/shows that include those words
with cte_category as
(select *,
		case when lower(description) like lower('%kill%') or lower(description) like lower('%violence%') then 'Bad'
        else 'Good'
        end as Category
from netflix
)
select Category, count(Category) from cte_category
group by Category;
