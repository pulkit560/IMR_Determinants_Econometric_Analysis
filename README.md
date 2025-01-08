# Analyzing Economic and Social Determinants of Infant Mortality Rate (IMR)

This project explores the economic and social determinants of infant mortality rates (IMR) using panel data from 24 countries (12 developed and 12 developing) spanning two decades. Through advanced econometric models, the study investigates the impact of GDP, unemployment, health index, and other variables, capturing fixed effects, time effects, and differences between developed and developing nations.

---

## **Project Objectives**
- Investigate the impact of economic and social indicators (GDP, unemployment, and healthcare access) on IMR.
- Highlight the differences between developed and developing countries in these relationships.
- Explore the significance of time effects using yearly and five-year intervals.
- Employ robust econometric techniques to ensure reliable results and interpretations.

---

## **Key Features**
1. **Dataset**: Panel data consisting of IMR, GDP, unemployment, health indicators, and more for 24 countries over 20 years.
2. **Models Implemented**:
   - Fixed Effects with Robust Standard Errors
   - Fixed Effects with Time Effects (Yearly and Five-Year Intervals)
   - Interaction Terms for Developed vs. Developing Countries
3. **Diagnostics**:
   - Multicollinearity Checks
   - Autocorrelation (Wooldridge Test)
   - Heteroskedasticity (Breusch-Pagan Test)
   - Cross-Sectional Dependence (Driscoll-Kraay Standard Errors)
4. **Visualization**: Trends and density plots showcasing IMR and key predictors.

---
## View the Report
You can view the project report [here](https://drive.google.com/file/d/11Yawq8L_FkKT4WMw4vBeUlB6NS_adLeK/view?usp=sharing).

---
## **Key Findings**
- **GDP**: Economic growth has a stronger impact on reducing IMR in developing countries compared to developed ones.
- **Health Index**: Higher healthcare access and quality significantly reduce IMR.
- **Unemployment**: Positively correlated with IMR, though the effect is mitigated in developing countries.
- **Time Effects**: IMR has consistently decreased over the years, reflecting global health improvements.

---

## **Repository Structure**
```plaintext
├── data/
│   ├── Ecotrix_IMR_Data.xlsx          # Original dataset
├── code/
│   ├── IMR_Analysis_Stata.do          # Final Stata script
├── results/
│   ├── Analyzing_Economic_and_Social_Determinants_of_IMR.pdf  # Final report
├── visuals/
│   ├── IMR_Trends_Over_Time.png       # Trend visualization
│   ├── Health_Index_Density.png       # Health index density plot
├── README.md                          # Project overview and usage

--- 
## **Usage Instructions**
Dependencies:

Stata 16 or higher is recommended.
Install required Stata packages (e.g., xtserial, xtscc).

Run Analysis:

Load the Ecotrix_IMR_Data.xlsx dataset into Stata.
Execute the provided final_log.do script to replicate the analysis.

View Results:

Review the detailed results in the provided PDF report.
Visualizations can be recreated using the commands in the script.
How to Cite
If you use this project or its components in your research, please cite as follows:
Garg, P. (2025). Analyzing Economic and Social Determinants of Infant Mortality Rates: A Panel Data Approach. GitHub Repository.

Contact
For any questions or collaboration opportunities, feel free to reach out:
Pulkit Garg
Email: pulkitgarg560@gmail.com

