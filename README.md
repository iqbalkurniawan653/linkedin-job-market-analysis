# Data Job Market Analysis: LinkedIn Job Postings

## Project Overview

Proyek ini menganalisis karakteristik pasar kerja bidang data berdasarkan dataset lowongan pekerjaan LinkedIn yang dikumpulkan pada Januari 2024.

Analisis dilakukan untuk memahami karakteristik dan pola distribusi lowongan pekerjaan berdasarkan position, seniority, company, country, serta kebutuhan skill.

Dataset diproses menggunakan PostgreSQL untuk Data Preparation, Feature Engineering, dan analisis berbasis SQL. Hasil analisis kemudian disajikan melalui interactive dashboard menggunakan Microsoft Power BI.

## Objective

Analisis bertujuan untuk:

- Memahami karakteristik dataset lowongan pekerjaan bidang data
- Mengevaluasi distribusi pada seluruh atribut yang tersedia
- Mengidentifikasi atribut yang paling relevan untuk analisis lanjutan berdasarkan struktur dan karakteristik datanya
- Membentuk atribut tambahan yang dapat memberikan representasi lebih baik terhadap job seniority dan skill
- Menganalisis distribusi job posting berdasarkan position, seniority, company, country, dan skill
- Mengeksplorasi relationship antaratribut yang telah dipilih untuk analisis lanjutan
- Menyajikan hasil analisis melalui interactive dashboard

## Dataset

Dataset yang digunakan adalah LinkedIn Job Postings Dataset (January 2024).

- Final Dataset: 12,217 job postings
- Skill Records after Normalization: 314,950
- Unique Skills: 64,956

### Original Tables

Dataset awal terdiri dari tiga tabel utama:

- `jobs`
- `job_skills`
- `job_summary`

Ketiga tabel tersebut menggunakan `job_link` sebagai key untuk menghubungkan informasi antar tabel.

### Data Transformation

Pada tahap Data Preparation, dibuat tabel baru `job_skills_normalized` untuk melakukan normalisasi data skill.

Pada dataset awal, beberapa skill disimpan dalam satu record pada tabel `job_skills`. Struktur tersebut membuat setiap skill belum dapat dianalisis secara individual.

Tabel `job_skills_normalized` dibuat dengan memisahkan setiap skill menjadi record tersendiri. Dengan demikian, satu job posting dapat memiliki beberapa record skill dan hubungan antara `jobs` dengan `job_skills_normalized` menjadi One-to-Many.

Hasil normalisasi menghasilkan:

- 314,950 skill records
- 64,956 unique skills

Tabel `job_skills_normalized` kemudian digunakan sebagai dasar untuk analisis skill dan pembentukan `skill_type`.

## Tools

- PostgreSQL
- SQL
- Microsoft Power BI

## Data Preparation

Data Preparation dilakukan untuk memastikan dataset memiliki struktur dan kualitas yang sesuai untuk proses analisis.

Proses meliputi:

- Data Cleaning
- Data Validation
- Data Type Validation
- Data Transformation
- Feature Engineering
- Skill Normalization
- Skill Type Classification
- Job Rank Classification

### Attribute Assessment

Distribusi diperiksa pada seluruh atribut untuk memperoleh pemahaman menyeluruh mengenai karakteristik dataset.

Namun, tidak seluruh atribut digunakan sebagai representasi utama pada analisis lanjutan. Pemilihan atribut dilakukan dengan mempertimbangkan tingkat detail, variasi nilai, fungsi analitis, serta adanya informasi yang tumpang tindih antaratribut.

### Job Level and Job Rank

Dataset menyediakan atribut `job_level` untuk menunjukkan tingkat senioritas pekerjaan. Namun, hasil pemeriksaan menunjukkan bahwa kategorinya sangat terbatas dan didominasi oleh `Mid Senior` dan `Associate`.

Informasi senioritas juga ditemukan pada `job_title`. Karena itu, dibuat atribut tambahan `job_rank` melalui Feature Engineering.

`job_rank` dibentuk menggunakan rule-based classification berdasarkan keyword atau pola senioritas yang terdapat pada `job_title`, seperti:

- Executive
- Manager
- Principal
- Lead
- Senior
- Mid
- Associate
- Junior
- Intern
- Unspecified

Atribut `job_level` tetap dipertahankan sebagai informasi original dataset, tetapi `job_rank` digunakan sebagai representasi senioritas pada analisis lanjutan karena memberikan pengelompokan yang lebih detail.

### Job Title and Search Position

`job_title` memiliki tingkat granularitas yang tinggi karena merupakan nama posisi sebagaimana tercantum pada masing-masing lowongan.

Dari 12,217 job postings terdapat 6,484 unique job titles. Variasi tersebut terjadi karena job title dapat mengandung informasi position sekaligus seniority, misalnya `Senior Data Analyst` atau `Lead Data Engineer`.

