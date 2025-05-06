#(Show all sale history to logged in user that matches memberID)
CREATE VIEW member_purchase_history AS
SELECT 
    m.memberID,
    m.memberName,
    s.saleID,
    s.saleDate,
    s.showID,
    s.itemID,
    s.saleTax,
    s.finalPrice,
    CASE 
        WHEN s.showID IS NOT NULL THEN 'Movie'
        WHEN s.itemID IS NOT NULL THEN 'Snack'
        ELSE 'Unknown'
    END AS sale_type
FROM member m
LEFT JOIN sale s ON m.memberID = s.memberID
WHERE m.memberID = USER();


#(Shows all theatre's avaiablity; calculates availability percentage, can be filtered in select statement)
CREATE VIEW available_theatres AS
SELECT 
    thID,
    seats,
    seatsAvailable,
    IF(seatsAvailable > 0, 'Yes', 'No') as hasAvailability,
    ROUND((seatsAvailable / seats) * 100, 2) as availability_percentage
FROM theatre
WHERE seatsAvailable > 0;


#(Show all members who have seen a movie in the past week)
CREATE VIEW members_past_week AS
SELECT member.memberName, movie.movieName, sale.saleDate
FROM member
JOIN sale ON member.memberID = sale.memberID
JOIN showing ON sale.showID = showing.showID
JOIN movie ON showing.movieID = movie.movieID
WHERE sale.saleDate >= CURDATE() - INTERVAL 7 DAY;


#(Show total sale amount for past week)
CREATE VIEW weekly_sales AS
SELECT DAYNAME(saleDate) AS day_of_week, SUM(finalPrice) AS total_sales
FROM sale
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');


#(Show all empty theatres)
CREATE VIEW empty_theatres AS
SELECT showing.showID, theatre.thID, showing.startTime
FROM showing
JOIN theatre ON showing.thID = theatre.thID
LEFT JOIN sale ON showing.showID = sale.showID
WHERE theatre.seats = theatre.seatsAvailable;


#(Show sales by movie start time)
CREATE VIEW sort_start_time AS
SELECT startTime, COUNT(*) AS num_sales
FROM sale
JOIN showing ON sale.showID = showing.showID
GROUP BY startTime
ORDER BY num_sales DESC;


#(Show most popular movie rating in sale)
CREATE VIEW most_popular_rating AS
SELECT movieRating, COUNT(*) AS rating_count
FROM movie
JOIN showing ON movie.movieID = showing.movieID
JOIN sale ON showing.showID = sale.showID
GROUP BY movieRating
ORDER BY rating_count DESC
LIMIT 1;
