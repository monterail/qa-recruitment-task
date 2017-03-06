from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import random


class AbstractPage():

    def __init__(self, driver):
        self.driver = driver
        """:type : WebDriver"""

    # input text method
    def input_text(self, element, value):
        by = By.ID
        try:
            self.driver.find_element(by, element).clear()
            self.driver.find_element(by, element).send_keys(value)
        except NoSuchElementException:
            return element + " does not exist"

    def click_item(self, element):
        by = By.ID
        self.driver.find_element(by, element).click()

    def find_text(self, text):
        self.driver.find_element(By.XPATH, "//*[contains(text(), '%s')]" % text)

    def wait(self, by, element):
        wait = WebDriverWait(self.driver, 10)
        wait.until(EC.visibility_of_element_located((by, element)))

    def get_random_number(self):
        return random.randint(1, 999)