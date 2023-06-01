--1a. Which prescriber had the highest total number of claims (totaled over all drugs)? NPI and claims--NPI 19122011792, 4538 total, 
SELECT DISTINCT(npi), nppes_provider_last_org_name, nppes_provider_first_name, total_claim_count
FROM prescriber
INNER JOIN prescription
USING(NPI)
ORDER BY total_claim_count DESC
--1b. Report provider full name, and speicality drug. --David Coffey
SELECT DISTINCT(npi), nppes_provider_last_org_name, nppes_provider_first_name, total_claim_count
FROM prescriber
INNER JOIN prescription
USING(NPI)
ORDER BY total_claim_count DESC;

--2a. Which specialty had the most total number of claims (totaled over all drugs)? Family Practice

SELECT specialty_description, SUM(total_claim_count) AS total_claim_count
FROM prescriber FULL JOIN prescription ON prescriber.npi = prescription.npi
WHERE total_claim_count IS NOT NULL
GROUP BY specialty_description
ORDER BY total_claim_count DESC;

--2b. Which specialty had the most total number of claims for opioids? Family practice 
SELECT drug_name,specialty_description, total_claim_count
FROM prescription
INNER JOIN drug USING(drug_name)
INNER JOIN prescriber USING(npi)
WHERE drug.opioid_drug_flag = 'Y'
ORDER BY total_claim_count DESC;


--3a. Which drug (generic_name) had the highest total drug cost?
SELECT generic_name, SUM(total_drug_cost) AS total_drug_cost
FROM drug
INNER JOIN prescription USING(drug_name)
GROUP BY generic_name 
ORDER BY total_drug_cost DESC;

--3b. Which drug (generic_name) has the hightest total cost per day?
SELECT generic_name, ROUND(SUM(total_drug_cost)/SUM(total_day_supply),2) AS drug_cost
FROM drug
INNER JOIN prescription USING(drug_name)
GROUP BY generic_name
ORDER BY drug_cost DESC;

--4a. 
SELECT DISTINCT(drug_name),
	CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
	     WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
		 ELSE 'NONE'
	END AS drug_type
FROM drug
ORDER BY drug_name DESC

--4b. 
SELECT SUM(total_drug_cost)::money AS total_drug_cost,
	CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
	     WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
		 ELSE 'NONE'
	END AS drug_type
FROM drug
FULL JOIN prescription
USING(drug_name)
GROUP BY drug_type
ORDER BY total_drug_cost; 

--5a. How many CBSAs are in Tennessee? 42
SELECT COUNT (DISTINCT cbsa)
FROM cbsa AS c
INNER JOIN fips_county AS f
USING(fipscounty)
WHERE f.state = 'TN' 

--5b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population. 
--Largest - Nashville_davidson-murfressboro-franklin 1830410
--smallest -- morristown 116352

SELECT f.county, p.population
FROM fips_county AS f
JOIN population AS p
USING(fipscounty)
GROUP BY f.county, p.population
ORDER BY p.population DESC;

--5c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.
SELECT 
FROM cbsa AS c
INNER JOIN fips_county AS f
USING(fipscounty)
WHERE f.state = 'TN' 


--6a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.
SELECT drug_name, total_claim_count
FROM prescription
WHERE total_claim_count >='3000';

--6b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.
SELECT drug_name, total_claim_count, opioid_drug_flag
FROM prescription
LEFT JOIN drug USING(drug_name)
WHERE total_claim_count >='3000';

--6c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.
SELECT drug_name, total_claim_count, opioid_drug_flag,nppes_provider_first_name || ' '||  nppes_provider_last_org_name
FROM prescription
INNER JOIN drug USING(drug_name)
INNER JOIN prescriber USING (npi)
WHERE total_claim_count >='3000';

--7a. 
SELECT npi, drug_name, specialty_description 
FROM prescriber CROSS JOIN drug
WHERE specialty_description = 'Pain Management'
	  AND nppes_provider_city = 'NASHVILLE'
	  AND opioid_drug_flag = 'Y'
GROUP BY npi, drug_name, specialty_description
ORDER BY npi;

--7b. 
SELECT npi, drug.drug_name, SUM(total_claim_count) 
FROM prescriber CROSS JOIN drug
FULL JOIN prescription USING(npi)
WHERE specialty_description = 'Pain Management'
	  AND nppes_provider_city = 'NASHVILLE'
	  AND opioid_drug_flag = 'Y'
GROUP BY npi, drug.drug_name
ORDER BY npi;
