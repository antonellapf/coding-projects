-- Using the ddmban_sql_analysis data base to start the important queries for my insights:
USE ddmban_sql_analysis;

SELECT * 
FROM ddmban_data
;

-- First cleaning the current data without modifying the table, only showing the rows and columns necessary for the analysis:
-- The next query shows the useful data which is considered for the following analysis
-- Format of price in 2 decimal units using aggregation

SELECT ID, category, subcategory, product,vegan , glutenfree , ketofriendly , vegetarian , organic ,
				dairyfree , sugarconscious , paleofriendly , wholefoodsdiet , lowsodium ,
				kosher , lowfat , engine2, 
                
                    (vegan + glutenfree + ketofriendly + vegetarian + organic +
	dairyfree + sugarconscious + paleofriendly + wholefoodsdiet + lowsodium +
    kosher +lowfat + engine2 ) AS dietary_score,
    
	CASE 
	WHEN
	ID < 270 THEN ROUND(price/100,2)
	ELSE NULL
	END AS valid_price 
    FROM ddmban_data ;

-- Showing the Weaker Correlations done in excel in SQL and using only the weak correlations or no correlations in SQL analysis:
-- Correlation between: Kosher and Ketofriendly, Kosher and Dairyfree, Kosher and Sugarconscious, Kosher and Price using aggregations,

-- CORRELATION Kosher and Ketofriendly
SELECT  
        -- For Kosher with Ketofriendly
        (AVG(kosher * ketofriendly) - AVG(kosher) * AVG(ketofriendly)) / 
        (sqrt(AVG(kosher * kosher) - AVG(kosher) * AVG(kosher)) * sqrt(AVG(ketofriendly * ketofriendly) - avg(ketofriendly) * avg(ketofriendly))) 
        AS correlation_Kosher_ketofriendly,
        -- For Sample
        (COUNT(*) * SUM(kosher * ketofriendly) - SUM(kosher) * SUM(ketofriendly)) / 
        (sqrt(COUNT(*) * SUM(kosher * kosher) - SUM(kosher) * SUM(kosher)) * sqrt(count(*) * SUM(ketofriendly * ketofriendly) - sum(ketofriendly) * sum(ketofriendly))) 
        AS correlation_coefficient_sample
    FROM ddmban_data;

-- CORRELATION Kosher and Dairyfree
SELECT  
        -- For Kosher with Dairyfree
        (AVG(kosher * dairyfree) - AVG(kosher) * AVG(dairyfree)) / 
        (sqrt(AVG(kosher * kosher) - AVG(kosher) * AVG(kosher)) * sqrt(AVG(dairyfree * dairyfree) - avg(dairyfree) * avg(dairyfree))) 
        AS correlation_Kosher_dairyfree,
        -- For Sample
        (COUNT(*) * SUM(kosher * dairyfree) - SUM(kosher) * SUM(dairyfree)) / 
        (sqrt(COUNT(*) * SUM(kosher * kosher) - SUM(kosher) * SUM(kosher)) * sqrt(count(*) * SUM(dairyfree * dairyfree) - sum(dairyfree) * sum(dairyfree))) 
        AS correlation_coefficient_sample
    FROM ddmban_data;
    
    -- CORRELATION Kosher and Sugarconscious
SELECT  
        -- For Kosher with Sugarconscious
        (AVG(kosher * sugarconscious) - AVG(kosher) * AVG(sugarconscious)) / 
        (sqrt(AVG(kosher * kosher) - AVG(kosher) * AVG(kosher)) * sqrt(AVG(sugarconscious * sugarconscious) - avg(sugarconscious) * avg(sugarconscious))) 
        AS correlation_Kosher_sugarconscious,
        -- For Sample
        (COUNT(*) * SUM(kosher * sugarconscious) - SUM(kosher) * SUM(sugarconscious)) / 
        (sqrt(COUNT(*) * SUM(kosher * kosher) - SUM(kosher) * SUM(kosher)) * sqrt(count(*) * SUM(sugarconscious * sugarconscious) - sum(sugarconscious) * sum(sugarconscious))) 
        AS correlation_coefficient_sample
    FROM ddmban_data;

SELECT  
        -- For Kosher with Price
        (AVG(kosher * price) - AVG(kosher) * AVG(price)) / 
        (sqrt(AVG(kosher * kosher) - AVG(kosher) * AVG(kosher)) * sqrt(AVG(price * price) - avg(price) * avg(price))) 
        AS correlation_Kosher_price,
        -- For Sample
        (COUNT(*) * SUM(kosher * price) - SUM(kosher) * SUM(price)) / 
        (sqrt(COUNT(*) * SUM(kosher * kosher) - SUM(kosher) * SUM(kosher)) * sqrt(count(*) * SUM(price * price) - sum(price) * sum(price))) 
        AS correlation_coefficient_sample
    FROM ddmban_data;







