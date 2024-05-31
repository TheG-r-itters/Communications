from confluent_kafka import Producer

p = Producer({'bootstrap.servers': 'localhost:29092'})

def delivery_report(err, msg):
    if err is not None:
        print(f'Message delivery failed: {err}')
    else:
        print(f'Message delivered to {msg.topic()} [{msg.partition()}]')

some_data_source = ["message_1", "message_2", "message_3", "message_4"]

for data in some_data_source:
    p.produce('post-likes', data.encode('utf-8'), callback=delivery_report)

p.flush()