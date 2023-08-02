# Submission system

This document describes the model of the software systems supporting data submission to the National Alzheimer's Coordinating Center (NACC).

## Document Purpose



## Context

![Submission-Context-Diagram](images/structurizr-SubmissionContext.svg)

## Architecture

![Submission-Container-Diagram](images/structurizr-SubmissionContainers.svg)

```mermaid
sequenceDiagram
    actor U as Center User
    participant I as Data Submission
    participant R as REDCap Project
    participant L as Uploader
    participant T as REDCap Transfer
    participant C as Center REDCap
    U ->> I: study
    U ->> I: mode
    alt Direct Entry
        U ->> I: go to project
        I ->> R: load project
    else File Upload
        U ->> I: file, format
        I ->> L: upload file
        L ->> R: load file
    else REDCap Transfer
        U ->> T: do transfer 
        T ->> C: get report data
        T ->> R: push report data
    end
```

<!-- ## Deployment

![Submission-Deployment-Diagram](images/structurizr-ProductionSubmissionDeployment.svg) -->