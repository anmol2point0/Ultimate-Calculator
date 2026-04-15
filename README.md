This is a massive achievement, bro. You’ve built an incredibly powerful math engine. Since there are over 144 functions, explaining every single one individually would take a massive book. 

However, because of the smart way we built the `StepEngine`, **every function follows the exact same 3-step logic.** Here is the master tutorial guide for your Ultimate Calculator. You can use this to understand how to operate it, or even copy-paste this into your GitHub `README.md` so other people know how to use your app.

---

## 🧠 The Core Concept: How the App Works

Unlike a normal calculator where you type `2 + 2`, this app uses **Smart Templates**. 

1. **Tap a Button:** When you open a category (like Algebra) and tap a button (like "Quadratic"), the app automatically pastes a template into the screen: `__QUAD__1,-5,6`.
2. **Edit the Values:** You use the on-screen number pad or backspace to change those default numbers to your own numbers. **Always separate your numbers with commas.**
3. **Press Equals (`=`):** The engine reads the `__PREFIX__`, splits your numbers by the commas, and runs the step-by-step math.

---

## 📘 Category-by-Category Guide

Here is how to format the inputs for every major category in the app.

### 1. Algebra & Number Theory (Equations & Sequences)
For formulas that require multiple specific variables, enter them in the exact order separated by commas.

* **Quadratic (`__QUAD__`):** Enter $a, b, c$.
    * *Example:* `__QUAD__1,-5,6` (Solves $1x^2 - 5x + 6 = 0$)
* **Linear (`__LINEAR__`):** Enter $a, b$.
    * *Example:* `__LINEAR__2,-6` (Solves $2x - 6 = 0$)
* **AP / GP nth Term (`__APNTH__` / `__GPNTH__`):** Enter starting number $a$, difference/ratio $r$, and term number $n$.
    * *Example:* `__APNTH__2,3,10`
* **Combinatorics (`__NCR__` / `__NPR__`):** Enter total items $n$, chosen items $r$.
    * *Example:* `__NCR__5,2`

### 2. Statistics (List Inputs)
For statistics, you can enter as many numbers as you want. Just separate them with commas.

* **Mean, Median, Mode, SD, Variance:** Enter your dataset.
    * *Example:* `__MEAN__2,4,4,4,5,5,7,9`
* **Percentile (`__PERC__`):** Enter the target percentage $k$, followed by your dataset.
    * *Example:* `__PERC__75,10,20,30,40,50` (Finds the 75th percentile of those 5 numbers).
* **Linear Regression (`__LINREG__`):** Enter $x, y$ coordinate pairs in order: $x_1, y_1, x_2, y_2...$
    * *Example:* `__LINREG__1,2,2,4,3,5`

### 3. Finance
Financial formulas require specific rates and time periods.

* **Simple/Compound Interest (`__SI__` / `__CI__`):** Enter Principal, Rate%, Years. (For CI, you can add compounding periods per year as a 4th number).
    * *Example:* `__CI__1000,10,2,1` (₹1000 at 10% for 2 years, compounded 1 time per year).
* **EMI (`__EMI__`):** Enter Loan Amount, Annual Interest Rate%, Total Months.
    * *Example:* `__EMI__100000,10,12`
* **GST / Taxes:** Enter just the base amount.
    * *Example:* `__GST18__1000` (Adds 18% GST to 1000).

### 4. Matrices & Linear Algebra
Matrix inputs are read row-by-row, left to right.

* **2x2 Determinant / Inverse (`__DET2__` / `__INV2__`):** Enter 4 numbers (Row 1, then Row 2).
    * *Example:* `__DET2__1,2,3,4` (Matrix is [1, 2] top, [3, 4] bottom).
* **2x2 Matrix Math (`__MADD2__` / `__MMUL2__`):** Enter 8 numbers. The first 4 are Matrix A, the next 4 are Matrix B.
    * *Example:* `__MMUL2__1,2,3,4,5,6,7,8`
* **Cramer's Rule 2x2 (`__CRAMER2__`):** Enter $a_1, b_1, c_1$ for equation 1, then $a_2, b_2, c_2$ for equation 2.
    * *Example:* `__CRAMER2__2,1,5,3,-1,1`

### 5. Unit Converters (The Triple Input)
Every single unit converter in the app takes exactly 3 inputs: **Value, From_Unit, To_Unit**.

* **Length (`__ULEN__`):** * *Example:* `__ULEN__1,km,m` (Converts 1 Kilometer to Meters).
* **Area (`__UAREA__`):**
    * *Example:* `__UAREA__1,hectare,acre`
* **Temperature (`__UTEMP__`):** (Use C, F, K, or R).
    * *Example:* `__UTEMP__100,C,F`

### 6. Health & Body
* **BMI (`__BMI__`):** Enter Weight (kg), Height (meters).
    * *Example:* `__BMI__70,1.75`
* **Body Fat (`__BFAT__`):** Enter Waist (cm), Neck (cm), Height (cm), Sex (1 for Male, 0 for Female).
    * *Example:* `__BFAT__85,38,175,1`
* **Daily Calories/TDEE (`__DCAL__`):** Enter Weight(kg), Height(cm), Age, Sex(1=M, 0=F), Activity Level(1 to 5).
    * *Example:* `__DCAL__70,175,25,1,3`

### 7. Date & Time
Dates are always entered in **Day, Month, Year** format.

* **Age Calculator (`__AGE__`):** Enter your Date of Birth.
    * *Example:* `__AGE__15,8,2000`
* **Days Between (`__DAYS__`):** Enter Date 1, then Date 2.
    * *Example:* `__DAYS__1,1,2024,31,12,2024`
* **Add Days (`__ADDD__`):** Enter Start Date, then Days to Add.
    * *Example:* `__ADDD__1,1,2024,100` (Finds the date 100 days from Jan 1st).

### 8. Developer & Bitwise
* **Base Conversion (`__HEX__`, `__BIN__`, etc.):** Enter a decimal number.
    * *Example:* `__HEX__255` (Returns 0xFF).
* **Bitwise Shifts (`__LSH__`, `__RSH__`):** Enter the Number, then the Shift amount.
    * *Example:* `__LSH__5,2` (Shifts 5 left by 2 bits).

---

## ⚙️ Pro-Tips for the User

1. **The 'C' Button:** Clears the screen completely.
2. **The '⌫' Button (Backspace):** Deletes the last character. If you are deleting a math function like `sin(`, it deletes the whole word at once safely.
3. **The BODMAS Toggle (📚):** At the top of the screen, tap the book icon. If it turns yellow, the calculator will explicitly show you the BODMAS order of operations step-by-step for standard math problems.
4. **History (🕒):** Tap the clock icon in the top left to see your last 50 calculations. Tap any of them to instantly load them back into the screen.
5. **Matrix UI:** For complex matrices (like 3x3 Determinants), tapping the button opens a beautiful visual grid popup so you don't have to type commas manually.

---

This covers the logic for every single feature in the app. Would you like me to format this into a professional `README.md` file with markdown styling so you can push it directly to your GitHub repo alongside your code?
