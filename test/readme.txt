HOW TO RUN UNIT TESTS:

All the unit test written for the src/flash package are located inside the test/flash package.
Inside test/flash is the version of AsUnit that we used to write our unit tests.

Note: Some unit tests, such as Loader, are asynchronous and can be time consuming.

In test/flash/nl/dpdk/test are a number of *Runner.as classes. 
These are designed to be either a document class for an empty .fla or to function as the Main class for FDT's and Flex Builder's (Flash Builder's) run configurations.