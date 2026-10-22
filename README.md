# Bike Share Data Analysis in R

An exploratory analysis of **900,000 bike-share trips** from Chicago, New York City, and Washington, DC. The project uses R to compare travel patterns, trip duration, rider types, and weekday demand during the first six months of 2017.

## Project Questions

1. Which month, weekday, and hour are most popular for starting trips in each city?
2. How do total and typical trip durations differ among the cities?
3. How does user-type composition differ by city?
4. How is demand distributed across weekdays?

## Key Findings

- June had the most trips in all three cities.
- Chicago and New York City peaked at 5:00 PM; Washington peaked at 8:00 AM.
- Washington had the longest mean trip duration at 20.62 minutes.
- Subscribers accounted for 79.63% of Chicago trips, 89.72% of New York City trips, and 73.60% of Washington trips.
- Chicago's busiest weekday was Tuesday; New York City and Washington peaked on Wednesday.

## Repository Contents

- `Explore_bikeshare_data.ipynb` — completed R notebook with code, numeric summaries, visualizations, and interpretations
- `Explore_bikeshare_data.html` — self-contained rendered report
- `bike_share_analysis.R` — reusable standalone R analysis script
- `data/README.md` — dataset structure and setup instructions

## Tools and Skills Demonstrated

- R programming
- Data import and validation
- Functions and iterative processing with `Map` and `lapply`
- Date/time feature engineering
- Descriptive statistics
- Comparative data visualization
- Missing-value handling
- Analytical interpretation and communication

## Data

The project uses randomly selected trips from January through June 2017:

- `chicago.csv`
- `new-york-city.csv` or `new_york_city.csv`
- `washington.csv`

The source datasets are not committed because of their combined size. Place them in the repository root before running the notebook. The notebook accepts either common spelling of the New York City filename.

## Run the Project

1. Install R and an R-enabled Jupyter environment.
2. Place the three CSV files in the repository root.
3. Open `Explore_bikeshare_data.ipynb`.
4. Select **Kernel → Restart & Run All**.
5. Confirm every cell completes without an error.

## Limitations

The data covers only the first six months of 2017. Washington does not include gender or birth-year fields, and the datasets do not contain weather, station capacity, or trip-purpose information. Findings describe patterns and do not establish causation.

## Author

**Dawit Mirkano**  
Data Analyst | Software Developer  
[GitHub](https://github.com/mirkanodawit)
