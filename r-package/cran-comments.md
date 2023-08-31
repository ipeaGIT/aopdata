── R CMD check results ────────────────────────── aopdata 1.0.3 ────
Duration: 3m 20.7s


0 errors ✔ | 0 warnings ✔ | 0 notes ✔

# aopdata v1.0.3

**Bug fixes**

- Simplified internal functions
- Download functions should now fail gracefully with an informative message when there are internet connection problems. Using a more robust solution now that also accounts for timeout.

