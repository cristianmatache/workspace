PAPER PLANE
-----------

This is the submission to LauzHack 2018 by Andrawes Al Bahou, Cristian Matache, Oana Ciocioman.

## About: 

We have noticed that skyscanner advertises different prices for the same flight, depending on the geographical
market the customer is located in.
We have created a service which scans all the geographical markets for an airfare, on Skyscanner. It consists of 
a simple frontend for user input and a Python/Flask based backend which manages queries, and query sessions. 

## Usage: 

- **Run the script in basic mode (can only receive one request at a time):**

```
python -u main.py
```

- **Run the script in performance mode (can receive many requests at a time):**

```
waitress-serve --listen=*:5000 main:app
```
