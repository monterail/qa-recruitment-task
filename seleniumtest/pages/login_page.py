from .abstract_page import AbstractPage
from selenium.webdriver.common.by import By
from .home_page import HomePage


class LoginPage(AbstractPage):

    EMAIL_FIELD_ID = "user_email"
    PASSWORD_FIELD_ID = "user_password"
    LOGIN_BUTTON_CSS_SELECTOR = "[name='commit']"

    def __init__(self, driver):
        AbstractPage.__init__(self, driver)
        self.driver = driver
        """:type : WebDriver"""

    def enter_credentials(self, username, password):
        self.wait(By.ID, self.EMAIL_FIELD_ID)
        self.input_text(self.EMAIL_FIELD_ID,username)
        self.input_text(self.PASSWORD_FIELD_ID,password)

    def login(self):
        self.driver.find_element(By.CSS_SELECTOR,self.LOGIN_BUTTON_CSS_SELECTOR).click()
        return HomePage(self.driver)
