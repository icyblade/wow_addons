import os

for root, dirs, files in os.walk('./'):
    for filename in files:
        path = os.path.join(root, filename)
        name, ext = os.path.splitext(os.path.basename(path))
        if ext == '.tga':
            with open(path, 'rb+') as fi:
                with open(os.path.join(root, name+'.blp'), 'wb+') as fo:
                    fo.write(fi.read())