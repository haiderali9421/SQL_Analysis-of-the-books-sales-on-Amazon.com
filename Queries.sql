-- 1. What are the top 10 bestselling books based on sales?

select Book_Title, Author, Main_Genre, Price, No_Of_People_rated
from booksdetails
order by No_Of_People_rated desc
limit 10;

-- 2.How many unique authors are present in the dataset?

with cte as
(select author, count(*)
from booksdetails
group by Author
having count(*) =1)

select count(*) as Unique_Authors
from cte;

-- 3.	What is the average price of books in each main genre?

select Main_Genre, round(avg(Price),2) as "Average Price", count(BookID) "Number of Books"
from booksdetails
group by Main_Genre
order by avg(price) desc;

-- 4.Which author has the highest average rating for their books?
 
 with cte2 as (select Author, round(avg(Rating),1)  "Average_Rating"
from booksdetails
group by author
order by avg(Rating) desc)

select * 
from cte2 
group by author
having average_rating= (select max(average_rating)
from cte2);

-- 5.What is the distribution of ratings for books in the dataset?

select case 
when Rating>=0 and rating<=3 then '0 to 3'
when rating>3 and rating<=4.5 then 'Above 3 to 4.5'
when rating>4.5 then 'Above 4.5'
end as 'Rating_Slab',
count(rating) as "Books Count"
from booksdetails
group by rating_slab
order by rating_slab;

-- 6.What are the top 5 sub-genres with the highest average rating?

select * from(
select Sub_Genre, Average_rating, dense_rank() over(order by Average_Rating desc) Rank_
from(
select sub_genre, Round(avg(rating),1) Average_Rating
from booksdetails
group by sub_genre) SQ) Q
where Rank_<=5;

-- 9. Which book has the highest number of people rated?
select Book_Title, No_Of_People_rated
from booksdetails
order by No_Of_People_rated desc
limit 1;

-- 10.	How many books have a rating above 4.5?

select count(*) "Number of Books Above 4.5 Rating"
from booksdetails
where Rating>4.5;

-- 11.	What is the average price of books by each author? (TOP 5)

select Author, round(avg(price),2) "Average Book Price"
from booksdetails
group by author 
order by Avg(price) desc
limit 5;

-- 10.	How many books have a rating above 4.5?

select cover_type, count(*)
from booksdetails
group by Cover_Type
order by count(*) desc;

-- 13.	Which main genre has the highest number of people rated?

select Main_Genre, sum(No_Of_People_rated) "Total No. of people rated"
from booksdetails
group by Main_Genre
order by sum(No_Of_People_rated) desc
limit 5;

-- 14.	What is the average rating of books by each author?

select Author, round(avg(Rating),1)
from booksdetails
group by Author
order by avg(Rating) desc;

-- 15.	How many books are priced above 2000?
set @total_books := (select count(*) from booksdetails);
select concat(round((count(*)/@total_books)*100,1),"%") "% of Books Above Rs. 2000"
from booksdetails
where price>1500;

-- Top 5 Most Selling Books by each cover type

select Book_Title,Cover_Type, No_Of_People_rated, rank_
from(select * , dense_rank() over(partition by Cover_Type order by No_Of_People_rated desc) Rank_
from booksdetails) Q
where rank_=1;

-- Most preferred book type among kindle, paperback and hardcover.

select cover_type, count(Cover_Type) "No of Book sold"
from booksdetails
where Cover_Type in ("Kindle edition","Hardcover","Paperback")
group by Cover_Type
order by count(Cover_Type) desc;

-- Average price distribution among kindle, paperback and Hardcover

select cover_type, Avg(Price) "Average Price"
from booksdetails
where Cover_Type in ("Kindle edition","Hardcover","Paperback")
group by Cover_Type
order by avg(Price) desc;

-- Identify bestselling authors by genre.

with cte as 
(select Main_Genre, Author, sum(No_Of_People_rated) "Rated"
from booksdetails
group by Main_Genre, author
order by 3 desc)
select *,
dense_rank() over (partition by Main_genre order by rated )
from cte ;


select Main_Genre,Author,Rated 
from(select Main_Genre, Author, rated,
rank() over (partition by Main_Genre order by rated desc) rnk
from (select Main_Genre, Author, sum(No_Of_People_rated) "Rated"
from booksdetails
group by Main_Genre, author
order by 3 desc) Q)Q1
where rnk=1
order by rated desc;






