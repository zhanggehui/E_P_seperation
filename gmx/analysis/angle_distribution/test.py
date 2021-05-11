import unittest
import analysis as ay

class MyTestCase(unittest.TestCase):
    def test_something(self):
        ay.Analysis('./data/test.gro').analysis()


if __name__ == '__main__':
    unittest.main()
