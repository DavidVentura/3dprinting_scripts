#!/usr/bin/python3
import requests
import sys

APIKEY = '81A811D2D4094037AD9C69411B1AC73F'
r = requests.get('http://octopi.labs/api/printer', params={'exclude': 'temperature,sd'}, headers={"X-Api-Key": APIKEY})
if not r.ok:
    print(r.text)
    sys.exit(1)
state = r.json()['state']
flags = state['flags']
if flags['printing'] or flags['cancelling'] or flags['pausing'] or flags['paused']:
    print("Printing -- aborting")
    exit(1)
if not flags['operational'] or not flags['ready']:
    print("Not ready?? -- aborting")
    exit(1)
if flags['error'] or flags['closedOrError']:
    print("In error state? -- aborting")
    exit(1)


exit(0)
