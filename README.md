# Overview

This repo is comprised of the following:

- An ansible role for deploying docker containers
- A catalog of docker apps

# Deployments

- Every file in a given app's catalog entry is a jinja template

## How to Deploy an app

This repo is itself an ansible role that handles the deployment process.

As such, deploying an app can be done by calling this role with
the appropriate variables.

# TODO Document this more