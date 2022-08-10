# Setup the tests by generating the required files
pnpm test:setup > /dev/null 2>&1

echo "* Testing near-operation generation with introspection json"
pnpm test:introspection > /dev/null
if [ $? -ne 0 ]; then
  echo "Introspection test failed"
  exit 1
fi

echo "* Testing near-operation generation with schema"
pnpm test:schema > /dev/null
if [ $? -ne 0 ]; then
  echo "Introspection test failed"
  exit 1
fi

# Run just the operations generation
# This should fail so if it passes thats a problem
echo "* Testing operations generation"
pnpm test:operations > /dev/null 2>&1
if [ $? -ne 1 ]; then
  echo "Operations generation passed even though it should have failed"
  exit 1
fi

# Cleanup / Remove all the generated files
pnpm test:cleanup > /dev/null


echo "Passed all tests"
