-1. How many npi numbers appear in the prescriber table but not in the prescription table? 
SELECT COUNT(prescriber.npi) - COUNT(prescription.npi)
FROM prescriber LEFT JOIN prescription USING (npi)


--2a.Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Family Practice.
SELECT drug_name, SUM (total_claim_count) AS claim_count
FROM prescription
INNER JOIN prescriber
USING (npi)
WHERE specialty_description ='Family Practice'
GROUP BY drug_name
ORDER BY claim_count DESC
LIMIT 5

--2b. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Cardiology.
SELECT drug_name, SUM (total_claim_count) AS claim_count
FROM prescription
INNER JOIN prescriber
USING (npi)
WHERE specialty_description ='Cardiology'
GROUP BY drug_name
ORDER BY claim_count DESC
LIMIT 5

--2c.Which drugs are in the top five prescribed by Family Practice prescribers and Cardiologists?
SELECT drug.drug_name, SUM(prescription.total_claim_count) AS total_claims
FROM prescription
INNER JOIN drug USING (drug_name)
INNER JOIN prescriber USING (npi)
WHERE prescriber.specialty_description IN ('Family Practice', 'Cardiology')
GROUP BY drug.drug_name
ORDER BY total_claims DESC
LIMIT 5;



---3. Your goal in this question is to generate a list of the top prescribers in each of the major metropolitan areas of Tennessee.
	-- Write a query that finds the top 5 prescribers in Nashville in terms of the total number of claims (total_claim_count) across all drugs.

		SELECT prescriber.npi, SUM(prescription.total_claim_count) AS total_claims
		FROM prescriber
		INNER JOIN prescription ON prescriber.npi = prescription.npi
		WHERE prescriber.nppes_provider_city = 'NASHVILLE'
		GROUP BY prescriber.npi
		ORDER BY total_claims DESC
		LIMIT 5;

     --- Now, report the same for Memphis.
	 
		SELECT prescriber.npi, SUM(prescription.total_claim_count) AS total_claims
		FROM prescriber
		INNER JOIN prescription ON prescriber.npi = prescription.npi
		WHERE prescriber.nppes_provider_city = 'MEMPHIS'
		GROUP BY prescriber.npi
		ORDER BY total_claims DESC
		LIMIT 5;
		
--4. Find all counties which had an above-average number of overdose deaths. Report the county name and number of overdose deaths.


SELECT fips_county.county, AVG(overdose_deaths.fipscounty) AS avg_od
FROM overdose_deaths
INNER JOIN fips_county ON overdose_deaths.fipscounty = CAST(fips_county.fipscounty AS numeric)
GROUP BY fips_county.county
HAVING SUM(overdose_deaths.fipscounty) > AVG(overdose_deaths.fipscounty)
ORDER BY avg_od;




