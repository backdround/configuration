#include "gtest/gtest.h"
using namespace testing;

#include "solution.h"


TEST(Test_suit, test_case) {
    Solution instance;
    EXPECT_EQ(instance.f(), 2);
}



int main(int argc, char** argv) {
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
