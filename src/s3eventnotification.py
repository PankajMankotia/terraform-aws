import json
import boto3

s3 = boto3.client("s3")
dynamodb = boto3.resource("dynamodb")
dynamobdTable = dynamodb.Table("countrydetails")

def eventnotificationhandler(event, context):
    if event:
        print("Event: ", event)
        file_obj = event["Records"][0]
        filename = str(file_obj["s3"]["object"]["key"])
        print("File Name: ", filename)
        fileObj = s3.get_object(Bucket="s3-dtedemo-storage", Key = filename)
        file_content = fileObj["Body"].read().decode("utf-8")
        print(file_content)
        jsonfile = json.dumps(file_content)
        print("Json Details: ", jsonfile)
        parsejson = json.loads(jsonfile).replace("'", '"')
        print("Parsed Json: ", parsejson)
        if bool(parsejson and parsejson.strip()):
            print("Line: ", parsejson)
            d = parsejson.replace("\r\n", "*").replace("**","")
            print(d)
            data = d.split("*")
            print(data)
            res_dct = {data[i]: data[i + 1] for i in range(0, len(data), 2)}
        print(res_dct)
        finaljson = json.dumps(res_dct)
        
        print("Final JSON : ", finaljson)
        
        dynamobdTable.put_item(Item=json.loads(finaljson))
        
    return "File updated in dynamoDB table"