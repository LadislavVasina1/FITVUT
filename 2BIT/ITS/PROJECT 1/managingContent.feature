Feature: Creating and editing content
    This feature will test creating and editing new content in a new folder

    Background:
        Given an administrator account
        And logged in as 'itsadmin'
    
    Scenario: Choose to add Folder
        Given I am at frontpage of the website
        And I see Add new... button in left control panel
        When I try to click on 'Add new...' button in left control panel 
        And I click on 'Folder' option in Add new... option popup
        Then I should see Add Folder page

    Scenario: Add folder info 
        Given I am at the Add Folder page
        When I click into Title input field
        And I type folder name into the 'Title' input field
        And I click into 'Summary' input field
        And I type folder description into Summary input field
        And I click 'Save' button
        Then I should see Info message Item created
    
    Scenario: Change Folder state to published
        Given I have created the folder
        And I am at the folder page
        And I can see State: Private option in left control panel
        When I click 'State: Private' option in left control panel
        And I can see Publish option in showed popup
        And I click 'Publish' option in showed popup
        Then I should see Info message Item state changed
        
    Scenario: Add Requirement to the created folder
        Given I have created the folder
        And I am at the folder page
        When I click on 'Add new...' button in left control panel
        And I click on 'Requirement' option in Add new... option popup
        Then I should see Add Requirement page

    Scenario: Add requirement info
        Given I am at Add Requirement page
        When I click into Title input field
        And I type requirement name into the 'Title' input field
        And I click into 'Summary' input field
        And I type folder description into Summary input field
        And I click into 'Requirement ID' input field
        And I type Requirement ID into Requirement ID input field 
        And I click 'Save' button   
        Then I should see Info message Item created
    
   Scenario: Change Requirement state to published
        Given I have created the requirement
        And I am at the requirement page
        And I can see State: Private option in left control panel
        When I click 'State: Private' option in left control panel
        And I can see Publish option in showed popup
        And I click 'Publish' option in showed popup
        Then I should see Info message Item state changed 

    Scenario: Add Evaluation Scenario to the created folder
        Given I have created the folder
        And I am at the folder page
        When I click on 'Add new...' button in left control panel
        And I click on 'Evaluation Scenario' option in Add new... option popup
        Then I should see Add Evaluation Scenario page

    Scenario: Add Evaluation Scenario info
        Given I am at Add Evaluation Scenario page
        And I have requirement created in the folder
        When I click into Title input field 
        And I type Evaluation Scenario name into the 'Title' input field
        And I click into 'Id' input field
        And I type evaluation scenario ID
        And I click into 'Evaluation Scenario Textual Description'
        And I type Evaluation Scenario Textual Description
        And I click on 'Evaluation Scenario Requirements' tab
        And I click into a search window
        And I click shown Requirement name
        And I click 'Save' button
        Then I should see Info message Item state changed 

    Scenario: Change Evaluation Scenario state to published
        Given I have created the Evaluation Scenario
        And I am at the Evaluation Scenario page
        And I can see State: Private option in left control panel
        When I click 'State: Private' option in left control panel
        And I can see Publish option in showed popup
        And I click 'Publish' option in showed popum
        Then I should see Info message Item state changed

    Scenario: Add Use Case to the created folder
        Given I have created the folder
        And I am at the folder page
        When I click on 'Add new...' button in left control panel
        And I click on 'Use Case' option in Add new... option popup
        Then I should see Add Use Case page

    Scenario: Add Use Case info
        Given I am at Add Use Case page
        And I have Evaluation Scenario created in the folder
        When I click into Title input field 
        And I type Use Case name into the 'Title' input field
        And I click into 'Use Case Description' input field
        And I type Use Case description
        And I click on 'Use case Evaluation Scenarios' tab
        And I click into a search window
        And I click shown Evaluation Scenario name
        And I click 'Save' button
        Then I should see Info message Item state changed
    
    Scenario: Change Use Case state to published
        Given I have created the Use Case
        And I am at the Use Case page
        And I can see State: Private option in left control panel
        When I click 'State: Private' option in left control panel
        And I can see Publish option in showed popup
        And I click 'Publish' option in showed popum
        Then I should see Info message Item state changed

    Scenario: Change Use Case Partner
        Given I have created the Use Case
        And I am at the Use Case page
        When I click 'Edit' in left control panel
        And I am at the Edit Use Case page
        And I click house icon in Partners search window
        And I type Partners organization name
        And I click on found organization
        And I click 'Save' button
        Then I should see Info message Changes saved

    Scenario: Delete folder
        Given I am at the landing page of the website
        When I click 'Contents' option in left control panel
        And I can see check boxes next to every item on the website
        And I check checkbox next to folder I want to delete
        And I click trash can button
        And I click 'Yes' button in delete confirmation popup
        Then I should see info message Successfully delete items