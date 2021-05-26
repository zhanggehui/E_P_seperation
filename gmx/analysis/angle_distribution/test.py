import unittest

a=1


class MyTestCase(unittest.TestCase):
    def test_something(self):
        print(a,'--------------------------------------------------')


if __name__ == '__main__':
    unittest.main()
