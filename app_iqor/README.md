IQOR: I Quit Ordinary Renting
=============================

[![Build Status](https://dev.azure.com/cristianmatache/workspace/_apis/build/status/cristianmatache.workspace?branchName=master)](https://dev.azure.com/crm15/workspace/_build/latest?definitionId=1&branchName=master)
[![Python 3.8+](https://img.shields.io/badge/python-3.7+-blue.svg)](https://www.python.org/downloads/)
[![Checked with mypy](http://www.mypy-lang.org/static/mypy_badge.svg)](http://mypy-lang.org/)
![pylint Score](https://mperlet.github.io/pybadge/badges/10.svg)

What
----

Small hackathon project developed at HackZurich 2019.
It aims to make the renting system in Switzerland more efficient, which is notorious for large queues.
See: <https://devpost.com/software/iqor>

Why
---

1. Timetabling: last minute cancellations occur pretty often from both landlords and potential tenants due to various
   reasons. There is no simple way to manage that. IQOR integrates a powerful timetable system linked to a very simple
   interface.
2. Monitoring: there is no simple way to monitor the (im)balance between *supply and demand* on the real estate market
   especially in more conservative places like Switzerland. IQOR unlocks such transparency for the first time. One can
   also *see how many people were rejected by the landlord*. Compare this to an order book on an electronic exchange.
3. Quick feedback loop: landlords have a number of requirements e.g. preferences (or not) for students, tenants
   with/without pets, with/without children. Usually potential tenants are not aware of (all) such requirements.
   It is frustrating for both sides to wait for and to take time to do a viewing only to find out that the landlord
   does not like certain things about the potential tenant (e.g. doesn't like people who work from home because
   neighbours tend to complain a lot about - any - noise and people who work long hours in offices are preferred).
   Therefore, IQOR features early-rejection based on user profiles (Note that, the intent of the app is to require a
   reason in writing from the landlord such that discriminatory criteria do not happen). In turn, landlords will have a
   "rating" based on how responsive they are, how they behave on the platform and how likely they are to reject someone
   (see above).
4. Powerful yet minimalist interface: made for everyone!

How it works
------------

1. Landlords list their flats
2. Potential tenants register their interest and set expectations based on the metrics shown about the flat and
   the landlord
3. The landlord may reject on a first impression (i.e. based on the profile) and must give a reason in case this happen
4. Schedule a viewing
5. Move in

How it is implemented
---------------------

- Backend: Lightweight Python-Flask wrapper over a powerful Q/KDB backend.
- Frontend: HTML, CSS, Jinja

Team
----

- Oana Ciocioman: <https://github.com/oanaciocioman>
- Cristian Matache: <https://github.com/cristianmatache>
