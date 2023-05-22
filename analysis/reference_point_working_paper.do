/* header */
version 14.2

set more off, permanently
set scheme s2mono


/* sample */
use "data_full", clear

label define gender_lb 1 "male" 2 "female" 3 "other"
   label values gender gender_lb

label define employment_lb 1 "student" 2 "white-collar worker or civil servant" 3 "self employed" 4 "marginally employed" 5 "unemployed"
   label values employment employment_lb

sum age, detail
tab gender
tab employment
sum actual_living_space, detail


/* mean justice ratings in the global rating task (full sample) */
use "data_full", clear

label define treatment_lb 1 "Need" 2 "NoNeed"
   label values treatment treatment_lb

by units, sort : ttest justice, by(treatment)

nl (justice = 1 - exp(-({lambda0} * units)^{k0 = 1})) if treatment == 1
   test _b[/k0] = 1
   local sign_wgt = sign(_b[/k0] - 1)
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   scalar lambdat1 = _b[/lambda0]
   scalar kt1 = _b[/k0]

nl (justice = 1 - exp(-({lambda0} * units)^{k0 = 1})) if treatment == 2
   test _b[/k0] = 1
   local sign_wgt = sign(_b[/k0])
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   scalar lambdat2 = _b[/lambda0]
   scalar kt2 = _b[/k0]

gen d1000 = 0
   replace d1000 = 1 if units >= 1000

nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * d1000) * units)^({k0 = 1} + {k1 = 0} * d1000))) if treatment == 1
   test _b[/k0] = 1
   local sign_wgt = sign(_b[/k0] - 1)
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   test _b[/k0] + _b[/k1] = 1
   local sign_wgt = sign(_b[/k0] + _b[/k1] - 1)
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   scalar lambdat1_0 = _b[/lambda0]
   scalar lambdat1_1 = _b[/lambda1]
   scalar kt1_0 = _b[/k0]
   scalar kt1_1 = _b[/k1]

nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * d1000) * units)^({k0 = 1} + {k1 = 0} * d1000))) if treatment == 2
   test _b[/k0] = 1
   local sign_wgt = sign(_b[/k0] - 1)
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   test _b[/k0] + _b[/k1] = 1
   local sign_wgt = sign(_b[/k0] + _b[/k1] - 1)
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   scalar lambdat2_0 = _b[/lambda0]
   scalar lambdat2_1 = _b[/lambda1]
   scalar kt2_0 = _b[/k0]
   scalar kt2_1 = _b[/k1]

collapse (mean) meanjustice = justice (sd) sdjustice = justice (count) n = justice, by(treatment units)

generate hi_j = meanjustice + invttail(n - 1, 0.05) * (sdjustice / sqrt(n))
generate low_j = meanjustice - invttail(n - 1, 0.05) * (sdjustice / sqrt(n))

twoway (function y = 1 - exp(-((lambdat1_0) * x)^(kt1_0)), range(0 1000) lcolor(black) lpattern(solid)) ///
       (function y = 1 - exp(-((lambdat1_0 + lambdat1_1) * x)^(kt1_0 + kt1_1)), range(1000 2000) lcolor(black) lpattern(solid)) ///
       (function y = 1 - exp(-((lambdat2_0) * x)^(kt2_0)), range(0 1000) lcolor(gs8) lpattern(dash)) ///
       (function y = 1 - exp(-((lambdat2_0 + lambdat2_1) * x)^(kt2_0 + kt2_1)), range(1000 2000) lcolor(gs8) lpattern(dash)) ///
       (scatter meanjustice units if treatment == 1, mcolor(black) msize(medium) msymbol(diamond)) ///
       (rcap hi_j low_j units if treatment == 1, lcolor(black)) ///
       (scatter meanjustice units if treatment == 2, mcolor(gs8) msize(medium) msymbol(square)) ///
       (rcap hi_j low_j units if treatment == 2, lcolor(gs8)), ///
       title("") ///
       xtitle("Units of Living Space") ///
       xline(1000, lcolor(gs8) lpattern(dash)) ///
       ytitle("Justice Rating") ///
       text(0.95 1000 "Need Threshold", place(l)) ///
       legend(pos(5) ring(0) col(1) order(5 7) label(5 "Need") label(7 "NoNeed")) ///
       graphregion(color(white)) ///
       saving(figure_1, replace)
