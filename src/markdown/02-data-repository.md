# NACC data repository

## Repository Context 

this is the description of the NACC system context

![Repository-Context-Diagram](images/structurizr-RepositoryContext.svg)

## Domain model 

The repository captures data for for a study the goal of which is to capture (longitudinal) standardized observations for the enrolled participants.
A study consists of centers that enroll and observe participants, and a design which determines the observations that will be made.

```mermaid
classDiagram
    class Center {
        +ID center_id
    }
    class Study {
        +ID study_id
        +String name
    }
    Study --> "n" Center
    Study --> "0..n" Participant : enrollees
    Study --> "1..n" Design
    Study --> "0..n" Observation : dataset
```

Observations are captured at a study center where the participant is enrolled within the study.

```mermaid
classDiagram
    class Center
    class Visit {
        +ID visit_id
        +Date visit_date
    }

    Participant --> "0..n" Visit
    Visit --> "1" Center
    Visit *-- "1..n" Observation
```

*note: need to represent participant enrollment at a center being time dependent*

As determined by the study design, observations may be form responses, images, other forms of digital data, or biospecimens captured during the visit.

```mermaid
classDiagram
    Observation <|-- FormResponses
    Observation <|-- Image
    Observation <|-- Biospecimen
    Observation <|-- Digital Data
```

All but biospecimens can be storied as files or other structured data.
In the context of NACC, a biospecimen may be represented as a reference to a sample at a tissue repository (e.g., NCRAD).

The data set for a study includes any files capturing observations, and *variables*, each of which is a value extracted or derived from an observation.

```mermaid
classDiagram
    Variable --> "1" Observation : derived_from
```

Examples include

1.  encoded form response for a question, 
2.  a biomarker derived from a biospecimen,
3.  a volumetric measure computed from an image series, or
4.  a measure of cognition computed from tablet-based assessments.

Observations must meet the study design

```mermaid
classDiagram
    class FormSet {
        +ValidationCriteria rules
    }
    Design <|-- FormSet
    FormSet *-- "n" Form : required 
    FormSet *-- "n" Form : optional
    Design <|-- Biomarker
    Design <|-- Genetic Observation

    FormResponses --> "1" Form
```

## Repository Architecture

![Repository-Component-Diagram](images/structurizr-RepositoryContainers.svg)