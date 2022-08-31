-- R CMD check results ----------------------- aopdata 1.0.1 ----
Duration: 4m 57.1s

0 errors v | 0 warnings v | 0 notes v

- fixed invalid DOI link

**Minor changes**

- Remove code redundancy from main read_ and download function
- Do not throw connection error message in first check
- Improve error message when `mode = car`. Closes #52
- Added citation file

**Bug fixes**

- Fixed bug that did not allow one to download access estimates by car in off-peak period. Closes #53

