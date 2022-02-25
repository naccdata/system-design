# NACC System Landscape

This document describes a model of the software systems supporting the National Alzheimer's Coordinating Center (NACC).
## Document Purpose


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

## Landscape model

We focus on three primary internal functions that are accessed by the website:

1. Managing a directory of NACC users – determining who can use NACC systems and for what.
2. Managing data for UDS and affiliated studies.
3. Tracking research done with NACC managed data.

Interfaces with external users and systems are shown in the following diagram.

![System-Landscape-Diagram](images/structurizr-SystemLandscape.svg)

As this model shows, the website serves as the interface for external users of the system, which include the following

1. ADRC Users - The NIA Alzheimer's Disease Research Centers provide UDS data to NACC. 
   There are two user roles that we describe in this model.
    1. ADRC Administrative user – an administrative user manages the ADRC relationship with NACC, determining which staff are users of NACC systems and in what role.
    2. ADRC Data user – 
2. Study Users – Study users are responsible for the metadata that defines a study and how it is managed within NACC.
    1. Study Administrative user – manages the study relationship with NACC, determines what data the study collects, and which centers can contribute data.
    2. Study Investigator - initiates the creation of a study within NACC by making an intake request. Provides initial definition of the study.
3. Forms manager - a user that is responsible for the definition and maintenance of a set of forms including questions and data validations.
4. Researcher - a user who is using NACC managed data for research.
5. Other external users include members of the public, staff from NIA, ADRCs, NACC, or legislatures who are interested in information, events or resources provided by NACC.

The external systems that integrate with NACC systems include the following:

1. ADRC Data System – some ADRC manage their own data management systems that they would like to have interact directly with NACC APIs. 
   These systems typically involve some form of Electronic Data Capture that populates a database. 
   NACC APIs may be used for validating or submitting data, or pulling center specific data.
   Data submitted by an ADRC may include form responses, EHR records, images (MRI/PET), and files from digital or other phenotyping capture.
2. NCRAD – NCRAD provides data to be distributed to ADRCs based on the processing of samples submitted.
   Additionally, NACC centralized search capabilities would link to NCRAD records for UDS participants.
3. NIAGADS – NIAGADS provides genotype data from the ADGC to be distributed to ADRCs based on genotyping of samples submitted to NCRAD.
   Additionally, NACC centralized search capabilities would link to NIAGADS records for UDS participants.
4. LONI – LONI supports the SCAN project by collecting MRI/PET images, which are then analyzed by SCAN computational teams.
   LONI provides NACC with status data for uploads and results of SCAN computational results.
   Additionally, NACC centralized search capabilities would link to LONI records for SCAN images.
5. ATRI – ATRI supports the LEADS study, and NACC pulls a participant list from ATRI to create a report for LEADS for UDS submissions.
6. GAAIN - GAAIN is a meta-database and *NEED MORE DETAILS*



