import unittest
import time
import re

from .browser import Browser
from .test_config import *
from .pages.login_page import LoginPage


class PostTest(unittest.TestCase):

    def setUp(self):
        self.browser = Browser()
        self.driver = self.browser.start()
        self.driver.get(URL)
        self.login_page = LoginPage(self.driver)

    def test_login_correct(self):
        self.login_page.enter_credentials(USERNAME, PASSWORD)
        self.login_page.login()
        self.assertEquals(self.driver.current_url, "https://qa-born.herokuapp.com/#/")

    def test_login_incorrect(self):
        self.login_page.enter_credentials("a@a.pl", "unicorn")
        self.login_page.login()
        self.assertEquals(self.driver.current_url, URL)

    def test_add_proposition(self):
        title = "Title " + str(self.login_page.get_random_number())
        description = "Description"
        value = 126548
        src = self.driver.page_source

        self.login_page.enter_credentials(USERNAME, PASSWORD)
        home_page = self.login_page.login()
        propositions_page = home_page.open_propositions()
        propositions_page.add_proposition(title, description, value)
        time.sleep(5)
        text_found = re.search(r'title', src)
        self.assertNotEqual(text_found, None)

    def test_add_and_remove_proposition(self):
        title = "Title " + str(self.login_page.get_random_number())
        description = "Description"
        value = 126548
        src = self.driver.page_source

        self.login_page.enter_credentials(USERNAME, PASSWORD)
        home_page = self.login_page.login()
        propositions_page = home_page.open_propositions()
        propositions_page.add_proposition(title, description, value)
        propositions_page.delete_proposition(title) # somehow this does not work. I cannot discern the reason
        text_found = re.search(r'title', src)
        self.assertEquals(text_found, None)

    def tearDown(self):
        self.browser.stop()

if __name__ == "__main__":
    unittest.main()
