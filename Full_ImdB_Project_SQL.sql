SELECT *
From Imdb_project;

/*
1) Overview & Trends */
        -- Movie Duration vs. Popularity --
    WITH Principle_Table AS (

        SELECT Duration_min, SUM(Popularity) AS Movie_Popularity
        From Imdb_project
        Group By Duration_min

    ), Percent_Table AS (

        SELECT Duration_min, Movie_Popularity, Movie_Popularity/SUM(Movie_Popularity) Over() *100 AS Percent_of_Popularity
        From Principle_Table
    )
    SELECT *
    From Percent_Table
    WHERE Percent_of_Popularity >= 1
    Order By Duration_min;

        -- The year's Biggest Releases --
    WITH Principle_Table AS (

        SELECT Release_Year, SUM(Popularity) AS Total_Popularity
        From Imdb_project
        Group by Release_Year

    ), Percent_Table AS (

        SELECT Release_Year, Total_Popularity/SUM(Total_Popularity) Over() *100 AS Perc_Popularity
        From Principle_Table
    )
    SELECT Release_Year, Round(Perc_Popularity, 2) AS Percent_Popularity
    From Percent_Table
    Group By Release_Year, Perc_Popularity
    Order By Percent_Popularity DESC;

        -- Most Popular Movies --
    SELECT TOP 10 
    Film_Title, SUM(Popularity) AS Popular
    From Imdb_project
    Group By Film_Title
    Order By Popular DESC;

        -- Favorite Genres --
    WITH Principle_Table AS (

        SELECT Genres, SUM(Popularity) AS Total_Popularity
        From Imdb_project
        Group by Genres

    ), Percent_Table AS (

        SELECT Genres, Total_Popularity, Total_Popularity/SUM(Total_Popularity) Over() *100 AS Perc_Popularity
        From Principle_Table

    )
    SELECT Genres, Total_Popularity, Round(Perc_Popularity, 2) AS Percent_Popularity
    From Percent_Table
    Group By Genres, Perc_Popularity, Total_Popularity
    Order By Percent_Popularity DESC;

/*
2) Financial Insights (Nominal vs. Adjusted) */
        -- 5 Most Profitable Genres (Nominal vs. Adjusted) --
    WITH Principle_Table AS (

        SELECT
        Genres, SUM(Film_Budget) AS Nominal_Budget, SUM(Film_Revenue) AS Nominal_Revenue,
        SUM(Film_Revenue) - SUM(Film_Budget) AS Nominal_Profit,
        SUM(Adjusted_Budget) AS Adj_Budget, SUM(Adjusted_Revenue) AS Adj_Revenue, 
        SUM(Adjusted_Revenue) - SUM(Adjusted_Budget) AS Adj_Profit
        From Imdb_project
        Group By Genres
    )
    SELECT TOP 5
    Genres, Nominal_Budget, Nominal_Revenue, Nominal_Profit, 
    Adj_Budget, Adj_Revenue, Adj_Profit
    From Principle_Table
    Order By Nominal_Profit DESC;

        -- Genres ROI: Which Genres yield the Highest Returns (Nominal vs. Adjusted) --
    WITH Principle_Table AS (
            
        SELECT Genres, SUM(Film_Budget) AS Nominal_Budget, SUM(Film_Revenue) AS Nominal_Revenue,
        SUM(Adjusted_Budget) AS Adj_Budget, SUM(Adjusted_Revenue) AS Adj_Revenue
        From Imdb_project
        Group By Genres
    )
    SELECT Genres, Nominal_Budget, Nominal_Revenue, Nominal_Revenue/Nominal_Budget AS Nominal_ROI,
    CASE WHEN NTILE(3) Over(Order By Nominal_Revenue/Nominal_Budget DESC) = 1 THEN 'High_ROI'
        WHEN NTILE(3) Over(Order By Nominal_Revenue/Nominal_Budget DESC) = 2 THEN 'Medium_ROI'
        ELSE 'Low_ROI'
    END AS ROI_Performance,
    Adj_Budget, Adj_Revenue, Adj_Revenue/Adj_Budget AS Adjusted_ROI,
    CASE WHEN NTILE(3) Over(Order By Adj_Revenue/Adj_Budget DESC) = 1 THEN 'High_ROI'
        WHEN NTILE(3) Over(Order By Adj_Revenue/Adj_Budget DESC) = 2 THEN 'Medium_ROI'
        ELSE 'Low_ROI'
    END AS ROI_Performance
    From Principle_Table
    Order By Nominal_ROI DESC;

        -- Top 10 Films by Net Profit (Nominal vs. Adjusted) --
    WITH Principle_Table AS (

        SELECT Film_Title, SUM(Adjusted_Budget) AS Total_Budget, SUM(Adjusted_Revenue) AS Total_Revenue, 
        SUM(Adjusted_Revenue) - SUM(Adjusted_Budget) AS Profit
        From Imdb_project
        Group By Film_Title
    )
    SELECT TOP 10 *,    -- Or Select All The Films --
    CASE WHEN Profit > 0 THEN 'Profitable'
        WHEN Profit < 0 THEN 'Not Profitable'
        ELSE 'No Change'
    END AS Profit_Performance
    From Principle_Table
    Order By Profit DESC;

/*
3) Audience Ratings */
        -- Fan Favorites High-Volume & Top-Rated --
    SELECT Film_Title, SUM(Total_Votes) AS High_Volume, Avg(Avg_Rating) AS Top_Rated
    From Imdb_project
    Group By Film_Title
    Order By High_Volume DESC;

        -- Top 10 High-Revenue Films (Rating >= 8.0) --
    WITH Principle_Table AS (

        SELECT Film_Title, SUM(Film_Revenue) AS High_Revenue, Avg(Avg_Rating) AS Rating -- We Calcule Avg_Rating with Avg Formel --
        From Imdb_project
        Group By Film_Title
    )
    SELECT TOP 10
    Film_Title, High_Revenue, Rating
    From Principle_Table
    WHERE Rating >= 8
    Order By High_Revenue DESC;

        -- Hidden Gems: High Ratings, Low Vote Counts --
    SELECT Film_Title, Genres, SUM(Total_Votes) AS Total_Votes, Avg(Avg_Rating) AS Total_Rating
    From Imdb_project
    Group By Film_Title, Genres
    Order By Total_Rating DESC, Total_Votes ASC;

/*
4) Industry Talents */
        -- Highest-Grossing Directors --
    SELECT TOP 10
    Directors, SUM(Film_Revenue) AS Nominal_Revenue, SUM(Adjusted_Revenue) AS Adjusted_Revenue
    From Imdb_project
    Group By Directors
    Order By Nominal_Revenue DESC;

        -- Lead Actors Performance by Lifetime Revenue (Nominal vs. Adjusted) --
    WITH Principle_Table AS (

        SELECT Lead_Actors, SUM(Film_Revenue) AS Nominal_Revenue, SUM(Adjusted_Revenue) AS Adj_Revenue
        From Imdb_project
        Group By Lead_Actors
    )
    SELECT
    Lead_Actors, Nominal_Revenue, Adj_Revenue,
    CASE WHEN Ntile(3) Over(Order By Nominal_Revenue DESC) = 1 THEN 'High_Revenue'
        WHEN Ntile(3) Over(Order By Nominal_Revenue DESC) = 2 THEN 'Medium_Revenue'
        ELSE 'Low_Revenue'
    END AS Revenue_Performance
    From Principle_Table
    Order By Nominal_Revenue DESC;
