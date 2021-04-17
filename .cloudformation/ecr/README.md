# YAML with Params
aws cloudformation deploy --template-file template.yml --stack-name sample-laravel8-ecr --profile uat --parameter-overrides file://$(PWD)/cf-params.json

aws cloudformation delete-stack --stack-name sample-laravel8-ecr --profile uat

aws ecr get-login-password --region ap-southeast-2 --profile uat | docker login --username AWS --password-stdin 132048024049.dkr.ecr.ap-southeast-2.amazonaws.com/sample-laravel8-ecr-repo &&  
docker build -t 132048024049.dkr.ecr.ap-southeast-2.amazonaws.com/sample-laravel8-ecr-repo . && 
docker tag sample-laravel8-ecr-repo:latest 132048024049.dkr.ecr.ap-southeast-2.amazonaws.com/sample-laravel8-ecr-repo:latest && 
docker push 132048024049.dkr.ecr.ap-southeast-2.amazonaws.com/sample-laravel8-ecr-repo:latest

aws ecr get-login-password --region ap-southeast-2 --profile uat | docker login --username AWS --password-stdin 132048024049.dkr.ecr.ap-southeast-2.amazonaws.com/sample-laravel8-ecr-repo && docker build -t132048024049.dkr.ecr.ap-southeast-2.amazonaws.com/sample-laravel8-ecr-repo . && docker tag sample-laravel8-ecr-repo:latest 132048024049.dkr.ecr.ap-southeast-2.amazonaws.com/sample-laravel8-ecr-repo:latest && docker push 132048024049.dkr.ecr.ap-southeast-2.amazonaws.com/sample-laravel8-ecr-repo:latest

# Stacks Used
- ECR

- ECS Cluster
    - Ec2 Linux with Networking
        - Cluster
            - Instance Size
            - AMI image type
            
        - VPC
        - Subnets
        - Security group
    - Container Instance
    
- Task Definition
    - For ec2
    - Memory
    - CPU
    - Select Container
        - Port Mappings
        - Select ECR image name
       
- ECS Service
    - Type: EC2
    - Task Definition
    - Select Cluster
    - Number of tasks
    - Healthy Max Percentage
    - Service type: replica
    
- Load Balancer (ELB) (Optional)

# Global Stack
- VPC
    - Subnets
    - Route Table
    - Internet Gateway
    
# Cloudformation Guide
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html
