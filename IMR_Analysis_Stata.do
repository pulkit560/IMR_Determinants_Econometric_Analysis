********************************************************************************
* Infant Mortality Rate (IMR) Analysis: Stata Script with Diagnostics
* Author: Pulkit Garg
* Objective: Analyze economic and social factors affecting IMR using panel data

********************************************************************************

* Step 1: Load the Dataset
import excel "Ecotrix_IMR_Data.xlsx", sheet("Sheet1") firstrow

* Step 2: Define Panel Data Structure
encode CountryName, gen(panel_id)
gen panel_id = group(CountryName)
xtset panel_id Time


******************************************************************************
* Step 2: Create Variables
******************************************************************************

* Log transformations
gen log_IMR = log(IMR)
gen log_GDP = log(GDP)
gen log_CHE = log(CHE)
gen log_PM25 = log(PM25)
gen log_UrbanPop = log(Urbanpopulation)
replace IMR = IMR + 0.0001

********************************************************************************
* Step 3: Creating Health Index
********************************************************************************
egen mean_UHC = mean(UHC), by(panel_id)
egen sd_UHC = sd(UHC), by(panel_id)
gen Z_UHC = (UHC - mean_UHC) / sd_UHC

egen mean_CHE = mean(CHE), by(panel_id)
egen sd_CHE = sd(CHE), by(panel_id)
gen Z_CHE = (CHE - mean_CHE) / sd_CHE

egen mean_ImmunizationDPT = mean(ImmunizationDPT), by(panel_id)
egen sd_ImmunizationDPT = sd(ImmunizationDPT), by(panel_id)
gen Z_ImmunizationDPT = (ImmunizationDPT - mean_ImmunizationDPT) / sd_ImmunizationDPT

gen Health_Index = (Z_UHC + Z_CHE + Z_ImmunizationDPT) / 3
list Z_UHC Z_CHE Z_ImmunizationDPT Health_Index in 1/10

histogram Health_Index, width(0.5)
summarize Health_Index
histogram Health_Index, width(0.5)

gen D_health_index = DevelopingDummy* Health_Index
********************************************************************************
* Step 4: Exploratory Data Analysis
********************************************************************************
summarize log_IMR log_GDP log_CHE log_PM25 log_UrbanPop sqrt_Unemp Z_UHC Z_CHE
tabulate DevelopingDummy, summarize(IMR)
twoway (scatter log_IMR log_GDP if DevelopingDummy == 1)(scatter log_IMR log_GDP if DevelopingDummy == 0), legend(label(1 "Developing") label(2 "Developed"))

******************************************************************************
* Step 5: Regression Analysis
******************************************************************************
* Hausman Test for Fixed vs. Random Effects

xtreg log_IMR GDP log_unemp Health_Index DlnGDP DUnemp D_health_index, re
estimates store re_model
xtreg log_IMR GDP log_unemp Health_Index DlnGDP DUnemp D_health_index, fe
estimates store fe_model
hausman fe_model re_model

* Robust Fixed Effects Model
xtreg log_IMR GDP log_unemp Health_Index DlnGDP DUnemp D_health_index, fe

******************************************************************************
* Step 6: Robustness and Diagnostic Testing
******************************************************************************
* Multicollinearity
gen log_unemp = log(Unemp)
xtreg log_IMR GDP log_unemp Health_Index DlnGDP DUnemp D_health_index, fe
vif, uncentered

* Heteroskedasticity Test

reg log_IMR GDP log_unemp Health_Index DlnGDP DUnemp D_health_index
estat hettest
xtreg log_IMR GDP log_unemp Health_Index DlnGDP DUnemp D_health_index, fe robust


* Autocorrelation Test

findit xtserial
xtserial log_IMR GDP log_unemp Health_Index DlnGDP DUnemp D_health_index
xtreg log_IMR GDP log_unemp Health_Index DlnGDP DUnemp D_health_index, fe cluster(panel_id)

* Cross-sectional Dependence (Driscoll-Kraay)
xtscc log_IMR GDP log_unemp Health_Index DlnGDP DUnemp D_health_index i.Time, fe

* Residual Normality
predict residuals, e
qnorm residuals

* Residual Plot
scatter residuals log_IMR, yline(0) title("Residuals vs. Predicted Values")
vif

******************************************************************************
* Step 7: Regression Analysis - Fixed Effects with Robust SE
******************************************************************************

* Fixed Effects Model
xtreg log_IMR GDP log_unemp Health_Index DlnGDP DUnemp D_health_index, fe robust


* For developing countries (Developing = 1)
xtreg log_IMR GDP log_unemp Health_Index DlnGDP DUnemp D_health_index if DevelopingDummy == 1, fe robust
* For developed countries (Developing = 0)
xtreg log_IMR GDP log_unemp Health_Index DlnGDP DUnemp D_health_index if DevelopingDummy == 0, fe robust


********************************************************************************
* Step 8: Final Fixed Effects Model with Five-Year Time Effects
********************************************************************************
* Group time variable into five-year intervals
gen Time_5yr = ceil(Time / 5)

* Final Fixed Effects Model with Five-Year Time Effects
xtreg log_IMR GDP log_unemp Health_Index DGDP DUnemp D_health_index i.Time_5yr, fe robust


* Model with Driscoll-Kraay Standard Errors
xtscc log_IMR GDP log_unemp Health_Index DGDP DUnemp D_health_index i.Time_5yr, fe


* Diagnostic Summary
* 1) Multicollinearity Check
vif, uncentered

* 2) Residual Analysis
predict residuals, e
scatter residuals log_IMR, yline(0) title("Residuals vs. Predicted Values")

* 3) Wooldridge Test for Autocorrelation
xtserial log_IMR GDP log_unemp Health_Index DGDP DUnemp D_health_index

********************************************************************************
* Step 9: Visualizations
********************************************************************************

* IMR Trends Over Time
twoway (line IMR Time_5yr if DevelopingDummy == 1, lcolor(red))(line IMR Time_5yr if DevelopingDummy == 0, lcolor(blue)), legend(label(1 "Developing") label(2 "Developed")) title("IMR Trends Over Time")

* Health_Index Density by Development Status
kdensity Health_Index if DevelopingDummy == 1, lcolor(red) legend(label(1 "Developing"))
kdensity Health_Index if DevelopingDummy == 0, lcolor(blue) legend(label(2 "Developed"))

********************************************************************************
* Step 10: Save Results for Reporting
********************************************************************************
save "Final_IMR_Analysis.dta", replace