graph export figure_1.pdf, replace


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
       title("") ///
       xtitle("Units of Living Space") ///
       xlabel(0 "(0,200)" 200 "(200,400)" 400 "(400,600)" 600 "(600,800)" 800 "(800,1000)" 1000 "(1000,1200)" 1200 "(1200,1400)" 1400 "(1400,1600)" 1600 "(1600,1800)" 1800 "(1800,2000)", labsize(small) angle(forty_five)) ///
       xline(800, lcolor(gs8) lpattern(dash)) ///
       ytitle("Justice Rating") ///
       text(0.5 800 "Need Threshold", place(l)) ///
       legend(pos(5) ring(0) col(1) order(3 4) label(3 "Need") label(4 "NoNeed")) ///
       graphregion(color(white)) ///
       saving(figure_2, replace)
graph export figure_2.pdf, replace


/* individual justice ratings */
use "data_full", clear

gen justice_type = .
   replace justice_type = 1 if ///
      subject == 11157 | ///
      subject == 11279 | ///
      subject == 11280 | ///
      subject == 11386 | ///
      subject == 11394 | ///
      subject == 12269 | ///
      subject == 12271 | ///
      subject == 12278 | ///
      subject == 11387 | ///
      subject == 11395 | ///
      subject == 12152 | ///
      subject == 12277 | ///
      subject == 11156 | ///
      subject == 11282 | ///
      subject == 12158 | ///
      subject == 12276 | ///
      subject == 12380 | ///
      subject == 12383 | ///
      subject == 12387
   replace justice_type = 2 if ///
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
      subject == 12159 | ///
      subject == 12162 | ///
      subject == 12381 | ///
      subject == 12384 | ///
      subject == 12386
   replace justice_type = 3 if ///
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
      subject == 12388

label variable justice_type "Justice Type"

label define justice_type_lb 1 "Sufficientarianism" 2 "Priortarianism" 3 "Utilitarianism"
   label values justice_type justice_type_lb

preserve
   collapse (first) justice_type actual_living_space political_attitude, by(subject)

   tabulate justice_type

   tabstat actual_living_space, statistics(median) by(justice_type)
   tabstat political_attitude, statistics(median) by(justice_type)
restore

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

label variable justice_type_finegrained "Justice Type Fine-Grained"

label define justice_type_finegrained_lb 1 "Hump" 2 "Binary" 3 "Flat At/Above" 4 "Zero Below" 5 "Increasing" 6 "Other"
   label values justice_type_finegrained justice_type_finegrained_lb

preserve
   collapse (first) justice_type_finegrained treatment, by(subject)
   
   tabulate justice_type_finegrained treatment
restore

preserve
   keep if treatment == 1

   egen newsub = group(subject)
   drop subject
   rename newsub subject

   twoway (connected justice units, mcolor(black) lpattern(solid)), ///
      by(justice_type_finegrained subject, note("") graphregion(color(white)) cols(7)) ///
      xtitle("Units of Living Space") ///
      xlabel(, labsize(huge) angle(forty_five)) ///
      xline(1000, lcolor(gs8) lpattern(s)) ///
      ytitle("Justice Rating") ///
      saving(figure_3, replace)
   graph export figure_3.pdf, replace
restore

preserve
   keep if treatment == 2

  egen newsub = group(subject)
  drop subject
  rename newsub subject

   twoway (connected justice units, mcolor(black) lpattern(solid)), ///
      by(justice_type_finegrained subject, note("") graphregion(color(white)) cols(7)) ///
      xtitle("Units of Living Space") ///
      xlabel(, labsize(huge) angle(forty_five)) ///
      xline(1000, lcolor(gs8) lpattern(s)) ///
      ytitle("Justice Rating") ///
      saving(figure_4, replace)
   graph export figure_4.pdf, replace
restore


/* mean justice ratings in the global rating task (conditional sample) */
use "data_cond", clear

by units, sort : ttest justice, by(treatment)

nl (justice = 1 - exp(-({lambda0} * units)^{k0 = 1})) if treatment == 1
   test _b[/k0] = 1
   local sign_wgt = sign(_b[/k0] - 1)
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   scalar lambdat1 = _b[/lambda0]
   scalar kt1 = _b[/k0]

