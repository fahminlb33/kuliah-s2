# Pertemuan 11 - Software Testing

Tugas untuk membuat test case menggunakan teknik *equivalence class partitioning*.

Problem:

Next date function.

Input: month, day, year representing a date

- 1 <= month <= 12
- 1 <= day <= 31
- 1812<= year <= 2012

Output: date of the day after the input date

- Must consider leap years
- Leap year is divisible by 4, and not a century year
- Century year is leap years if multiple of 400

Test cases:

- should return error when day is less than 1
- should return error when day is greater than 31
- should return error when month is less than 1
- should return error when month is greater than 12
- should return error when year is less than 1812
- should return error when year is greater than 2012
- should return 1, 1, 2011 when input 31, 12, 2011
- should return 1, 2, 2012 when input 31, 1, 2012
- should return error when input 31, 4, 2012
- should return 1, 5, 2012 when input 30, 4, 2012
- should return 1, 3, 2012 when input 29, 2, 2012 on non-leap year
- should return error when input 29, 2, 2011 on non-leap year
- should return 1, 3, 2010 when input 28, 2, 2010 on leap year
- should return error when input 28, 2, 2008 on non-leap year
- should return 31, 1, 2012 when input 30, 1, 2012
- should return 2, 1, 2012 when input 1, 1, 2012
