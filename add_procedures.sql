#(Reset seatsAvailable to seats)
DELIMITER //
CREATE PROCEDURE reset_theatre_seats(
    IN p_thID INT
)
BEGIN
    -- Validate input
    IF p_thID IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Theatre ID cannot be NULL';
    END IF;

    -- Update seatsAvailable to match total seats
    UPDATE theatre
    SET seatsAvailable = seats
    WHERE thID = p_thID;
END; //

DELIMITER ;


#(Show all movies with runtimes shorter than the input)
DELIMITER //

CREATE PROCEDURE display_shorter_runtimes(
    IN i_mLength INT
)
BEGIN
    SELECT * FROM movie
    WHERE CAST(movieLength AS UNSIGNED) < i_mLength;
END //

DELIMITER ;


#(Show all movies with runtimes longer than the input)
DELIMITER //

CREATE PROCEDURE display_longer_runtimes(
    IN i_mLength INT
)
BEGIN
    SELECT * FROM movie
    WHERE CAST(movieLength AS UNSIGNED) > i_mLength;
END //

DELIMITER ;

#(Show all snack sales on a specified day)
DELIMITER //

CREATE PROCEDURE check_snack_sales(
    IN d_dateCheck VARCHAR(20)
)
BEGIN
    SELECT saleID, itemID, saleDate
	FROM sale
	WHERE saleDate = d_dateCheck;
END //

DELIMITER ;


#(Show seats available for selected showID)
DELIMITER //

CREATE PROCEDURE display_showing_seats(
    IN s_showID INT
)
BEGIN
    SELECT showID, COUNT(*) AS seats_taken
    FROM sale
    WHERE showID = s_showID
    GROUP BY showID;
END //

DELIMITER ;
