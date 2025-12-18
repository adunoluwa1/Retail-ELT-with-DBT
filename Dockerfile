# Base image to build on. Slim version to save space
FROM python:3.11-slim

# Create and change directory to /usr/app/dbt
WORKDIR /usr/app/dbt


# Install system dependencies
# refreshes software packages
RUN apt-get update \
# Install git to install packages from github
&& apt-get install -y git \
# Remove temporart list of packages to keep image size small
    && rm -rf /var/lib/apt/lists/*

# Install dbt and postgres adapter, use --no-cache-dir to tell Python not to save installer files to save space
RUN pip install --no-cache-dir dbt-core dbt-postgres

# Copy dbt project files from current dir to container cwd
COPY . .

# install dbt dependencies (packages.yml)
RUN dbt deps

# check for project file in container cwd not ~/dbt/profiles.yml
ENV DBT_PROFILES_DIR=.

ENV DBT_HOST=localhost
ENV DBT_USER=retail_user
ENV DBT_PASSWORD=password
ENV DBT_PORT=5432
ENV DBT_DBNAME=retail_elt_db
ENV DBT_SCHEMA=public

CMD ["dbt","build"]
