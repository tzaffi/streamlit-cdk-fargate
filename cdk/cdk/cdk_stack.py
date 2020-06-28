from aws_cdk import (
    aws_ec2 as ec2,
    aws_ecs as ecs,
    aws_ecs_patterns as ecs_patterns,
    core,
)


class CdkStack(core.Stack):

    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        vpc = ec2.Vpc(
            self, "ZephStreamlitVPC", 
            max_azs = 2, # default is all AZs in region, 
            )     

        cluster = ecs.Cluster(self, "ZephStreamlitCluster", vpc=vpc)

        # Build Dockerfile from local folder and push to ECR
        image = ecs.ContainerImage.from_asset('streamlit-docker')

        # Use an ecs_patterns recipe to do all the rest!
        ecs_patterns.ApplicationLoadBalancedFargateService(self, "ZephFargateService",
            cluster=cluster,            # Required
            cpu=256,                    # Default is 256
            desired_count=1,            # Default is 1
            task_image_options=ecs_patterns.ApplicationLoadBalancedTaskImageOptions(
                image=image, container_port=8501),  # Docker exposes 8501 for streamlit
            memory_limit_mib=512,       # Default is 512
            public_load_balancer=True,  # Default is False
        )  
