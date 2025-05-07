/* header */
version 15.1

set more off, permanently
set scheme s2mono


/* generate data_cond.dta */
use "data_full", clear

gen monotonic = .

label define monotonic_lb 0 "no" 1 "yes"
   label values monotonic monotonic_lb

replace monotonic = 1
replace monotonic = 0 if ///
   subject == 11157 | ///
   subject == 11279 | ///
   subject == 11280 | ///
   subject == 11386 | ///
   subject == 11394 | ///
   subject == 12269 | ///
   subject == 12271 | ///
   subject == 12278 | ///
   subject == 41177 | ///
   subject == 41194 | ///
   subject == 41196 | ///
   subject == 41170 | ///
   subject == 41190 | ///
   subject == 42290

keep if monotonic
drop monotonic

save "data_cond", replace


/* sample */
use "data_full", clear

label define gender_lb 1 "male" 2 "female" 3 "other"
   label values gender gender_lb

label define employment_lb 1 "student" 2 "white-collar worker or civil servant" 3 "self employed" 4 "marginally employed" 5 "unemployed"
   label values employment employment_lb

preserve
   collapse (first) age gender actual_living_space employment, by(subject)

   sum age, detail
   tab gender
   tab employment
   sum actual_living_space, detail
restore


/* number of subjects per treatmet and ordering effects with respect to task */
preserve
   keep subject treatment version justice relative_justice
   collapse (first) treatment version (mean) justice relative_justice, by(subject)
   tabulate treatment

   by treatment, sort : ttest justice, by(version) unequal welch level(90)
   by treatment, sort : ttest relative_justice, by(version) unequal welch level(90)
restore


/* individual justice ratings */
use "data_full", clear

gen justice_type_finegrained = .
   replace justice_type_finegrained = 1 if ///
      subject == 11157 | ///
      subject == 11279 | ///
      subject == 11280 | ///
      subject == 11386 | ///
      subject == 11394 | ///
      subject == 12269 | ///
      subject == 12271 | ///
      subject == 12278 | ///
      subject == 41177 | ///
      subject == 41196	  
   replace justice_type_finegrained = 2 if ///
      subject == 11387 | ///
      subject == 11395 | ///
      subject == 12152 | ///
      subject == 12277 | ///
      subject == 41171 | ///
      subject == 41180 | ///
      subject == 41191 | ///
      subject == 42274 | ///
      subject == 42279
   replace justice_type_finegrained = 3 if ///
      subject == 11156 | ///
      subject == 11282 | ///
      subject == 12158 | ///
      subject == 12276 | ///
      subject == 12380 | ///
      subject == 12383 | ///
      subject == 12387 | ///
      subject == 41179	  
   replace justice_type_finegrained = 4 if ///
      subject == 11158 | ///
      subject == 11160 | ///
      subject == 11165 | ///
      subject == 11276 | ///
      subject == 11277 | ///
      subject == 11278 | ///
      subject == 11390 | ///
      subject == 11393 | ///
      subject == 12154 | ///
      subject == 12155 | ///
      subject == 12156 | ///
      subject == 12162 | ///
      subject == 12381 | ///
      subject == 12384 | ///
      subject == 12386 | ///
      subject == 41169 | ///
      subject == 41178 | ///
      subject == 41187 | ///
      subject == 41188 | ///
      subject == 42289
   replace justice_type_finegrained = 5 if ///
      subject == 11159 | ///
      subject == 11161 | ///
      subject == 11162 | ///
      subject == 11163 | ///
      subject == 11164 | ///
      subject == 11281 | ///
      subject == 11283 | ///
      subject == 11388 | ///
      subject == 11389 | ///
      subject == 11391 | ///
      subject == 12160 | ///
      subject == 12272 | ///
      subject == 12273 | ///
      subject == 12379 | ///
      subject == 12382 | ///
      subject == 12385 | ///
      subject == 12388 | ///
      subject == 41165 | ///
      subject == 41168 | ///
      subject == 41172 | ///
      subject == 41174 | ///
      subject == 41175 | ///
      subject == 41176 | ///
      subject == 41181 | ///
      subject == 41182 | ///
      subject == 41184 | ///
      subject == 41185 | ///
      subject == 41189 | ///
      subject == 41192 | ///
      subject == 41193 | ///
      subject == 41195 | ///
      subject == 41198 | ///
      subject == 42267 | ///
      subject == 42268 | ///
      subject == 42269 | ///
      subject == 42270 | ///
      subject == 42272 | ///
      subject == 42273 | ///
      subject == 42275 | ///
      subject == 42276 | ///
      subject == 42277 | ///
      subject == 42278 | ///
      subject == 42280 | ///
      subject == 42283 | ///
      subject == 42285 | ///
      subject == 42286 | ///
      subject == 42287 | ///
      subject == 42288 | ///
      subject == 42291 | ///
      subject == 42292 | ///
      subject == 42293 | ///
      subject == 42294 | ///
      subject == 42296
   replace justice_type_finegrained = 6 if ///
      subject == 12159 | ///
      subject == 41170 | ///
      subject == 41186 | ///
      subject == 41190 | ///
      subject == 41194 | ///
      subject == 42271 | ///
      subject == 42282 | ///
      subject == 42290 | ///
      subject == 42297

label variable justice_type_finegrained "Justice Type"

label define justice_type_finegrained_lb 1 "Hump" 2 "Binary" 3 "Flat At/Above" 4 "Zero Below" 5 "Increasing" 6 "Other"
   label values justice_type_finegrained justice_type_finegrained_lb

preserve
   collapse (first) justice_type_finegrained treatment actual_living_space age employment gender political_attitude (mean) justice, by(subject)
   tabulate justice_type_finegrained treatment

   by treatment, sort : tabulate gender justice_type_finegrained, exact
   by treatment, sort : tabulate employment justice_type_finegrained, exact
   by treatment, sort : median age, by(justice_type_finegrained) exact medianties(below)
   by treatment, sort : median actual_living_space, by(justice_type_finegrained) exact medianties(below)
   by treatment, sort : median political_attitude, by(justice_type_finegrained) exact medianties(below)
   by treatment, sort : pwcorr actual_living_space justice, obs sig
restore

preserve
   drop if units != 0

   gen utilitarian = 0
      replace utilitarian = 1 if justice_type_finegrained == 5
   prtest utilitarian, by(treatment) level(90)

   gen sufficientarian = 0
      replace sufficientarian = 1 if ///
         justice_type_finegrained == 1 | ///
         justice_type_finegrained == 2 | ///
         justice_type_finegrained == 3
   prtest sufficientarian, by(treatment) level(90)

   gen priotarian = 0
      replace priotarian = 1 if justice_type_finegrained == 4
   prtest priotarian, by(treatment) level(90)
restore


/* individual classification by regression for treatment 1 */
use "data_full", clear

egen newsub = group(subject)
drop subject
rename newsub subject

gen drp = (units >= 1000)

