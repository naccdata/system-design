workspace {
    model {
        authorizationSystem = softwareSystem "Authorization Service" "Authentication and Authorization to Access Systems" "External System"
    
        enterprise "NACC" {

            dataWarehouseSystem = softwareSystem "Data Warehouse" "Supports management and queries of data sets" {
                dataIndexing = container "Data Index" "Subsystem to support search across all data resources" "ElasticSearch"
                dataWarehouseAPI = container "Data Warehouse API" "API for data access" {
                    dataController = component "Data Access Controller" "Provide data requested for participants"                    
                    identifiersController = component "Identifier Mapping Controller" "Provide/provision identifiers for participants" 
                    indexingController = component "Data Indexing Controller" "Adds data to index for search"
                }
                metadataManagementSystem = container "Metadata Management" "Supports management of metadata for projects and organizations" {
                    formDefinitionDatabase = component "Form Definitions" "Database of form definitions and quality rules"
                    formManagementInterface = component "Form Management" "Single page interface for managing form definitions and versions" {
                        -> formDefinitionDatabase
                    }
                    projectDefinitionDatabase = component "Project Metadata" "Database of project meta-data"
                    projectIntake = component "Project Intake" "Single page interface for requestin new projects"                
                    projectManagementInterface = component "Project Management" "Single page interface for managing projects within repository" {
                        # -> directorySystem
                        -> projectDefinitionDatabase
                    }
                }
                searchInterface = container "Data Search" "Single page interface for search across all types of data" {
                    -> indexingController
                }
            }
            dataSubmissionSystem = softwareSystem "Submission System" "Supports acquisition of data sets" {
                formPipeline = container "Form Pipeline" "Receives and validates forms" {
                    validatedProject = component "<<stereotype>> Validated Form Store" "Stores validated forms ready for transfer into data warehouse" "REDCap"
                    formValidator = component "Form Data Validator" "Service for validation of forms data"
                    transferService = component "Form Transfer" "Transfers valid forms" {
                        -> formValidator "form data to be validated aginst project rules" "JSON/HTTPS"
                        -> validatedProject "validated data"
                    }                   
                    formQuarantineProject = component "<<stereotype>> Form Quarantine Project" "Accepts form submissions" "REDCap" {
                        -> transferService
                    }
                }
                imagePipeline = container "Image Pipeline" "Receives, validates and transforms image headers" {
                }
                filePipeline = container "File Pipeline" "Recieves, validates and transforms other data files" {
                }
                dataSubmissionAPI = container "Data Submission API" "API for data submission and access" {
                    fileSubmissionController = component "(Non-form/image) File Submission Controller" "Accept general file submissions" {
                        -> filePipeline
                    }
                    imageSubmissionController = component "Image Submission Controller" "Accept image submissions" {
                        -> imagePipeline
                    }
                    //no form controller because use REDCap
                }
                submissionApplication = container "Data Submission" "Single page interface for submission of all types of data" {
                    -> formQuarantineProject
                }
            }

            dataTransferSystem = softwareSystem "Transfer System" "Supports pushing/pulling data to collaborating centers/projects" {
                -> dataWarehouseAPI
            }
            reportingSystem = softwareSystem "Reporting System" "Supports generation and presentation of reports" {
                dataReporting = container "Reporting System" "Subsystem to generate reports about data" {
                    -> dataWarehouseAPI
                }
                reportingInterface = container "Data Reporting/Auditing" "Single page interface for reporting on/auditing of data submissions" {
                    -> dataReporting
                }
            }

            website = softwareSystem "Website" "NACC website serving as entry to NACC information and data resources" {
                accessRequestInterface = container "Access Request" "User Access requests to change authorizations" {
                    -> authorizationSystem
                }
                calculatorInterface = container "Calculators" "User access to calculators used in form completion"
                documentationInterface = container "Documentation Interface" "Provide access to form and center documentation"
                landingPage = container "Landing Page" "Landing page for website with routing to subsystems" {

                }
            }
        }
        externalUser = person "External User" "ADRC, NIA, or other external user" "External User"{
            -> website "Accesses website for information about NACC, data, and events"
        }

        researchCenterUser = person "Research Center User" "User at ADRC or other research center" "External User" {
            -> calculatorInterface "Use calculators for completing forms" "HTTPS"
            # -> directoryManagementInterface  "Adds/Removes Members Of Adrc" "HTTPS"
            -> documentationInterface "Get information about NACC resources" "HTTPS"
            -> reportingInterface "Views ADRC data and reports about submissions and errors" "HTTPS"
            -> submissionApplication "Uploads data and corrects errors" "HTTPS"
            # -> trainingInterface "Learn about using NACC resources" "HTTPS"
        }
        adrcDataUser = person "ADRC Data User" "ADRC user uploading and managing data" "External User" {
            -> submissionApplication "Uploads data and corrects errors" "HTTPS"
            -> calculatorInterface  "Use calculators for completing forms" "HTTPS"
            -> documentationInterface "Get information about NACC resources" "HTTPS"
            -> reportingInterface "Views ADRC data and reports about submissions and errors" "HTTPS"
            # -> trainingInterface "Learn about usng NACC resources" "HTTPS"
        }
        adrcOpsUser = person "ADRC Admin User" "ADRC user responsible for administration tasks" "External User" {
            # -> directoryManagementInterface "Adds/Removes Members Of Adrc" "HTTPS"
            -> reportingInterface "Views ADRC data and reports about submissions and errors" "HTTPS"
            # -> trainingInterface "Learn about usng NACC resources" "HTTPS"
        }
        adrcClinicalUser = person "ADRC Clinical User" "ADRC user responsible for data collection" "External User" {
            # -> trainingInterface "Learn about using forms" "HTTPS"
            -> calculatorInterface "Use calculators for completing forms" "HTTPS"
            -> documentationInterface "Get information about use of forms"  "HTTPS"
        }
        adrcLeader = person "ADRC Leader" "ADRC leadership member" "External User" {
            -> documentationInterface "Get information about ADRC use of NACC" "HTTPS"
            -> reportingInterface "Views ADRC data and reports about submissions and errors" "HTTPS"
            # -> trainingInterface "Learn about using NACC resources" "HTTPS"
        }

        projectUser = person "Project User" "Member of project" "External User" {
            -> projectIntake "Request new project" "REDCAP"
            -> projectManagementInterface "Update project meta-data" "HTTPS"
        }
        projectInstigatorUser = person "Project Instigator" "Initiates request for external project" "External User" {
            -> projectIntake "Requests a new project" "REDCap"
        }
        projectAdminUser = person "Project Coordinator" "Manages project meta data including forms and other collected data" "External User"{
            -> projectManagementInterface "Update project meta-data" "HTTPS"
        }
        formManagerUser = person "Forms Manager" "Manages forms and form versions" "External User" {
            -> formManagementInterface "Modify form definitions and versions" "HTTPS"
        }

        researchUser = person "Research User" "Research user of NACC managed data" "External User" {
            -> searchInterface "Search for data/resources relevant to query" "HTTPS"
            # -> publicationTrackingInterface "Submit publication" "REDCap"
            # -> duaInterface "Sign Data Use Agreement" "REDCap"
            # -> dataRequestInterface "Make and update customized requests; view history of requests" "HTTPS"
            # -> quickAccessInterface "Access to quick access data sets" "HTTPS"
        }

        externalDataCenterSystem = softwareSystem "<<stereotype>> External Data Center" "Represents linked repository of specialized data." "External System" {
            -> fileSubmissionController "Submit specialized data" "JSON/HTTPS"
            -> identifiersController "Request NACC ID for ADRC participant" "JSON/HTTPS"
            -> dataController "Request data for participant" "JSON/HTTPS"
        }
        dataReporting -> externalDataCenterSystem "Request data for reporting" "JSON/HTTPS"
        dataTransferSystem -> externalDataCenterSystem "Scheduled data transfer" "JSON/HTTPS"

        adrcDataSystem = softwareSystem "ADRC Data System" "Data system of ADRC" "External System" {
            -> formQuarantineProject "Submit forms data" "JSON/HTTPS"
            -> imageSubmissionController "Submit image data" "JSON/HTTPS"
            -> fileSubmissionController "Submit file data" "JSON/HTTPS"
        }
        centerDataSystem = softwareSystem "Research Center Data System" "Data system of research center participating in project" "External System" {
            -> formQuarantineProject "Submit forms data" "JSON/HTTPS"
            -> imageSubmissionController "Submit image data" "JSON/HTTPS"
            -> fileSubmissionController "Submit file data" "JSON/HTTPS"
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
                -> identifiersController "Request NACC ID for SCAN participant"
            }
            dataReporting -> loniSystem "Request SCAN image status" "JSON/HTTPS"
        }

        group "Project Centers" {
            atriSystem = softwareSystem "ATRI" "ATRI data system supporting LEADS project" "External System"
            dataReporting -> atriSystem "Request LEADS participants" "JSON/HTTPS"

            rushSystem = softwareSystem "Rush/DVCID" "Rush data system supporting DVCID project" "External System" {
                -> identifiersController "Request NACC ID for DVCID participant"
                -> dataController "Request UDS data for DVCID participant"
            }
            
        }

        gaainSystem = softwareSystem "GAAIN" "GAAIN data system" "External System"
        dataTransferSystem -> gaainSystem "UDS data?"

    }

    views {
        systemlandscape "GeneralizedSystemLandscape" {
            include *
            exclude adrcDataSystem
            exclude ncradSystem
            exclude niagadsSystem
            exclude loniSystem
            exclude atriSystem
            exclude rushSystem
            exclude gaainSystem
            exclude adrcClinicalUser
            exclude adrcDataUser
            exclude adrcLeader
            exclude adrcOpsUser
            exclude projectAdminUser
            exclude projectInstigatorUser
            exclude website
            exclude externalUser
            autoLayout
        }

        systemContext dataWarehouseSystem "WarehouseContext" {
            include *
            exclude adrcDataSystem
            exclude ncradSystem
            exclude niagadsSystem
            exclude loniSystem
            exclude atriSystem
            exclude rushSystem
            exclude gaainSystem
            exclude adrcClinicalUser
            exclude adrcDataUser
            exclude adrcLeader
            exclude adrcOpsUser
            exclude projectAdminUser
            exclude projectInstigatorUser
            exclude website
            exclude externalUser
            autoLayout 
        }

        container dataWarehouseSystem "WarehouseContainers" {
            include *
            exclude adrcDataSystem
            exclude ncradSystem
            exclude niagadsSystem
            exclude loniSystem
            exclude atriSystem
            exclude rushSystem
            exclude gaainSystem
            exclude adrcClinicalUser
            exclude adrcDataUser
            exclude adrcLeader
            exclude adrcOpsUser
            exclude projectAdminUser
            exclude projectInstigatorUser
            exclude website
            exclude externalUser
            autoLayout 
        }

        systemContext dataSubmissionSystem "SubmissionContext" {
            include *
            exclude adrcDataSystem
            exclude ncradSystem
            exclude niagadsSystem
            exclude loniSystem
            exclude atriSystem
            exclude rushSystem
            exclude gaainSystem
            exclude adrcClinicalUser
            exclude adrcDataUser
            exclude adrcLeader
            exclude adrcOpsUser
            exclude projectAdminUser
            exclude projectInstigatorUser
            exclude website
            exclude externalUser
            autoLayout 
        }

        container dataSubmissionSystem "SubmissionContainers" {
            include *
            exclude adrcDataSystem
            exclude ncradSystem
            exclude niagadsSystem
            exclude loniSystem
            exclude atriSystem
            exclude rushSystem
            exclude gaainSystem
            exclude adrcClinicalUser
            exclude adrcDataUser
            exclude adrcLeader
            exclude adrcOpsUser
            exclude projectAdminUser
            exclude projectInstigatorUser
            exclude website
            exclude externalUser
            autoLayout 
        }

        systemContext dataTransferSystem "TransferContext" {
            include *
            exclude adrcDataSystem
            exclude ncradSystem
            exclude niagadsSystem
            exclude loniSystem
            exclude atriSystem
            exclude rushSystem
            exclude gaainSystem
            exclude adrcClinicalUser
            exclude adrcDataUser
            exclude adrcLeader
            exclude adrcOpsUser
            exclude projectAdminUser
            exclude projectInstigatorUser
            exclude website
            exclude externalUser
            autoLayout 
        }

        container dataTransferSystem "TransferContainers" {
            include *
            exclude adrcDataSystem
            exclude ncradSystem
            exclude niagadsSystem
            exclude loniSystem
            exclude atriSystem
            exclude rushSystem
            exclude gaainSystem
            exclude adrcClinicalUser
            exclude adrcDataUser
            exclude adrcLeader
            exclude adrcOpsUser
            exclude projectAdminUser
            exclude projectInstigatorUser
            exclude website
            exclude externalUser
            autoLayout 
        }

        systemContext reportingSystem "ReportingContext" {
            include *
            exclude adrcDataSystem
            exclude ncradSystem
            exclude niagadsSystem
            exclude loniSystem
            exclude atriSystem
            exclude rushSystem
            exclude gaainSystem
            exclude adrcClinicalUser
            exclude adrcDataUser
            exclude adrcLeader
            exclude adrcOpsUser
            exclude projectAdminUser
            exclude projectInstigatorUser
            exclude website
            exclude externalUser
            autoLayout 
        }

        container dataTransferSystem "ReportingContainers" {
            include *
            exclude adrcDataSystem
            exclude ncradSystem
            exclude niagadsSystem
            exclude loniSystem
            exclude atriSystem
            exclude rushSystem
            exclude gaainSystem
            exclude adrcClinicalUser
            exclude adrcDataUser
            exclude adrcLeader
            exclude adrcOpsUser
            exclude projectAdminUser
            exclude projectInstigatorUser
            exclude website
            exclude externalUser
            autoLayout 
        }

        systemContext website "WebsiteContext" {
            include *
            exclude adrcDataSystem
            exclude ncradSystem
            exclude niagadsSystem
            exclude loniSystem
            exclude atriSystem
            exclude rushSystem
            exclude gaainSystem
            exclude adrcClinicalUser
            exclude adrcDataUser
            exclude adrcLeader
            exclude adrcOpsUser
            exclude projectAdminUser
            exclude projectInstigatorUser
            autoLayout 
        }

        container website "WebsiteContainers" {
            include *
            exclude adrcDataSystem
            exclude ncradSystem
            exclude niagadsSystem
            exclude loniSystem
            exclude atriSystem
            exclude rushSystem
            exclude gaainSystem
            exclude adrcClinicalUser
            exclude adrcDataUser
            exclude adrcLeader
            exclude adrcOpsUser
            exclude projectAdminUser
            exclude projectInstigatorUser
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