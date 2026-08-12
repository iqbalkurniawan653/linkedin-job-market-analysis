-- 1.1 dataset overview
select * from jobs
select * from job_skills
select * from job_summary

-- 1.2 dataset structure

--total record tabel jobs
SELECT COUNT(*) AS total_jobs
FROM jobs;

--total record tabel job_skills
SELECT COUNT(*) AS total_job_skills
FROM job_skills;

--total record tabel job_summary
SELECT COUNT(*) AS total_job_summary
FROM job_summary;

-- 1.3 table description

--struktur kolom tabel jobs
SELECT column_name,data_type
FROM information_schema.columns
WHERE table_name = 'jobs';

--struktur kolom tabel job_skills
SELECT column_name,data_type
FROM information_schema.columns
WHERE table_name = 'job_skills';

--struktur kolom abel job_summary
SELECT column_name,data_type
FROM information_schema.columns
WHERE table_name = 'job_summary';

--1.4 entity relationship
--validasi primary key (job_link)
SELECT COUNT(*) AS total_records,
COUNT(DISTINCT job_link) AS unique_job_link
FROM jobs;

--validasi relasi jobs → job_skills
SELECT COUNT(*) AS matched_records
FROM jobs j
JOIN job_skills s
ON j.job_link = s.job_link;

--validasi relasi jobs → job_summary
SELECT COUNT(*) AS matched_records
FROM jobs j
JOIN job_summary js
ON j.job_link = js.job_link;

--contoh hubungan antar tabel
SELECT j.job_title, s.job_skills, js.job_summary
FROM jobs j
JOIN job_skills s
ON j.job_link = s.job_link
JOIN job_summary js
ON j.job_link = js.job_link
LIMIT 5;


--02 data preparation

--2.2 data quality assessment

--missing value
--jobs
SELECT COUNT(*) AS null_records FROM jobs WHERE company IS NULL
OR job_title IS NULL
OR job_location IS NULL
OR first_seen IS NULL
OR search_city IS NULL
OR search_country IS NULL
OR search_position IS NULL
OR job_level IS NULL
OR job_type IS NULL;

--job skills
SELECT COUNT(*) FROM job_skills WHERE job_skills IS NULL;

--job summary
SELECT COUNT(*)
FROM job_summary
WHERE job_summary IS NULL;


--empty string

--jobs
SELECT COUNT(*) FROM jobs WHERE TRIM(company)=''
OR TRIM(job_title)=''
OR TRIM(job_location)='';

--job Skills
SELECT COUNT(*) FROM job_skills WHERE TRIM(job_skills)='';

--job summary
SELECT COUNT(*) FROM job_summary WHERE TRIM(job_summary)='';

--duplicate records

--jobs
SELECT job_link, COUNT(*) FROM jobs GROUP BY job_link HAVING COUNT(*)>1;

--job skills
SELECT job_link, COUNT(*) FROM job_skills GROUP BY job_link HAVING COUNT(*)>1;

--job summary
SELECT job_link, COUNT(*) FROM job_summary GROUP BY job_link HAVING COUNT(*)>1;

--primary key validation
SELECT COUNT(*) total_record, COUNT(DISTINCT job_link) unique_job_link FROM jobs;

--foreign key validation

--job skills
SELECT COUNT(*)
FROM job_skills s LEFT JOIN jobs j ON s.job_link=j.job_link WHERE j.job_link IS NULL;

--job summary
SELECT COUNT(*) FROM job_summary js LEFT JOIN jobs j ON js.job_link=j.job_link WHERE j.job_link IS NULL;


--2.3 data transformation

--data type adjustment
ALTER TABLE jobs ALTER COLUMN first_seen TYPE DATE USING first_seen::DATE;

--2.4 feature engineering

--menambahkan kolom job rank
ALTER TABLE jobs ADD COLUMN job_rank VARCHAR(20);

--mengisi job rank
UPDATE jobs SET job_rank = CASE
WHEN job_title ILIKE '%director%'
OR job_title ILIKE '%head%'
OR job_title ILIKE '%chief%'
OR job_title ILIKE '%vp%' THEN 'Executive'
WHEN job_title ILIKE '%manager%' THEN 'Manager'
WHEN job_title ILIKE '%principal%'
OR job_title ILIKE '%staff%' THEN 'Principal'
WHEN job_title ILIKE '%lead%' THEN 'Lead'
WHEN job_title ILIKE '%senior%'
OR job_title ILIKE 'sr.%'
OR job_title ILIKE '%sr %' THEN 'Senior'
WHEN job_title ILIKE '%level iii%' THEN 'Mid'
WHEN job_title ILIKE '%associate%'
OR job_title ILIKE '%level ii%' THEN 'Associate'
WHEN job_title ILIKE '%junior%'
OR job_title ILIKE '%entry%'
OR job_title ILIKE '%level i%' THEN 'Junior'
WHEN job_title ILIKE '%intern%'
OR job_title ILIKE '%trainee%' THEN 'Intern'
ELSE 'Unspecified'
END;

--validasi job rank
SELECT job_rank,count(*)as total_job_rank from jobs 
group by job_rank order by total_job_rank desc

--membuat tabel job skills normalized
CREATE TABLE job_skills_normalized AS
SELECT job_link,TRIM(UNNEST(STRING_TO_ARRAY(job_skills, ',')))AS skill
FROM job_skills;

