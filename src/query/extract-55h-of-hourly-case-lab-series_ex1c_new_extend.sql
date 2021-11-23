/*
Extract 55 hours of LAB time series of sepsis case icustays (48 hours before onset and 7 hours after onset).
---------------------------------------------------------------------------------------------------------------------
- MODIFIED VERSION
- SOURCE: https://github.com/MIT-LCP/mimic-code/blob/7ff270c7079a42621f6e011de6ce4ddc0f7fd45c/concepts/firstday/lab-first-day.sql
- AUTHOR (of this version): Michael Moor, October 2018
---------------------------------------------------------------------------------------------------------------------
*/


-- This query pivots lab values 

DROP MATERIALIZED VIEW IF EXISTS case_55h_hourly_labs_ex1c_new_extend CASCADE;
CREATE materialized VIEW case_55h_hourly_labs_ex1c_new_extend AS
SELECT
  pvt.icustay_id
  , pvt.subject_id
  , pvt.chart_time
  , case 
    when pvt.chart_time < pvt.sepsis_onset then 0 
    when pvt.chart_time between pvt.sepsis_onset and (pvt.sepsis_onset+interval '5' hour ) then 1
    else 2 end as sepsis_target

  , CASE WHEN label = 'ALBUMIN' THEN valuenum ELSE null END as ALBUMIN
  , CASE WHEN label = 'ANION GAP' THEN valuenum ELSE null END as ANIONGAP
  , CASE WHEN label = 'BANDS' THEN valuenum ELSE null END as BANDS
  , CASE WHEN label = 'BICARBONATE' THEN valuenum ELSE null END as BICARBONATE
  , CASE WHEN label = 'BILIRUBIN' THEN valuenum ELSE null END as BILIRUBIN
  , CASE WHEN label = 'CREATININE' THEN valuenum ELSE null END as CREATININE
  , CASE WHEN label = 'CHLORIDE' THEN valuenum ELSE null END as CHLORIDE
  , CASE WHEN label = 'GLUCOSE' THEN valuenum ELSE null END as GLUCOSE
  , CASE WHEN label = 'HEMATOCRIT' THEN valuenum ELSE null END as HEMATOCRIT
  , CASE WHEN label = 'HEMOGLOBIN' THEN valuenum ELSE null END as HEMOGLOBIN
  , CASE WHEN label = 'LACTATE' THEN valuenum ELSE null END as LACTATE
  , CASE WHEN label = 'PLATELET' THEN valuenum ELSE null END as PLATELET
  , CASE WHEN label = 'POTASSIUM' THEN valuenum ELSE null END as POTASSIUM
  , CASE WHEN label = 'PTT' THEN valuenum ELSE null END as PTT
  , CASE WHEN label = 'PT' THEN valuenum ELSE null END as PT -- Prothrombin time
  , CASE WHEN label = 'SODIUM' THEN valuenum ELSE null END as SODIUM
  , CASE WHEN label = 'BUN' THEN valuenum ELSE null end as BUN
  , CASE WHEN label = 'WBC' THEN valuenum ELSE null end as WBC
  , CASE WHEN label = 'CK_MB' THEN valuenum ELSE null END as CK_MB
  , CASE WHEN label = 'Fibrinogen' THEN valuenum ELSE null END as Fibrinogen
  , CASE WHEN label = 'Magnesium' THEN valuenum ELSE null END as Magnesium
  , CASE WHEN label = 'Calcium_free' THEN valuenum ELSE null END as Calcium_free
  , CASE WHEN label = 'pH_bloodgas' THEN valuenum ELSE null END as pH_bloodgas
  , CASE WHEN label = 'pCO2_bloodgas' THEN valuenum ELSE null END as pCO2_bloodgas
  , CASE WHEN label = 'Troponin_T' THEN valuenum ELSE null END as Troponin_T
  , CASE WHEN label = 'Bilirubin_Direct' THEN valuenum ELSE null END as Bilirubin_Direct
  , CASE WHEN label = 'Calcium' THEN valuenum ELSE null END as Calcium
  , CASE WHEN label = 'Chol_HDL' THEN valuenum ELSE null END as Chol_HDL
  , CASE WHEN label = 'CO2' THEN valuenum ELSE null END as CO2
  , CASE WHEN label = 'MCH_Concentration' THEN valuenum ELSE null END as MCH_Concentration
  , CASE WHEN label = 'Mean_Corpuscular_Hemoglobin' THEN valuenum ELSE null END as Mean_Corpuscular_Hemoglobin
  , CASE WHEN label = 'Mean_Corpuscular_Volume' THEN valuenum ELSE null END as Mean_Corpuscular_Volume
  , CASE WHEN label = 'PaO2' THEN valuenum ELSE null END as PaO2
  , CASE WHEN label = 'RBC' THEN valuenum ELSE null END as RBC
  , CASE WHEN label = 'SaO2' THEN valuenum ELSE null END as SaO2
  , CASE WHEN label = 'Triglyceride' THEN valuenum ELSE null END as Triglyceride
  , CASE WHEN label = 'Troponin_I' THEN valuenum ELSE null END as Troponin_I

