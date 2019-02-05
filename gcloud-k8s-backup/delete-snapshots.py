#!/usr/bin/env python

import argparse
import dateutil.parser
import pytz
import datetime
import re
import google.auth
from googleapiclient import discovery


parser = argparse.ArgumentParser(description='Delete GCE snapshots')
parser.add_argument('pattern', help='Pattern to match')
parser.add_argument('--days', default=7, type=int, help='Days to keep')
args = parser.parse_args()

now = datetime.datetime.now(tz=pytz.utc)
regex = re.compile(args.pattern)
credentials, project = google.auth.default()
snapshots = discovery.build('compute', 'v1', credentials=credentials).snapshots()

list_req = snapshots.list(project=project)

while list_req is not None:
    list_res = list_req.execute()

    for snapshot in list_res['items']:
        if not regex.match(snapshot['name']):
            continue

        print "Matched snapshot {}".format(snapshot['name'])

        dt = dateutil.parser.parse(snapshot['creationTimestamp']).replace(tzinfo=pytz.utc)
        delta = now - dt
        if delta.days > args.days:
            del_req = snapshots.delete(project=project, snapshot=snapshot['name'])
            del_res = del_req.execute()
            print "Sent delete request {} for snapshot {} with id {}".format(
              del_res['id'], snapshot['name'], del_res['targetId'])

    list_req = snapshots.list_next(previous_request=list_req, previous_response=list_res)
