PAPER PLANE
-----------
[![Build Status](https://dev.azure.com/crm15/workspace/_apis/build/status/cristianmatache.workspace?branchName=master)](https://dev.azure.com/crm15/workspace/_build/latest?definitionId=1&branchName=master)
[![Python 3.8+](https://img.shields.io/badge/python-3.7+-blue.svg)](https://www.python.org/downloads/)
[![Checked with mypy](http://www.mypy-lang.org/static/mypy_badge.svg)](http://mypy-lang.org/)
![pylint Score](https://mperlet.github.io/pybadge/badges/10.svg)

This is the submission to LauzHack 2018 by Andrawes Al Bahou, Cristian Matache, Oana Ciocioman.

## About: 

We have noticed that skyscanner advertises different prices for the same flight, depending on the geographical market the customer is located in.
We have created a service which scans all the geographical markets for an airfare, on Skyscanner. It consists of a simple frontend for user input and a Python/Flask based backend which manages queries, and query sessions. 

## Usage: 

- **Run the script in basic mode (can only receive one request at a time):**

```
python -u main.py
```

- **Run the script in performance mode (can receive many requests at a time):**

```
waitress-serve --listen=*:5000 main:app
```
