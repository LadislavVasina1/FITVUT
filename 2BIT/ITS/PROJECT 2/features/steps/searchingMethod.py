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
from selenium.webdriver.common.keys import Keys

@given(u'a web browser is on landing page')
def step_impl(context):
    context.driver.get("http://localhost:8080/repo")
    context.driver.find_element(By.CSS_SELECTOR, "img").click()


@given(u'noone is signed')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "personaltools-login")
    except NoSuchElementException:
        return False
    return True


@when(u'admin clicks on \'Log in\' button on landing page')
def step_impl(context):
    context.driver.find_element(By.ID, "personaltools-login").click()


@when(u'admin fills Login Name')
def step_impl(context):
    context.driver.find_element(By.ID, "__ac_name").click()
    context.driver.find_element(By.ID, "__ac_name").send_keys("itsadmin")
    context.driver.find_element(By.CSS_SELECTOR, "div:nth-child(2) > .field").click()


@when(u'admin fills Password')
def step_impl(context):
    context.driver.find_element(By.ID, "__ac_password").click()
    context.driver.find_element(By.ID, "__ac_password").send_keys("itsadmin")
    context.driver.find_element(By.CSS_SELECTOR, "div:nth-child(2) > .field").click()


@when(u'admin clicks \'Log in\' button in login form popup')
def step_impl(context):
    context.driver.find_element(By.ID, "__ac_password").send_keys(Keys.ENTER)


@then(u'admin is logged in')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "portal-personaltools")
    except NoSuchElementException:
        return False
    return True


@given(u'I am at frontpage of the website')
def step_impl(context):
    context.driver.find_element(By.ID, "portal-logo").click()


@given(u'I see Add new... button in left control panel')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "plone-contentmenu-factories")
    except NoSuchElementException:
        return False
    return True


@when(u'I try to click on \'Add new...\' button in left control panel')
def step_impl(context):
    time.sleep(2)
    context.driver.find_element(By.ID, "plone-contentmenu-factories").click()
    time.sleep(2)


@when(u'I click on \'Method\' option in Add new... option popup')
def step_impl(context):
    context.driver.find_element(By.ID, "method").click()


@then(u'I should see Add Method page')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "form-widgets-method_purpose")
    except NoSuchElementException:
        return False
    return True


@given(u'I am at the Add Method page')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "form-widgets-method_purpose")
    except NoSuchElementException:
        return False
    return True


@when(u'I click into Title input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-IBasic-title").click()


@when(u'I type method name into the \'Title\' input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-IBasic-title").send_keys("Method Title")


@when(u'I click into \'Method Purpose\' input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-method_purpose").click()


@when(u'I type method purpose description into Method Purpose input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-method_purpose").send_keys("Method purpose")


@when(u'I click into \'Method description\' input field')
def step_impl(context):
    context.driver.find_element(By.ID, "mceu_151").click()
    dropdown = context.driver.find_element(By.ID, "form-widgets-method_description_text_format")
    dropdown.find_element(By.XPATH, "//option[. = 'text/x-web-textile']").click()
    context.driver.find_element(By.CSS_SELECTOR, ".outer-wrapper").click()


@when(u'I type a detailed description of the method')
def step_impl(context):
    context.driver.find_element(By.NAME, "form.widgets.method_strengths.mimeType").click()
    context.driver.find_element(By.NAME, "form.widgets.method_description").send_keys("Method description")
    context.driver.find_element(By.CSS_SELECTOR, ".outer-wrapper").click()


@when(u'I click into \'Method Strengths\' input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-method_strengths_text_format").click()
    context.driver.find_element(By.XPATH, "/html/body/div/div[3]/main/div[1]/div/div/article/div/form/fieldset[1]/div[5]/select/option[2]").click()
    context.driver.find_element(By.CSS_SELECTOR, ".outer-wrapper").click()


@when(u'I type a listof the strengths of the method')
def step_impl(context):
    context.driver.find_element(By.NAME, "form.widgets.method_strengths.mimeType").click()
    context.driver.find_element(By.NAME, "form.widgets.method_strengths").send_keys("Method strengths")
    context.driver.find_element(By.CSS_SELECTOR, ".outer-wrapper").click()


@when(u'I click into \'Method Limitations\' input field')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-method_limitations_text_format").click()
    context.driver.find_element(By.XPATH,
    "/html/body/div/div[3]/main/div[1]/div/div/article/div/form/fieldset[1]/div[6]/select/option[2]").click()
    context.driver.find_element(By.CSS_SELECTOR, ".outer-wrapper").click()


@when(u'I type a limitations of the method')
def step_impl(context):
    context.driver.find_element(By.NAME, "form.widgets.method_limitations.mimeType").click()
    context.driver.find_element(By.NAME, "form.widgets.method_limitations").send_keys("Method limitations")
    context.driver.find_element(By.CSS_SELECTOR, ".outer-wrapper").click()


@when(u'I click \'Save\' method button')
def step_impl(context):
    context.driver.find_element(By.ID, "form-buttons-save").click()


@when(u'I click on \'Method Dimensions\' tab')
def step_impl(context):
    context.driver.find_element(By.ID, "contentview-edit").click()
    context.driver.find_element(By.ID, "autotoc-item-autotoc-1").click()

@when(u'I choose \'Experimental - Testing\' from Evaluation Type select')
def step_impl(context):
    context.driver.find_element(By.ID, "form-widgets-evaluation_type-0").click()

@when(u'I click \'Save\' button')
def step_impl(context):
    context.driver.find_element(By.ID, "form-buttons-save").click()


@then(u'I should see Info message Item created')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "global_statusmessage")
    except NoSuchElementException:
        return False
    return True


@given(u'I have created method with evaluation type dimension set to \'Experimental - Testing\'')
def step_impl(context):
    try:
        context.driver.find_element(By.ID, "form-widgets-evaluation_type")
    except NoSuchElementException:
        return False
    return True


@given(u'I am at the landing page')
def step_impl(context):
    context.driver.find_element(By.ID, "portal-logo").click()


@when(u'I click \'Methods\' button in top menu')
def step_impl(context):
    context.driver.find_element(By.XPATH, "/html/body/div/div[1]/div/nav/div/div[2]/ul/li[1]/a").click()


@when(u'I click into Evaluation Type Dimension search field')
def step_impl(context):
    element = context.driver.find_element_by_xpath("/html/body/div[1]/div[3]/main/div[1]/div/div/article/div[2]/div/div/div[5]/div/div[2]/div[2]/fieldset/form")
    context.driver.execute_script("arguments[0].click();", element)


@when(u'I click on \'Experimental - Testing\' option from given options')
def step_impl(context):
    option = context.driver.find_element(By.XPATH, "/html/body/div[1]/div[3]/main/div[1]/div/div/article/div[2]/div/div/div[5]/div/div[2]/div[2]/fieldset/form/select/option[5]")
    context.driver.execute_script("arguments[0].click();", option)


@when(u'I click out of the Evaluation Type Dimension search field')
def step_impl(context):
    context.driver.find_element(By.CSS_SELECTOR, ".outer-wrapper").click()


@then(u'I should see specified method')
def step_impl(context):
    try:
        context.driver.find_element(By.XPATH, "/html/body/div[1]/div[3]/main/div[1]/div/div/article/div[2]/div/div/div[4]/div[1]/div/div[2]/div/article[6]")
    except NoSuchElementException:
        return False
    return True
