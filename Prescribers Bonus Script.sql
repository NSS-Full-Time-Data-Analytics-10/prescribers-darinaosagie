--1. How many npi numbers appear in the prescriber table but not in the prescription table? 660516

---NPIs in presciber - 25050
SELECT *
FROM prescriber

--NPIS in prescription 656058
SELECT COUNT(npi)
FROM prescription

SELECT COUNT(npi)
FROM prescriber
LEFT JOIN prescription USING (npi)

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









---3. Your goal in this question is to generate a list of the top prescribers in each of the major metropolitan areas of Tennessee.
	-- Write a query that finds the top 5 prescribers in Nashville in terms of the total number of claims (total_claim_count) across all drugs.
	SELECT*
	FROM prescriber
	INNER JOIN prescription USING (npi)

	SELECT npi,SUM(total_claim_count) AS total_claim_count
	FROM prescriber
	INNER JOIN prescription USING (npi)
	WHERE nppes_provider_city = 'Nashville'
	

