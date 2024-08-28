── R CMD check results ───────────────────────────────────────────────── aopdata 1.1.0 ────
Duration: 3m 35.7s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔


# aopdata v1.1.0

**Minor changes**

- Simplified internal functions
- Removed dependency on the {httr} package
- Now using `curl::multi_download()` to download files in parallel

