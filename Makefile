SHELL := /bin/bash

help:
	@echo 'Makefile for managing "macgyver"                                       '
	@echo '                                                                       '
	@echo 'Usage:                                                                 '
	@echo '                                                                       '
	@echo ' make deploy-streamlit: deploy a demo streamlit to Fargate using CDK   '
	@echo '                                                                       '
	@echo ' make local-streamlit: build streamlit docker and run on port 8501     '
	@echo '                                                                       '


local-streamlit:
	cd streamlit-docker && docker-compose up --build streamlit


deploy-streamlit:
	cd cdk && cdk deploy

############# CDK: AWS Cloud Developer Kit ###########

PROJECT = "invalid"
PACKS = "invalid"

cdk-init-dir:
	mkdir -p cdk/$(PROJECT)

cdk-init-new:
	cd cdk/$(PROJECT) \
		&& cdk init app --language python \
		&& python3 -m venv .env \
		&& pip install --upgrade pip \
		&& source .env/bin/activate \
		&& pip install -r requirements.txt

cdk-init: cdk-init-dir cdk-init-new


# EG for fargate: make cdk-install PROJECT=fargate PACKS="aws_cdk.aws_ec2 aws_cdk.aws_ecs aws_cdk.aws_ecs_patterns"

cdk-install:
	cd cdk/$(PROJECT) \
	 	&& pip install $(PACKS) \
	 	&& pip freeze > requirements.txt

cdk-fix-this-stack-uses-assets-error:
	cd cdk/$(PROJECT) && cdk bootstrap

cdk-deploy:
	cd cdk/$(PROJECT) && cdk deploy

cdk-clean:
	cd cdk/$(PROJECT) && cdk destroy

cdk-show-cloudformation:
	cd cdk/$(PROJECT) && cdk synth

cdk-help:
	cdk docs
