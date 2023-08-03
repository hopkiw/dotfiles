#!/usr/bin/env python3

import json
import os
import sys

import requests

WEBHOOK_URL = ('https://discordapp.com/api/webhooks/999543213578780727/GQMuhiR'
               '14KbBfVizrzis1n8pfUoeM02IawzR4_jh3kBtyPYf7yF78Q6CrYlDR5zID_Fz')
CONFIG_DIR = os.path.join(os.environ.get('HOME', '.'), '.config', 'the_watcher')


def encode_path(name):
  """Replace '/' with '%2f' for writing"""

  return name.replace('/', '%2F')


def get_files(dirname):
  """Get files in directory.
  Returns dictionary of filename to state NEW."""

  return {i: 'NEW' for i in os.listdir(dirname)}


def get_known_files(dirname):
  """Read state file.
  Returns dictionary of filename to state."""

  dirname = encode_path(dirname)
  try:
    with open(os.path.join(CONFIG_DIR, f'{dirname}.txt')) as fh:
      ret = json.load(fh)
  except FileNotFoundError:
    ret = {}

  return ret


def write_known_files(dirname, data):
  """Write state file."""

  dirname = encode_path(dirname)
  os.makedirs(CONFIG_DIR, exist_ok=True)
  with open(os.path.join(CONFIG_DIR, f'{dirname}.txt'), 'w+') as fh:
    json.dump(data, fh)


def get_open_files(dirname):
  """ Homegrown `LSOF(8)`
  Returns List of open files in the directory given by dirname."""

  pids = [i for i in os.listdir('/proc') if i.isdigit()]

  res = []
  for pid in pids:
    try:
      fds = os.listdir(f'/proc/{pid}/fd')
    except PermissionError:
      continue

    for fd in fds:
      try:
        target = os.readlink(f'/proc/{pid}/fd/{fd}')
      except FileNotFoundError:
        continue

      if target.startswith(dirname):
        res.append(os.path.join(dirname, target))

  return res


def notify(file):
  ret = requests.post(WEBHOOK_URL, json={'username': 'torrentz',
                                         'content': f'uploaded {file}'})

  return ret


def main():
  watch_dir = sys.argv[1]
  files = get_files(watch_dir)
  known_files = get_known_files(watch_dir)
  open_files = get_open_files(watch_dir)

  for file in files:
    if known_files.get(file, None) == 'NOTIFIED':
      print('found known file:', file)
      files[file] = 'NOTIFIED'
      continue

    for ofile in open_files:
      if ofile.startswith(os.path.join(watch_dir, file)):
        files[file] = 'PENDING'
        break

    if files[file] == 'PENDING':
      print('found open file:', file)
      continue

    notify(file)
    files[file] = 'NOTIFIED'
    print('notified for new file:', file)

  write_known_files(watch_dir, files)


if __name__ == '__main__':
  main()
  # TODO: store options in config; parameterize.
