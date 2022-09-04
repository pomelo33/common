from xml.etree import ElementTree as ET
from xml.dom import minidom

def getNodeText(node):
    nodelist = node.childNodes
    result = []
    for node in nodelist:
        if node.nodeType == node.TEXT_NODE:
            result.append(node.data)
    return ''.join(result)


filename = "/tmp/config.xml"

doc = minidom.parse(filename)
staffs = doc.getElementsByTagName("server")
for staff in staffs:
    nickname = staff.getElementsByTagName("name")[0]
    try:
        salary = staff.getElementsByTagName("listen-port")[0]
    except:
        salary = " "
        print(getNodeText(nickname),salary)
    else:
        print(getNodeText(nickname),getNodeText(salary))
