/*
Extract 55 hours of vital time series of sepsis case icustays (48 hours before onset and 7 hours after onset).
---------------------------------------------------------------------------------------------------------------------
- MODIFIED VERSION
- SOURCE: https://github.com/MIT-LCP/mimic-code/blob/7ff270c7079a42621f6e011de6ce4ddc0f7fd45c/concepts/firstday/vitals-first-day.sql
- AUTHOR (of this version): Michael Moor, October 2018
- HINT: to add/remove vitals uncomment/comment both the 'case' statements (e.g. l.35) the corresponding itemids below (e.g. l.112,113)
- CAVE: For our purposes we did not use CareVue data. Therefore their IDs were removed from the 'case' statement in l.66!
    However, you find them commented out in the 'where' clause at the end of the script.
---------------------------------------------------------------------------------------------------------------------
*/

--extract-time-series.sql
-- extract time series, TEMPLATE/inspiration: vitals-first-day.sql
-- info: to choose only 1 vital: comment out both the case statement (l.14) of the other variables and the corresponding itemids below (l.71-127)


DROP MATERIALIZED VIEW IF EXISTS case_55h_hourly_vitals_ex1c_new_extend2 CASCADE;
create materialized view case_55h_hourly_vitals_ex1c_new_extend2 as
SELECT  pvt.icustay_id, pvt.subject_id -- removed , pvt.hadm_id,
,   pvt.chart_time 
, case 
    when pvt.chart_time < pvt.sepsis_onset then 0 
    when pvt.chart_time between pvt.sepsis_onset and (pvt.sepsis_onset+interval '5' hour ) then 1
    else 2 end as sepsis_target
--, case
--  when pvt.sepsis_onset > (pvt.intime + interval '150' hour) then 1
--  else 0 end as late_onset_after_150h

-- Easier names

, case when VitalID = 1 then valuenum else null end as HeartRate
, case when VitalID = 2 then valuenum else null end as SysBP
, case when VitalID = 3 then valuenum else null end as DiaBP
, case when VitalID = 4 then valuenum else null end as MeanBP
, case when VitalID = 5 then valuenum else null end as RespRate
, case when VitalID = 6 then valuenum else null end as TempC
, case when VitalID = 7 then valuenum else null end as SpO2_pulsoxy
, case when VitalID = 16 then valuenum else null end as TVset
, case when VitalID = 17 then valuenum else null end as TVobserved
, case when VitalID = 18 then valuenum else null end as TVspontaneous
, case when VitalID = 21 then valuenum else null end as TotalPEEPLevel
, case when VitalID = 24 then valuenum else null end as FiO2
, case when VitalID = 25 then valuenum else null end as Pain_Score
, case when VitalID = 26 then valuenum else null end as Urine_Output
, case when VitalID = 27 then valuenum else null end as ETCO2
, case when VitalID = 28 then valuenum else null end as HCO3
, case when VitalID = 29 then valuenum else null end as Alk_Phos
, case when VitalID = 30 then valuenum else null end as Base_Excess
, case when VitalID = 31 then valuenum else null end as Pulse
, case when VitalID = 32 then valuenum else null end as Supplmental_Oxygen
, case when VitalID = 33 then valuenum else null end as QT_Interval
, case when VitalID = 34 then valuenum else null end as BradenSensoryPerception
, case when VitalID = 35 then valuenum else null end as BradenMoisture
, case when VitalID = 36 then valuenum else null end as BradenActivity
, case when VitalID = 37 then valuenum else null end as BradenMobility
, case when VitalID = 38 then valuenum else null end as BradenNutrition
, case when VitalID = 39 then valuenum else null end as BradenFrictionShear

