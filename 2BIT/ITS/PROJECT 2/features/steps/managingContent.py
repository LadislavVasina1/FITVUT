# /**************************************/
# /*         ITS - PROJECT2             */
# /*     AUTHOR: LADISLAV VASINA        */
# /*         LOGIN: XVASIN11            */
# /*           YEAR: 2022               */
# /**************************************/

import time
from behave import *
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException


@when(u'I click on \'Folder\' option in Add new... option popup')
def step_impl(context):
    context.driver.find_element(By.ID, "folder").click()


@then(u'I should see Add Folder page')
def step_impl(context):
    try:
        context.driver.find_element(By.XPATH, "p/html/body/div/div[3]/main/div[1]/div/div/article/h1s")
    except NoSuchElementException:
        return False
    return True


@given(u'I am at the Add Folder page')
def step_impl(context):
    try:
        context.driver.find_element(By.XPATH, "p/html/body/div/div[3]/main/div[1]/div/div/article/h1s")
    except NoSuchElementException:
        return False
    return True


@when(u'I click into folder Title input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-IDublinCore-title").click()


@when(u'I type folder name into the \'Title\' input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-IDublinCore-title").send_keys("Folder name")


@when(u'I click into folder \'Summary\' input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-IDublinCore-description").click()


@when(u'I type folder description into folder Summary input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-IDublinCore-description").send_keys("Folder Summary")


@when(u'I click \'Save\' folder button')
def step_impl(context):
    context.driver.find_element(By.ID, "form-buttons-save").click()


@given(u'I have created the folder')
def step_impl(context):
    context.driver.find_element_by_link_text('Folder name').click()


@given(u'I am at the folder page')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "documentFirstHeading")
    except NoSuchElementException:
        return False
    return True


@given(u'I can see folder State: Private option in left control panel')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "plone-contentmenu-workflow")
    except NoSuchElementException:
        return False
    return True


@when(u'I click folder \'State: Private\' option in left control panel')
def step_impl(context):
    context.driver.find_element(By.ID, "plone-contentmenu-workflow").click()


@when(u'I can see Publish folder option in showed popup')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "workflow-transition-publish")
    except NoSuchElementException:
        return False
    return True


@when(u'I click \'Publish\' folder option in showed popup')
def step_impl(context):
    context.driver.find_element(By.ID, "workflow-transition-publish").click()


@then(u'I should see Info message Item state changed')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "global_statusmessage")
    except NoSuchElementException:
        return False
    return True


@when(u'I click on \'Add new....\' button in left control panel')
def step_impl(context):
    context.driver.find_element(By.ID, "plone-contentmenu-factories").click()


@when(u'I click on \'Requirement\' option in Add new... option popup')
def step_impl(context):
    context.driver.find_element(By.XPATH, "/html/body/section/div/div/nav/ul[1]/li[4]/ul/li[13]/a").click()


@then(u'I should see Add Requirement page')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "workflow-transition-publish")
    except NoSuchElementException:
        return False
    return True


@given(u'I am at Add Requirement page')
def step_impl(context):
    try:
        context.driver.find_element(By.XPATH, "/html/body/div/div[3]/main/div[1]/div/div/article/div/form/nav/a[2]")
    except NoSuchElementException:
        return False
    return True


