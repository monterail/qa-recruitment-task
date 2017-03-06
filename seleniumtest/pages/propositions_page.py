from selenium.webdriver.common.by import By
from .abstract_page import AbstractPage


class PropositionsPage(AbstractPage):

    PROPOSITION_TITLE_CSS_SELECTOR = "[name='propositionTitle']"
    PROPOSITION_DESCRIPTION_CSS_SELECTOR = "[name='propositionDescription']"
    PROPOSITION_VALUE_CSS_SELECTOR = "[name='propositionValue']"
    PROPOSITION_SUBMIT_CSS_SELECTOR = "[value='Save']"
    COMMENT_FIELD_XPATH = ""
    COMMENT_SEND_XPATH = ""
    EDIT_DESCRIPTION_XPATH = ""
    EDIT_DESCRIPTION_SEND_XPATH = ""
    UPVOTE_XPATH = "/html[@class='ng-scope']/body/div[@class='ng-scope']/div[@class='crs-topbar--sticky ng-scope']/ui-view[@class='ng-scope']/div[@class='ng-scope'][1]/div[@class='crs-grid__row crs-grid__row--centered ng-scope']/div[@class='crs-grid__column crs-grid__unit--sm-8']/div[@class='propositions__container ng-scope'][1]/div[@class='ng-scope'][1]/div[@class='ng-isolate-scope']/div[@class='crs-comment__votes--up']"
    DOWNVOTE_XPATH = "/html[@class='ng-scope']/body/div[@class='ng-scope']/div[@class='crs-topbar--sticky ng-scope']/ui-view[@class='ng-scope']/div[@class='ng-scope'][1]/div[@class='crs-grid__row crs-grid__row--centered ng-scope']/div[@class='crs-grid__column crs-grid__unit--sm-8']/div[@class='propositions__container ng-scope'][1]/div[@class='ng-scope'][1]/div[@class='ng-isolate-scope']/div[@class='crs-comment__votes--down']"

    def __init__(self, driver):
        AbstractPage.__init__(self, driver)
        self.driver = driver
        """:type : WebDriver"""

    def add_proposition(self, title, description, value):
        self.wait(By.CSS_SELECTOR,self.PROPOSITION_TITLE_CSS_SELECTOR)
        self.driver.find_element(By.CSS_SELECTOR, self.PROPOSITION_TITLE_CSS_SELECTOR).send_keys(title)
        self.driver.find_element(By.CSS_SELECTOR, self.PROPOSITION_DESCRIPTION_CSS_SELECTOR).send_keys(description)
        self.driver.find_element(By.CSS_SELECTOR, self.PROPOSITION_VALUE_CSS_SELECTOR).send_keys(value)
        self.driver.find_element(By.CSS_SELECTOR, self.PROPOSITION_SUBMIT_CSS_SELECTOR).click()

    def delete_proposition(self, title):
        XPATH = '//h3[contains(text(), "%s")]/../div[@class="propositions__container"]/button[contains(text(), "Delete")]' % title
        self.wait(By.XPATH, XPATH)
        self.driver.find_element(By.XPATH, XPATH).click()

    def add_comment(self, text):
        self.wait(By.XPATH, self.COMMENT_FIELD_XPATH)
        self.driver.find_element(By.CSS_SELECTOR, self.COMMENT_FIELD_XPATH).send_keys(text)
        self.driver.find_element(By.CSS_SELECTOR, self.COMMENT_SEND_XPATH).click()

    def upvote(self):
        self.wait(By.XPATH,self.UPVOTE_XPATH)
        self.driver.find_element(By.XPATH, self.UPVOTE_XPATH).click()

    def downvote(self):
        self.wait(By.XPATH,self.DOWNVOTE_XPATH)
        self.driver.find_element(By.XPATH, self.DOWNVOTE_XPATH).click()
