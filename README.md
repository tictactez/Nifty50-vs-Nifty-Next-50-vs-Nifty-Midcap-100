This study evaluates the long-term performance of three major Indian equity indices using historical daily closing price data spanning 18 years (2007–2025):
- Nifty 50: Represents the float-adjusted market capitalization of the 50 largest companies listed on the National Stock Exchange (NSE).
- Nifty Next 50: Comprises the next 50 largest companies after those in the Nifty 50, often considered potential future entrants into the Nifty 50.
- Nifty Midcap 100: Covers companies ranked 101–200 by market capitalization, offering exposure to the midcap segment

Note: While the Nifty Midcap 150 would have been a more comprehensive representation of the midcap universe, historical data availability constraints led to the use of Nifty Midcap 100 instead.

It is widely believed that companies with smaller market capitalizations tend to offer higher return potential, albeit with greater volatility. To test this hypothesis, we analyze index-level returns across different time horizons

<img width="1691" height="770" alt="image" src="https://github.com/user-attachments/assets/dbb1598c-416b-4554-af24-86cc66d18762" />

1. Point-to-Point Returns (CAGR)
This method calculates the Compounded Annual Growth Rate between two specific dates. For example:
- From Jan 1 to Dec 31 of a given year
- Year-to-date (last 365 days)
- Any custom start and end date
While simple and intuitive, this approach is highly sensitive to the chosen time window. A strong or weak performance during the selected period can skew perception, making it unreliable for forecasting future returns.


2. Rolling Returns
Rolling returns offer a more robust view by calculating CAGR over every possible time window of a fixed duration (e.g., 3 years, 5 years) throughout the dataset. This answers the question:
“How consistently has the index delivered returns over all possible 3-year (or 5-year) periods?”

For instance, if data starts on Jan 1, 2000, the rolling 3-year windows would be:


01-01-2000 to 31-12-2002
02-01-2000 to 01-01-2003
03-01-2000 to 02-01-2003
…..
09-12-2020 to 10-12-2023
10-12-2020 to 11-12-2023
11-12-2020 to 12-12-2023

This method smooths out short-term noise and reveals the consistency and reliability of returns across market cycles.

<img width="1693" height="772" alt="image" src="https://github.com/user-attachments/assets/fef46f2e-0111-477f-a236-8afa6ededb62" />


Midcap and Nifty Next 50 indices don’t consistently outperform the Nifty 50. Their periods of outperformance are intermittent and unstable, lacking sustained momentum. At times, they lead, but those gains tend to fade, only to re-emerge later without any predictable pattern.










