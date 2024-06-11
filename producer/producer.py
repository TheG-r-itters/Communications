from confluent_kafka import Producer
import time

p = Producer({'bootstrap.servers': 'localhost:9092'})

def delivery_report(err, msg):
    if err is not None:
        print(f'Message delivery failed: {err}')
    else:
        print(f'Message delivered to TOPIC: {msg.topic()} IN PARTITION: [{msg.partition()}] with VALUE: [{msg.value().decode('utf-8')}]')

some_data_source = ["message_1", "message_2", "message_3", "message_4"]

msg_counter = 0
try: 
    while True:
        data = "message_" + str(msg_counter)
        p.produce('post-likes', data.encode('utf-8'), callback=delivery_report)
        msg_counter += 1
        p.flush()
        time.sleep(5)
except KeyboardInterrupt:
    print('Closing producer...')
    pass