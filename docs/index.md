# NACC System Architecture Documentation

This set of documents describes a model of the planned software systems supporting the National Alzheimer's Coordinating Center (NACC).

## About NACC
The National Alzheimer’s Coordinating Center (NACC) is home to one of the largest, oldest (20+ years), and most powerful Alzheimer’s datasets in the world and facilitates impactful research across 37 Alzheimer’s Disease Research Centers (ADRCs) throughout the US.
NACC has been funded by the National Institute of Aging since 1999 and is based at the University of Washington.

NACC facilitates collaborative research across NIA-funded ADRCs managing data sets and serving as a hub between ADRCs and specialized research consortia and centers.

The primary data set is Uniform Data Set (UDS), consisting of longitudinal data for participants.
Additional data sets are the Neuropathology Data Set (NP), and the Minimum Data Set which is a retrospective data for participants prior to the UDS.
Several small affiliated studies either use ADRC data with other phenotyping data sets, or UDS survey questions for non-ADRC participants.
These additional studies may include non-ADRC centers where data is collected.

The NACC data sets are integrated with data from multiple collaborating centers including
the Alzheimer's Disease Genetics Consortium (ADGC), 
the NIA Genetics of AD Data Storage Site (NIAGADS), 
the National Centralized Repository for AD and Related Dementias (NCRAD) and 
the Standardized Centralized Alzheimer's and Related Dementias Neuroimaging (SCAN) project.

## Documents

1. [NACC System Landscape](01-system-landscape.md) – 
   describes the NACC software system and the landscape in which it exists.
   It is meant for a general audience.

2. [Domain Model](02-domain-model.md) -
   describes a model of the objects and relationships that are relevant in the context of NACC.
   This document uses UML class diagram notation, but should be accessible to most readers.

3. Subsystems - the initial sections of these documents are meant to be accessible to a general audience, but most of the content is meant for a technical audience.
   1. [Project Management](03-project-management.md) -
      describes management of projects.

   2. [User Management](04-user-management.md) -
      describes management of users.

   3. [Data Warehouse](05-warehouse.md) –
       describes the system for managing data.

   4. [Data Submission](06-submission.md) -
      describes data submission system.

   5. [Data Transfer](07-transfer.md) -
      describes the subsystem for tracking research using NACC-managed data.

   6. [Reporting](08-reporting.md) –
      describes the subsystem for NACC communications

   7. [Website](09-website.md)

4. [Architectural Decisions](20-decision-log.md) -
   Captures decisions made about architecture

## Document Access

These documents are managed on the UW Enterprise GitHub in the [naccdata](https://github.com/naccdata) organization.
They are deployed to the web using GitHub Pages and are only accessible to members of the naccdata organization or users explicitly given access.

## Document Maintenance

Information about maintaining these documents is given in the [README](https://github.com/naccdata/system-design/blob/main/README.md) of the [naccdata/system-design](https://github.com/naccdata/system-design) repository.

