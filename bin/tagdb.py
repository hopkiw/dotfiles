#!/usr/bin/env python3


# dmenu -l 10 -p 'Choose: ' -fn inconsolata:size=22 -nb black -nf white -w 0x120014d


import argparse
import hashlib
import sqlite3
import sys


class TagDB:
    def __init__(self):
        self.con = sqlite3.connect("/home/cc/.tagdb.sqlite3")
        cur = self.con.cursor()
        cur.execute("""
        CREATE TABLE IF NOT EXISTS tags (
            id  INTEGER PRIMARY KEY,
            tag TEXT UNIQUE NOT NULL
        )""")
        cur.execute("""
        CREATE TABLE IF NOT EXISTS images (
            id         INTEGER PRIMARY KEY,
            image_path TEXT NOT NULL,
            image_hash TEXT NOT NULL,
            UNIQUE(image_path, image_hash)
        )""")
        cur.execute("""
        CREATE TABLE IF NOT EXISTS imagetags (
            id       INTEGER PRIMARY KEY,
            image_id INTEGER NOT NULL,
            tag_id   INTEGER NOT NULL,
            FOREIGN KEY(image_id) REFERENCES images(id),
            FOREIGN KEY(tag_id) REFERENCES tags(id),
            UNIQUE(image_id, tag_id)
        )""")
        self.con.commit()

    def add_image_tag(self, image_id, tag_id):
        cur = self.con.cursor()
        cur.execute("""
            INSERT OR IGNORE INTO imagetags (image_id, tag_id)
            VALUES (?, ?)""", (image_id, tag_id))
        self.con.commit()

    def add_tag(self, tag):
        cur = self.con.cursor()
        cur.execute('INSERT OR IGNORE INTO tags (tag) VALUES (?)', (tag,))
        self.con.commit()

    def add_image(self, image_path, image_hash):
        cur = self.con.cursor()
        cur.execute("""
            INSERT OR IGNORE INTO images (image_path, image_hash)
            VALUES (?, ?)""", (image_path, image_hash))
        self.con.commit()

    def get_tag(self, tag):
        cur = self.con.cursor()
        res = cur.execute('SELECT id FROM tags WHERE tag = ?',
                          (tag,))
        maybe = res.fetchone()
        return maybe[0] if maybe else None

    def get_image_by_path(self, image_path):
        cur = self.con.cursor()
        res = cur.execute('SELECT id FROM images WHERE image_path = ?',
                          (image_path,))
        maybe = res.fetchone()
        return maybe[0] if maybe else None

    def get_image_by_hash(self, image_hash):
        cur = self.con.cursor()
        res = cur.execute('SELECT id FROM images WHERE image_hash = ?',
                          (image_hash,))
        maybe = res.fetchone()
        return maybe[0] if maybe else None

    def get_images_by_tag(self, tag_id):
        cur = self.con.cursor()
        res = cur.execute("""
              SELECT image_path
              FROM images
              LEFT JOIN imagetags ON images.id = imagetags.image_id
              WHERE tag_id = ?""", (tag_id,))

        return [entry[0] for entry in res.fetchall()]

    def get_tags_by_image(self, image_id):
        cur = self.con.cursor()
        res = cur.execute("""
              SELECT tag
              FROM tags
              LEFT JOIN imagetags ON tags.id = imagetags.tag_id
              WHERE image_id = ?""", (image_id,))

        return [entry[0] for entry in res.fetchall()]

    def get_all_tags(self):
        cur = self.con.cursor()
        res = cur.execute('SELECT tag FROM tags')

        return [entry[0] for entry in res.fetchall()]


def getmd5sum(path):
    with open(path, 'rb') as fh:
        s = fh.read()
    return hashlib.md5(s).hexdigest()


def main():
    # TODO:
    # user should be able to search 'all images that match ALL these tags'
    # user should be able to search 'all images that match ANY of these tags'

    # user should be able to provide a file of filenames to tag
    # user should be able to specify multiple tags to add at once

    # user should be able to rename, merge, or delete tags

    parser = argparse.ArgumentParser()
    grp = parser.add_mutually_exclusive_group(required=True)
    grp.add_argument("--add", action="store_true")
    grp.add_argument("--get", action="store_true")
    grp.add_argument("--get-all-tags", action="store_true")

    parser.add_argument("--path")
    parser.add_argument("--tag")
    args = parser.parse_args()

    if args.get_all_tags:
        db = TagDB()
        for tag in db.get_all_tags():
            print(tag)

        return

    if args.get:
        if len(list(filter(None, (args.tag, args.path)))) != 1:
            print('--get requires --tag or --path')
            return

        db = TagDB()

        if args.tag:
            tag_id = db.get_tag(args.tag)
            print(f'images tagged "{args.tag}":', db.get_images_by_tag(tag_id))
            return 1

        if args.path:
            image_id = db.get_image_by_path(args.path)
            print(f'tags for file "{args.path}":', db.get_tags_by_image(image_id))
            return 1

    if args.add:
        if not args.tag or not args.path:
            print('--add requires --tag and --path')
            return 1

        db = TagDB()

        db.add_tag(args.tag)
        tag_id = db.get_tag(args.tag)

        md5sum = getmd5sum(args.path)

        db.add_image(args.path, md5sum)
        image_id = db.get_image_by_hash(md5sum)

        db.add_image_tag(image_id, tag_id)
        print(f'Added tag "{args.tag}" to image {md5sum}:{args.path}.')

        return 0


if __name__ == '__main__':
    sys.exit(main())
