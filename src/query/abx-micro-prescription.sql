/*
- ORIGINAL VERSION. 
- SOURCE: https://github.com/alistairewj/sepsis3-mimic/blob/master/query/tbls/abx-micro-prescription.sql
- DOWNLOADED on 8th February 2018
*/

-- only works for metavision as carevue does not accurately document antibiotics

-- abx_poe_list: antibiotics considered in definition of SI
-- startdate and enddate have timestamps, but are mostly 00:00:00
DROP TABLE IF EXISTS abx_micro_poe CASCADE;
CREATE TABLE abx_micro_poe as
with mv as
(
  select hadm_id
  , mv.drug as antibiotic_name
  , startdate as antibiotic_time
  , enddate as antibiotic_endtime
  from prescriptions mv
  inner join abx_poe_list ab
      on mv.drug = ab.drug
)
-- get cultures for each icustay
-- note this duplicates data across ICU stays for the same hospitalization
-- we later filter down to first ICU stay so not concerned about it
-- ICU 입원 환자들 중에 우리가 선택한 antibiotics를 맞고 있는 사람을 선택
, ab_tbl as
(
  select
        ie.subject_id, ie.hadm_id, ie.icustay_id
      , ie.intime, ie.outtime
      , mv.antibiotic_name
      , mv.antibiotic_time
      , mv.antibiotic_endtime
      -- , ROW_NUMBER() over
      -- (
      --   partition by ie.icustay_id
      --   order by mv.antibiotic_time, mv.antibiotic_endtime
      -- ) as rn
  from icustays ie
  left join mv
      on ie.hadm_id = mv.hadm_id
)
, me as
(
  select hadm_id
    , chartdate, charttime
    , spec_type_desc
    , max(case when org_name is not null and org_name != '' then 1 else 0 end) as PositiveCulture
  from microbiologyevents
  group by hadm_id, chartdate, charttime, spec_type_desc
)
 -- antibiotics를 맞고 있는 환자중에 culture test 결과가 있는 환자가 있다면, 그 data를 붙임 
, ab_fnl as
(
  select
      ab_tbl.icustay_id, ab_tbl.intime, ab_tbl.outtime
    , ab_tbl.antibiotic_name
    , ab_tbl.antibiotic_time
    , coalesce(me72.charttime,me72.chartdate) as last72_charttime
    , coalesce(me24.charttime,me24.chartdate) as next24_charttime

    , me72.positiveculture as last72_positiveculture
    , me72.spec_type_desc as last72_specimen
    , me24.positiveculture as next24_positiveculture
    , me24.spec_type_desc as next24_specimen
  from ab_tbl
  -- blood culture in last 72 hours
  -- culture lab test 결과가 먼저인 경우
  left join me me72
    on ab_tbl.hadm_id = me72.hadm_id
    and ab_tbl.antibiotic_time is not null
    and
    (
      -- if charttime is available, use it
      -- microbiologyevent(lab test 결과 시간)가 있음과 동시에 72시간 이내 antibiotics가 주어졌을 경우
      (
          ab_tbl.antibiotic_time > me72.charttime
      and ab_tbl.antibiotic_time <= me72.charttime + interval '72' hour
      )
      OR
      (
      -- if charttime is not available, use chartdate
      -- microbiologyevent(lab test 결과 (시간이 없고) 날짜)가 있음과 동시에 72시간 이내 antibiotics가 주어졌을 경우
          me72.charttime is null
      and ab_tbl.antibiotic_time > me72.chartdate -- 21-10-14 23:59:59 -> 21-10-14 00:00:00 이렇게 될 수도 있다,,
      and ab_tbl.antibiotic_time < me72.chartdate + interval '96' hour -- could equally do this with a date_trunc, but that's less portable
      )
    )
  -- blood culture in subsequent 24 hours
  -- antibiotics가 먼저인 경우
  left join me me24
    on ab_tbl.hadm_id = me24.hadm_id
    and ab_tbl.antibiotic_time is not null
    and me24.charttime is not null
    and
    (
      -- if charttime is available, use it
      (
          ab_tbl.antibiotic_time > me24.charttime - interval '24' hour
      and ab_tbl.antibiotic_time <= me24.charttime
      )
      OR
      (
      -- if charttime is not available, use chartdate
          me24.charttime is null
      and ab_tbl.antibiotic_time > me24.chartdate -- 21-10-14 00:00:00
      and ab_tbl.antibiotic_time <= me24.chartdate + interval '24' hour
      )
    )
)
, ab_laststg as
(
select
  icustay_id
  , antibiotic_name
  , antibiotic_time
  , last72_charttime --me72
  , next24_charttime --me24

  -- 혼란스러운 코멘트?? 논문에는 sampling(culture time)을 기준으로 한다고 나와있고, 코드도 분석해본 결과 antibiotic time을 사용하지 않음. (me24 또는 me72 에서 사용,,)
  -- time of suspected infection: either the culture time (if before antibiotic), or the antibiotic time
  , case
      when coalesce(last72_charttime,next24_charttime) is null
        then 0
      else 1 end as suspected_infection

  , coalesce(last72_charttime,next24_charttime) as suspected_infection_time

  -- the specimen that was cultured
  , case
      when last72_charttime is not null
        then last72_specimen
      when next24_charttime is not null
        then next24_specimen
    else null
  end as specimen

  -- whether the cultured specimen ended up being positive or not
  , case
      when last72_charttime is not null
        then last72_positiveculture
      when next24_charttime is not null
        then next24_positiveculture
    else null
  end as positiveculture
from ab_fnl
)

select
  icustay_id
  , antibiotic_name
  , antibiotic_time
  , last72_charttime
  , next24_charttime
  , suspected_infection_time -- microbiologyevent time
  -- -- the below two fields are used to extract data - modifying them facilitates sensitivity analyses
  , suspected_infection_time - interval '48' hour as si_starttime --CHANGE FROM ORIGINAL: uncommented this and next line such that start and end time are calculated!
  , suspected_infection_time + interval '24' hour as si_endtime
  , specimen, positiveculture
from ab_laststg
order by icustay_id, antibiotic_time;
