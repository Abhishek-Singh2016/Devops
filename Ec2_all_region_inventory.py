import boto3
import collections
import datetime
import csv
from time import gmtime, strftime
import os


#EC2 connection beginning
ec = boto3.client('ec2')

#get to the curren date
date_fmt = strftime("%Y_%m_%d", gmtime())
#Give your file path
filepath ='/tmp/AWS_Ec2_Inventory_' + date_fmt + '.csv'
#Give your filename
filename ='AWS_Ec2_Inventory_' + date_fmt + '.csv'
csv_file = open(filepath,'w+')

#boto3 library ec2 API describe region page
#http://boto3.readthedocs.org/en/latest/reference/services/ec2.html#EC2.Client.describe_regions
regions = ec.describe_regions().get('Regions',[] )
csv_file.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n"%('InstanceID','InstanceName','PrivateIpAddress','PublicIpAddress','Platform','Instance_State','Instance_Type','SG1','SG2','SG3','SG4','SG5','Termination-Protection','Autorecovery-Configured','Environment','Department','Region','Instance_Placement'))
csv_file.flush()
for region in regions:
    reg=region['RegionName']
    regname='REGION :' + reg
    #EC2 connection beginning
    ec2con = boto3.client('ec2',region_name=reg)
    #boto3 library ec2 API describe instance page
    #http://boto3.readthedocs.org/en/latest/reference/services/ec2.html#EC2.Client.describe_instances
    reservations = ec2con.describe_instances().get(
    'Reservations',[]
    )
    instances = sum(
        [
            [i for i in r['Instances']]
            for r in reservations
        ], [])
    #instanceslist = len(instances)
    for instance in instances:
        state=instance['State']['Name']
        term_prot ="Disabled"
        autorecovery ="NA"
        environment ="-"
        department ="-"
        SG1="-"
        SG2="-"
        SG3="-"
        SG4="-"
        SG5="-"
        #SGs=[]
            #print(instance['Tags'])
        for tags in instance.get('Tags',[]):                
            if tags['Key'] == "Termination-Protection":
                term_prot = tags["Value"]
            elif tags['Key'] == "Autorecovery-Configured":
                autorecovery =tags["Value"]
            elif tags['Key'] == "Environment":
                environment = tags["Value"]
            elif tags["Key"]== "Ownership":
                department = tags["Value"]
            elif tags['Key'] == 'Name' :
                Instancename= tags['Value']
        for SG in instance.get('SecurityGroups',[]):
            if SG1 == "-":
                SG1 = SG["GroupName"]
            elif SG2 == "-":
                SG2 = SG["GroupName"]
            elif SG3 == "-":
                SG3 = SG["GroupName"]
            elif SG4 == "-":
                SG4 = SG["GroupName"]
            elif SG5 == "-":
                SG5 = SG["GroupName"]
        instanceid=instance['InstanceId']
        instancetype=instance['InstanceType']
        Placement=instance['Placement']['AvailabilityZone']
        platform=instance.get('Platform',"Linux")
        public_IP=instance.get('PublicIpAddress',"-")
        private_IP=instance.get('PrivateIpAddress',"-")
        csv_file.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n"%(instanceid,Instancename,private_IP,public_IP,platform,state,instancetype,SG1,SG2,SG3,SG4,SG5,term_prot,autorecovery,environment,department,reg,Placement))
        csv_file.flush()
