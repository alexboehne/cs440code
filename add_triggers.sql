#(Automatically Calc Final Price in sale)

DELIMITER //

CREATE TRIGGER trg_calculate_final_price
BEFORE INSERT ON sale
FOR EACH ROW
BEGIN
    IF NEW.showID IS NOT NULL THEN
        SET NEW.finalPrice = (
            SELECT m.moviePrice * (1 + COALESCE(NEW.saleTax, 0)) * 
                   (1 - COALESCE((SELECT memberDiscount 
                                 FROM member 
                                 WHERE memberID = NEW.memberID), 0))
            FROM movie m
            JOIN showing sh ON m.movieID = sh.movieID
            WHERE sh.showID = NEW.showID
            LIMIT 1
        );
    ELSEIF NEW.itemID IS NOT NULL THEN
        SET NEW.finalPrice = (
            SELECT s.itemPrice * (1 + COALESCE(NEW.saleTax, 0)) * 
                   (1 - COALESCE((SELECT memberDiscount 
                                 FROM member 
                                 WHERE memberID = NEW.memberID), 0))
            FROM snack s
            WHERE s.itemID = NEW.itemID
            LIMIT 1
        );
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Either showID or itemID must be provided';
    END IF;
END; //

DELIMITER ;


#(Decrement seat for theatre attatched to showing when a sale is processed for that showing)
DELIMITER //

CREATE TRIGGER trg_decrement_seats
AFTER INSERT ON sale
FOR EACH ROW
BEGIN
    IF NEW.showID IS NOT NULL THEN
        UPDATE theatre
        SET seatsAvailable = seatsAvailable - 1
        WHERE thID = (
            SELECT thID 
            FROM showing 
            WHERE showID = NEW.showID
        );
    END IF;
END; //

DELIMITER ;

#(Prevents sale on fully booked theatre)
DELIMITER //

CREATE TRIGGER trg_validate_theatre_capacity
BEFORE INSERT ON sale
FOR EACH ROW
BEGIN
    DECLARE current_seats INT;
    
    IF NEW.showID IS NOT NULL THEN
        SELECT t.seatsAvailable INTO current_seats
        FROM theatre t
        JOIN showing s ON t.thID = s.thID
        WHERE s.showID = NEW.showID;
        
        IF current_seats < 1 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Theatre is fully booked';
        END IF;
    END IF;
END; //

DELIMITER ;

#(Validate movie rating input)
DELIMITER //

CREATE TRIGGER trg_validate_movie_rating
BEFORE INSERT ON movie
FOR EACH ROW
BEGIN
    IF NEW.movieRating IS NOT NULL THEN
        IF NEW.movieRating NOT IN ('G', 'PG', 'PG-13', 'R', 'NC-17') THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid movie rating. Must be one of: G, PG, PG-13, R, NC-17';
        END IF;
    END IF;
END; //

DELIMITER ;


#(Increment member's discount by .01 per 10 movies seen; cap at 0.3)
DELIMITER //

CREATE TRIGGER trg_update_member_discount
AFTER INSERT ON sale
FOR EACH ROW
BEGIN
    DECLARE movie_count INT;
    DECLARE new_discount DECIMAL(3,2);
    IF NEW.showID IS NOT NULL THEN
        
        SELECT COUNT(*) INTO movie_count
        FROM sale s
        JOIN showing sh ON s.showID = sh.showID
        WHERE s.memberID = NEW.memberID;
        
        SET new_discount = 0.1 + (FLOOR(movie_count / 10) * 0.01);
        SET new_discount = LEAST(new_discount, 0.3);
        
        UPDATE member
        SET memberDiscount = new_discount
        WHERE memberID = NEW.memberID;
    END IF;
END; //

DELIMITER ;


#(Set new member's discount to 0.1 if value not provided)
DELIMITER //

CREATE TRIGGER trg_set_initial_member_discount
BEFORE INSERT ON member
FOR EACH ROW
BEGIN
    IF NEW.memberDiscount IS NULL OR NEW.memberDiscount = 0 THEN
        SET NEW.memberDiscount = 0.1;
    END IF;
END; //

DELIMITER ;
---

#(Prevent sale from having both showID and itemID)
DELIMITER //

CREATE TRIGGER trg_validate_sale_ids
BEFORE INSERT ON sale
FOR EACH ROW
BEGIN
    IF NEW.showID IS NOT NULL AND NEW.itemID IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A sale cannot have both showID and itemID';
    END IF;
END; //

DELIMITER ;