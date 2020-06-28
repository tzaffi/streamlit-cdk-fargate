SHELL := /bin/bash

help:
	@echo 'Makefile for managing "macgyver"                                       '
	@echo '                                                                       '
	@echo 'Usage:                                                                 '
	@echo '                                                                       '
	@echo ' make deploy-streamlit: deploy a demo streamlit to Fargate using CDK   '
	@echo '                                                                       '
	@echo ' make teardown-streamlit: clean up the demo and all its resources      '
	@echo '                                                                       '
	@echo ' make local-streamlit: build streamlit docker and run on port 8501     '
	@echo '                                                                       '


local-streamlit:
	cd streamlit-docker && docker-compose up --build streamlit


deploy-streamlit:
	cd cdk \
	&& python3 -m venv .env \
	&& source .env/bin/activate \
	&& pip install --upgrade pip \
	&& pip install -r requirements.txt \
	&& cdk bootstrap \
	&& cdk deploy


teardown-streamlit:
	cd cdk && cdk destroy
