# /**************************************/
# /*         IPK - PROJECT2             */
# /*     AUTHOR: LADISLAV VASINA        */
# /*         LOGIN: XVASIN11            */
# /*           YEAR: 2022               */
# /**************************************/

from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.common.by import By
from selenium.common.exceptions import WebDriverException


def get_driver():
    """Get Firefox/Chrome driver from Selenium Hub"""
    try:
        driver = webdriver.Remote(
                command_executor='http://localhost:4444/wd/hub',
                desired_capabilities=DesiredCapabilities.FIREFOX)
    except WebDriverException:
        driver = webdriver.Remote(
                command_executor='http://localhost:4444/wd/hub',
                desired_capabilities=DesiredCapabilities.CHROME)
    driver.implicitly_wait(5)

    driver.get("http://localhost:8080/repo")

    return driver


def before_all(context):
    context.driver = get_driver()


def after_feature(context, feature):
    context.driver.find_element(By.ID, "portal-personaltools").click()
    context.driver.find_element(By.XPATH, "/html/body/section/div/div/nav/ul[2]/li/ul/li[5]").click()


def after_all(context):
    context.driver.close()
