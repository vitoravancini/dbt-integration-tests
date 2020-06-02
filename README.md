# dbt-integration-tests

## Installation

Clone this repository, then run `pip install -r requirements.txt`. Make sure that this project is installed into the same Python environment as the adapter and dbt code that you want to test.

## Usage

To invoke, use:

```bash
bin/run-with-profile <profile-name> <other-options>
```

So, for example, to run the tests on a profile named `postgres`:

```bash
bin/run-with-profile postgres
```

To run a specific test:

```bash
bin/run-with-profile postgres features/001_basic_materializations.feature
```


### Things changed from forked repo

## added types to dbt seed

added 

'''bash
+      seeds:
+          test:
+              seed:
+                  column_types:
+                      id: number(10,2)
+                      first_name: varchar(250)
+                      last_name: varchar(250)
+                      email: varchar(250)
+                      gender: varchar(250)
+                      ip_address: varchar(250)
'''

to seed tests, agate and oracle types are not working properly without specifying types here.
Without  explicitly specifing types, agate tries to insert with decimal(),(agate_helper.py line 115 at dbt project)
maybe we could overwrite the DEFAULT_TYPE_TESTER at agate_helper, not sure how though.


## removed dbt_utils test equality at seed tests, added not null and unique tests instead.

Dbt utils do not support oracle, not sure how to proceed about this. Added other tests to at least test schema tests 

## Added an option for specifyin profile location

For the porpuse of running in an automated fashion I added the possiblity to specify the profile dir,
this way I'm able to have a test profile without adding unecessary stuff to my ~/.dbt/ file.


#### Additional Notes

The feature 003_hooks.feature does not seem to work even for postgres adapter.
It looks like the dbt seed command tries to run the  on-run-start hook before it creates the seed table
and we get an table does not exists error