-- CREATE A TABLE WITH VALID DATA FOR THE ANALYSIS USED AND SUPPORTED WITH THE EXCEL ANALYSIS:
-- Using WITH without affecting the data

WITH 
dietary_preferences_valid_table AS
(
	SELECT ID, category, subcategory, product,vegan , glutenfree , ketofriendly , vegetarian , organic ,
				dairyfree , sugarconscious , paleofriendly , wholefoodsdiet , lowsodium ,
				kosher , lowfat , engine2, 
                
                    (vegan + glutenfree + ketofriendly + vegetarian + organic +
	dairyfree + sugarconscious + paleofriendly + wholefoodsdiet + lowsodium +
    kosher +lowfat + engine2 ) AS dietary_score,
    
	CASE 
	WHEN
	ID < 270 THEN ROUND(price/100,2)
	ELSE NULL
	END AS valid_price FROM ddmban_data 
)

SELECT
    
CASE 	        
				WHEN kosher = '0' 	THEN "No kosher"
                WHEN kosher = '1' THEN "Yes kosher"
				WHEN kosher > '1' THEN 'Not valid'
			    
END AS kosher_product
FROM ddmban_data

UNION ALL

-- Show the Weaker Correlations done in excel in SQL and using only the weak correlations or no correlations in SQL analysis:
-- Correlation between: Kosher and Ketofriendly, Kosher and Dairyfree, Kosher and Sugarconscious, Kosher and Price,
-- CORRELATION Kosher and Ketofriendly

	SELECT  
        -- For Kosher with Ketofriendly
        (AVG(kosher * ketofriendly) - AVG(kosher) * AVG(ketofriendly)) / 
        (sqrt(AVG(kosher * kosher) - AVG(kosher) * AVG(kosher)) * sqrt(AVG(ketofriendly * ketofriendly) - avg(ketofriendly) * avg(ketofriendly))) 
        AS correlation_kosher,
        -- For Sample
        (COUNT(*) * SUM(kosher * ketofriendly) - SUM(kosher) * SUM(ketofriendly)) / 
        (sqrt(COUNT(*) * SUM(kosher * kosher) - SUM(kosher) * SUM(kosher)) * sqrt(count(*) * SUM(ketofriendly * ketofriendly) - sum(ketofriendly) * sum(ketofriendly))) 
        AS correlation_coefficient_sample
  
UNION ALL

	SELECT  
        -- Correlation For Kosher with Dairyfree
        (AVG(kosher * dairyfree) - AVG(kosher) * AVG(dairyfree)) / 
        (sqrt(AVG(kosher * kosher) - AVG(kosher) * AVG(kosher)) * sqrt(AVG(dairyfree * dairyfree) - avg(dairyfree) * avg(dairyfree))) 
        AS correlation_kosher,
        -- For Sample
        (COUNT(*) * SUM(kosher * dairyfree) - SUM(kosher) * SUM(dairyfree)) / 
        (sqrt(COUNT(*) * SUM(kosher * kosher) - SUM(kosher) * SUM(kosher)) * sqrt(count(*) * SUM(dairyfree * dairyfree) - sum(dairyfree) * sum(dairyfree))) 
        AS correlation_coefficient_sample
        
  UNION ALL      
        
        -- CORRELATION Kosher and Sugarconscious
SELECT  
        -- For Kosher with Sugarconscious
        (AVG(kosher * sugarconscious) - AVG(kosher) * AVG(sugarconscious)) / 
        (sqrt(AVG(kosher * kosher) - AVG(kosher) * AVG(kosher)) * sqrt(AVG(sugarconscious * sugarconscious) - avg(sugarconscious) * avg(sugarconscious))) 
        AS correlation_kosher,
        -- For Sample
        (COUNT(*) * SUM(kosher * sugarconscious) - SUM(kosher) * SUM(sugarconscious)) / 
        (sqrt(COUNT(*) * SUM(kosher * kosher) - SUM(kosher) * SUM(kosher)) * sqrt(count(*) * SUM(sugarconscious * sugarconscious) - sum(sugarconscious) * sum(sugarconscious))) 
        AS correlation_coefficient_sample
        
UNION ALL

SELECT  
        -- For Kosher with Price
        (AVG(kosher * price) - AVG(kosher) * AVG(price)) / 
        (sqrt(AVG(kosher * kosher) - AVG(kosher) * AVG(kosher)) * sqrt(AVG(price * price) - avg(price) * avg(price))) 
        AS correlation_kosher,
        -- For Sample
        (COUNT(*) * SUM(kosher * price) - SUM(kosher) * SUM(price)) / 
        (sqrt(COUNT(*) * SUM(kosher * kosher) - SUM(kosher) * SUM(kosher)) * sqrt(count(*) * SUM(price * price) - sum(price) * sum(price))) 
        AS correlation_coefficient_sample



FROM dietary_preferences_valid_table



GROUP BY kosher_product
ORDER BY kosher DESC
;






