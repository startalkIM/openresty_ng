import psycopg2
import uuid
import xml
import requests
from xml.etree.ElementTree import Element, SubElement, ElementTree

host = '127.0.0.1'
database = 'ejabberd'
user = 'ejabberd'
password = '123456'
port = '5432'
sent_text = input('输入内容：')

send_url = 'http://127.0.0.1:10050/qtalk/send_thirdmessage'

conn = psycopg2.connect(host=host, database=database, user=user, password=password, port=port)
conn.autocommit = True
sql = 'select host_info.host, host_users.user_id from host_users left join host_info on host_users.host_id = host_info.id;'
cursor = conn.cursor()
result = cursor.execute(sql)
cursor.execute(sql)
rs = cursor.fetchall()
_from = 'admin@' + str(rs[0][0])
user_list = [x[1]+'@'+x[0] for x in rs]
cursor.close()
conn.close()


for user in user_list:
    message = Element('message',{'type': 'headline', 'from': _from, 'to':user})
    body = SubElement(message, 'body', {'id': 'system-'+uuid.uuid4().hex, 'msgType': '1','extendInfo':'1'})
    body.text = sent_text
    _xml = xml.etree.ElementTree.tostring(message).decode()
    _agg = {'from':_from, 'to':user, 'message':_xml}
    print('params : {}\n'.format(_agg))
    response = requests.post(send_url, json=_agg)
    print('respone : {}\n', format(response))
print('done')

