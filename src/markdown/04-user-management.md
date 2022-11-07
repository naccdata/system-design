# User Management

User management for NACC is primarily driven from a directory managed by users of ADRCs or other affiliated centers.
The directory identifies users and their roles within the center, which in turn identifies authorization within projects at the center.
Individual users will be expected to manage their own directory entries, including adding necessary email address used by the identity provider for the center. 
This would include either an ePPN (eduPersonPrincipalName) or a primary email address associated with an ORCID account.

## Document Purpose

This document is intended to convey the context and design of user management subsystem for NACC.

## Context

The user management system is used by research center and NACC administrative users to update directory information.
The system then synchronizes this information with the users within Flywheel (the data warehouse).

![User-Management-Context-Diagram](images/structurizr-UserManagementContext.svg)

## Architecture

The user management system consists of the NACC Directory and the synchronizer.
The directory is a REDCap project built to collect center and personnel details, and the synchronizer is a script that uses the Flywheel API to add and disable users.

> Note: project access is managed by the Project Management System.

![User-Management-Container-Diagram](images/structurizr-UserManagementContainers.svg)