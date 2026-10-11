# Stack Overflow Developer Technology Trends Analysis


An end-to-end analysis of current technology usage, future technology interest, and respondent characteristics in a Stack Overflow survey extract.

## Project objective

The analysis asks:

1. Which technologies are most commonly used today?
2. Which technologies show stronger future interest?
3. How do current-use and future-interest patterns differ?
4. What does the respondent population look like by age, education and country?
5. What relationships appear across experience, compensation, job satisfaction and remote work?


## Dataset

The notebooks use a Stack Overflow survey extract containing **18,845 respondents and 114 columns**.

The dataset includes information about respondents' backgrounds, employment, technologies, experience, compensation, and selected AI-related responses.

The raw CSV is not included in this repository. The exploratory notebook loads the dataset from the source URL specified in its data-loading cell.

The findings describe the respondents represented in this survey extract and should not be interpreted as a complete representation of all developers.


## Repository Structure

- `notebooks/` — Python notebooks for data exploration and analysis.
- `sql/` — SQL queries for technology analysis.
- `dashboard/` — Power BI dashboard images and related documentation.
- `requirements.txt` — Python libraries used in the analysis.


## Key findings

### Current technology usage

| Category | Leading technology | Selections |
|---|---|---:|
| Languages | JavaScript | 14,943 |
| Databases | PostgreSQL | 11,514 |
| Platforms | AWS | 10,871 |
| Web frameworks | Node.js | 9,230 |

### Future interest

- PostgreSQL remains the leading future database: **12,193 selections**.
- Go rises from **3,305 current** selections to **5,661 future** selections.
- Rust rises from **2,284 current** selections to **5,597 future** selections.
- React leads future web-framework interest with **8,223 selections**.
- AWS remains the leading future platform with **10,516 selections**.

These are preference signals from the survey, not a forecast of hiring demand.


## Data-quality decisions

- Missingness is measured before transformation.
- Job satisfaction and remote-work responses are not blindly filled with a mode or median.
- Complete-case subsets are used only when the variables required for an analysis are present.
- Exact duplicate rows and duplicate response IDs are checked explicitly.
- Multi-select fields are split and exploded before technology counts are calculated.
- Compensation outliers are examined with both 3-sigma and IQR rules; the base survey is not silently deleted.
- Age-band midpoints are used only as approximations when a numeric value is needed for a plot.


## Tools

**Python:** pandas, NumPy, Matplotlib, Seaborn  
**SQL:** SQL Server-oriented analytical SQL and SQLite  
**Dashboard:** power bi  
**Environment:** Jupyter Notebook / VS Code

## Conclusion

The analysis provides an overview of current developer technology trends and changing interests. Combining SQL analysis, Python exploration, and Power BI dashboards makes these patterns easier to examine and communicate. Survey limitations and differences in respondent groups should be considered when interpreting the findings.


## Limitations

- The dataset is a survey subset, not the complete Stack Overflow population.
- Multi-select technology totals are selection counts.
- Future interest measures stated preference, not guaranteed market demand.
- Missing responses may contain information and are not automatically equivalent to “No”.
- Correlation describes association and does not establish causation.
- Approximate age midpoints should not be interpreted as exact ages.
