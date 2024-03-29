# Generated by Selenium IDE
import pytest
import time
import json
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support import expected_conditions
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities

class TestLogin():
  def setup_method(self, method):
    self.driver = webdriver.Chrome()
    self.vars = {}
  
  def teardown_method(self, method):
    self.driver.quit()
  
  def test_login(self):
    self.driver.get("http://localhost:8080/repo")
    self.driver.set_window_size(1536, 816)
    self.driver.find_element(By.ID, "personaltools-login").click()
    self.driver.find_element(By.ID, "__ac_name").click()
    self.driver.find_element(By.ID, "__ac_name").send_keys("itsadmin")
    self.driver.find_element(By.ID, "__ac_password").click()
    self.driver.find_element(By.ID, "__ac_password").send_keys("itsadmin")
    self.driver.find_element(By.CSS_SELECTOR, ".pattern-modal-buttons > #buttons-login").click()
  
