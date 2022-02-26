workspace {
    model {


        enterprise "NACC" {
            authorizationSystem = softwareSystem "Authorization Service" "Authentication and Authorization to Access Systems"

            dataRepostorySystem = softwareSystem "NACC Data Repository" "Allows acquisition, management and queries of data sets" {
                dataWarehouse = container "Data Warehouse" "Subsystem for managing study data"
                formDefinitionDatabase = container "Form Definitions" "Database of form definitions and quality rules"
                studyDefinitionDatabase = container "Study Metadata" "Database of study meta-data"
                dataValidator = container "Data Validator" "API for validation of forms data" {
                    -> formDefinitionDatabase "Get form definitions" "JSON/HTTPS"
                    -> studyDefinitionDatabase "Get completenes criteria" "JSON/HTTPS"
                }
                imagePipeline = container "Image Pipeline" "Validates and transforms image headers" {
                    -> dataWarehouse
                }
                dataSubmissionAPI = container "Data Submission API" "API for submission of data" {
                    fileSubmissionController = component "(Non-form/Non-image) File Submission Controller" "Accept general file submissions"
                    formSubmissionController = component "Form Submission Controller" "Accept form submissions" {
                        -> dataValidator "form data to be validated aginst study rules" "JSON/HTTPS"
                        -> dataWarehouse "validated data" "JSON/HTTPS"
                    }
                    imageSubmissionController = component "Image Submission Controller" "Accept image submissions" {
                        -> imagePipeline
                    }
                }
                dataIndexing = container "Data Index" "Subsystem to support search across all data resources" "ElasticSearch" {
                    -> dataWarehouse
                }
                dataReporting = container "Reporting System" "Subsystem to generate reports about data" {
                    -> dataWarehouse
                }
            }

            directorySystem = softwareSystem "NACC Directory" "Directory of NACC, ADRC, and affiliated study staff with roles"

            communicationsSystem = softwareSystem "NACC Communications" "Subsystem to support external communications" {
                -> directorySystem
            }

            researchTrackingSystem = softwareSystem "Research Tracking" "Directory of research activity using NACC managed data"

            website = softwareSystem "Website" "NACC website serving as entry to NACC information and data resources" {
                accessRequestInterface = container "Access Request" "User access requests to change authorizations" {
                    -> authorizationSystem
                }
                directoryManagementInterface = container "Directory Management" "Single page interface for managing directory entries" {
                    -> directorySystem
                    -> authorizationSystem
                }
                submissionInterface = container "Data Submission" "Single page interface for submission of all types of data" {
                    -> dataSubmissionAPI
                }
                searchInterface = container "Data Search" "Single page interface for search across all types of data" {
                    -> dataIndexing
                }
                reportingInterface = container "Data Reporting" "Single page interface for reporting on data submissions" {
                    -> dataReporting
                }
                studyManagementInterface = container "Study Management" "Single page interface for managing studies within repository" {
                    -> directorySystem
                    -> studyDefinitionDatabase
                }
                formManagementInterface = container "Form Management" "Single page interface for managing form definitions and versions" {
                    -> formDefinitionDatabase
                }
                projectIntake = container "Project Intake" "Single page interface for requestin new projects/studies"
                researchTrackingInterface = container "Tracking Interface" "Interface for submitting publications using NACC managed data" {
                    -> researchTrackingSystem
                }
            }
            
        }

        externalUser = person "External User" "ADRC, NIA, or other external user" "External User"{
            -> website "Accesses website for information about NACC, data, and events"
        }
        adrcDataUser = person "ADRC Data User" "ADRC user uploading and managing data" "External User" {
            -> submissionInterface "Uploads data and corrects errors" "HTTPS"
        }
        adrcOpsUser = person "ADRC Admin User" "ADRC user responsible for administration tasks" "External User" {
            -> directoryManagementInterface "Adds/Removes members of ADRC" "HTTPS"
            -> reportingInterface "Views ADRC data and reports about submissions and errors" "HTTPS"
        }

        studyInvestigator = person "Study Investigator" "PI for external study" "External User" {
            -> projectIntake "Requests a new study or project" "REDCap"
        }
        studyAdmin = person "Study Manager" "Manages study meta data including forms and other collected data" "External User"{
            -> studyManagementInterface "Update study meta-data" "HTTPS"
        }
        formManager = person "Forms Manager" "Manages forms and form versions" "External User" {
            -> formManagementInterface "Modify form definitions and versions" "HTTPS"
        }

        researchUser = person "Researcher" "Research user of NACC managed data" "External User" {
            -> searchInterface "Search for data relevant to research project" "HTTPS"
            -> researchTrackingInterface "Report publication" "REDCap"
        }

        #externalDataCenterSystem = softwareSystem "<<stereotype>> Specialized Data Repository" "Represents linked repository of specialized data." "Existing System"
        adrcDataSystem = softwareSystem "ADRC Data System" "Data system of ADRC" "External System" {
            -> formSubmissionController "Submit forms data" "JSON/HTTPS"
        }
        group "Data Centers" {
            ncradSystem = softwareSystem "NCRAD" "Data systems of collaborating site" "External System" {
                -> fileSubmissionController "Genomic data for transfer to ADRCs" 
            }
            niagadsSystem = softwareSystem "NIAGADS" "Data systems of collaborating site" "External System" {
                -> fileSubmissionController "Genotype data for transfer to ADRCs"
            }
            loniSystem = softwareSystem "LONI" "LONI data system supporting SCAN project" "External System" {
                -> fileSubmissionController "Computed SCAN image metadata" 
            }
            dataReporting -> loniSystem "Request SCAN image status" "JSON/HTTPS"
        }

        atriSystem = softwareSystem "ATRI" "ATRI data system supporting LEADS project" "External System"
        dataReporting -> atriSystem "Request LEADS participants" "JSON/HTTPS"

        gaainSystem = softwareSystem "GAAIN" "GAAIN data system" "External System"
        dataRepostorySystem -> gaainSystem "UDS data?"
    }

    views {
        systemlandscape "SystemLandscape" {
            include *
            autoLayout
        }

        systemContext dataRepostorySystem "RepositoryContext" {
            include *
            autoLayout
        }

        container dataRepostorySystem "RepositoryContainers" {
            include *
            autoLayout
        }

        systemContext directorySystem "DirectoryContext" {
            include *
            autoLayout
        }

        container directorySystem "DirectoryContainers" {
            include *
            autoLayout
        }

        systemContext researchTrackingSystem "ResearchTrackingContext" {
            include *
            autoLayout
        }

        container researchTrackingSystem "ResearchTrackingContainers" {
            include *
            autoLayout
        }

        systemContext communicationsSystem "CommunicationsContext" {
            include *
            autoLayout
        }

        container communicationsSystem "CommunicationsContainers" {
            include *
            autoLayout
        }

        systemContext website "WebsiteContext" {
            include *
            autoLayout
        }

        container website "WebsiteContainers" {
            include *
            autoLayout
        }


        styles {
            element "Person" {
                color #ffffff
                fontSize 22
                shape Person
            }
            element "External User" {
                background #08427b
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "External System" {
                background #08427b
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Database" {
                shape Cylinder
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
        }
    }
}