Feature: Adding and finding created method

    Scenario: Log in as itsadmin
        Given a web browser is on landing page
        And noone is signed 
        When admin clicks on 'Log in' button on landing page
        And admin fills Login Name
        And admin fills Password
        And admin clicks 'Log in' button in login form popup
        Then admin is logged in

    Scenario: Add new method
        Given I am at frontpage of the website
        And I see Add new... button in left control panel
        When I try to click on 'Add new...' button in left control panel 
        And I click on 'Method' option in Add new... option popup
        Then I should see Add Method page

    Scenario: Add method info
        Given I am at the Add Method page
        When I click into Title input field
        And I type method name into the 'Title' input field
        And I click into 'Method Purpose' input field
        And I type method purpose description into Method Purpose input field
        And I click into 'Method description' input field
        And I type a detailed description of the method
        And I click into 'Method Strenghts' input field
        And I type a listof the strengths of the method
        And I click into 'Method Limitations' input field
        And I type a limitations of the method
        And I click 'Save' button
        And I click on 'Method Dimensions' tab
        And I choose 'Experimental - Testing' from Evaluation Type select
        And I click 'Save' button
        Then I should see Info message Item created

    Scenario: Search method
        Given I have created method with evaluation type dimension set to 'Experimental - Testing'
        And I am at the landing page
        When I click 'Methods' button in top menu
        And I click into Evaluation Type Dimension search field
        And I click on 'Experimental - Testing' option from given options
        And I click out of the Evaluation Type Dimension search field
        Then I should see specified method
