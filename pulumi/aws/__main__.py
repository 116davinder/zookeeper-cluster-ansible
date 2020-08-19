import pulumi
import pulumi_aws as aws

instance_type = 't2.micro'
ebs_size = 10 #in GiBs
az = "eu-central-1a"

ami = aws.get_ami(most_recent="true",
                  owners=["amazon"] ,
                  filters=[
                      {"name":"owner-alias","values":["amazon"]},
                      {"name": "name", "values":["amzn2-ami-hvm*"]}
                  ])

sg = aws.ec2.SecurityGroup('zookeeper-sg',
    description='Allow Zookeeper traffic',
    ingress=[
        { 'protocol': 'tcp',
          'from_port': 22,
          'to_port': 22,
          'cidr_blocks': ['0.0.0.0/0']
        },
        { 'protocol': 'tcp',
          'from_port': 2181,
          'to_port': 2181,
          'cidr_blocks': ['0.0.0.0/0']
        }
    ],
    egress=[
        { 'protocol': -1, 
          'from_port': 0,
          'to_port': 0, 
          'cidr_blocks': ['0.0.0.0/0']
        }
    ])

ebs = aws.ebs.Volume("zookeeper-vol",
    availability_zone=az,
    size=ebs_size,
    type="gp2",
    tags={
        "Name": "Zookeeper Vol",
    })

server = aws.ec2.Instance('zookeeper',
    instance_type=instance_type,
    availability_zone=az,
    vpc_security_group_ids=[sg.id],
    ami=ami.id,
    tags={
        "Name": "Zookeeper",
    })

pulumi.export('publicIp', server.public_ip)
pulumi.export('publicHostName', server.public_dns)