FROM
( -- begin query that extracts the data
  SELECT ie.subject_id, ie.hadm_id, ie.icustay_id
  , le.charttime as chart_time
  , ch.sepsis_onset
  , le.valueuom

  -- here we assign labels to ITEMIDs
  -- this also fuses together multiple ITEMIDs containing the same data
  , CASE
        WHEN itemid = 50862 THEN 'ALBUMIN'
        WHEN itemid = 50868 THEN 'ANION GAP'
        WHEN itemid = 51144 THEN 'BANDS'
        WHEN itemid = 50882 THEN 'BICARBONATE'
        WHEN itemid = 50885 THEN 'BILIRUBIN'
        WHEN itemid = 50912 THEN 'CREATININE'
        WHEN itemid = 50806 THEN 'CHLORIDE'
        WHEN itemid = 50902 THEN 'CHLORIDE'
        WHEN itemid = 50809 THEN 'GLUCOSE'
        WHEN itemid = 50931 THEN 'GLUCOSE'
        WHEN itemid = 50810 THEN 'HEMATOCRIT'
        WHEN itemid = 51221 THEN 'HEMATOCRIT'
        WHEN itemid = 50811 THEN 'HEMOGLOBIN'
        WHEN itemid = 51222 THEN 'HEMOGLOBIN'
        WHEN itemid = 50813 THEN 'LACTATE'
        WHEN itemid = 51265 THEN 'PLATELET'
        WHEN itemid = 50822 THEN 'POTASSIUM'
        WHEN itemid = 50971 THEN 'POTASSIUM'
        WHEN itemid = 51275 THEN 'PTT'
        WHEN itemid = 51274 THEN 'PT'
        WHEN itemid = 50824 THEN 'SODIUM'
        WHEN itemid = 50983 THEN 'SODIUM'
        WHEN itemid = 51006 THEN 'BUN'
        WHEN itemid = 51300 THEN 'WBC'
        WHEN itemid = 51301 THEN 'WBC'
        WHEN itemid = 50911 THEN 'CK_MB'
        WHEN itemid = 51214 THEN 'Fibrinogen'
        WHEN itemid = 50960 THEN 'Magnesium'
        WHEN itemid = 50808 THEN 'Calcium_free'
        WHEN itemid = 50820 THEN 'pH_bloodgas'
        WHEN itemid = 50818 THEN 'pCO2_bloodgas'
        WHEN itemid = 51003 THEN 'Troponin_T'
        WHEN itemid = 50883 THEN 'Bilirubin_Direct'
        WHEN itemid = 50893 THEN 'Calcium'
        WHEN itemid = 50904 THEN 'Chol_HDL'
        WHEN itemid = 50804 THEN 'CO2'
        WHEN itemid = 51249 THEN 'MCH_Concentration'
        WHEN itemid = 51248 THEN 'Mean_Corpuscular_Hemoglobin'
        WHEN itemid = 51250 THEN 'Mean_Corpuscular_Volume'
        WHEN itemid = 50821 THEN 'PaO2'
        WHEN itemid = 51279 THEN 'RBC'
        WHEN itemid = 50817 THEN 'SaO2'
        WHEN itemid = 51000 THEN 'Triglyceride'
        WHEN itemid = 51002 THEN 'Troponin_I'

      ELSE null
    END AS label
  , -- add in some sanity checks on the values
  -- the where clause below requires all valuenum to be > 0, so these are only upper limit checks
    CASE
      WHEN itemid = 50862 and valuenum >    10 THEN null -- g/dL 'ALBUMIN'
      WHEN itemid = 50868 and valuenum > 10000 THEN null -- mEq/L 'ANION GAP'
      WHEN itemid = 51144 and valuenum >   100 THEN null -- immature band forms, %
      WHEN itemid = 50882 and valuenum > 10000 THEN null -- mEq/L 'BICARBONATE'
      WHEN itemid = 50885 and valuenum >   150 THEN null -- mg/dL 'BILIRUBIN'
      WHEN itemid = 50806 and valuenum > 10000 THEN null -- mEq/L 'CHLORIDE'
      WHEN itemid = 50902 and valuenum > 10000 THEN null -- mEq/L 'CHLORIDE'
      WHEN itemid = 50912 and valuenum >   150 THEN null -- mg/dL 'CREATININE'
      WHEN itemid = 50809 and valuenum > 10000 THEN null -- mg/dL 'GLUCOSE'
      WHEN itemid = 50931 and valuenum > 10000 THEN null -- mg/dL 'GLUCOSE'
      WHEN itemid = 50810 and valuenum >   100 THEN null -- % 'HEMATOCRIT'
      WHEN itemid = 51221 and valuenum >   100 THEN null -- % 'HEMATOCRIT'
      WHEN itemid = 50811 and valuenum >    50 THEN null -- g/dL 'HEMOGLOBIN'
      WHEN itemid = 51222 and valuenum >    50 THEN null -- g/dL 'HEMOGLOBIN'
      WHEN itemid = 50813 and valuenum >    50 THEN null -- mmol/L 'LACTATE'
      WHEN itemid = 51265 and valuenum > 10000 THEN null -- K/uL 'PLATELET'
      WHEN itemid = 50822 and valuenum >    30 THEN null -- mEq/L 'POTASSIUM'
      WHEN itemid = 50971 and valuenum >    30 THEN null -- mEq/L 'POTASSIUM'
      WHEN itemid = 51275 and valuenum >   150 THEN null -- sec 'PTT'
      WHEN itemid = 51274 and valuenum >   150 THEN null -- sec 'PT'
      WHEN itemid = 50824 and valuenum >   200 THEN null -- mEq/L == mmol/L 'SODIUM'
      WHEN itemid = 50983 and valuenum >   200 THEN null -- mEq/L == mmol/L 'SODIUM'
      WHEN itemid = 51006 and valuenum >   300 THEN null -- 'BUN'
      WHEN itemid = 51300 and valuenum >  1000 THEN null -- 'WBC'
      WHEN itemid = 51301 and valuenum >  1000 THEN null -- 'WBC'
      WHEN itemid = 50911 and valuenum > 10000 THEN null -- ng/mL Creatine Kinase, MB Isoenzyme Blood Chemistry
      WHEN itemid = 51214 and valuenum > 10000 THEN null -- mg/dL Fibrinogen, Functional  Blood Hematology
      WHEN itemid = 50960 and valuenum > 50 THEN null -- mg/dL Magnesium Blood Chemistry
      WHEN itemid = 50808 and valuenum > 50 THEN null -- mmol/L Free Calcium  Blood Blood Gas
      WHEN itemid = 50820 and valuenum > 15 THEN null -- pH units Blood Blood Gas
      WHEN itemid = 50818 and valuenum > 500 THEN null  -- mm Hg, pCO2  Blood Blood Gas
      WHEN itemid = 51003 and valuenum > 100 THEN null  -- ng/mL, Troponin T  Blood Chemistry

    ELSE le.valuenum
    END AS valuenum

  from cases_hourly_ex1c ch -- was icustays ie (changed it below as well)
      left join icustays ie
      on ch.icustay_id = ie.icustay_id
    LEFT JOIN labevents le
      ON le.subject_id = ie.subject_id AND le.hadm_id = ie.hadm_id
      AND le.charttime BETWEEN (ch.sepsis_onset - interval '72' hour) AND (ch.sepsis_onset+interval '7' hour)
      AND le.ITEMID in
    (
      -- comment is: LABEL | CATEGORY | FLUID | NUMBER OF ROWS IN LABEVENTS
      50862, -- ALBUMIN | CHEMISTRY | BLOOD | 146697
      50868, -- ANION GAP | CHEMISTRY | BLOOD | 769895
      51144, -- BANDS - hematology
      50882, -- BICARBONATE | CHEMISTRY | BLOOD | 780733
      50885, -- BILIRUBIN, TOTAL | CHEMISTRY | BLOOD | 238277
      50912, -- CREATININE | CHEMISTRY | BLOOD | 797476
      50902, -- CHLORIDE | CHEMISTRY | BLOOD | 795568
      50806, -- CHLORIDE, WHOLE BLOOD | BLOOD GAS | BLOOD | 48187
      50931, -- GLUCOSE | CHEMISTRY | BLOOD | 748981
      50809, -- GLUCOSE | BLOOD GAS | BLOOD | 196734
      51221, -- HEMATOCRIT | HEMATOLOGY | BLOOD | 881846
      50810, -- HEMATOCRIT, CALCULATED | BLOOD GAS | BLOOD | 89715
      51222, -- HEMOGLOBIN | HEMATOLOGY | BLOOD | 752523
      50811, -- HEMOGLOBIN | BLOOD GAS | BLOOD | 89712
      50813, -- LACTATE | BLOOD GAS | BLOOD | 187124
      51265, -- PLATELET COUNT | HEMATOLOGY | BLOOD | 778444
      50971, -- POTASSIUM | CHEMISTRY | BLOOD | 845825
      50822, -- POTASSIUM, WHOLE BLOOD | BLOOD GAS | BLOOD | 192946
      51275, -- PTT | HEMATOLOGY | BLOOD | 474937
      51274, -- PT | HEMATOLOGY | BLOOD | 469090
      50983, -- SODIUM | CHEMISTRY | BLOOD | 808489
      50824, -- SODIUM, WHOLE BLOOD | BLOOD GAS | BLOOD | 71503
      51006, -- UREA NITROGEN | CHEMISTRY | BLOOD | 791925
      51301, -- WHITE BLOOD CELLS | HEMATOLOGY | BLOOD | 753301
      51300,  -- WBC COUNT | HEMATOLOGY | BLOOD | 2371
      50911,  -- Creatine Kinase, MB Isoenzyme Blood Chemistry
      51214,  -- Fibrinogen, Functional  Blood Hematology
      50960,  -- Magnesium Blood Chemistry
      50808,  -- Free Calcium  Blood Blood Gas
      50820,  -- pH  Blood Blood Gas
      50818,  -- pCO2  Blood Blood Gas
      51003,  -- Troponin T  Blood Chemistry
      50883,   -- Bilirubin_Direct
      50893,   -- Calcium
      50904,   -- Chol_HDL
      50804,   -- CO2
      51249,   -- MCH_Concentration
      51248,   -- Mean_Corpuscular_Hemoglobin
      51250,   -- Mean_Corpuscular_Volume
      50821,   -- PaO2
      51279,   -- RBC
      50817,   -- SaO2
      51000,   -- Triglyceride
      51002    -- Troponin_I

    )
    AND valuenum IS NOT null AND valuenum > 0 -- lab values cannot be 0 and cannot be negative
) pvt
--GROUP BY pvt.icustay_id, pvt.subject_id, pvt.hadm_id 
ORDER BY pvt.icustay_id, pvt.subject_id, pvt.hadm_id, pvt.chart_time;






