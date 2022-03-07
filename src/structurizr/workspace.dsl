workspace {
    model {


        enterprise "NACC" {
            authorizationSystem = softwareSystem "Authorization Service" "Authentication and Authorization to Access Systems"

            dataRepostorySystem = softwareSystem "NACC Data Repository" "Allows acquisition, management and queries of data sets" {
                dataWarehouse = container "Data Warehouse" "Subsystem for managing study data"
                formDefinitionDatabase = container "Form Definitions" "Database of form definitions and quality rules"
                studyDefinitionDatabase = container "Study Metadata" "Database of study meta-data"
                dataValidator = container "Data Validator" "API for validation of forms data" {
                    formVariableIndex = component "Form Definition Index" "Index of form definitions in the validator" {
                        -> formDefinitionDatabase "Get form definitions" "JSON/HTTPS"
                    }
                    studyDefinitionIndex = component "Index of Study Definitions" "Index of study metadata for validation" {
                        -> studyDefinitionDatabase "Get completenes criteria" "JSON/HTTPS"
                    }
                    validateController = component "Validation Controller" "Accepts forms for validation" {
                        -> formVariableIndex "look up constraints on variables"
                        -> studyDefinitionIndex "look up completeness criteria"
                    }
                }
                imagePipeline = container "Image Pipeline" "Validates and transforms image headers" {
                    -> dataWarehouse
                }
                dataWarehouseAPI = container "Data Warehouse API" "API for data submission and access" {
                    fileSubmissionController = component "(Non-form/Non-image) File Submission Controller" "Accept general file submissions"
                    formSubmissionController = component "Form Submission Controller" "Accept form submissions" {
                        -> dataValidator "form data to be validated aginst study rules" "JSON/HTTPS"
                        -> dataWarehouse "validated data" "JSON/HTTPS"
                    }
                    imageSubmissionController = component "Image Submission Controller" "Accept image submissions" {
                        -> imagePipeline
                    }
                    identifiersController = component "Identifier Mapping Controller" "Provide/provision identifiers for participants"
                    dataController = component "Data Access Controller" "Provide data requested for participants"
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

            researchTrackingSystem = softwareSystem "Research Tracking" "Directory of research activity using NACC managed data" {
                requestDatabase = container "Data Request Database" "Stores history of data requests"
                publicationDatabase = container "Publication Database" "Stores publication history"
            }

            website = softwareSystem "Website" "NACC website serving as entry to NACC information and data resources" {
                accessRequestInterface = container "Access Request" "User access requests to change authorizations" {
                    -> authorizationSystem
                }
                calculatorInterface = container "Calculators" "User access to calculators used in form completion"
                directoryManagementInterface = container "Directory Management" "Single page interface for managing directory entries" {
                    -> directorySystem
                    -> authorizationSystem
                }
                submissionInterface = container "Data Submission" "Single page interface for submission of all types of data" {
                    -> dataWarehouseAPI
                }
                searchInterface = container "Data Search" "Single page interface for search across all types of data" {
                    -> dataIndexing
                }
                reportingInterface = container "Data Reporting/Auditing" "Single page interface for reporting on/auditing of data submissions" {
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
                publicationTrackingInterface = container "Tracking Interface" "Interface for submitting publications using NACC managed data" {
                    -> publicationDatabase
                }
                duaInterface = container "DUA Approval Interface" "Sign DUA" {
                    -> authorizationSystem 
                }
                dataRequestInterface = container "Data Request Interface" "Interface to make and view custom data requests" {
                    -> requestDatabase "Update/get request history"
                }
                quickAccessInterface = container "Quick Access Interface" "Provides access to quick access data sets" {
                    -> requestDatabase "Update request history"
                }
                trainingInterface = container "Training Interface" "Provide access to training about forms and NACC systems"
                documentationInterface = container "Documentation Interface" "Provide access to form and center documentation"
            }
            
        }

        externalUser = person "External User" "ADRC, NIA, or other external user" "External User"{
            -> website "Accesses website for information about NACC, data, and events"
        }

        adrcDataUser = person "ADRC Data User" "ADRC user uploading and managing data" "External User" {
            -> submissionInterface "Uploads data and corrects errors" "HTTPS"
            -> calculatorInterface
            -> documentationInterface
            -> reportingInterface
        }
        adrcOpsUser = person "ADRC Admin User" "ADRC user responsible for administration tasks" "External User" {
            -> directoryManagementInterface "Adds/Removes members of ADRC" "HTTPS"
            -> reportingInterface "Views ADRC data and reports about submissions and errors" "HTTPS"
        }
        adrcClinicalUser = person "ADRC Clinical User" "ADRC user responsible for data collection" "External User" {
            -> trainingInterface "Learn about using forms"
            -> calculatorInterface
            -> documentationInterface
        }
        adrcLeader = person "ADRC Leader" "ADRC leadership member" "External User" {
            -> reportingInterface
        }

        studyInstigator = person "Study Instigator" "Initiates request for external study" "External User" {
            -> projectIntake "Requests a new study or project" "REDCap"
        }
        studyAdmin = person "Study Coordinator" "Manages study meta data including forms and other collected data" "External User"{
            -> studyManagementInterface "Update study meta-data" "HTTPS"
        }
        formManager = person "Forms Manager" "Manages forms and form versions" "External User" {
            -> formManagementInterface "Modify form definitions and versions" "HTTPS"
        }

        researchUser = person "Researcher" "Research user of NACC managed data" "External User" {
            -> searchInterface "Search for data/resources relevant to query" "HTTPS"
            -> publicationTrackingInterface "Submit publication" "REDCap"
            -> duaInterface "Sign Data Use Agreement" "REDCap"
            -> dataRequestInterface "Make and update customized requests; view history of requests" "HTTPS"
            -> quickAccessInterface "Access to quick access data sets" "HTTPS"
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
                -> identifiersController "Request NACC ID for SCAN participant"
            }
            dataReporting -> loniSystem "Request SCAN image status" "JSON/HTTPS"
        }

        group "Study Centers" {
            atriSystem = softwareSystem "ATRI" "ATRI data system supporting LEADS project" "External System"
            dataReporting -> atriSystem "Request LEADS participants" "JSON/HTTPS"

            rushSystem = softwareSystem "Rush/DVCID" "Rush data system supporting DVCID project" "External System" {
                -> identifiersController "Request NACC ID for DVCID participant"
                -> dataController "Request UDS data for DVCID participant"
            }
            
        }

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

        component dataValidator "ValidatorComponent" {
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