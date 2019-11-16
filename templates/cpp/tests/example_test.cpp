#include "gtest/gtest.h"
using namespace testing;

class Example_test_fixture : public Test {

protected:
    void SetUp() override {}
    void TearDown() override {}

    int data = 10;
};

TEST_F(Example_test_fixture, example_test_case) {
    EXPECT_EQ(data, 5 + 5);
}

int main(int argc, char** argv) {
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