FROM  (
  select ch.icustay_id, ie.subject_id -- removed: ie.subject_id, ie.hadm_id, 
  , case
    when itemid in (220045) and valuenum > 0 and valuenum < 300 then 1 -- HeartRate
    when itemid in (220179,220050,225309) and valuenum > 0 and valuenum < 400 then 2 -- SysBP
    when itemid in (220180,220051,225310) and valuenum > 0 and valuenum < 300 then 3 -- DiasBP
    when itemid in (220052,220181,225312) and valuenum > 0 and valuenum < 300 then 4 -- MeanBP
    when itemid in (220210,224690) and valuenum > 0 and valuenum < 70 then 5 -- RespRate
    when itemid in (223761) and valuenum > 70 and valuenum < 120  then 6 -- TempF, converted to degC in valuenum call
    when itemid in (223762) and valuenum > 10 and valuenum < 50  then 6 -- TempC
    when itemid in (220277) and valuenum > 0 and valuenum <= 100 then 7 -- SpO2
    when itemid in (224684) and valuenum > 0 then 16 -- Tidal Volume (set) (ml)
    when itemid in (224685) and valuenum > 0 then 17 -- Tidal Volume (observed) (ml)
    when itemid in (224686) and valuenum > 0 then 18 -- Tidal Volume (spontaneous) (ml)
    when itemid in (224700) and valuenum >= 0 then 21 -- Total PEEP Level   metavision  chartevents Respiratory (cmH2O)
    when itemid in (223835) and valuenum >= 0 then 24 -- Inspired O2 Fraction  FiO2  metavision  chartevents Respiratory (No unit)
    when itemid in (227881) and valuenum >= 0 then 25 -- Pain Score
    when itemid in (226559, 226560, 227510, 226561, 226584, 226563, 226564, 226565, 226567, 226557, 226558) and valuenum >= 0 then 26 -- Urine Output
    when itemid in (228640) and valuenum >= 0 then 27 -- ETCO2
    when itemid in (227443) and valuenum >= 0 then 28 -- HCO3
    when itemid in (225612) and valuenum >= 0 then 29 -- Alk Phos, Serum
    when itemid in (224828) and valuenum >= 0 then 30 -- Base Excess
    when itemid in (223944, 223945, 223946, 223947, 223948, 223949, 228194, 223934, 223935, 223936, 223938, 223939, 223940, 223941, 223942, 223943) and valuenum >= 0 then 31 -- Pulse
    when itemid in (223848) and valuenum >= 0 then 32 -- Supplmental Oxygen
    when itemid in (224359) and valuenum >= 0 then 33 -- QT Interval
    when itemid in (224054) and valuenum >= 0 then 34 -- BradenSensoryPerception
    when itemid in (224055) and valuenum >= 0 then 35 -- BradenMoisture
    when itemid in (224056) and valuenum >= 0 then 36 -- BradenActivity
    when itemid in (224057) and valuenum >= 0 then 37 -- BradenMobility
    when itemid in (224058) and valuenum >= 0 then 38 -- BradenNutrition
    when itemid in (224059) and valuenum >= 0 then 39 -- BradenFrictionShear

    else null end as VitalID
      -- convert F to C
  , case when itemid in (223761) then (valuenum-32)/1.8 else valuenum end as valuenum
  , ce.charttime as chart_time
  , ch.sepsis_onset
  , s3c.intime

  from cases_hourly_ex1c ch -- was icustays ie (changed it below as well)
  left join icustays ie
    on ch.icustay_id = ie.icustay_id
  left join sepsis3_cohort s3c
    on ch.icustay_id = s3c.icustay_id
  left join chartevents ce
    on ch.icustay_id = ce.icustay_id -- removed: ie.subject_id = ce.subject_id and ie.hadm_id = ce.hadm_id and 
  and ce.charttime between (ch.sepsis_onset-interval '96' hour ) and (ch.sepsis_onset+interval '7' hour ) 

  -- exclude rows marked as error
  where ce.error=0 and
   ce.itemid in -- and sepsis_case = 1
  (
  -- HEART RATE
  220045, --"Heart Rate"

  -- Systolic
  220179, --    Non Invasive Blood Pressure systolic
  220050, --    Arterial Blood Pressure systolic
  225309, --    ART BP systolic
  
  -- Diastolic
  220180, --    Non Invasive Blood Pressure diastolic
  220051, --    Arterial Blood Pressure diastolic
  225310, --    ART BP diastolic

  -- MEAN ARTERIAL PRESSURE
  220052, --"Arterial Blood Pressure mean"
  220181, --"Non Invasive Blood Pressure mean"
  225312, --"ART BP mean"

  -- RESPIRATORY RATE
  220210,-- Respiratory Rate
  224690, --, --    Respiratory Rate (Total)

  -- TEMPERATURE
  223762, -- "Temperature Celsius"
  223761, -- "Temperature Fahrenheit"

  -- SPO2, peripheral
  220277,

  -- Tidal Volume set 
  224684, -- (ml)

  -- Tidal Volume (observed)
  224685, -- (ml)

  -- Tidal Volume (spontaneous)
  224686, -- (ml)
  
  -- Total PEEP Level 
  224700, -- Total PEEP Level   metavision  chartevents Respiratory (cmH2O)

  -- Inspired O2 Fraction  (FiO2)
  223835, -- Inspired O2 Fraction  FiO2  metavision  chartevents Respiratory (No unit)

  -- Pain Score
  227881,

  -- Urine Output
  226559, 226560, 227510, 226561, 226584, 226563, 226564, 226565, 226567, 226557, 226558,

  -- ETCO2
  228640,

  -- HCO3
  227443,

  -- Alk Phos, Serum
  225612,

  -- Base Excess
  224828,

  -- Pulse
  223944, 223945, 223946, 223947, 223948, 223949, 228194, 223934, 223935, 223936, 223938, 223939, 223940, 223941, 223942, 223943,

  -- Supplmental Oxygen
  223848,

  -- QT Interval
  224359,

  -- Braden Scale
  224054, -- BradenSensoryPerception
  224055, -- BradenMoisture
  224056, -- BradenActivity
  224057, -- BradenMobility
  224058, -- BradenNutrition
  224059 -- BradenFrictionShear

  )
  
) pvt
--group by pvt.subject_id, pvt.hadm_id, pvt.icustay_id
order by pvt.icustay_id, pvt.subject_id, pvt.chart_time; -- removed pvt.hadm_id, 
