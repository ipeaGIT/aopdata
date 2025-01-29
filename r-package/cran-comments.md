── R CMD check results ───────────────────────────────────────────────────────── aopdata 1.1.1 ────
Duration: 2m 30s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔


# aopdata v1.1.1

**Bug fixes**
- Removed Non-standard file/directory 'codemeta.json' from top level
- Download functions should now fail gracefully with an informative message when there are internet connection problems. This version of the pakage makes sure to propagate eventual internet connection issues across function and includes several testes using `testthat::local_mocked_bindings`.


