# NACC System Landscape

This document describes a model of the software systems supporting the [National Alzheimer's Coordinating Center (NACC)](https://naccdata.org).

## Document Purpose

The goal of this document is to help the reader understand the environment in which NACC and the NACC software system operate.

The software system is modeled in a desired state, and does not describe the system that grew organically through the history of NACC.

## About NACC

NACC is the coordinating center for the [Alzheimer's Disease Research Center (ADRC) program of the NIH](https://www.nia.nih.gov/health/alzheimers-disease-research-centers), which funds ADRCs across the country.
Clinical representatives from the ADRCs (the Clinical Task Force) define the protocol used to gather data, mainly through a set of forms called UDS (or Uniform Data Set).
However, NACC also receives other forms of data from the ADRCs, such as imaging and neuropathology exam data.
ADRCs are also exploring new types of data that may be indicative of AD phenotype that are expected to be managed by NACC.

As the coordinating center, NACC serves primarily as the warehouse and "publisher" of data collected at ADRCs; with the data shared with the research community beyond the ADRCs.
NACC is also the conduit for returning to the ADRCs data derived elsewhere and stored at other data centers, including the biomarker inventory at [NCRAD](https://ncrad.iu.edu), genetics data at [NIAGADS](https://www.niagads.org) from the [ADGC](https://www.adgenetics.org), and data computed from imaging data stored at LONI for [SCAN](http://scan.naccdata.org).

NACC also supports several affiliate projects that collect UDS data.
These are often specialized studies that collect UDS form responses for non-ADRC participants, or use the data from subsets of the UDS participants.
These projects are defined and managed separately from the UDS project, and may involve non-ADRC sites.

NACC also contributes warehoused UDS data to other projects (e.g., [GAAIN](https://gaain.org)).



## NACC data

Historically, the data managed at NACC are of two kinds:

- Form responses – these are data collected from the completion of forms. 
  Responses may be captured electronically using a system such as REDCap, or may be captured on paper and transcribed into a data file manually.
  NACC forms data consists primarily of responses to forms of the Uniform Data Set and associated modules.
- MR or PET Images – these are DICOM images collected by imaging cores at research centers.
  These are a series of images created during a single session, and have associated metadata in a DICOM header.

Expected data types for the future include (1) EHR data, (2) images collected by visualization of neuropathology slides, and (3) digital phenotype data. Digital phenotype is a broad class of data that includes audio/video files capturing interaction with the participant, movement sensor data, and tablet captured responses from the participant (e.g., drawing of a clock face).

## System Landscape Model

The NACC system setting with interfaces with external users and systems are shown in the following diagram.

![Generalized-System-Landscape-Diagram](images/structurizr-GeneralizedSystemLandscape.svg)

## Subsystems of the NACC system

To support NACC’s role, there are five key subsystems of the NACC system:

1. *Submission System*: Data can be received from centers in three ways, through an online form interface, a batch submission interface, and by direct transfer.
   Data quality is ensured before the data is stored.
2. *Data Sharing System*: Users may browse or search for data as permitted by data ownership and authorization. 
   Data may also be accessed via API.
3. *Data Warehouse*: All NACC supported data types can be stored with sufficient indexing to support efficient searches.
   All data has provenance indicating where it came from and whether it has been transformed.
   Externally accessible data is also indexed.
4. *Transfer System*: NACC pushes data to or pulls data from other centers. 
5. *Reporting System*: Reports may be generated that reflect the data available, status of data, and audits of data quality.

In addition, there are management subsystems:

1. *Project Management*: managing metadata related to research studies supported by NACC.
2. *User Management*: managing the directory of study personnel, and NACC system users.

## External Interactions

### Alzheimer's Disease Research Centers

The primary role of NACC is to support the ADRC Program, and NACC works most closely with the centers funded by this program (the ADRCs).
An ADRC collects data, images and blood and tissue samples during visits with participants and then submits these to NACC and other national centers.
UDS form data and some images are submitted to NACC, with the rest being sent to [other national centers](#other-alzheimers-disease-national-centers).

The ADRCs have a relatively consistent structure with the following user roles:

1. Administrative user – an administrative user manages the ADRC relationship with NACC, determining which staff are users of NACC systems and in what role.
2. Clinical user - a clinical user interacts with participants and is responsible for capture of data ultimately stored at NACC.
3. Data Core user – data core manager or staff member who will be responsible for data collected at the ADRC, and will submit data as well as audit data at NACC.
4. Imaging Core user - imaging core manager or staff member who is responsible for PET or MRI images gathered at the ADRC, will submit as well as audit data at NACC.
5. ADRC Leadership user – a director of the center or core of the center. Will view reports.

Each of these user roles interacts with NACC systems in some way.
Administrative users manage the center membership in the NACC Directory (in User Management), including assigning user roles that determine access to the system.
Clinical users reference calculators that are found on the NACC website (not included in the system model).
Data and Imaging core users submit data to and audit data in the NACC data warehouse, including accessing data from cooperating national centers.
Leadership users use reports from the reporting system in tracking their contribution to the ADRC Program and developing reports to the NIA.

Other interactions with research centers will be with center data systems that can be integrated with the NACC system for submission or pulling data via API.
These systems typically involve some form of Electronic Data Capture that populates a database. 
NACC APIs may be used for validating or submitting data, or pulling center specific data.
Data submitted by an ADRC may include form responses, EHR records, images (MRI/PET), and files from digital or other phenotyping capture.

NACC also accepts data from non-ADRC research centers for [affiliated studies](#affiliated-studies).

### Other Alzheimer's Disease National Centers

As mentioned above, a center collects images and biological samples that are sent to other national centers from which data is derived, and then transferred to NACC for distribution to the center.

Images collected for the SCAN project are submitted to to LONI for management.
These images analyzed by SCAN project teams, the resulting data is first stored at LONI, and then NACC pulls the analytical results for return to the ADRC and inclusion in the released dataset.

Blood and tissue samples are sent to NCRAD for biobanking.
These samples are genotyped by NIAGADS for the ADGC, yielding genetic data that is transferred to NACC for return to the center.
Genotype of particular sites is also captured by ADGC which is transferred to NACC for inclusion in the UDS dataset released to researchers.
In addition, NCRAD performs lab tests on the samples, and those tests are transferred to NACC for distribution to the centers.

Finally, NACC provides data to other projects aggregating data.
In particular, [GAAIN](http://www.gaain.org/) which is a meta-database of Alzheimer's Disease data to which UDS data is contributed.


### Affiliated Studies

An affiliated study is an ADRD study that involves the use of UDS data, but may not be restricted to participants within an ADRC.
These studies are often run by principal investigators at an ADRC, and may require NACC to interact with other data teams or systems.
   
### Research Users

Researchers wanting to use ADRC data will complete a Data Use Agreement and request the particular data they need.
In most cases, researchers are given access to a fixed data release, called "Quick Access" files, but in some cases they may have ongoing requests that may be repeatedly updated as more data comes in and is frozen within the NACC data warehouse.
