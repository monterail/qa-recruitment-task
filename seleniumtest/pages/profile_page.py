from .abstract_page import AbstractPage


class ProfilePage(AbstractPage):

    def __init__(self, driver):
        AbstractPage.__init__(self, driver)
        self.driver = driver
        """:type : WebDriver"""