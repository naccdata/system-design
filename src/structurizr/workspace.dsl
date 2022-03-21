workspace {
    model {
        authorizationSystem = softwareSystem "Authorization Service" "Authentication and Authorization to Access Systems" "External System"

        enterprise "NACC" {
            directorySystem = softwareSystem "NACC Directory" "Directory of NACC, ADRC, and affiliated project staff with roles" {
                directoryManagementInterface = container "Directory Management" "Single page interface for managing directory entries" {
                    -> authorizationSystem
                }
            }

            dataRepostorySystem = softwareSystem "NACC Data Repository" "Allows acquisition, management and queries of data sets" {
                formManagementSystem = container "Form Management System" "Manages form definitions" {
                    formDefinitionDatabase = component "Form Definitions" "Database of form definitions and quality rules"
                    formManagementInterface = component "Form Management" "Single page interface for managing form definitions and versions" {
                        -> formDefinitionDatabase
                    } 
                }
                projectManagementSystem = container "Project Management System" "Manage project definitions" {
                    projectDefinitionDatabase = component "Project Metadata" "Database of project meta-data"
                    projectIntake = component "Project Intake" "Single page interface for requestin new projects"                
                    projectManagementInterface = component "Project Management" "Single page interface for managing projects within repository" {
                        -> directorySystem
                        -> projectDefinitionDatabase
                    }
                }
                dataWarehouse = container "Data Warehouse" "Subsystem for managing project data"
                dataValidator = container "Data Validator" "API for validation of forms data" {
                    formVariableIndex = component "Form Definition Index" "Index of form definitions in the validator" {
                        -> formDefinitionDatabase "Get form definitions" "JSON/HTTPS"
                    }
                    projectDefinitionIndex = component "Index of Project Definitions" "Index of project metadata for validation" {
                        -> projectDefinitionDatabase "Get completenes criteria" "JSON/HTTPS"
                    }
                    validateController = component "Validation Controller" "Accepts forms for validation" {
                        -> formVariableIndex "look up constraints on variables"
                        -> projectDefinitionIndex "look up completeness criteria"
                    }
                }
                imagePipeline = container "Image Pipeline" "Validates and transforms image headers" {
                    -> dataWarehouse
                }
                dataWarehouseAPI = container "Data Warehouse API" "API for data submission and access" {
                    fileSubmissionController = component "(Non-form/Non-image) File Submission Controller" "Accept general file submissions"
                    formSubmissionController = component "Form Submission Controller" "Accept form submissions" {
                        -> dataValidator "form data to be validated aginst project rules" "JSON/HTTPS"
                        -> dataWarehouse "validated data" "JSON/HTTPS"
                    }
                    imageSubmissionController = component "Image Submission Controller" "Accept image submissions" {
                        -> imagePipeline
                    }
                    identifiersController = component "Identifier Mapping Controller" "Provide/provision identifiers for participants"
                    dataController = component "Data Access Controller" "Provide data requested for participants"
                }
                submissionInterface = container "Data Submission" "Single page interface for submission of all types of data" {
                    -> dataWarehouseAPI
                }

                searchSystem =  container "Search System" "Supports search across NACC and data from other sites" {
                    dataIndexing = component "Data Index" "Subsystem to support search across all data resources" "ElasticSearch" {
                        -> dataWarehouse
                    }
                    searchInterface = component "Data Search" "Single page interface for search across all types of data" {
                        -> dataIndexing
                    }
                }

                reportingSystem = container "Reporting System" "Supports generation and presentation of reports" {
                    dataReporting = component "Reporting System" "Subsystem to generate reports about data" {
                        -> dataWarehouse
                    }
                    reportingInterface = component "Data Reporting/Auditing" "Single page interface for reporting on/auditing of data submissions" {
                        -> dataReporting
                    }
                }
            }

            communicationsSystem = softwareSystem "NACC Communications" "Subsystem to support external communications" {
                -> directorySystem
            }

            researchTrackingSystem = softwareSystem "Research Tracking" "Directory of research activity using NACC managed data" {
                requestDatabase = container "Data Request Database" "Stores history of data requests"
                dataRequestInterface = container "Data Request Interface" "Interface to make and view custom data requests" {
                    -> requestDatabase "Update/get request history"
                }    
                quickAccessInterface = container "Quick Access Interface" "Provides access to quick access data sets" {
                    -> requestDatabase "Update request history"
                }            
                publicationDatabase = container "Publication Database" "Stores publication history"
                publicationTrackingInterface = container "Tracking Interface" "Interface for submitting publications using NACC managed data" {
                    -> publicationDatabase
                }
                duaInterface = container "DUA Approval Interface" "Sign DUA" {
                    -> authorizationSystem 
                }
            }

            trainingSystem = softwareSystem "Training System" "Learning management system providing training materials" {
                trainingInterface = container "Training Interface" "Provide access to training about forms and NACC systems"
            }

            website = softwareSystem "Website" "NACC website serving as entry to NACC information and data resources" {
                accessRequestInterface = container "Access Request" "User access requests to change authorizations" {
                    -> authorizationSystem
                }
                calculatorInterface = container "Calculators" "User access to calculators used in form completion"
                documentationInterface = container "Documentation Interface" "Provide access to form and center documentation"
                landingPage = container "Landing Page" "Landing page for website with routing to subsystems" {
                    -> accessRequestInterface
                    -> authorizationSystem
                    -> calculatorInterface
                    -> documentationInterface
                    -> trainingInterface
                    -> dataRequestInterface
                    -> quickAccessInterface
                    -> publicationTrackingInterface
                    -> duaInterface
                    -> reportingInterface 
                    -> searchInterface
                    -> submissionInterface
                    -> projectManagementInterface
                    -> formManagementInterface
                    -> directoryManagementInterface
                }
            }
        }

        externalUser = person "External User" "ADRC, NIA, or other external user" "External User"{
            -> website "Accesses website for information about NACC, data, and events"
        }

        researchCenterUser = person "Research Center User" "User at ADRC or other research center" "External User" {
            -> calculatorInterface "Use calculators for completing forms" "HTTPS"
            -> directoryManagementInterface  "Adds/Removes Members Of Adrc" "HTTPS"
            -> documentationInterface "Get information about NACC resources" "HTTPS"
            -> reportingInterface "Views ADRC data and reports about submissions and errors" "HTTPS"
            -> submissionInterface "Uploads data and corrects errors" "HTTPS"
            -> trainingInterface "Learn about using NACC resources" "HTTPS"
        }
        adrcDataUser = person "ADRC Data User" "ADRC user uploading and managing data" "External User" {
            -> submissionInterface "Uploads data and corrects errors" "HTTPS"
            -> calculatorInterface  "Use calculators for completing forms" "HTTPS"
            -> documentationInterface "Get information about NACC resources" "HTTPS"
            -> reportingInterface "Views ADRC data and reports about submissions and errors" "HTTPS"
            -> trainingInterface "Learn about usng NACC resources" "HTTPS"
        }
        adrcOpsUser = person "ADRC Admin User" "ADRC user responsible for administration tasks" "External User" {
            -> directoryManagementInterface "Adds/Removes Members Of Adrc" "HTTPS"
            -> reportingInterface "Views ADRC data and reports about submissions and errors" "HTTPS"
            -> trainingInterface "Learn about usng NACC resources" "HTTPS"
        }
        adrcClinicalUser = person "ADRC Clinical User" "ADRC user responsible for data collection" "External User" {
            -> trainingInterface "Learn about using forms" "HTTPS"
            -> calculatorInterface "Use calculators for completing forms" "HTTPS"
            -> documentationInterface "Get information about use of forms"  "HTTPS"
        }
        adrcLeader = person "ADRC Leader" "ADRC leadership member" "External User" {
            -> documentationInterface "Get information about ADRC use of NACC" "HTTPS"
            -> reportingInterface "Views ADRC data and reports about submissions and errors" "HTTPS"
            -> trainingInterface "Learn about using NACC resources" "HTTPS"
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

        researchUser = person "Researcher" "Research user of NACC managed data" "External User" {
            -> searchInterface "Search for data/resources relevant to query" "HTTPS"
            -> publicationTrackingInterface "Submit publication" "REDCap"
            -> duaInterface "Sign Data Use Agreement" "REDCap"
            -> dataRequestInterface "Make and update customized requests; view history of requests" "HTTPS"
            -> quickAccessInterface "Access to quick access data sets" "HTTPS"
        }

        externalDataCenterSystem = softwareSystem "<<stereotype>> External Data Center" "Represents linked repository of specialized data." "External System" {
            -> fileSubmissionController "Submit specialized data" "JSON/HTTPS"
            -> identifiersController "Request NACC ID for ADRC participant" "JSON/HTTPS"
            -> dataController "Request data for participant" "JSON/HTTPS"
        }
        dataReporting -> externalDataCenterSystem "Request data for reporting" "JSON/HTTPS"
        dataRepostorySystem -> externalDataCenterSystem "Scheduled data transfer" "JSON/HTTPS"

        adrcDataSystem = softwareSystem "ADRC Data System" "Data system of ADRC" "External System" {
            -> formSubmissionController "Submit forms data" "JSON/HTTPS"
            -> imageSubmissionController "Submit image data" "JSON/HTTPS"
            -> fileSubmissionController "Submit file data" "JSON/HTTPS"
        }
        centerDataSystem = softwareSystem "Research Center Data System" "Data system of research center participating in project" "External System" {
            -> formSubmissionController "Submit forms data" "JSON/HTTPS"
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
        dataRepostorySystem -> gaainSystem "UDS data?"
    }

    views {
        systemlandscape "SystemLandscape" {
            include *
            exclude externalDataCenterSystem
            exclude researchCenterUser
            exclude projectUser
            autoLayout
        }

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
            autoLayout
        }

        systemContext dataRepostorySystem "RepositoryContext" {
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

        container dataRepostorySystem "RepositoryContainers" {
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