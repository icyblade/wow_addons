string = ''
for map_name, value in db.iteritems():
    string += 'nodes["%s"] = {\n' % map_name
    for pos, attr in value.iteritems():
        icon, title, desc, cont = attr['icon'], attr['title'].decode('utf8'), attr['desc'].decode('utf8'), attr['cont']
        if title == u'稀有':
            title = desc
            typ = 'rare'
            reward_id = 120209 # skull
        elif title == u'箱子':
            typ = 'treasure'
            reward_id = 9265 # box
        elif title == u'入口':
            typ = 'entrance'
            reward_id = 134055 # key
        quest_id = 0
        reward = ''
        string += '    [%s]={ "%s", "%s", "%s", "", "default", "%s","%s"},\n' % (
            pos, quest_id, title, reward, typ, reward_id
        )
    string += '}\n'
with open('d:/1','w') as f:
    f.write(string.encode('utf8'))
        