--validasi table job skills normalized
SELECT COUNT(*) AS total_skill_records FROM job_skills_normalized;

SELECT COUNT(DISTINCT skill) AS unique_skill
FROM job_skills_normalized;

--menambahkan kolom skill type
ALTER TABLE job_skills_normalized ADD COLUMN skill_type VARCHAR(50);

--mengisi skill type
UPDATE job_skills_normalized SET skill_type =CASE
WHEN skill IN ('Python','SQL','Machine Learning','Deep Learning','Spark','Tensorflow','PyTorch')
THEN 'Technical Skills'
WHEN skill IN ('Communication Skills','Team Collaboration','Leadership')
THEN 'Soft Skills'
WHEN skill IN ('Project Management','Business Analysis')
THEN 'Business Skills'
WHEN skill IN ('Healthcare','Finance','Marketing')
THEN 'Domain Knowledge'
WHEN skill IN ('AWS','Azure','Tableau','Power BI')
THEN 'Tools'
WHEN skill ILIKE '%Bachelor%'
OR skill ILIKE '%Master%'
THEN 'Education'
WHEN skill ILIKE '%Research%'
THEN 'Research'
ELSE 'Other' END;

--Validasi skill type
SELECT skill_type,count(*)as total_skill_type from job_skills_normalized
group by skill_type 

--EDA
--dataset overview
SELECT
COUNT(*) AS total_job_posting,
COUNT(DISTINCT company) AS total_company,
COUNT(DISTINCT job_title) AS total_job_title,
COUNT(DISTINCT search_country) AS total_country,
COUNT(DISTINCT search_city) AS total_city,
COUNT(DISTINCT search_position) AS total_search_position,
COUNT(DISTINCT job_level) AS total_job_level,
COUNT(DISTINCT job_rank) AS total_job_rank,
COUNT(DISTINCT job_type) AS total_job_type
FROM jobs;

--distribustion job level
SELECT job_level, COUNT(*) AS total_job FROM jobs GROUP BY job_level ORDER BY total_job DESC;

--distribusi job type
SELECT job_type, COUNT(*) AS total_job FROM jobs GROUP BY job_type ORDER BY total_job DESC;

--distribusi search position
SELECT search_position,COUNT(*) AS total_job FROM jobs GROUP BY search_position ORDER BY total_job DESC;

--distribusi country
SELECT search_country, COUNT(*) AS total_job FROM jobs GROUP BY search_country ORDER BY total_job DESC;

--top city
SELECT search_city, COUNT(*) AS total_job FROM jobs GROUP BY search_city ORDER BY total_job DESC LIMIT 10;

--top company
SELECT company, COUNT(*) AS total_job FROM jobs GROUP BY company ORDER BY total_job DESC LIMIT 10;

--distribusi company berdasarkan negara
SELECT search_country, COUNT(DISTINCT company) AS total_company FROM jobs GROUP BY search_country ORDER BY total_company DESC;

--top job title
SELECT job_title, COUNT(*) AS total_job FROM jobs GROUP BY job_title ORDER BY total_job DESC LIMIT 10;

--search position berdasarkan country
SELECT search_country, search_position, COUNT(*) AS total_job FROM jobs GROUP BY search_country, search_position ORDER BY search_country, total_job DESC;

--distribusi job rank
SELECT job_rank, COUNT(*) AS total_job FROM jobs GROUP BY job_rank ORDER BY total_job DESC;

--top skill
SELECT skill, COUNT(*) AS total_skill FROM job_skills_normalized GROUP BY skill ORDER BY total_skill DESC LIMIT 10;

--top skill berdasarkan search position
WITH skill_position AS (
SELECT j.search_position, js.skill, COUNT(*) AS total_skill,
ROW_NUMBER() OVER (
PARTITION BY j.search_position
ORDER BY COUNT(*) DESC) AS rn
FROM jobs j JOIN job_skills_normalized js
ON j.job_link = js.job_link
GROUP BY j.search_position, js.skill)
SELECT search_position,skill,total_skill
FROM skill_position
WHERE rn <= 5
ORDER BY search_position,total_skill DESC;

--top skill berdasarkan job rank
WITH skill_rank AS (
SELECT j.job_rank,js.skill,COUNT(*) AS total_skill,
ROW_NUMBER() OVER (
PARTITION BY j.job_rank
ORDER BY COUNT(*) DESC) AS rn
FROM jobs j JOIN job_skills_normalized js
ON j.job_link = js.job_link
GROUP BY j.job_rank,js.skill)
SELECT job_rank,skill,total_skill
FROM skill_rank
WHERE rn <= 5
ORDER BY job_rank,total_skill DESC;

--company dan negara
WITH company_position AS (
SELECT company,search_position,COUNT(*) AS total_job
FROM jobs GROUP BY company,search_position)
SELECT company,search_position,total_job
FROM company_position ORDER BY total_job DESC LIMIT 5;

--country dan search position
WITH country_position AS (
SELECT search_country,search_position,COUNT(*) AS total_job
FROM jobs GROUP BY search_country,search_position)
SELECT search_country,search_position,total_job
FROM country_position ORDER BY total_job DESC LIMIT 10;

--search position dan job rank
WITH position_rank AS (
SELECT search_position,job_rank,COUNT(*) AS total_job
FROM jobs GROUP BY search_position,job_rank)
SELECT search_position,job_rank,total_job
FROM position_rank ORDER BY total_job DESC LIMIT 5;