nl (justice = 1 - exp(-({lambda0} * units)^{k0 = 1})) if treatment == 2
   test _b[/k0] = 1
   local sign_wgt = sign(_b[/k0])
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   scalar lambdat2 = _b[/lambda0]
   scalar kt2 = _b[/k0]

gen d1000 = 0
   replace d1000 = 1 if units >= 1000

nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * d1000) * units)^({k0 = 1} + {k1 = 0} * d1000))) if treatment == 1
   test _b[/k0] = 1
   local sign_wgt = sign(_b[/k0] - 1)
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   test _b[/k0] + _b[/k1] = 1
   local sign_wgt = sign(_b[/k0] + _b[/k1] - 1)
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   scalar lambdat1_0 = _b[/lambda0]
   scalar lambdat1_1 = _b[/lambda1]
   scalar kt1_0 = _b[/k0]
   scalar kt1_1 = _b[/k1]

nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * d1000) * units)^({k0 = 1} + {k1 = 0} * d1000))) if treatment == 2
   test _b[/k0] = 1
   local sign_wgt = sign(_b[/k0] - 1)
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   test _b[/k0] + _b[/k1] = 1
   local sign_wgt = sign(_b[/k0] + _b[/k1] - 1)
   display "Ho: coef <= 0 p value = " ttail(r(df_r), `sign_wgt' * sqrt(r(F)))
   scalar lambdat2_0 = _b[/lambda0]
   scalar lambdat2_1 = _b[/lambda1]
   scalar kt2_0 = _b[/k0]
   scalar kt2_1 = _b[/k1]

collapse (mean) meanjustice = justice (sd) sdjustice = justice (count) n = justice, by(treatment units)

generate hi_j = meanjustice + invttail(n - 1, 0.05) * (sdjustice / sqrt(n))
generate low_j = meanjustice - invttail(n - 1, 0.05) * (sdjustice / sqrt(n))

twoway (function y = 1 - exp(-((lambdat1_0) * x)^(kt1_0)), range(0 1000) lcolor(black) lpattern(solid)) ///
       (function y = 1 - exp(-((lambdat1_0 + lambdat1_1) * x)^(kt1_0 + kt1_1)), range(1000 2000) lcolor(black) lpattern(solid)) ///
       (function y = 1 - exp(-((lambdat2_0) * x)^(kt2_0)), range(0 1000) lcolor(gs8) lpattern(dash)) ///
       (function y = 1 - exp(-((lambdat2_0 + lambdat2_1) * x)^(kt2_0 + kt2_1)), range(1000 2000) lcolor(gs8) lpattern(dash)) ///
       (scatter meanjustice units if treatment == 1, mcolor(black) msize(medium) msymbol(diamond)) ///
       (rcap hi_j low_j units if treatment == 1, lcolor(black)) ///
       (scatter meanjustice units if treatment == 2, mcolor(gs8) msize(medium) msymbol(square)) ///
       (rcap hi_j low_j units if treatment == 2, lcolor(gs8)), ///
       title("") ///
       xtitle("Units of Living Space") ///
       xline(1000, lcolor(gs8) lpattern(dash)) ///
       ytitle("Justice Rating") ///
       text(0.95 1000 "Need Threshold", place(l)) ///
       legend(pos(5) ring(0) col(1) order(5 7) label(5 "Need") label(7 "NoNeed")) ///
       graphregion(color(white)) ///
       saving(figure_5, replace)
graph export figure_5.pdf, replace


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
       title("") ///
       xtitle("Units of Living Space") ///
       xlabel(0 "(0,200)" 200 "(200,400)" 400 "(400,600)" 600 "(600,800)" 800 "(800,1000)" 1000 "(1000,1200)" 1200 "(1200,1400)" 1400 "(1400,1600)" 1600 "(1600,1800)" 1800 "(1800,2000)", labsize(small) angle(forty_five)) ///
       xline(800, lcolor(gs8) lpattern(dash)) ///
       ytitle("Justice Rating") ///
       text(0.5 800 "Need Threshold", place(l)) ///
       legend(pos(5) ring(0) col(1) order(3 4) label(3 "Need") label(4 "NoNeed")) ///
       graphregion(color(white)) ///
       saving(figure_6, replace)
graph export figure_6.pdf, replace
