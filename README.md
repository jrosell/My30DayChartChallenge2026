# My30DayChartChallenge2026

As every year, the goal for the [#30DayChartChallenge 2026 edition](https://github.com/30DayChartChallenge/Edition2026) is to create one plot per day for 30 days.

My plan is to:

- Use the same [dataset](https://transtats.bts.gov/TableInfo.asp?gnoyr_VQ=FGJ&QO_fu146_anzr=b0-gvzr&V0s1_b0yB=D) throughout all 30 days.
- Save the [R code in this repo ](https://github.com/jrosell/My30DayChartChallenge2026)and leverage R development tools.
- Publish a [Quarto website on GitHub Pages](https://jrosell.github.io/My30DayChartChallenge2026) to showcase the plots.


## Dataset

Reporting Carrier On-Time Performance (1987–present)  
[Data source](https://transtats.bts.gov/TableInfo.asp?gnoyr_VQ=FGJ&QO_fu146_anzr=b0-gvzr&V0s1_b0yB=D)

**Key Variables Overview:**

- **Time Period:** Year, Quarter, Month, DayOfMonth, DayOfWeek, FlightDate  
- **Airline:** Reporting_Airline, DOT_ID_Reporting_Airline, IATA_CODE_Reporting_Airline, Tail_Number, Flight_Number_Reporting_Airline  
- **Origin & Destination:** OriginAirportID, OriginCityMarketID, Origin, OriginState, DestAirportID, DestCityMarketID, Dest, DestState  
- **Departure & Arrival Performance:** CRSDepTime, DepTime, DepDelay, DepDel15, CRSArrTime, ArrTime, ArrDelay, ArrDel15, TaxiIn, TaxiOut  
- **Cancellations & Diversions:** Cancelled, CancellationCode, Diverted  
- **Flight Summaries:** CRSElapsedTime, ActualElapsedTime, AirTime, Flights, Distance  
- **Cause of Delay (from 6/2003):** CarrierDelay, WeatherDelay, NASDelay, SecurityDelay, LateAircraftDelay  
- **Gate Return & Diverted Flight Information (from 10/2008)**: FirstDepTime, TotalAddGTime, LongestAddGTime, DivAirportLandings, DivReachedDest, DivActualElapsedTime, DivArrDelay, DivDistance, Div1–Div4 airport details  


## Topics by Day

### Comparisons

1. Part-to-Whole
2. Pictogram
3. Mosaic
4. Slope
5. Experimental
6. theme day: FlowingData

### Distributions

7. Multiscale
8. Circular
9. Wealth
10. Pop culture
11. Physical
12. data day: Reporters Without Borders

### Relationships

13. Ecosystems
14. Trade
15. Correlation
16. Causation
17. Remake
18. theme day: South China Morning Post

### Timeseries

19. Evolution
20. Global change
21. Historical
22. New tool
23. Seasons
24. data day: UNICEF

### Uncertainties

25. Space
26. Trend
27. Animation
28. Modeling
29. Monochrome
30. theme day



## Inspiration 

### Mapping Data to Chart Types

**Continuous Variables:** DepDelay, ArrDelay, Distance, AirTime, TaxiOut, WeatherDelay, CarrierDelay  
**Discrete Variables:** Marketing_Airline_Network, Operating_Airline, Origin, Dest  
**Date Variables:** DayOfWeek, Month, FlightDate  

| var1       | var2       | var3       | Best chart                 |
| ---------- | ---------- | ---------- | -------------------------- |
| Continuous | -          | -          | Histogram / Density        |
| Continuous | Continuous | -          | Scatter                    |
| Continuous | Continuous | Discrete   | Scatter + Color            |
| Discrete   | -          | -          | Bar (counts)               |
| Discrete   | Continuous | -          | Bar / Box / Violin         |
| Discrete   | Discrete   | -          | Heatmap (counts)           |
| Discrete   | Discrete   | Continuous | Heatmap (values)           |
| Date       | Continuous | -          | Line                       |
| Date       | Continuous | Discrete   | Multi-line                 |
| Date       | Discrete   | -          | Calendar / Heatmap         |
| Continuous | Continuous | Continuous | Bubble / Contour           |

### From other years

* https://www.cedricscherer.com/2021/05/09/contributions-30daychartchallenge-2021/
* https://public.tableau.com/app/profile/rishabhbahuguna03/viz/Day0130DayChartChallengeParttowhole/Day0130Parttowhole
* https://github.com/terezaif/30DayChartChallenge/
* https://www.cedricscherer.com/2021/05/09/contributions-30daychartchallenge-2021/
* https://www.cedricscherer.com/2024/04/01/contributions-30daychartchallenge-2024/
* https://github.com/moriahtaylor1/30DayChartChallenge
* https://helenajambor.wordpress.com/2022/04/01/30daychartchallenge/
* https://www.linkedin.com/posts/cedscherer_30daychartchallenge-dataviz-ggplot2-activity-7445209428364222465-ReHx/
* https://perthirtysix.com/essay/30-day-chart-challenge-2024
* https://observablehq.com/@mukhtyar/day-1-part-to-whole?collection=@mukhtyar/30-day-chart-challenge-2022
* https://fgazzelloni.quarto.pub/30daychartchallenge/edition2023.html
* https://elle-est-au-nord.github.io/30daychartchallenge/
* https://www.datawrapper.de/blog/cedric-scherer-30daychartchallenge
* https://www.instagram.com/p/C5OR_Gstj8b/
* https://www.gregdubrow.io/posts/30-day-chart-challenge-2025/
* https://datavis.blog/2021/05/02/30daychartchallenge/
* https://public.tableau.com/app/profile/marc.reid/viz/30DayChartChallenge01part-to-whole/ofInternationalStudentsbyCountry
* https://x.com/AsjadNaqvi/status/2039402965648187895
* https://x.com/AsjadNaqvi/status/1774915022298198471
* https://flowingdata.com/2023/05/02/one-day-chart-challenge/
* https://public.tableau.com/app/profile/nicole.mark/viz/30DayChartChallengePart-to-WholeShelterDogIntakesbyBreed/IntakesbyBreedPRC
* https://www.linkedin.com/posts/michal-kinel_30daychartchallenge-ggplot2-dataviz-activity-7445002035034304512-YKzy/?originalSubdomain=es
* https://observablehq.com/@alexaac/30daychartchallenge-comparisons-part-to-whole
* https://helenajambor.wordpress.com/tag/30daychartchallenge/
* https://github.com/RamiKrispin/30DayChartChallenge/blob/main/README.md
* https://nrennie.rbind.io/blog/30-day-chart-challenge-2025/


## Status

- [x] 1. Comparisons: Part-to-Whole. Waffle flight status using 100 tiles On Time → Delayed → Cancelled. How reliable are US flights overall?
- [ ] 2. Comparisons: Pictogram. Top 2 airports, normalized pictogram faceted 3x3 plot 100 icon per aiport and color status?
- [ ] 3. Comparisons: Mosaic. Are flights more delayed in winter/summer? c(12,1,2) ~ "Winter", c(3,4,5) ~ "Spring", c(6,7,8) ~ "Summer", TRUE ~ "Fall"
- [ ] 4. Comparisons: Slope. rank(desc(on_time_rate)) top 10 and highlight biggest improver and biggest drop
- [ ] 5. Comparisons: Experimental. Heatmap of mean(arr_delay >= 15) by airline and airport
