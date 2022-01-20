workspace {
    # attach markdown documentation from docs directory
    #!docs docs/architecture
    #
    #!adrs docs/decisions

    model {
        externalUser = person "External User" "ADRC, NIA, or other external user" "External User"
        adrcDataUser = person "ADRC Data User" "ADRC user uploading and managing data" "External User"
        adrcAdminUser = person "ADRC Admin User" "ADRC user responsible for administration tasks" "External User"
        researchUser = person "Research User" "User accessing NACC data for research" "External User"

        enterprise "NACC" {
            adminUser = person "Center Ops Specialist" "Administers center operations" "NACC Staff"
            commsUser = person "Communication Specialist" "Manages external center communications" "NACC Staff"
            formsUser = person "Forms Specialist" "Creates and manages data aquisition instruments" "NACC Staff"
            querySpecialist = person "Data Query Specialist" "Performs complex queries requiring detailed knowledge" "NACC Staff"
            # supportUser = person "Support Specialist"


            naccDataRepositorySystem = softwareSystem "Data Repository System" "Allows acquisition, management and queries of data sets" {
                # container takes name, description, technology, tags
                webPortal = container "Web Portal" "Investigator interface to center tools" "Next.js"
                api = container "API"
                uploadAPI = container "Upload API"
                validator = container "Validator" "Validates forms"
                rds = container "UDS Database" "stores UDS data" "mysql" "Database"
                objectStore = container "Object Store"
                leaf = container "Leaf" "Supports self service queries over repository data sets" "Existing System"
                redcap = container "REDCap" "Supports entry and upload of survey responses" "Existing System"
                internalSpecializedDataRepository = container "<<stereotype>> Specialized Data Repository" "Represents linked internal repository of specialized data."

                api -> rds "Uses"
                api -> internalSpecializedDataRepository "Uses"

                webPortal -> uploadAPI "upload form data"
                uploadAPI -> validator "check visit"
                uploadAPI -> redcap "upload visit"

                validator -> rds "pulls historical data"


                webPortal -> api "Calls"
                webPortal -> objectStore "Uses"
            }

            naccCommunicationsSystem = softwareSystem "Communications System" "Supports marketing and communication" {
                webSite = container "Web Site"
                customerRelationshipManagement = container "CRM System" "Supports external communication"
            }

            naccAdministrativeSystem = softwareSystem "Center Administration System" "Supports managing center users and authorization, and reporting" {
                authorizationManager = container "Authorization Manager"
                personnelDirectory = container "Personnel Directory System" "Manages directory of NACC, ADRC and unaffiliated staff and researchers" "Existing System"
                reportingSystem = container "Center Report Generation"
            }

            # 

        }

        authSystem = softwareSystem "Authorization Service" "Authentication and Authorization to access systems" "Existing System"

        externalDataCenterSystem = softwareSystem "<<stereotype>> Specialized Data Repository" "Represents linked repository of specialized data." "Existing System"


        ##
        # Relationships
        #
        # Users
        adminUser -> personnelDirectory "Manage users"
        adminUser -> reportingSystem "Generate reports"
        #
        commsUser -> webSite "Update content"
        commsUser -> customerRelationshipManagement "Send announcements, newsletters, etc."
        #
        externalUser -> webSite "Uses"
        externalUser -> webPortal "Uses"        
        researchUser -> leaf "Queries data"
        externalUser -> redcap "Enters/Uploads reponses"
        externalUser -> objectStore "Uploads/Downloads"
        #
        adrcDataUser -> webPortal "upload/review data"

        #
        formsUser -> redcap "Create/manage Instruments"
        #
        querySpecialist -> naccDataRepositorySystem
        #
        




        reportingSystem -> api "Request report"
        webSite -> api "Request metrics"



        # naccDataRepositorySystem -> internalSpecializedDataRepository "links to data"
        # internalSpecializedDataRepository -> naccDataRepositorySystem "registers data"

 
        # external relationships
        authorizationManager -> authSystem "authenticate and authorize user"
        authorizationManager -> authSystem "create, update users and authorizations"
        authorizationManager -> personnelDirectory "pulls users and roles"
        #
        customerRelationshipManagement -> personnelDirectory "pulls contact information"
        #
        webPortal -> authSystem "authenticate and authorize user"
        redcap -> authSystem "authorize user"
        leaf -> authSystem "authorize user"
        # 
        naccDataRepositorySystem -> externalDataCenterSystem "links to data"
        externalDataCenterSystem -> naccDataRepositorySystem "registers data"


    }

    views {

        systemlandscape "SystemLandscape" {
            include *
            exclude adminUser
            exclude commsUser
            exclude formsUser
            exclude querySpecialist
            autoLayout
        }

        systemContext naccDataRepositorySystem "RepositoryContext" {
            include *
            autoLayout
        }


        container naccDataRepositorySystem "RepositoryContainers" {
            include *
            autoLayout
        }

        container naccCommunicationsSystem "CommunicationsContainers" {
            include *
            autoLayout
        }

        container naccAdministrativeSystem "AdministrationContainers" {
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
            element "NACC Staff" {
                background #999999
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Existing System" {
                background #999999
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Web Browser" {
                shape WebBrowser
            }
            element "Mobile App" {
                shape MobileDeviceLandscape
            }
            element "Database" {
                shape Cylinder
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
            element "Failover" {
                opacity 25
            }
        }
    }

}
