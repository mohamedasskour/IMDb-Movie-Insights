 IMDb Movie Insights: Advanced SQL Data Analysis 🍿

This project dives deep into movie trends, financial performance (contrasting historic nominal values with inflation-adjusted data), audience sentiment, and industry talent performance using advanced SQL techniques.

📊 Project Structure & Insights

The analysis is structured into 4 key analytical domains:

1. Overview & Trends
*   **Movie Duration vs. Popularity:** Analyzes how film runtime correlates with overall popularity, identifying the optimal duration window for audience engagement.
*   **The Year's Biggest Releases:** Tracks historical releases by computing the percentage share of popularity per year using window functions.
*   **Most Popular Movies & Favorite Genres:** Ranks the top 10 most popular movies and calculates the percentage market share of popularity for each genre.

2. Financial Insights (Nominal vs. Adjusted)
*   **Top 5 Profitable Genres:** Extracts the most lucrative genres based on net profit.
*   **Genre ROI (Return on Investment):** Calculates financial returns and segments genres into *High, Medium, or Low ROI* using percentile ranking window functions (`NTILE`).
*   **Top 10 Films by Net Profit:** Ranks individual movies by their financial success, adjusting for inflation to compare classic cinema fairly against modern blockbusters.

3. Audience Ratings
*   **Fan Favorites:** Cross-references high vote volumes with top average ratings.
*   **High-Revenue Blockbusters:** Highlights the top 10 highest-grossing films that maintained a critical acclaim rating of $\ge 8.0$.
*   **Hidden Gems:** Identifies critically highly-rated movies that suffered from low visibility (low vote counts)—perfect for recommendation engines.

4. Industry Talents
*   **Highest-Grossing Directors:** Tracks directors whose films generated the highest cumulative global box office revenue.
*   **Lead Actors' Lifetime Performance:** Evaluates top actors by lifetime revenue (nominal vs. adjusted) and segments their box-office power using advanced ranking functions.


Made with ♡ by Asskour Analyst
