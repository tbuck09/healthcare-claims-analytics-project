WITH opioid_cte
AS (
	SELECT *
	FROM drug_exclusions
	WHERE (
			exclude_htpp_all != 'Excl'
			AND exclude_htpp_pill_ct != 'Excl'
			AND exclude_pip_all != 'Excl'
			)
	)
SELECT rp.*
	,o.drug
	,o.generic_drug_name
FROM raw_prescription_drug_events rp
JOIN opioid_cte o ON product_service_identifier = o.ndc
