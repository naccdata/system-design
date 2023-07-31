workspace {
    model {
        authorizationSystem = softwareSystem "Authorization Service" "Authentication and Authorization to Access Systems" "External System"


    
        enterprise "NACC" {

            dataWarehouseSystem = softwareSystem "Data Warehouse" "Supports management and queries of data sets" {


                group "Flywheel" {
                    dataPipeline = container "<<Stereotype>> Project Pipeline" "Pipeline for QC, harmonization of project data" {
                        // see dataSubmissionSystem
                        group "Data Pipeline" {
                            ingestProject = component "<<Stereotype>> Site Ingest" "Collection of quarantined data" "FW Group"
                            acceptedProject = component "<<Stereotype>> Site Persistent" "Collection of data that has past QC and released by center" "FW Group"
                        }
                    }                
                    dataReleasePipeline = container "Data Release Pipeline" "Pipeline for data release" {
                        dataReleaseProject = component "Master Project" "Collection of frozen data for release to researchers" "FW Group"
                        dataAggregator = component "Data Aggregator" "Aggregates project data across centers" "FW Gear" {
                            -> dataReleaseProject
                        }
                        acceptedProject -> dataAggregator "Pull project data"

                        // TODO: data needs to be pushed to leaf or data request bucket
                        dataReleaseView = component "Data Release View" "Data view for release data" "FW View(s)"
                        buildAndExportViews = component "Build & Export Release Views" "Builds data views for data releases" "Python/FW Gear" {
                            -> dataReleaseView "create data view"
                        }

                    }

                    dataWarehouseAPI = container "Data Warehouse API" "API for data access" "FW" {
                        -> ingestProject
                        -> acceptedProject
                        -> dataReleaseProject
                    }
                }

                participantManagement = container "Participant Management" "Manages participant identifiers and center access" {
                    identifiersController = component "Identifier Mapping Controller" "Provide/provision identifiers for participants" 
                }




            }

            userManangementSystem = softwareSystem "User Management" "Allows centers or projects to manage their own users and access rights" {
                directory = container "NACC Directory" "Allows users to view and edit the NACC directory" "REDCap" {
                    directoryInterface = component "Directory Management Interface" "Interface to manage directory entries" "REDCap"
                    directoryAPI = component "Directory API" "API for accessing NACC directory information" "JSON/HTTPS"
                }

                userManagementSynchonizer = container "User Management Synchronizer" "Synchronizes user accounts with NACC Directory" "FW Gear" {
                    -> directoryAPI "User information" "JSON/HTTPS"
                    -> dataWarehouseAPI "Create/Retire users"
                }
            }

            projectManagementSystem = softwareSystem "Project Management" "Supports the management of projects within NACC systems" {
                projectIntakeSystem = container "Project Intake" "Supports intake of project information" {
                    projectIntakeInterface = component "Project Intake" "Interface for requesting new projects"  "REDCap"
                    projectIntakeAPI = component "Project API" "Interface for access project intake requests"
                }

                projectManagementSynchronizer = container "Project Management Sync" "Synchronizes project definitions and user authorization" "FW Gear" {
                    -> directoryAPI "Center information" "JSON/HTTPS"
                    -> projectIntakeAPI "Project details" "JSON/HTTPS"
                    -> dataWarehouseAPI "Create/update projects"
                }

                formManagementSystem = container "Form Management" "Supports management of metadata for projects and organizations" {
                    formDefinitionDatabase = component "Form Definitions" "Database of form definitions and quality rules"
                    formManagementInterface = component "Form Management" "Single page interface for managing form definitions and versions" {
                        -> formDefinitionDatabase
                    }
                }
            }

            dataSubmissionSystem = softwareSystem "Submission System" "Supports acquisition of data sets" {
                // Form pipeline
                group "Form pipeline" {
                    formValidator = container "Form Data Validator" "Service for validation of forms data" "Python/FW Gear" {
                        -> dataWarehouseAPI "Record errors in forms in ingest project" "JSON"
                        -> formDefinitionDatabase "form definitions" "JSON/YAML"
                    }
                    formQuarantineProject = container "<<stereotype>> Form Quarantine Project" "Accepts form submissions" "REDCap Project" {
                        formEntryInterface = component "Form Entry Interface" "Interface for direct entry of data" "REDCap"
                        formQuarantineAPI = component "Form API" "API for submission of form data" "CSV/HTTPS"
                    }
                    transferService = container "Form Transfer" "Transfers valid forms" "Python" {
                        -> formQuarantineProject "pull form data from quarantine" "CSV/HTTPS"
                        -> formValidator "form data to be validated against project rules" "JSON/HTTPS"
                        -> dataWarehouseAPI "push validated data to ingest project" "JSON/HTTPS"
                    }                   
                    redcapTransferService = container "REDCap Transfer" "Transfers form data from center REDCap instance" "Python" {
                        -> formQuarantineProject "push center data to quarantine project" "JSON/HTTPS"
                    }
                    fileUploadService = container "File Uploader" "Accepts uploaded data and pushes to quarantine project" "Javascript" {
                        -> formQuarantineProject "push data to quarantine proect" "JSON/HTTPS"
                    }
                }

                // DICOM Image pipeline
                dicomImagePipeline = container "Image Pipeline" "Receives, validates and transforms image headers" {
                }

                // File pipeline
                filePipeline = container "File Pipeline" "Recieves, validates and transforms other data files" {
                }

                dataSubmissionAPI = container "Data Submission API" "API for data submission and access" {
                    fileSubmissionController = component "(Non-form/image) File Submission Controller" "Accept general file submissions" {
                        -> filePipeline
                    }
                    dicomImageSubmissionController = component "Image Submission Controller" "Accept image submissions" {
                        -> dicomImagePipeline
                    }
                    //no form controller because use REDCap
                }

                submissionApplication = container "Data Submission" "Single page interface for submission of all types of data" "Next.js" {
                    -> redcapTransferService "Initiate form data transfer" "JSON/HTTPS"
                    -> formQuarantineProject "Route to REDCap UI" "HTTPS"
                    -> fileUploadService "Initiate upload process" "JSON/HTTPS"

                    -> ingestProject "Retrieve submission errors" "JSON/HTTPS"
                }
                submissionWebApplication = container "Submission Web App" "Delivers submission application to user" "nginx" {
                    -> submissionApplication "Delivers app to user's browser"
                }                
            }

            dataTransferSystem = softwareSystem "Transfer System" "Supports pushing/pulling data to collaborating centers/projects" {
                bucketIngestor = container "Data Ingestor" "Pulls structured data from AWS bucket and places in appropriate project" "Python/FW Gear" {
                    -> dataWarehouseAPI
                }
                ingestBucket = container "Ingest Bucket" "S3 bucket for ingest of data from external data centers" "AWS S3" {
                    -> bucketIngestor
                }
                dataPuller = container "<<Stereotype>> Data Puller" "Service to pull data from external data center" "Python/FW Gear" {
                    -> dataWarehouseAPI
                }
                dataPusher = container "<<Stereotype>> Data Pusher" "Service to push data to external data center" "Python/FW Gear" {
                    -> dataWarehouseAPI
                }
            }

            reportingSystem = softwareSystem "Reporting System" "Supports generation and presentation of reports" {
                dataReporting = container "Reporting System" "Subsystem to generate reports about data" {
                    -> dataWarehouseAPI
                }
                reportingInterface = container "Data Reporting/Auditing" "Single page interface for reporting on/auditing of data submissions" {
                    -> dataReporting
                }
            }

            sharingSystem = softwareSystem "Data Sharing System" "Supports access to data" {
                searchInterface = container "Data Search" "Single page interface for search across all types of data" {
                    //TODO: this is wrong
                    -> dataWarehouseAPI
                }

                dataRequentIntake = container "Data Request Intake" "Supports requests of project data" {
                    dataRequestInterface = component "Data Request Interface" "Interface for requesting data" "REDCap"
                    dataRequestAPI = component "Data Request API" "API for accessing data request information" "JSON/HTTPS"
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

        //Users are split by role with the first user being a generalization of roles
        externalUser = person "External User" "ADRC, NIA, or other external user" "External User"{
            -> website "Accesses website for information about NACC, data, and events"
        }

        //Research Centers/ADRCs - users at centers collecting data
        researchCenterUser = person "Research Center User" "User at ADRC or other research center" "External User" {
            -> calculatorInterface "Use calculators for completing forms" "HTTPS"
            -> directoryInterface  "Adds/Removes Members Of Adrc" "HTTPS"
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
            -> directoryInterface "Adds/Removes Members Of Adrc" "HTTPS"
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

        // Project users -- users within groups running research projects
        projectUser = person "Project User" "Member of project" "External User" {
            -> projectIntakeInterface "Request new project" "REDCAP"
        }
        projectInstigatorUser = person "Project Instigator" "Initiates request for external project" "External User" {
            -> projectIntakeInterface "Requests a new project" "REDCap"
        }
        projectAdminUser = person "Project Coordinator" "Manages project meta data including forms and other collected data" "External User"{
            
        }
        formManagerUser = person "Forms Manager" "Manages forms and form versions" "External User" {
            -> formManagementInterface "Modify form definitions and versions" "HTTPS"
        }

        researchUser = person "Research User" "Research user of NACC managed data" "External User" {
            -> searchInterface "Search for data/resources relevant to query" "HTTPS"
            # -> publicationTrackingInterface "Submit publication" "REDCap"
            # -> duaInterface "Sign Data Use Agreement" "REDCap"
            -> dataRequestInterface "Make and update customized requests; view history of requests" "HTTPS"
            # -> quickAccessInterface "Access to quick access data sets" "HTTPS"
        }

        externalDataCenterSystem = softwareSystem "<<stereotype>> External Data Center" "Represents linked repository of specialized data." "External System" {
            -> identifiersController "Request NACC ID for ADRC participant" "JSON/HTTPS"
            -> dataWarehouseAPI "Request data for participant" "JSON/HTTPS"
            -> ingestBucket "Push data to NACC" "JSON/HTTPS"
        }
        dataPuller -> externalDataCenterSystem "Pull data" "JSON/HTTPS"
        dataPusher -> externalDataCenterSystem "Push data" "JSON/HTTPS"

        adrcDataSystem = softwareSystem "ADRC Data System" "Data system of ADRC" "External System" {
            -> formQuarantineProject "Submit forms data" "JSON/HTTPS"
            -> dicomImageSubmissionController "Submit image data" "JSON/HTTPS"
            -> fileSubmissionController "Submit file data" "JSON/HTTPS"
        }
        redcapTransferService -> adrcDataSystem "Pull project form data" "JSON/HTTPS"
        centerDataSystem = softwareSystem "Research Center Data System" "Data system of research center participating in project" "External System" {
            -> formQuarantineProject "Submit forms data" "JSON/HTTPS"
            -> dicomImageSubmissionController "Submit image data" "JSON/HTTPS"
            -> fileSubmissionController "Submit file data" "JSON/HTTPS"
        }
        redcapTransferService -> centerDataSystem "Pull project form data" "JSON/HTTPS"     

        group "Data Centers" {
            ncradSystem = softwareSystem "NCRAD" "Data systems of collaborating site" "External System" {
                -> dataTransferSystem "Genomic data for transfer to ADRCs" 
            }
            niagadsSystem = softwareSystem "NIAGADS" "Data systems of collaborating site" "External System" {
                -> dataTransferSystem "Genotype data for transfer to ADRCs"
            }
            loniSystem = softwareSystem "LONI" "LONI data system supporting SCAN project" "External System" {
                -> dataTransferSystem "Computed SCAN image metadata" 
                -> identifiersController "Request NACC ID for SCAN participant"
            }
            dataReporting -> loniSystem "Request SCAN image status" "JSON/HTTPS"
        }

        group "Project Centers" {
            atriSystem = softwareSystem "ATRI" "ATRI data system supporting LEADS project" "External System"
            dataTransferSystem -> atriSystem "Request LEADS participants" "JSON/HTTPS"

            rushSystem = softwareSystem "Rush/DVCID" "Rush data system supporting DVCID project" "External System" {
                -> identifiersController "Request NACC ID for DVCID participant"
                -> dataWarehouseAPI "Request UDS data for DVCID participant"
            }
            
        }

        gaainSystem = softwareSystem "GAAIN" "GAAIN data system" "External System"
        dataTransferSystem -> gaainSystem "UDS data?"

        # deploymentEnvironment "Production" {
        #     deploymentNode "User's Computer" "" "MS Windows, Apple MacOS, Linux" {
        #         deploymentNode "Web Browser" "" "Chrome, Firefox, Safari or Edge" {
        #             submissionApplicationInstance = containerInstance submissionApplication 
        #         }
        #     }
        #     deploymentNode "redcap.naccdata.org" "" "RIT Redhat VM" {
        #         deploymentNode "NACC REDCap" "" "REDCap" {
        #             formQuarantineInstance = containerInstance formQuarantineProject
        #             validatedFormInstance = containerInstance validatedProject
        #         }
        #     }
        #     deploymentNode "VM" "" "Cloud VM or RIT Redhat VM" {
        #         deploymentNode "Docker Container - Submission App" "" "Docker" {
        #             submissionWebApplicationInstance = containerInstance submissionWebApplication
        #         }
        #         deploymentNode "Docker Container - Form Transfer Service" "" "Docker" {
        #             transferServiceInstance = containerInstance transferService
        #         }
        #         deploymentNode "Docker Container - Form Validator Service" "" "Docker" {
        #             formValidatorInstance = containerInstance formValidator
        #         }
        #         deploymentNode "Docker Container - Data Submission API" "" "Docker" {
        #             deploymentNode "web server" "" "web server" {
        #                 dataSubmissionAPIInstance = containerInstance dataSubmissionAPI
        #             }
        #         }
        #         deploymentNode "Docker Container - Error Database" "" "Docker" {
        #             errorDatabaseInstance = containerInstance errorDatabase
        #         }
        #     }

        # }
    }

    views {
        systemlandscape "GeneralizedSystemLandscape" {
            include *
            exclude authorizationSystem
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

        systemlandscape "SystemLandscape" {
            include *
            exclude externalDataCenterSystem
            exclude researchCenterUser
            exclude projectUser
            autoLayout
        }

        systemContext projectManagementSystem "ProjectManagementContext" {
            include *
            exclude projectInstigatorUser
            autoLayout
        }

        container projectManagementSystem "ProjectManagementContainers" {
            include *
            exclude projectInstigatorUser
            autoLayout
        }

        systemContext userManangementSystem "UserManagementContext" {
            include *
            exclude adrcOpsUser
            autoLayout
        }

        container userManangementSystem "UserManagementContainers" {
            include *
            exclude adrcOpsUser
            exclude projectManagementSystem
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

        # deployment dataSubmissionSystem "Production" "ProductionSubmissionDeployment" {
        #     include *
        #     autoLayout
        # }

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

        container reportingSystem "ReportingContainers" {
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