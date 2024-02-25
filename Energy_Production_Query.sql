SELECT 
	CONVERT(DATETIME, LEFT(YYYYMM, 4) + '-01-01') AS Date, -- Converting the integer date into a proper date, for data visualization purposes.
	Value, -- Amount of energy production in btu, quadrillions.
	Description, -- Sub-category
	CASE -- Creating Categories that will split into either 'Renewable' or 'Fossil Fuels'
		WHEN Description = 'Hydroelectric Power Production' THEN 'Renewables'
		WHEN Description = 'Biomass Energy Production' THEN 'Renewables'
		WHEN Description = 'Geothermal Energy Production' THEN 'Renewables'
		WHEN Description = 'Solar Energy Production' THEN 'Renewables'
		WHEN Description = 'Wind Energy Production' THEN 'Renewables'
		ELSE 'Fossil Fuels'
	END AS Category
FROM energy_production
WHERE Value IS NOT NULL -- Cleaning up data 
GROUP BY energy_production.YYYYMM,
	Value,
	Description,
	Unit
HAVING RIGHT(energy_production.YYYYMM, 2) = 13 -- This is to make sure that I will only get dates that are summaries of the year. I found that the yearly amounts are all 13.
	AND LEFT(Description, 5) != 'Total' -- Making sure that only totals are not seen.
ORDER BY Date, Description DESC; -- Ordering by date, then description to indicate the total amounts first.

/* The following categorizations are made :
Renewable: Hydroelectric Power Production, Biomass Energy Production, Geothermal Energy Production, Solar Energy Production, Wind Energy Production

Fossil Fuels: Coal Production, Crude Oil Production, Natural Gas Plant Liquids Production, Natural Gas (Dry) Production
*/