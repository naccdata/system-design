# NACC System Architecture Documentation

This set of documents describes a model of the planned software systems supporting the National Alzheimer's Coordinating Center (NACC).

## Documents

1. [NACC System](01-nacc-system.md) – 
   describes the NACC software system and the landscape in which it exists.
   It is meant for a general audience.

2. [Domain Model](02-domain-model.md) -
   describes a model of the objects and relationships that are relevant in the context of NACC.
   This document uses UML class diagram notation, but should be accessible to most readers.

3. Subsystems - the initial sections of these documents are meant to be accessible to a general audience, but most of the content is meant for a technical audience.
   1. [NACC Data Repository](03-data-repository.md) -
      describes a model of the data repository subsystem.

   2. [NACC Directory](04-directory.md) –
       describes a model of the system for tracking NACC-affiliated organizations and memberships needed in NACC operations and communication.

   3. [Research Tracking](05-research-tracking.md) -
      describes the subsystem for tracking research using NACC-managed data.

   4. [Communications](06-communications.md) –
      describes the subsystem for NACC communications

4. [Architectural Decisions](14-decision-log.md) -

## Document Access

These documents are managed on the UW Enterprise GitHub in the [naccdata](https://github.com/naccdata) organization.
They are deployed to the web using GitHub Pages and are only accessible to members of the naccdata organization.

## Document Maintenance

Information about maintaining these documents is given in the [README](https://github.com/naccdata/system-design/blob/main/README.md) of the [naccdata/system-design](https://github.com/naccdata/system-design) repository.

