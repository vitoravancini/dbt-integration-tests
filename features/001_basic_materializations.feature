Feature: Test direct copying of source tables

  Background: Project setup
    Given a seed "seed" with:
      """
      id,first_name,last_name,email,gender,ip_address
      1,Jack,Hunter,jhunter0@pbs.org,Male,59.80.20.168
      2,Kathryn,Walker,kwalker1@ezinearticles.com,Female,194.121.179.35
      3,Gerald,Ryan,gryan2@com.com,Male,11.3.212.243
      4,Bonnie,Spencer,bspencer3@ameblo.jp,Female,216.32.196.175
      5,Harold,Taylor,htaylor4@people.com.cn,Male,253.10.246.136
      """
    And a file named "packages.yml" with:
      """
      packages:
        - git: https://github.com/fishtown-analytics/dbt-utils.git
      """
    And a file named "dbt_project.yml" with:
      """
      name: test
      version: 1.0

      seeds:
        test:
          seed:
            column_types:
              id: number(10,2)
              first_name: varchar(250)
              last_name: varchar(250)
              email: varchar(250)
              gender: varchar(250)
              ip_address: varchar(250)

      """

  Scenario Outline: Test materialized='<materialization>'

    Given a model "<materialization>_relation" with:
      """
      {{config(materialized='<materialization>')}}
      select * from {{ ref('seed') }}
      """
      And a file named "models/schema.yml" with:
      """
      version: 2

      models:
        - name: <materialization>_relation
          columns:
            - name: id
              tests:
                - not_null
                - unique

      """

    When I successfully run "dbt deps"
     And I successfully run "dbt seed"
     And I successfully run "dbt run"
     And I successfully run "dbt test"

  Examples:
    | materialization |
    | view            |
    | table           |
    | incremental     |