forvalues i = 1(1)52 {
   if inlist(`i', 2, 14, 15, 19, 26, 36, 37, 42) {
      nl (justice = 1 - exp(-({lambda} * units)^({k = 1}))) if subject == `i' & units <= 1000
         matrix list r(table)
         scalar lambda_low_b = el(r(table), 1, 1)
         scalar k_low_b = el(r(table), 1, 2)
      nl (justice = exp(-({lambda} * units)^({k = 1}))) if subject == `i' & units >= 1000
         matrix list r(table)
         scalar lambda_high_b = el(r(table), 1, 1)
         scalar k_high_b = el(r(table), 1, 2)
      twoway (function y = 1 - exp(-(lambda_low_b * x)^(k_low_b)), range(0 1000) lcolor(black) lpattern(solid)) ///
             (function y = exp(-(lambda_high_b * x)^(k_high_b)), range(1000 2000) lcolor(black) lpattern(solid)) ///
             (scatter justice units if subject==`i', msymbol(D) mcolor(black) msize(large) lcolor(black) lpattern(solid)), ///
             graphregion(color(white)) ///
             legend(off) ///
             note("") ///
             title("Hump-Shaped, `i'", size(vhuge)) ///
             xlabel(0 1000 2000, labsize(vlarge) angle(forty_five)) ///
             xline(1000, lcolor(gs8) lpattern(solid)) ///
             xticks(0(200)2000) ///
             ylabel(0(0.5)1, labsize(vlarge) angle(0)) ///
             ytick(0(0.1)1) ///
             saving(figure_tmp_`i', replace)
   }
   if inlist(`i', 20, 27, 41) {
      twoway (function y = 0, range(0 1000) lcolor(black) lpattern(solid)) ///
             (function y = 1, range(1000 2000) lcolor(black) lpattern(solid)) ///
             (scatter justice units if subject == `i', msymbol(D) mcolor(black) msize(large) lcolor(black) lpattern(solid)), ///
             graphregion(color(white)) ///
             legend(off) ///
             note("") ///
             title("Binary, `i'", size(vhuge)) ///
             xlabel(0 1000 2000, labsize(vlarge) angle(forty_five)) ///
             xline(1000, lcolor(gs8) lpattern(solid)) ///
             xticks(0(200)2000) ///
             ylabel(0(0.5)1, labsize(vlarge) angle(0)) ///
             ytick(0(0.1)1) ///
             saving(figure_tmp_`i', replace)
   }
   if inlist(`i', 28) {
      twoway (function y = 0.5, range(0 1000) lcolor(black) lpattern(solid)) ///
             (function y = 1, range(1000 2000) lcolor(black) lpattern(solid)) ///
             (scatter justice units if subject == `i', msymbol(D) mcolor(black) msize(large) lcolor(black) lpattern(solid)), ///
             graphregion(color(white)) ///
             legend(off) ///
             note("") ///
             title("Binary, `i'", size(vhuge)) ///
             xlabel(0 1000 2000, labsize(vlarge) angle(forty_five)) ///
             xline(1000, lcolor(gs8) lpattern(solid)) ///
             xticks(0(200)2000) ///
             ylabel(0(0.5)1, labsize(vlarge) angle(0)) ///
             ytick(0(0.1)1) ///
             saving(figure_tmp_`i', replace)
   }
   if inlist(`i', 4, 6, 7, 8, 9, 16, 18, 21, 22, 24, 34, 38, 39, 43, 46, 49, 52) {
      nl (justice = 1 - exp(-({lambda} * units)^({k = 1}))) if subject == `i'
         matrix list r(table)
         scalar lambda_b = el(r(table), 1, 1)
         scalar k_b = el(r(table), 1, 2)
      twoway (function y = 1 - exp(-(lambda_b * x)^(k_b)), range(0 2000) lcolor(black) lpattern(solid)) ///
             (scatter justice units if subject == `i', msymbol(D) mcolor(black) msize(large) lcolor(black) lpattern(solid)), ///
             graphregion(color(white)) ///
             legend(off) ///
             note("") ///
             title("Increasing, `i'", size(vhuge)) ///
             xlabel(0 1000 2000, labsize(vlarge) angle(forty_five)) ///
             xline(1000, lcolor(gs8) lpattern(solid)) ///
             xticks(0(200)2000) ///
             ylabel(0(0.5)1, labsize(vlarge) angle(0)) ///
             ytick(0(0.1)1) ///
             saving(figure_tmp_`i', replace)
   }
   if inlist(`i', 1, 17, 32, 40, 44, 47, 51) {
      nl (justice = 1 - exp(-({lambda} * units)^({k = 1}))) if subject == `i' & units < 1000
         matrix list r(table)
         scalar lambda_b = el(r(table), 1, 1)
         scalar k_b = el(r(table), 1, 2)
      twoway (function y = 1 - exp(-(lambda_b * x)^(k_b)), range(0 1000) lcolor(black) lpattern(solid)) ///
             (function y = 1, range(1000 2000) lcolor(black) lpattern(solid)) ///
             (scatter justice units if subject == `i', msymbol(D) mcolor(black) msize(large) lcolor(black) lpattern(solid)), ///
             graphregion(color(white)) ///
             legend(off) ///
             note("") ///
             title("Flat At/Above, `i'", size(vhuge)) ///
             xlabel(0 1000 2000, labsize(vlarge) angle(forty_five)) ///
             xline(1000, lcolor(gs8) lpattern(solid)) ///
             xticks(0(200)2000) ///
             ylabel(0(0.5)1, labsize(vlarge) angle(0)) ///
             ytick(0(0.1)1) ///
             saving(figure_tmp_`i', replace)
   }
   if inlist(`i', 3, 5, 10, 11, 12, 13, 23 ,25, 29, 30, 31, 35, 45, 48, 50) {
      nl (justice = 1 - exp(-({lambda} * units)^({k = 1}))) if subject == `i' & units >= 1000
         matrix list r(table)
         scalar lambda_b = el(r(table), 1, 1)
         scalar k_b = el(r(table), 1, 2)
      twoway (function y = 1 - exp(-(lambda_b * x)^(k_b)), range(1000 2000) lcolor(black) lpattern(solid)) ///
             (function y = 0, range(0 1000) lcolor(black) lpattern(solid)) ///
             (scatter justice units if subject == `i', msymbol(D) mcolor(black) msize(large) lcolor(black) lpattern(solid)), ///
             graphregion(color(white)) ///
             legend(off) ///
             note("") ///
             title("Zero Below, `i'", size(vhuge)) ///
             xlabel(0 1000 2000, labsize(vlarge) angle(forty_five)) ///
             xline(1000, lcolor(gs8) lpattern(solid)) ///
             xticks(0(200)2000) ///
             ylabel(0(0.5)1, labsize(vlarge) angle(0)) ///
             ytick(0(0.1)1) ///
             saving(figure_tmp_`i', replace)
   }
   if inlist(`i', 33) {
      nl (justice = 1 - exp(-({lambda} * units)^({k = 1}))) if subject == `i'
         matrix list r(table)
         scalar lambda_b = el(r(table), 1, 1)
         scalar k_b = el(r(table), 1, 2)
      twoway (function y = 1 - exp(-(lambda_b * x)^(k_b)), range(0000 2000) lcolor(black) lpattern(solid)) ///
             (scatter justice units if subject == `i', msymbol(D) mcolor(black) msize(large) lcolor(black) lpattern(solid)), ///
             graphregion(color(white)) ///
             legend(off) ///
             note("") ///
             title("Other, `i'", size(vhuge)) ///
             xlabel(0 1000 2000, labsize(vlarge) angle(forty_five)) ///
             xline(1000, lcolor(gs8) lpattern(solid)) ///
             xticks(0(200)2000) ///
             ylabel(0(0.5)1, labsize(vlarge) angle(0)) ///
             ytick(0(0.1)1) ///
             saving(figure_tmp_`i', replace)
   }
}

graph combine ///
   figure_tmp_2.gph ///
   figure_tmp_14.gph ///
   figure_tmp_15.gph ///
   figure_tmp_19.gph ///
   figure_tmp_26.gph ///
   figure_tmp_36.gph ///
   figure_tmp_37.gph ///
   figure_tmp_42.gph ///
   figure_tmp_20.gph ///
   figure_tmp_27.gph ///
   figure_tmp_28.gph ///
   figure_tmp_41.gph ///
   figure_tmp_1.gph ///
   figure_tmp_17.gph ///
   figure_tmp_32.gph ///
   figure_tmp_40.gph ///
   figure_tmp_44.gph ///
   figure_tmp_47.gph ///
   figure_tmp_51.gph, ///
   ycommon cols(6) graphregion(color(white)) altshrink xsize(9.45) ysize(6.29)
graph export figure_2.pdf, replace

graph combine ///
   figure_tmp_3.gph ///
   figure_tmp_5.gph ///
   figure_tmp_10.gph ///
   figure_tmp_11.gph ///
   figure_tmp_12.gph ///
   figure_tmp_13.gph ///
   figure_tmp_23.gph ///
   figure_tmp_25.gph ///
   figure_tmp_29.gph ///
   figure_tmp_30.gph ///
   figure_tmp_31.gph ///
   figure_tmp_35.gph ///
   figure_tmp_45.gph ///
   figure_tmp_48.gph ///
   figure_tmp_50.gph, ///
   ycommon cols(6) graphregion(color(white)) altshrink xsize(9.45) ysize(4.72)
graph export figure_3.pdf, replace

graph combine ///
   figure_tmp_4.gph ///
   figure_tmp_6.gph ///
   figure_tmp_7.gph ///
   figure_tmp_8.gph ///
   figure_tmp_9.gph ///
   figure_tmp_16.gph ///
   figure_tmp_18.gph ///
   figure_tmp_21.gph ///
   figure_tmp_22.gph ///
   figure_tmp_24.gph ///
   figure_tmp_34.gph ///
   figure_tmp_38.gph ///
   figure_tmp_39.gph ///
   figure_tmp_43.gph ///
   figure_tmp_46.gph ///
   figure_tmp_49.gph ///
   figure_tmp_52.gph, ///
   ycommon cols(6) graphregion(color(white)) altshrink xsize(9.45) ysize(4.72)
graph export figure_4.pdf, replace

graph combine ///
   figure_tmp_33.gph, ///
   ycommon cols(1) graphregion(color(white)) altshrink xsize(1.57) ysize(1.57)
graph export figure_11.pdf, replace


/* individual classification by regression for treatment 2 */
use "data_full", clear

keep if treatment == 2

egen newsub = group(subject)
drop subject
rename newsub subject

gen drp = (units >= 1000)

forvalues i = 1(1)57 {
   if inlist(`i', 10, 28) {
      nl (justice = 1 - exp(-({lambda} * units)^({k = 1}))) if subject == `i' & units <= 1000
         matrix list r(table)
         scalar lambda_low_b = el(r(table), 1, 1)
         scalar k_low_b = el(r(table), 1, 2)
      nl (justice = exp(-({lambda} * units)^({k = 1}))) if subject == `i' & units >= 1000
         matrix list r(table)
         scalar lambda_high_b = el(r(table), 1, 1)
         scalar k_high_b = el(r(table), 1, 2)
      twoway (function y = 1 - exp(-(lambda_low_b * x)^(k_low_b)), range(0 1000) lcolor(black) lpattern(solid)) ///
             (function y = exp(-(lambda_high_b * x)^(k_high_b)), range(1000 2000) lcolor(black) lpattern(solid)) ///
             (scatter justice units if subject == `i', msymbol(D) mcolor(black) msize(large) lcolor(black) lpattern(solid)), ///
             graphregion(color(white)) ///
             legend(off) ///
             note("") ///
             title("Hump-Shaped, `i'", size(vhuge)) ///
             xlabel(0 1000 2000, labsize(vlarge) angle(forty_five)) ///
             xline(1000, lcolor(gs8) lpattern(solid)) ///
             xticks(0(200)2000) ///
             ylabel(0(0.5)1, labsize(vlarge) angle(0)) ///
             ytick(0(0.1)1) ///
             saving(figure_tmp_`i', replace)
   }
   if inlist(`i', 23, 37) {
      twoway (function y = 0, range(0 1000) lcolor(black) lpattern(solid)) ///
             (function y = 1, range(1000 2000) lcolor(black) lpattern(solid)) ///
             (scatter justice units if subject == `i', msymbol(D) mcolor(black) msize(large) lcolor(black) lpattern(solid)), ///
             graphregion(color(white)) ///
             legend(off) ///
             note("") ///
             title("Binary, `i'", size(vhuge)) ///
             xlabel(0 1000 2000, labsize(vlarge) angle(forty_five)) ///
             xline(1000, lcolor(gs8) lpattern(solid)) ///
             xticks(0(200)2000) ///
             ylabel(0(0.5)1, labsize(vlarge) angle(0)) ///
             ytick(0(0.1)1) ///
             saving(figure_tmp_`i', replace)
   }
   if inlist(`i', 5, 42) {
      twoway (function y = 0, range(0 200) lcolor(black) lpattern(solid)) ///
             (function y = 1, range(200 2000) lcolor(black) lpattern(solid)) ///
             (scatter justice units if subject == `i', msymbol(D) mcolor(black) msize(large) lcolor(black) lpattern(solid)), ///
             graphregion(color(white)) ///
             legend(off) ///
             note("") ///
             title("Binary, `i'", size(vhuge)) ///
             xlabel(0 1000 2000, labsize(vlarge) angle(forty_five)) ///
             xline(1000, lcolor(gs8) lpattern(solid)) ///
             xticks(0(200)2000) ///
             ylabel(0(0.5)1, labsize(vlarge) angle(0)) ///
             ytick(0(0.1)1) ///
             saving(figure_tmp_`i', replace)
   }
   if inlist(`i', 13) {
      twoway (function y = 0, range(0 1800) lcolor(black) lpattern(solid)) ///
             (function y = 1, range(1800 2000) lcolor(black) lpattern(solid)) ///
             (scatter justice units if subject == `i', msymbol(D) mcolor(black) msize(large) lcolor(black) lpattern(solid)), ///
             graphregion(color(white)) ///
             legend(off) ///
             note("") ///
             title("Binary, `i'", size(vhuge)) ///
             xlabel(0 1000 2000, labsize(vlarge) angle(forty_five)) ///
             xline(1000, lcolor(gs8) lpattern(solid)) ///
             xticks(0(200)2000) ///
             ylabel(0(0.5)1, labsize(vlarge) angle(0)) ///
             ytick(0(0.1)1) ///
             saving(figure_tmp_`i', replace)
   }
   if inlist(`i', 1, 2, 6, 7, 8, 9, 14, 15, 16, 17, 21, 24, 25, 27, 29, 30, 31, 32, 33, 35, 36, 38, 39, 40, 41, 43, 45, 46, 47, 48, 49, 52, 53, 54, 55, 56) {
      nl (justice = 1 - exp(-({lambda} * units)^({k = 1}))) if subject == `i'
         matrix list r(table)
         scalar lambda_b = el(r(table), 1, 1)
         scalar k_b = el(r(table), 1, 2)
      twoway (function y = 1 - exp(-(lambda_b * x)^(k_b)), range(0 2000) lcolor(black) lpattern(solid)) ///
             (scatter justice units if subject == `i', msymbol(D) mcolor(black) msize(large) lcolor(black) lpattern(solid)), ///
             graphregion(color(white)) ///
             legend(off) ///
             note("") ///
             title("Increasing, `i'", size(vhuge)) ///
             xlabel(0 1000 2000, labsize(vlarge) angle(forty_five)) ///
             xline(1000, lcolor(gs8) lpattern(solid)) ///
             xticks(0(200)2000) ///
             ylabel(0(0.5)1, labsize(vlarge) angle(0)) ///
             ytick(0(0.1)1) ///
             saving(figure_tmp_`i', replace)
   }
   if inlist(`i', 12) {
      nl (justice = 1 - exp(-({lambda} * units)^({k = 1}))) if subject == `i' & units < 1000
         matrix list r(table)
         scalar lambda_b = el(r(table), 1, 1)
         scalar k_b = el(r(table), 1, 2)
      twoway (function y = 1 - exp(-(lambda_b * x)^(k_b)), range(0 1000) lcolor(black) lpattern(solid)) ///
             (function y = 1, range(1000 2000) lcolor(black) lpattern(solid)) ///
             (scatter justice units if subject == `i', msymbol(D) mcolor(black) msize(large) lcolor(black) lpattern(solid)), ///
             graphregion(color(white)) ///
             legend(off) ///
             note("") ///
             title("Flat At/Above, `i'", size(vhuge)) ///
             xlabel(0 1000 2000, labsize(vlarge) angle(forty_five)) ///
             xline(1000, lcolor(gs8) lpattern(solid)) ///
             xticks(0(200)2000) ///
             ylabel(0(0.5)1, labsize(vlarge) angle(0)) ///
             ytick(0(0.1)1) ///
             saving(figure_tmp_`i', replace)
   }
   if inlist(`i', 3, 11, 19, 50) {
      nl (justice = 1 - exp(-({lambda} * units)^({k = 1}))) if subject == `i' & units >= 1000
         matrix list r(table)
         scalar lambda_b = el(r(table), 1, 1)
         scalar k_b = el(r(table), 1, 2)
      twoway (function y = 1 - exp(-(lambda_b * x)^(k_b)), range(1000 2000) lcolor(black) lpattern(solid)) ///
             (function y = 0, range(0 1000) lcolor(black) lpattern(solid)) ///
             (scatter justice units if subject == `i', msymbol(D) mcolor(black) msize(large) lcolor(black) lpattern(solid)), ///
             graphregion(color(white)) ///
             legend(off) ///
             note("") ///
             title("Zero Below, `i'", size(vhuge)) ///
             xlabel(0 1000 2000, labsize(vlarge) angle(forty_five)) ///
             xline(1000, lcolor(gs8) lpattern(solid)) ///
             xticks(0(200)2000) ///
             ylabel(0(0.5)1, labsize(vlarge) angle(0)) ///
             ytick(0(0.1)1) ///
             saving(figure_tmp_`i', replace)
   }
   if inlist(`i', 20) {
      nl (justice = 1 - exp(-({lambda} * units)^({k = 1}))) if subject == `i' & units >= 1400
         matrix list r(table)
         scalar lambda_b = el(r(table), 1, 1)
         scalar k_b = el(r(table), 1, 2)
      twoway (function y = 1 - exp(-(lambda_b * x)^(k_b)), range(1400 2000) lcolor(black) lpattern(solid)) ///
             (function y = 0, range(0 1400) lcolor(black) lpattern(solid)) ///
             (scatter justice units if subject == `i', msymbol(D) mcolor(black) msize(large) lcolor(black) lpattern(solid)), ///
             graphregion(color(white)) ///
             legend(off) ///
             note("") ///
             title("Zero Below, `i'", size(vhuge)) ///
             xlabel(0 1000 2000, labsize(vlarge) angle(forty_five)) ///
             xline(1000, lcolor(gs8) lpattern(solid)) ///
             xticks(0(200)2000) ///
             ylabel(0(0.5)1, labsize(vlarge) angle(0)) ///
             ytick(0(0.1)1) ///
             saving(figure_tmp_`i', replace)
   }
   if inlist(`i', 4, 22) {
      twoway (function y = 1, range(0 2000) lcolor(black) lpattern(solid)) ///
             (scatter justice units if subject == `i', msymbol(D) mcolor(black) msize(large) lcolor(black) lpattern(solid)), ///
             graphregion(color(white)) ///
             legend(off) ///
             note("") ///
             title("Other, `i'", size(vhuge)) ///
             xlabel(0 1000 2000, labsize(vlarge) angle(forty_five)) ///
             xline(1000, lcolor(gs8) lpattern(solid)) ///
             xticks(0(200)2000) ///
             ylabel(0(0.5)1, labsize(vlarge) angle(0)) ///
             ytick(0(0.1)1) ///
             saving(figure_tmp_`i', replace)
   }
   if inlist(`i', 51) {
      twoway (function y = 0, range(0 2000) lcolor(black) lpattern(solid)) ///
             (scatter justice units if subject == `i', msymbol(D) mcolor(black) msize(large) lcolor(black) lpattern(solid)), ///
             graphregion(color(white)) ///
             legend(off) ///
             note("") ///
             title("Other, `i'", size(vhuge)) ///
             xlabel(0 1000 2000, labsize(vlarge) angle(forty_five)) ///
             xline(1000, lcolor(gs8) lpattern(solid)) ///
             xticks(0(200)2000) ///
             ylabel(0(0.5)1, labsize(vlarge) angle(0)) ///
             ytick(0(0.1)1) ///
             saving(figure_tmp_`i', replace)
   }
   if inlist(`i', 18, 26, 34, 44, 57) {
      twoway (connected justice units if subject == `i', msymbol(D) mcolor(black) msize(large) lcolor(black) lpattern(solid)), ///
             graphregion(color(white)) ///
             legend(off) ///
             note("") ///
             title("Other, `i'", size(vhuge)) ///
             xlabel(0 1000 2000, labsize(vlarge) angle(forty_five)) ///
             xline(1000, lcolor(gs8) lpattern(solid)) ///
             xticks(0(200)2000) ///
             ylabel(0(0.5)1, labsize(vlarge) angle(0)) ///
             ytick(0(0.1)1) ///
             saving(figure_tmp_`i', replace)
   }
}

graph combine ///
   figure_tmp_1.gph ///
   figure_tmp_2.gph ///
   figure_tmp_6.gph ///
   figure_tmp_7.gph ///
   figure_tmp_8.gph ///
   figure_tmp_9.gph ///
   figure_tmp_14.gph ///
   figure_tmp_15.gph ///
   figure_tmp_16.gph ///
   figure_tmp_17.gph ///
   figure_tmp_21.gph ///
   figure_tmp_24.gph ///
   figure_tmp_25.gph ///
   figure_tmp_27.gph ///
   figure_tmp_29.gph ///
   figure_tmp_30.gph ///
   figure_tmp_31.gph ///
   figure_tmp_32.gph ///
   figure_tmp_33.gph ///
   figure_tmp_35.gph ///
   figure_tmp_36.gph ///
   figure_tmp_38.gph ///
   figure_tmp_39.gph ///
   figure_tmp_40.gph ///
   figure_tmp_41.gph ///
   figure_tmp_43.gph ///
   figure_tmp_45.gph ///
   figure_tmp_46.gph ///
   figure_tmp_47.gph ///
   figure_tmp_48.gph ///
   figure_tmp_49.gph ///
   figure_tmp_52.gph ///
   figure_tmp_53.gph ///
   figure_tmp_54.gph ///
   figure_tmp_55.gph ///
   figure_tmp_56.gph, ///
   ycommon cols(6) graphregion(color(white)) altshrink xsize(9.45) ysize(9.45)
graph export figure_5.pdf, replace

graph combine ///
   figure_tmp_10.gph ///
   figure_tmp_28.gph ///
   figure_tmp_5.gph ///
   figure_tmp_13.gph ///
   figure_tmp_23.gph ///
   figure_tmp_37.gph ///
   figure_tmp_42.gph ///
   figure_tmp_12.gph, ///
   ycommon cols(6) graphregion(color(white)) altshrink xsize(9.45) ysize(3.15)
graph export figure_6.pdf, replace

graph combine ///
   figure_tmp_3.gph ///
   figure_tmp_11.gph ///
   figure_tmp_19.gph ///
   figure_tmp_20.gph ///
   figure_tmp_50.gph, ///
   ycommon cols(5) graphregion(color(white)) altshrink xsize(7.87) ysize(1.57) 
graph export figure_7.pdf, replace

graph combine ///
   figure_tmp_4.gph ///
   figure_tmp_18.gph ///
   figure_tmp_22.gph ///
   figure_tmp_26.gph ///
   figure_tmp_34.gph ///
   figure_tmp_44.gph ///
   figure_tmp_51.gph ///
   figure_tmp_57.gph, ///
   ycommon cols(6) graphregion(color(white)) altshrink xsize(9.45) ysize(3.15)
graph export figure_12.pdf, replace


/* mean justice ratings for suffcientarians (strict) */
use "data_full", clear

keep if ///
   subject == 11157 | ///
   subject == 11279 | ///
   subject == 11280 | ///
   subject == 11386 | ///
   subject == 11394 | ///
   subject == 12269 | ///
   subject == 12271 | ///
   subject == 12278 | ///
   subject == 41177 | ///
   subject == 41196

by units, sort : ttest justice, by(treatment)
by units, sort : ranksum justice, by(treatment)

gen dt2 = (treatment == 2)

nl (justice = 1 - exp(-(({lambda1_below} + {lambda2_below} * dt2) * units)^({k1_below = 1} + {k2_below = 0} * dt2))) if units <= 1000
   scalar lambda1_below = _b[/lambda1_below]
   scalar lambda2_below = _b[/lambda2_below]
   scalar k1_below = _b[/k1_below]
   scalar k2_below = _b[/k2_below]

test _b[/k1_below] = 1
test _b[/k1_below] + _b[/k2_below] = 1
lincom _b[/k1_below] + _b[/k2_below]

nl (justice = exp(-(({lambda1_above} + {lambda2_above} * dt2) * units)^({k1_above = 1} + {k2_above = 0} * dt2))) if units >= 1000
   scalar lambda1_above = _b[/lambda1_above]
   scalar lambda2_above = _b[/lambda2_above]
   scalar k1_above = _b[/k1_above]
   scalar k2_above = _b[/k2_above]

test _b[/k1_above] = 1
test _b[/k1_above] + _b[/k2_above] = 1
lincom _b[/k1_above] + _b[/k2_above]

collapse (mean) meanjustice = justice (sd) sdjustice = justice (count) n = justice, by(treatment units)

generate hi_j = meanjustice + invttail(n - 1,0.05) * (sdjustice / sqrt(n))
generate low_j = meanjustice - invttail(n - 1,0.05) * (sdjustice / sqrt(n))

twoway (function y = 1 - exp(-((lambda1_below) * x)^(k1_below)) if treatment == 1, range(0 1000) lcolor(black) lpattern(solid)) ///
       (function y = exp(-((lambda1_above) * x)^(k1_above)) if treatment == 1, range(1000 2000) lcolor(black) lpattern(solid)) ///
       (function y = 1 - exp(-((lambda1_below + lambda2_below) * x)^(k1_below + k2_below)) if treatment == 2, range(0 1000) lcolor(gs8) lpattern(dash)) ///
       (function y = exp(-((lambda1_above + lambda2_above) * x)^(k1_above + k2_above)) if treatment == 2, range(1000 2000) lcolor(gs8) lpattern(dash)) ///
       (scatter meanjustice units if treatment == 1, mcolor(black) msize(medium) msymbol(diamond)) ///
       (rcap hi_j low_j units if treatment == 1, lcolor(black)) ///
       (scatter meanjustice units if treatment == 2, mcolor(gs8) msize(medium) msymbol(square)), ///
       graphregion(color(white)) ///
       legend(pos(2) ring(0) col(1) order(5 7) label(5 "Need (n = 8)") label(7 "NoNeed (n = 2)")) ///
       text(0.95 1000 "Need Threshold", place(l)) ///
       title("Strict Sufficientarians") ///
       xlabel(0 1000 2000) ///
       xline(1000, lcolor(gs8) lpattern(dash)) ///
       xticks(0(200)2000) ///
       xtitle("Units of Living Space") ///
       ylabel(, angle(0)) ///
       ytitle("Justice Rating") ///
       saving(figure_tmp_strict, replace)
graph export figure_tmp_strict.pdf, replace


/* mean justice ratings for suffcientarians (quantitative) */
use "data_full", clear

keep if ///
   subject == 11156 | ///
   subject == 11282 | ///
   subject == 12158 | ///
   subject == 12276 | ///
   subject == 12380 | ///
   subject == 12383 | ///
   subject == 12387 | ///
   subject == 41179

by units, sort : ttest justice, by(treatment)
ttest justice == 0 if treatment == 1 & units == 200
ttest justice == 0 if treatment == 1 & units == 400
ttest justice == 0.5 if treatment == 1 & units == 600
ttest justice == 0.5 if treatment == 1 & units == 800
by units, sort : ranksum justice, by(treatment)

gen dt2 = (treatment == 2)

nl (justice = 1 - exp(-(({lambda1}+{lambda2} * dt2) * units)^({k1 = 1} + {k2 = 0} * dt2))) if units < 1000
   scalar lambda1 = _b[/lambda1]
   scalar lambda2 = _b[/lambda2]
   scalar k1 = _b[/k1]
   scalar k2 = _b[/k2]

test _b[/k1] = 1
test _b[/k1] + _b[/k2] = 1
lincom _b[/k1] + _b[/k2]

collapse (mean) meanjustice = justice (sd) sdjustice = justice (count) n = justice, by(treatment units)

generate hi_j = meanjustice + invttail(n - 1,0.05) * (sdjustice / sqrt(n))
generate low_j = meanjustice - invttail(n - 1,0.05) * (sdjustice / sqrt(n))

twoway (function y = 1 if treatment == 1, range(1000 2000) lcolor(black) lpattern(solid)) ///
       (function y = 1 if treatment == 4, range(1000 2000) lcolor(gs8) lpattern(dash)) ///
       (function y = 1 - exp(-((lambda1) * x)^(k1)) if treatment == 1, range(000 1000) lcolor(black) lpattern(solid)) ///
       (function y = 1 - exp(-((lambda1 + lambda2) * x)^(k1 + k2)) if treatment == 4, range(0 1000) lcolor(gs8) lpattern(dash)) ///
       (scatter meanjustice units if treatment == 1, mcolor(black) msize(medium) msymbol(diamond)) ///
       (rcap hi_j low_j units if treatment == 1, lcolor(black)) ///
       (scatter meanjustice units if treatment == 2, mcolor(gs8) msize(medium) msymbol(square)) ///
       (rcap hi_j low_j units if treatment == 2, lcolor(gs8)), ///
       graphregion(color(white)) ///
       legend(pos(5) ring(0) col(1) order(5 7) label(5 "Need (n = 7)") label(7 "NoNeed (n = 1)")) ///
       text(0.95 1000 "Need Threshold", place(l)) ///
       title("Quantitative Sufficientarians") ///
       xlabel(0 1000 2000) ///
       xline(1000, lcolor(gs8) lpattern(dash)) ///
       xticks(0(200)2000) ///
       xtitle("Units of Living Space") ///
       ylabel(, angle(0)) ///
       ytitle("Justice Rating") ///
       saving(figure_tmp_quanti, replace)
graph export figure_tmp_quanti.pdf, replace


/* mean justice ratings for prioritarians */
use "data_full", clear

keep if ///
   subject == 11158 | ///
   subject == 11160 | ///
   subject == 11165 | ///
   subject == 11276 | ///
   subject == 11277 | ///
   subject == 11278 | ///
   subject == 11390 | ///
   subject == 11393 | ///
   subject == 12154 | ///
   subject == 12155 | ///
   subject == 12156 | ///
   subject == 12162 | ///
   subject == 12381 | ///
   subject == 12384 | ///
   subject == 12386 | ///
   subject == 41169 | ///
   subject == 41178 | ///
   subject == 41187 | ///
   subject == 41188 | ///
   subject == 42289

by units, sort : ttest justice, by(treatment)
by units, sort : ranksum justice, by(treatment)

gen dt2 = (treatment == 2)

nl (justice = 1 - exp(-(({lambda1} + {lambda2} * dt2) * units)^({k1 = 1} + {k2 = 0} * dt2))) if units >= 1000
   scalar lambda1 = _b[/lambda1]
   scalar lambda2 = _b[/lambda2]
   scalar k1 = _b[/k1]
   scalar k2 = _b[/k2]

test _b[/k1] = 1
test _b[/k1] + _b[/k2] = 1
lincom _b[/k1] + _b[/k2]

collapse (mean) meanjustice = justice (sd) sdjustice = justice (count) n = justice, by(treatment units)

generate hi_j = meanjustice + invttail(n - 1,0.05) * (sdjustice / sqrt(n))
generate low_j = meanjustice - invttail(n - 1,0.05) * (sdjustice / sqrt(n))

twoway (function y = 0 if treatment == 1, range(0 1000) lcolor(black) lpattern(solid)) ///
       (function y = 0 if treatment == 2, range(0 1000) lcolor(gs8) lpattern(dash)) ///
       (function y = 1 - exp(-((lambda1) * x)^(k1)) if treatment == 1, range(1000 2000) lcolor(black) lpattern(solid)) ///
       (function y = 1 - exp(-((lambda1 + lambda2) * x)^(k1 + k2)) if treatment == 2, range(1000 2000) lcolor(gs8) lpattern(dash)) ///
       (scatter meanjustice units if treatment == 1, mcolor(black) msize(medium) msymbol(diamond)) ///
       (rcap hi_j low_j units if treatment == 1, lcolor(black)) ///
       (scatter meanjustice units if treatment == 2, mcolor(gs8) msize(medium) msymbol(square)) ///
       (rcap hi_j low_j units if treatment == 2, lcolor(gs8)), ///
       graphregion(color(white)) ///
       legend(pos(5) ring(0) col(1) order(5 7) label(5 "Need (n = 15)") label(7 "NoNeed (n = 5)")) ///
       text(0.95 1000 "Need Threshold", place(l)) ///
       title("Prioritarians") ///
       xlabel(0 1000 2000) ///
       xline(1000, lcolor(gs8) lpattern(dash)) ///
       xticks(0(200)2000) ///
       xtitle("Units of Living Space") ///
       ylabel(, angle(0)) ///
       ytitle("Justice Rating") ///
       saving(figure_tmp_priori, replace)
graph export figure_tmp_priori.pdf, replace


/* mean justice ratings for utilitarians */
use "data_full", clear

keep if ///
   subject == 11159 | ///
   subject == 11161 | ///
   subject == 11162 | ///
   subject == 11163 | ///
   subject == 11164 | ///
   subject == 11281 | ///
   subject == 11283 | ///
   subject == 11388 | ///
   subject == 11389 | ///
   subject == 11391 | ///
   subject == 12160 | ///
   subject == 12272 | ///
   subject == 12273 | ///
   subject == 12379 | ///
   subject == 12382 | ///
   subject == 12385 | ///
   subject == 12388 | ///
   subject == 41165 | ///
   subject == 41168 | ///
   subject == 41172 | ///
   subject == 41174 | ///
   subject == 41175 | ///
   subject == 41176 | ///
   subject == 41181 | ///
   subject == 41182 | ///
   subject == 41184 | ///
   subject == 41185 | ///
   subject == 41189 | ///
   subject == 41192 | ///
   subject == 41193 | ///
   subject == 41195 | ///
   subject == 41198 | ///
   subject == 42267 | ///
   subject == 42268 | ///
   subject == 42269 | ///
   subject == 42270 | ///
   subject == 42272 | ///
   subject == 42273 | ///
   subject == 42275 | ///
   subject == 42276 | ///
   subject == 42277 | ///
   subject == 42278 | ///
   subject == 42280 | ///
   subject == 42283 | ///
   subject == 42285 | ///
   subject == 42286 | ///
   subject == 42287 | ///
   subject == 42288 | ///
   subject == 42291 | ///
   subject == 42292 | ///
   subject == 42293 | ///
   subject == 42294 | ///
   subject == 42296

by units, sort : ttest justice, by(treatment)
by units, sort : ranksum justice, by(treatment)

gen d1000 = (units >= 1000)
gen dt2 = (treatment == 2)

nl (justice = 1 - exp(-(({lambda0}) * units)^({k0 = 1}))) if treatment == 1
nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * d1000) * units)^({k0 = 1} + {k1 = 0} * d1000))) if treatment == 1

nl (justice = 1 - exp(-(({lambda1} + {lambda2} * dt2) * units)^({k1 = 1} + {k2 = 0} * dt2)))
   scalar lambda1 = _b[/lambda1]
   scalar lambda2 = _b[/lambda2]
   scalar k1 = _b[/k1]
   scalar k2 = _b[/k2]

test _b[/k1] = 1
test _b[/k1] + _b[/k2] = 1
lincom _b[/k1] + _b[/k2]

collapse (mean) meanjustice = justice (sd) sdjustice = justice (count) n = justice, by(treatment units)

generate hi_j = meanjustice + invttail(n - 1,0.05) * (sdjustice / sqrt(n))
generate low_j = meanjustice - invttail(n - 1,0.05) * (sdjustice / sqrt(n))

twoway (function y = 1 - exp(-((lambda1) * x)^(k1)) if treatment == 1, range(0 2000) lcolor(black) lpattern(solid)) ///
       (function y = 1 - exp(-((lambda1 + lambda2) * x)^(k1 + k2)) if treatment == 2, range(0 2000) lcolor(gs8) lpattern(dash)) ///
       (scatter meanjustice units if treatment == 1, mcolor(black) msize(medium) msymbol(diamond)) ///
       (rcap hi_j low_j units if treatment == 1, lcolor(black)) ///
       (scatter meanjustice units if treatment == 2, mcolor(gs8) msize(medium) msymbol(square)) ///
       (rcap hi_j low_j units if treatment == 2, lcolor(gs8)), ///
       graphregion(color(white)) ///
       legend(pos(5) ring(0) col(1) order(3 5) label(3 "Need (n = 17)") label(5 "NoNeed (n = 36)")) ///
       text(0.95 1000 "Need Threshold", place(l)) ///
       title("Utilitarians") ///
       xlabel(0 1000 2000) ///
       xline(1000, lcolor(gs8) lpattern(dash)) ///
       xticks(0(200)2000) ///
       xtitle("Units of Living Space") ///
       ylabel(, angle(0)) ///
       ytitle("Justice Rating") ///
       saving(figure_tmp_utilit, replace)
graph export figure_tmp_utilit.pdf, replace

graph combine ///
   figure_tmp_strict.gph ///
   figure_tmp_quanti.gph ///
   figure_tmp_priori.gph ///
   figure_tmp_utilit.gph, ///
   ycommon altshrink cols(2) graphregion(color(white))
graph export figure_8.pdf, replace


/* mean justice ratings in the global rating task (full sample) */
use "data_full", clear

label define treatment_lb 1 "Need" 2 "NoNeed"
   label values treatment treatment_lb

by units, sort : ttest justice, by(treatment)

nl (justice = 1 - exp(-({lambda0} * units)^{k0 = 1})) if treatment == 1
   test _b[/k0] = 1
   local sign_wgt = sign(_b[/k0] - 1)
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   scalar lambda1 = _b[/lambda0]
   scalar k1 = _b[/k0]

nl (justice = 1 - exp(-({lambda0} * units)^{k0 = 1})) if treatment == 2
   test _b[/k0] = 1
   local sign_wgt = sign(_b[/k0])
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   scalar lambda2 = _b[/lambda0]
   scalar k2 = _b[/k0]

gen d1000 = 0
   replace d1000 = 1 if units >= 1000

nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * d1000) * units)^({k0 = 1} + {k1 = 0} * d1000))) if treatment == 1
   test _b[/k0] = 1
   local sign_wgt = sign(_b[/k0] - 1)
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   test _b[/k0] + _b[/k1] = 1
   local sign_wgt = sign(_b[/k0] + _b[/k1] - 1)
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   scalar lambda1_0 = _b[/lambda0]
   scalar lambda1_1 = _b[/lambda1]
   scalar k1_0 = _b[/k0]
   scalar k1_1 = _b[/k1]

nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * d1000) * units)^({k0 = 1} + {k1 = 0} * d1000))) if treatment == 2
   test _b[/k0] = 1
   local sign_wgt = sign(_b[/k0] - 1)
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   test _b[/k0] + _b[/k1] = 1
   local sign_wgt = sign(_b[/k0] + _b[/k1] - 1)
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   scalar lambda2_0 = _b[/lambda0]
   scalar lambda2_1 = _b[/lambda1]
   scalar k2_0 = _b[/k0]
   scalar k2_1 = _b[/k1]

collapse (mean) meanjustice = justice (sd) sdjustice = justice (count) n = justice, by(treatment units)

generate hi_j = meanjustice + invttail(n - 1, 0.05) * (sdjustice / sqrt(n))
generate low_j = meanjustice - invttail(n - 1, 0.05) * (sdjustice / sqrt(n))

twoway (function y = 1 - exp(-((lambda1_0) * x)^(k1_0)), range(0 1000) lcolor(black) lpattern(solid)) ///
       (function y = 1 - exp(-((lambda1_0 + lambda1_1) * x)^(k1_0 + k1_1)), range(1000 2000) lcolor(black) lpattern(solid)) ///
       (function y = 1 - exp(-((lambda2_0) * x)^(k2_0)), range(0 1000) lcolor(gs8) lpattern(dash)) ///
       (function y = 1 - exp(-((lambda2_0 + lambda2_1) * x)^(k2_0 + k2_1)), range(1000 2000) lcolor(gs8) lpattern(dash)) ///
       (scatter meanjustice units if treatment == 1, mcolor(black) msize(medium) msymbol(diamond)) ///
       (rcap hi_j low_j units if treatment == 1, lcolor(black)) ///
       (scatter meanjustice units if treatment == 2, mcolor(gs8) msize(medium) msymbol(square)) ///
       (rcap hi_j low_j units if treatment == 2, lcolor(gs8)), ///
       graphregion(color(white)) ///
       legend(pos(5) ring(0) col(1) order(5 7) label(5 "Need") label(7 "NoNeed")) ///
       text(0.95 1000 "Need Threshold", place(l)) ///
       title("") ///
       xline(1000, lcolor(gs8) lpattern(dash)) ///
       xtitle("Units of Living Space") ///
       ylabel(, angle(0)) ///
       ytitle("Justice Rating") ///
       saving(figure_9, replace)
graph export figure_9.pdf, replace


/* mean justice ratings in the relative rating task (full sample) */
use "data_full", clear

drop if units == 2000

by units, sort : ttest relative_justice, by(treatment)
by treatment, sort : ttest relative_justice if (units == 0    | units == 200), by(units)
by treatment, sort : ttest relative_justice if (units == 200  | units == 400), by(units)
by treatment, sort : ttest relative_justice if (units == 400  | units == 600), by(units)
by treatment, sort : ttest relative_justice if (units == 600  | units == 800), by(units)
by treatment, sort : ttest relative_justice if (units == 800  | units == 1000), by(units)
by treatment, sort : ttest relative_justice if (units == 1000 | units == 1200), by(units)
by treatment, sort : ttest relative_justice if (units == 1200 | units == 1400), by(units)
by treatment, sort : ttest relative_justice if (units == 1400 | units == 1600), by(units)
by treatment, sort : ttest relative_justice if (units == 1600 | units == 1800), by(units)

scalar t200400 = ((57 * 57) / (57 + 57))^0.5 * (4.09 - 2.77) / ((56 * 57 * 0.6^2 + 56 * 57 * 0.47^2) / (57 + 57 - 2))^0.5
display ttail(t200400, 57 + 57 - 2)

collapse (mean) meanjustice = relative_justice (sd) sdjustice = relative_justice (count) n = relative_justice, by(treatment units)

generate hi_j = meanjustice + invttail(n - 1, 0.05) * (sdjustice / sqrt(n))
generate low_j = meanjustice - invttail(n - 1, 0.05) * (sdjustice / sqrt(n))

twoway (rcap hi_j low_j units if treatment == 1, lcolor(black)) ///
       (rcap hi_j low_j units if treatment == 2, lcolor(gs8)) ///
       (connected meanjustice units if treatment == 1, lcolor(black) lpattern(solid) mcolor(black) msize(medium) msymbol(diamond)) ///
       (connected meanjustice units if treatment == 2, lcolor(gs8) lpattern(dash) mcolor(gs8) msize(medium) msymbol(square)), ///
       graphregion(color(white)) ///
       legend(pos(5) ring(0) col(1) order(3 4) label(3 "Need") label(4 "NoNeed")) ///
       text(0.5 800 "Need Threshold", place(l)) ///
       title("") ///
       xlabel(0 "(0,200)" 200 "(200,400)" 400 "(400,600)" 600 "(600,800)" 800 "(800,1000)" 1000 "(1000,1200)" 1200 "(1200,1400)" 1400 "(1400,1600)" 1600 "(1600,1800)" 1800 "(1800,2000)", labsize(small) angle(forty_five)) ///
       xline(800, lcolor(gs8) lpattern(dash)) ///
       xtitle("Units of Living Space") ///
       ylabel(, angle(0)) ///
       ytitle("Justice Rating") ///
       saving(figure_10, replace)
graph export figure_10.pdf, replace


/* mean justice ratings in the global rating task (conditional sample) */
use "data_cond", clear

by units, sort : ttest justice, by(treatment)

nl (justice = 1 - exp(-({lambda0} * units)^{k0 = 1})) if treatment == 1
   test _b[/k0] = 1
   local sign_wgt = sign(_b[/k0] - 1)
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   scalar lambda1 = _b[/lambda0]
   scalar k1 = _b[/k0]

nl (justice = 1 - exp(-({lambda0} * units)^{k0 = 1})) if treatment == 2
   test _b[/k0] = 1
   local sign_wgt = sign(_b[/k0])
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   scalar lambda2 = _b[/lambda0]
   scalar k2 = _b[/k0]

gen d1000 = 0
   replace d1000 = 1 if units >= 1000

nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * d1000) * units)^({k0 = 1} + {k1 = 0} * d1000))) if treatment == 1
   test _b[/k0] = 1
   local sign_wgt = sign(_b[/k0] - 1)
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   test _b[/k0] + _b[/k1] = 1
   local sign_wgt = sign(_b[/k0] + _b[/k1] - 1)
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   scalar lambda1_0 = _b[/lambda0]
   scalar lambda1_1 = _b[/lambda1]
   scalar k1_0 = _b[/k0]
   scalar k1_1 = _b[/k1]

nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * d1000) * units)^({k0 = 1} + {k1 = 0} * d1000))) if treatment == 2
   test _b[/k0] = 1
   local sign_wgt = sign(_b[/k0] - 1)
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   test _b[/k0] + _b[/k1] = 1
   local sign_wgt = sign(_b[/k0] + _b[/k1] - 1)
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   scalar lambda2_0 = _b[/lambda0]
   scalar lambda2_1 = _b[/lambda1]
   scalar k2_0 = _b[/k0]
   scalar k2_1 = _b[/k1]

collapse (mean) meanjustice = justice (sd) sdjustice = justice (count) n = justice, by(treatment units)

generate hi_j = meanjustice + invttail(n - 1, 0.05) * (sdjustice / sqrt(n))
generate low_j = meanjustice - invttail(n - 1, 0.05) * (sdjustice / sqrt(n))

twoway (function y = 1 - exp(-((lambda1_0) * x)^(k1_0)), range(0 1000) lcolor(black) lpattern(solid)) ///
       (function y = 1 - exp(-((lambda1_0 + lambda1_1) * x)^(k1_0 + k1_1)), range(1000 2000) lcolor(black) lpattern(solid)) ///
       (function y = 1 - exp(-((lambda2_0) * x)^(k2_0)), range(0 1000) lcolor(gs8) lpattern(dash)) ///
       (function y = 1 - exp(-((lambda2_0 + lambda2_1) * x)^(k2_0 + k2_1)), range(1000 2000) lcolor(gs8) lpattern(dash)) ///
       (scatter meanjustice units if treatment == 1, mcolor(black) msize(medium) msymbol(diamond)) ///
       (rcap hi_j low_j units if treatment == 1, lcolor(black)) ///
       (scatter meanjustice units if treatment == 2, mcolor(gs8) msize(medium) msymbol(square)) ///
       (rcap hi_j low_j units if treatment == 2, lcolor(gs8)), ///
       graphregion(color(white)) ///
       legend(pos(5) ring(0) col(1) order(5 7) label(5 "Need") label(7 "NoNeed")) ///
       text(0.95 1000 "Need Threshold", place(l)) ///
       title("") ///
       xline(1000, lcolor(gs8) lpattern(dash)) ///
       xtitle("Units of Living Space") ///
       ylabel(, angle(0)) ///
       ytitle("Justice Rating") ///
       saving(figure_13, replace)
graph export figure_13.pdf, replace


/* mean justice ratings in the relative rating task (conditional sample) */
use "data_cond", clear

drop if units == 2000

by units, sort : ttest relative_justice, by(treatment)
by treatment, sort : ttest relative_justice if (units == 0    | units == 200), by(units)
by treatment, sort : ttest relative_justice if (units == 200  | units == 400), by(units)
by treatment, sort : ttest relative_justice if (units == 400  | units == 600), by(units)
by treatment, sort : ttest relative_justice if (units == 600  | units == 800), by(units)
by treatment, sort : ttest relative_justice if (units == 800  | units == 1000), by(units)
by treatment, sort : ttest relative_justice if (units == 1000 | units == 1200), by(units)
by treatment, sort : ttest relative_justice if (units == 1200 | units == 1400), by(units)
by treatment, sort : ttest relative_justice if (units == 1400 | units == 1600), by(units)
by treatment, sort : ttest relative_justice if (units == 1600 | units == 1800), by(units)

collapse (mean) meanjustice = relative_justice (sd) sdjustice = relative_justice (count) n = relative_justice, by(treatment units)

generate hi_j = meanjustice + invttail(n - 1, 0.05) * (sdjustice / sqrt(n))
generate low_j = meanjustice - invttail(n - 1, 0.05) * (sdjustice / sqrt(n))

twoway (rcap hi_j low_j units if treatment == 1, lcolor(black)) ///
       (rcap hi_j low_j units if treatment == 2, lcolor(gs8)) ///
       (connected meanjustice units if treatment == 1, lcolor(black) lpattern(solid) mcolor(black) msize(medium) msymbol(diamond)) ///
       (connected meanjustice units if treatment == 2, lcolor(gs8) lpattern(dash) mcolor(gs8) msize(medium) msymbol(square)), ///
       graphregion(color(white)) ///
       legend(pos(5) ring(0) col(1) order(3 4) label(3 "Need") label(4 "NoNeed")) ///
       text(0.5 800 "Need Threshold", place(l)) ///
       title("") ///
       xlabel(0 "(0,200)" 200 "(200,400)" 400 "(400,600)" 600 "(600,800)" 800 "(800,1000)" 1000 "(1000,1200)" 1200 "(1200,1400)" 1400 "(1400,1600)" 1600 "(1600,1800)" 1800 "(1800,2000)", labsize(small) angle(forty_five)) ///
       xline(800, lcolor(gs8) lpattern(dash)) ///
       xtitle("Units of Living Space") ///
       ylabel(, angle(0)) ///
       ytitle("Justice Rating") ///
       saving(figure_14, replace)
graph export figure_14.pdf, replace


/* alternative thresholds for treatment 1 */
use "data_full", clear

nl (justice = 1 - exp(-({lambda0} * units)^{k0 = 1})) if treatment == 1

gen drp = 0
   replace drp = 1 if units >= 2000
   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * drp) * units)^({k0 = 1} + {k1 = 0} * drp))) if treatment == 1

   replace drp = 1 if units >= 1800
   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * drp) * units)^({k0 = 1} + {k1 = 0} * drp))) if treatment == 1

   replace drp = 1 if units >= 1600
   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * drp) * units)^({k0 = 1} + {k1 = 0} * drp))) if treatment == 1

   replace drp = 1 if units >= 1400
   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * drp) * units)^({k0 = 1} + {k1 = 0} * drp))) if treatment == 1

   replace drp = 1 if units >= 1200
   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * drp) * units)^({k0 = 1} + {k1 = 0} * drp))) if treatment == 1

   replace drp = 1 if units >= 1000
   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * drp) * units)^({k0 = 1} + {k1 = 0} * drp))) if treatment == 1

   replace drp = 1 if units >= 800
   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * drp) * units)^({k0 = 1} + {k1 = 0} * drp))) if treatment == 1

   replace drp = 1 if units >= 600
   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * drp) * units)^({k0 = 1} + {k1 = 0} * drp))) if treatment == 1

   replace drp = 1 if units >= 400
   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * drp) * units)^({k0 = 1} + {k1 = 0} * drp))) if treatment == 1

   replace drp = 1 if units >= 200
   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * drp) * units)^({k0 = 1} + {k1 = 0} * drp))) if treatment == 1


/* alternative thresholds for treatment 2 */
use "data_full", clear

nl (justice = 1 - exp(-({lambda0} * units)^{k0 = 1})) if treatment == 2

gen drp = 0
   replace drp = 1 if units >= 2000
   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * drp) * units)^({k0 = 1} + {k1 = 0} * drp))) if treatment == 2

   replace drp = 1 if units >= 1800
   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * drp) * units)^({k0 = 1} + {k1 = 0} * drp))) if treatment == 2

   replace drp = 1 if units >= 1600
   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * drp) * units)^({k0 = 1} + {k1 = 0} * drp))) if treatment == 2

   replace drp = 1 if units >= 1400
   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * drp) * units)^({k0 = 1} + {k1 = 0} * drp))) if treatment == 2

   replace drp = 1 if units >= 1200
   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * drp) * units)^({k0 = 1} + {k1 = 0} * drp))) if treatment == 2

   replace drp = 1 if units >= 1000
   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * drp) * units)^({k0 = 1} + {k1 = 0} * drp))) if treatment == 2

   replace drp = 1 if units >= 800
   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * drp) * units)^({k0 = 1} + {k1 = 0} * drp))) if treatment == 2

   replace drp = 1 if units >= 600
   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * drp) * units)^({k0 = 1} + {k1 = 0} * drp))) if treatment == 2

   replace drp = 1 if units >= 400
   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * drp) * units)^({k0 = 1} + {k1 = 0} * drp))) if treatment == 2

   replace drp = 1 if units >= 200
   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * drp) * units)^({k0 = 1} + {k1 = 0} * drp))) if treatment == 2