Untuk analisis antar-kategori, digunakan `search_position` karena atribut tersebut sudah menyediakan pengelompokan position yang lebih terstruktur pada dataset.

Dengan demikian:

- `job_title` digunakan untuk memahami variasi penamaan posisi dan menjadi sumber informasi untuk pembentukan `job_rank`
- `search_position` digunakan sebagai representasi position pada analisis lanjutan
- `job_level` tetap dipertahankan sebagai atribut original, tetapi tidak digunakan sebagai representasi senioritas utama.
- `job_rank` digunakan sebagai representasi senioritas yang lebih terperinci

### Skill Normalization

Pada dataset awal, beberapa skill disimpan dalam satu record pada kolom `job_skills`.

Untuk memungkinkan setiap skill dianalisis secara individual, dibuat tabel baru `job_skills_normalized` dengan memisahkan setiap skill menjadi record terpisah.

Proses ini menghasilkan:

- 314,950 skill records
- 64,956 unique skills

Hasil normalisasi menunjukkan adanya variasi penamaan skill yang tinggi. Oleh karena itu, dibuat atribut `skill_type` untuk mengelompokkan skill ke dalam kategori yang lebih umum.

## Analysis

### Job Market Distribution Analysis

Distribusi diperiksa terhadap seluruh atribut untuk memperoleh pemahaman menyeluruh mengenai karakteristik dataset.

Setelah proses assessment, analisis lanjutan difokuskan pada atribut yang memberikan representasi lebih terstruktur dan informatif, terutama:

- Search Position
- Job Rank
- Company
- Country
- Skill
- Skill Type

Pendekatan ini digunakan agar analisis tidak hanya menampilkan distribusi setiap kolom, tetapi juga mempertimbangkan fungsi dan kualitas informasi dari masing-masing atribut.

### Search Position Distribution

`search_position` digunakan untuk melihat distribusi job posting berdasarkan kelompok position yang lebih terstruktur dibandingkan variasi individual pada `job_title`.

Kategori terbesar adalah:

- Other: 3,509
- Data Engineer: 2,611
- Data Analyst: 1,974
- Data Scientist: 1,015
- Machine Learning: 965

Jika kategori `Other` tidak diperhitungkan, Data Engineer, Data Analyst, dan Data Scientist menjadi tiga kategori terbesar.

### Job Rank Distribution

`job_rank` digunakan untuk memberikan perspektif senioritas yang lebih detail dibandingkan `job_level`.

Hasil klasifikasi menunjukkan kategori:

- Unspecified: 4,592
- Senior: 3,511
- Manager: 1,618
- Lead: 855
- Principal: 571
- Junior: 373
- Mid: 268
- Associate: 209
- Executive: 182
- Intern: 38

Kategori `Unspecified` digunakan ketika tidak ditemukan indikator senioritas yang cukup pada `job_title`, sehingga tidak memberikan asumsi tambahan terhadap data original.

### Skill Distribution

Setelah normalisasi, skill dianalisis pada tingkat individual.

Beberapa skill dengan frekuensi tertinggi adalah:

- Python
- Data Analytics
- SQL
- Communication Skills
- Machine Learning
- Team Collaboration
- Data Visualisation
- AWS
- Project Management
- Data Engineering

`skill_type` kemudian digunakan sebagai pengelompokan tambahan untuk melihat kebutuhan skill pada tingkat kategori yang lebih umum.

## Relationship Analysis

Relationship Analysis dilakukan setelah atribut yang relevan ditentukan melalui proses distribution dan attribute assessment.

Analisis difokuskan pada:

- Company vs Search Position
- Company vs Country
- Search Position vs Country
- Search Position vs Job Rank
- Skill vs Job Rank
- Skill Type vs Search Position

Analisis digunakan untuk melihat pola distribusi dan keterkaitan antaratribut berdasarkan data yang tersedia.

### Company vs Search Position

Analisis digunakan untuk melihat konsentrasi kategori position pada masing-masing company.

### Company vs Country

Analisis digunakan untuk melihat persebaran company berdasarkan country serta memberikan konteks geografis terhadap job posting.

### Search Position vs Country

Analisis digunakan untuk melihat distribusi kategori position berdasarkan country.

### Search Position vs Job Rank

Analisis digunakan untuk mengeksplorasi bagaimana kategori position tersebar pada tingkat senioritas yang telah dibentuk melalui `job_rank`.

### Skill vs Job Rank

Analisis digunakan untuk melihat skill yang muncul pada berbagai tingkat senioritas.

### Skill Type vs Search Position

Analisis digunakan untuk melihat distribusi kategori skill pada berbagai kelompok position.

## Key Findings

