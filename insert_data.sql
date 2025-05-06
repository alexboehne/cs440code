INSERT INTO member (memberName, creditCard, memberDiscount) VALUES 
('Oliver Queen', '1234567891234567', 0.10), 
('Dinah Lance', '9876543219876541', 0.10), 
('Johnny Blaze', '9879879879879879', 0.10); 

INSERT INTO movie (movieName, movieLength, movieGenre, movieRating, moviePrice) VALUES 
('Ghost Rider', '113', 'Comic Book', 'PG-13', 10.00), 
('Toy Story', '81', 'Animation', 'G', 10.00), 
('Inception', '148', 'Sci-Fi', 'PG-13', 12.00), 
('Avengers', '143', 'Comic Book', 'PG-13', 14.00);

INSERT INTO snack (itemID, itemName, itemPrice) VALUES 
(1, 'Small Popcorn', 5.50), 
(2, 'Medium Soda', 4.50), 
(3, 'Large Soda', 6.50), 
(4, 'Candy', 3.35), 
(5, 'Medium Popcorn', 7.50), 
(6, 'Large Popcorn', 9.50);    

INSERT INTO theatre (thID, seats, seatsAvailable) VALUES 
(1, 100, 100), 
(2, 150, 150), 
(3, 50, 50);  

INSERT INTO showing (movieID, thID, startTime) VALUES 
(5, 1, '18:00'), 
(6, 2, '15:30'), 
(7, 1, '20:00'); 

INSERT INTO sale (saleDate, showID, saleTax, memberID, finalPrice) VALUES 
('2025-03-31', 8, 0.07, 106, 17.55), 
('2025-04-27', 9, 0.07, 107, 13.45); 

INSERT INTO sale (saleDate, itemID, saleTax, finalPrice) VALUES 
('2025-04-27', 3, 0.07, 16.96); 