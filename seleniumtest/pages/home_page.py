from seleniumtest.test_config import *
from .abstract_page import AbstractPage
from .propositions_page import PropositionsPage
from selenium.webdriver.common.by import By


class HomePage(AbstractPage):

    USER_MENU_XPATH = "//*[contains(text(), '%s')]" % USER
    EDIT_PAGE_CSS_SELECTOR = "[ui-sref='auth.me']"
    EDIT_LINK = "https://qa-born.herokuapp.com/#/user/me"
    FEBRUARY = "//*[contains(text(), 'Black John')]"
    USER_LINK = '//span[@class="person__index ng-binding"]/strong[contains(text(), "Black John")]'

    def __init__(self, driver):
        AbstractPage.__init__(self, driver)
        self.driver = driver
        """:type : WebDriver"""

    def open_propositions(self):
        self.wait(By.XPATH,self.USER_LINK)
        self.driver.find_element(By.XPATH, self.USER_LINK).click()
        return PropositionsPage(self.driver)