- Dataset terdiri dari 12,217 job postings
- `job_level` memiliki kategori yang terbatas dan didominasi oleh `Mid Senior` dan `Associate`, sehingga tidak digunakan sebagai representasi senioritas utama pada analisis lanjutan
- `job_rank` memberikan pengelompokan senioritas yang lebih beragam, mulai dari Intern hingga Executive, berdasarkan informasi senioritas yang ditemukan pada `job_title`
- `job_title` memiliki 6,484 unique values sehingga menunjukkan variasi penamaan posisi yang tinggi
- `search_position` memiliki struktur kategori yang lebih terorganisir dan digunakan sebagai representasi position pada analisis lanjutan
- Data Engineer, Data Analyst, dan Data Scientist merupakan beberapa kategori `search_position` dengan jumlah job posting terbesar setelah kategori Other
- Python, Data Analytics, dan SQL merupakan tiga skill dengan frekuensi tertinggi
- Normalisasi skill menghasilkan 314,950 skill records dari 12,217 job postings
- Variasi penamaan skill yang tinggi menjadi alasan dilakukannya pengelompokan tambahan melalui `skill_type`
- Relationship Analysis menunjukkan bahwa distribusi position dapat berbeda berdasarkan company dan country, sementara kebutuhan skill juga dapat berbeda berdasarkan position dan job seniority

## Dashboard

Dashboard dikembangkan menggunakan Microsoft Power BI dan terdiri dari dua halaman utama:

1. Data Job Market Overview
2. Job Position Analysis

### Data Job Market Overview

Halaman ini memberikan gambaran umum mengenai:

- Total Job Postings
- Total Companies
- Total Countries
- Total Job Positions
- Job Posting Distribution
- Job Seniority Distribution
- Job Postings by Country
- Top Hiring Companies
- Skill Type Distribution

### Job Position Analysis

Halaman ini memberikan perspektif yang lebih terfokus terhadap:

- Top Required Skills
- Skill by Job Seniority
- Skill Type Distribution
- Top Hiring Company
- Job Postings by Country

Dashboard dilengkapi dengan slicer untuk membantu pengguna mengeksplorasi subset data berdasarkan karakteristik tertentu.

## Conclusion

Secara keseluruhan, analisis menunjukkan bahwa pemilihan atribut perlu mempertimbangkan struktur dan fungsi masing-masing variable, bukan hanya distribusi nilainya.

`job_level` tetap memberikan informasi awal mengenai senioritas pada dataset, tetapi keterbatasan kategorinya membuat atribut tersebut kurang sesuai digunakan sebagai representasi senioritas pada analisis lanjutan. Oleh karena itu, `job_rank` dibentuk melalui Feature Engineering berdasarkan informasi senioritas yang terdapat pada `job_title`.

Pada sisi position, `job_title` memiliki variasi penamaan yang sangat tinggi karena setiap lowongan dapat menggunakan penamaan yang berbeda dan dapat mencampurkan informasi position dengan seniority. `search_position` digunakan sebagai representasi position yang lebih terstruktur untuk analisis antar-kategori.

Pada sisi skill, normalisasi dilakukan dengan membuat tabel baru `job_skills_normalized` agar setiap skill dapat dianalisis secara individual. Namun, tingginya variasi penamaan skill membuat `skill_type` diperlukan untuk memberikan perspektif pada tingkat kategori yang lebih umum.

Dengan pendekatan tersebut, analisis lanjutan difokuskan pada `search_position`, `job_rank`, company, country, skill, dan skill type untuk memahami karakteristik serta pola pasar kerja yang terdapat pada dataset.

## Limitations & Further Analysis

Project ini merupakan exploratory analysis yang berfokus pada karakteristik dan pola yang terdapat pada dataset.

Beberapa keterbatasan meliputi:

- Dataset berasal dari periode pengumpulan tertentu sehingga tidak menggambarkan perubahan pasar kerja dari waktu ke waktu
- `job_rank` merupakan hasil rule-based classification berdasarkan informasi yang tersedia pada `job_title`
- Sebagian job posting tidak memiliki indikator senioritas yang dapat diklasifikasikan sehingga masuk kategori `Unspecified`
- `job_title` memiliki variasi penamaan yang tinggi
- `search_position` memiliki kategori `Other` yang cukup besar
- Skill memiliki variasi penamaan yang tinggi meskipun telah dilakukan normalisasi dan pengelompokan
- Relationship Analysis bersifat deskriptif dan tidak digunakan untuk menyimpulkan hubungan sebab-akibat

Further analysis dapat dikembangkan apabila tersedia:

- Data historis untuk melihat perubahan kebutuhan tenaga kerja dari waktu ke waktu
- Business context untuk memahami kebutuhan analisis yang lebih spesifik
- Standardisasi job title dan skill yang lebih konsisten
- Informasi tambahan mengenai company, position, seniority, dan geographic characteristics

## Project Documentation

Dokumentasi lengkap mengenai Data Preparation, Attribute Assessment, Feature Engineering, Job Market Distribution Analysis, Relationship Analysis, Dashboard Analysis, Conclusion, dan Further Analysis tersedia pada:

## Documentation

[Documentation.pdf].(./documentation/Documentation.pdf)
