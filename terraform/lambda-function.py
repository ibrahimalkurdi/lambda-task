import csv
import json

# TODO: Fetch the files from S3 Bucket

def lambda_handler(event, context):
    customer_csv_file = csv.reader(open('Customers', "r"), delimiter=",")
    next(customer_csv_file)
    orders_csv_file = csv.reader(open('Orders', "r"), delimiter=",")
    next(orders_csv_file)
    total_price=0
    number_of_orders=0
    for customer_line in customer_csv_file:
        customer_reference =  customer_line[3] # ade3-11ed
        for order_line in orders_csv_file:
            if customer_reference == order_line[1]: # ade3-11ed, ade3-11ed 
                number_of_orders+=1 # 1
                order_reference = order_line[3] # dc0aa69c, dc0ab1aa
                items_csv_file = csv.reader(open('Items', "r"), delimiter=",")
                next(items_csv_file)
                for item_line in items_csv_file:
                    if order_reference == item_line[1]: # dc0aa69c, dc0ab1aa
                        total_price = total_price + float(item_line[4]) # 20, 55
        print(customer_reference, number_of_orders, total_price)

# TODO: Print the output as JSON
# TODO: Add try and Catch for error