@when(u'I click into requirement Title input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-IDublinCore-title").click()


@when(u'I type requirement name into the \'Title\' input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-IDublinCore-title").send_keys("Requirement name")


@when(u'I click into requirement \'Summary\' input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-IDublinCore-description").click()


@when(u'I type description into requirement Summary input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-IDublinCore-description").send_keys("Requirement summary")


@when(u'I click into \'Requirement ID\' input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-requirement_id").click()


@when(u'I type Requirement ID into Requirement ID input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-requirement_id").send_keys("1")


@when(u'I click \'Save\' requirement button')
def step_impl(context):
    context.driver.find_element(By.ID, "form-buttons-save").click()


@given(u'I have created the requirement')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "global_statusmessage")
    except NoSuchElementException:
        return False
    return True


@given(u'I am at the requirement page')
def step_impl(context):
    try:
        context.driver.find_element(By.XPATH, "/html/body/div/div[3]/main/div[1]/div/div/article/header/div[3]")
    except NoSuchElementException:
        return False
    return True


@given(u'I can see requirement State: Private option in left control panel')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "plone-contentmenu-workflow")
    except NoSuchElementException:
        return False
    return True


@when(u'I click requirement \'State: Private\' option in left control panel')
def step_impl(context):
    context.driver.find_element(By.ID, "plone-contentmenu-workflow").click()


@when(u'I can see Publish option in showed popup')
def step_impl(context):
    try:
        context.driver.find_element(By.XPATH, "/html/body/section/div/div/nav/ul[1]/li[5]/ul/li[2]/a")
    except NoSuchElementException:
        return False
    return True


@when(u'I click \'Publish\' requirement option in showed popup')
def step_impl(context):
    context.driver.find_element(By.XPATH, "/html/body/section/div/div/nav/ul[1]/li[5]/ul/li[2]/a").click()


@when(u'I click on \'Add new..\' button in left control panel')
def step_impl(context):
    breadcrumb1 = context.driver.find_element(By.ID, "breadcrumbs-1")
    context.driver.execute_script("arguments[0].click();", breadcrumb1)
    context.driver.find_element(By.ID, "plone-contentmenu-factories").click()


@when(u'I click on \'Evaluation Scenario\' option in Add new... option popup')
def step_impl(context):
    context.driver.find_element(By.XPATH, "/html/body/section/div/div/nav/ul[1]/li[4]/ul/li[3]/a").click()


@then(u'I should see Add Evaluation Scenario page')
def step_impl(context):
    try:
        context.driver.find_element(By.XPATH, "/html/body/div/div[3]/main/div[1]/div/div/article/div/form/nav/a[2]")
    except NoSuchElementException:
        return False
    return True


@given(u'I am at Add Evaluation Scenario page')
def step_impl(context):
    try:
        context.driver.find_element(By.XPATH, "/html/body/div/div[3]/main/div[1]/div/div/article/div/form/nav/a[2]")
    except NoSuchElementException:
        return False
    return True


@when(u'I click into eval scenario Title input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-IBasic-title").click()


@when(u'I type Evaluation Scenario name into the \'Title\' input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-IBasic-title").click()
    context.driver.find_element(By.ID, "form-widgets-IBasic-title").send_keys("Evaluation Scenario name")


@when(u'I click into \'Id\' input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-evaluation_secnario_id").click()


@when(u'I type evaluation scenario ID')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-evaluation_secnario_id").send_keys("16")


@when(u'I click into \'Evaluation Scenario Textual Description\'')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-evaluation_scenario_textual_description").click()


@when(u'I type Evaluation Scenario Textual Description')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-evaluation_scenario_textual_description").send_keys("Evaluation Scenario Textual Description")


@when(u'I click on \'Evaluation Scenario Requirements\' tab')
def step_impl(context):
    context.driver.find_element(By.ID, "autotoc-item-autotoc-1").click()


@when(u'I click into a search window')
def step_impl(context):
    context.driver.find_element(By.XPATH, "/html/body/div[1]/div[3]/main/div[1]/div/div/article/div/form/fieldset[2]/div/div[2]/div[2]/ul").click()


@when(u'I click shown Requirement name')
def step_impl(context):
    context.driver.find_element(By.XPATH, "/html/body/div[4]/ul/li[2]/div/div/div/a[1]").click()


@when(u'I click \'Save\' requirement edit button')
def step_impl(context):
    context.driver.find_element(By.ID, "form-buttons-save").click()


@given(u'I have created the Evaluation Scenario')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "global_statusmessage")
    except NoSuchElementException:
        return False
    return True


@given(u'I am at the Evaluation Scenario page')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "documentFirstHeading")
    except NoSuchElementException:
        return False
    return True


@given(u'I can see evalScen State: Private option in left control panel')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "plone-contentmenu-workflow")
    except NoSuchElementException:
        return False
    return True


@when(u'I click evalScen \'State: Private\' option in left control panel')
def step_impl(context):
    context.driver.find_element(By.ID, "plone-contentmenu-workflow").click()


@when(u'I can see Publish eval scenario option in showed popup')
def step_impl(context):
    try:
        context.driver.find_element(By.XPATH, "/html/body/section/div/div/nav/ul[1]/li[5]/ul/li[2]/a")
    except NoSuchElementException:
        return False
    return True


@when(u'I click \'Publish\' eval scenario option in showed popup')
def step_impl(context):
    context.driver.find_element(By.XPATH, "/html/body/section/div/div/nav/ul[1]/li[5]/ul/li[2]/a").click()


@when(u'I click on \'Add new...\' button in left control panel')
def step_impl(context):
    breadcrumb1 = context.driver.find_element(By.ID, "breadcrumbs-1")
    context.driver.execute_script("arguments[0].click();", breadcrumb1)
    context.driver.find_element(By.ID, "plone-contentmenu-factories")


@when(u'I click on \'Use Case\' option in Add new... option popup')
def step_impl(context):
    use_case_option = context.driver.find_element(By.XPATH, "/html/body/section/div/div/nav/ul[1]/li[4]/ul/li[19]/a")
    context.driver.execute_script("arguments[0].click();", use_case_option)


@then(u'I should see Add Use Case page')
def step_impl(context):
    try:
        context.driver.find_element(By.XPATH, "/html/body/div/div[3]/main/div[1]/div/div/article/div/form/nav/a[2]")
    except NoSuchElementException:
        return False
    return True


@given(u'I am at Add Use Case page')
def step_impl(context):
    try:
        context.driver.find_element(By.XPATH, "/html/body/div/div[3]/main/div[1]/div/div/article/div/form/nav/a[2]")
    except NoSuchElementException:
        return False
    return True


@given(u'I have Evaluation Scenario created in the folder')
def step_impl(context):
    time.sleep(3)
    context.driver.execute_script("window.history.go(-1)")
    try:
        context.driver.find_element(By.XPATH,
                                    "/html/body/div/div[3]/main/div[1]/div/div/article/div[2]/div/article[2]/header/span")
    except NoSuchElementException:
        return False

    context.driver.find_element(By.ID, "plone-contentmenu-factories").click()
    context.driver.find_element(By.XPATH, "/html/body/section/div/div/nav/ul[1]/li[4]/ul/li[19]/a").click()


@when(u'I click into use case Title input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-IBasic-title").click()


@when(u'I type Use Case name into the \'Title\' input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-IBasic-title").send_keys("Use case name")


@when(u'I click into \'Use Case Description\' input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-use_case_description_text_format").click()
    context.driver.find_element(By.XPATH, "/html/body/div/div[3]/main/div[1]/div/div/article/div/form/fieldset[1]/div[7]/select/option[2]").click()
    context.driver.find_element(By.XPATH, "/html/body/div/div[3]/main/div[1]/div/div/article/div/form/fieldset[1]/div[7]/textarea").click()


@when(u'I type Use Case description')
def step_impl(context):
    context.driver.find_element(By.XPATH, "/html/body/div/div[3]/main/div[1]/div/div/article/div/form/fieldset[1]/div[7]/textarea").send_keys("Use case description")


@when(u'I click \'Save\' use case button')
def step_impl(context):
    save = context.driver.find_element(By.ID, "form-buttons-save")
    context.driver.execute_script("arguments[0].click();", save)


@given(u'I have created the Use Case')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "global_statusmessage")
    except NoSuchElementException:
        return False
    return True


@given(u'I am at the Use Case page')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "formfield-form-widgets-use_case_number")
    except NoSuchElementException:
        return False
    return True


@given(u'I can see useCase State: Private option in left control panel')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "plone-contentmenu-workflow")
    except NoSuchElementException:
        return False
    return True


@when(u'I click useCase \'State: Private\' option in left control panel')
def step_impl(context):
    context.driver.find_element(By.ID, "plone-contentmenu-workflow").click()


@when(u'I click \'Publish\' option in showed popup')
def step_impl(context):
    publish_btn = context.driver.find_element(By.ID, "workflow-transition-publish")
    context.driver.execute_script("arguments[0].click();", publish_btn)


@when(u'I click \'Edit\' in left control panel')
def step_impl(context):
    context.driver.find_element(By.ID, "contentview-edit").click()


@when(u'I am at the Edit Use Case page')
def step_impl(context):
    try:
        context.driver.find_element(By.XPATH, "/html/body/div/div[3]/main/div[1]/div/div/article/div/form/nav/a[2]")
    except NoSuchElementException:
        return False
    return True


@when(u'I click into use case summary input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-IBasic-description").click()


@when(u'I type use case summary name')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-IBasic-description").send_keys("USE CASE SUMMARY")


@then(u'I should see Info message Changes saved')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "global_statusmessage")
    except NoSuchElementException:
        return False
    return True


@given(u'I am at the landing page of the website')
def step_impl(context):
    context.driver.find_element(By.ID, "portal-logo").click()


@when(u'I click \'Contents\' option in left control panel')
def step_impl(context):
    context.driver.find_element(By.ID, "contentview-folderContents").click()


@when(u'I can see check boxes next to every item on the website')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "selectAllInputCheckbox")
    except NoSuchElementException:
        return False
    return True


@when(u'I check checkbox next to folder I want to delete')
def step_impl(context):
    context.driver.find_element(By.ID, "select8InputCheckbox").click()


@when(u'I click trash can button')
def step_impl(context):
    context.driver.find_element(By.ID, "btn-delete").click()


@when(u'I click \'Yes\' button in delete confirmation popup')
def step_impl(context):
    context.driver.find_element(By.CLASS_NAME, "applyBtn").click()


@then(u'I should see info message Successfully delete items')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "fc-status-container")
    except NoSuchElementException:
        return False
    return True
