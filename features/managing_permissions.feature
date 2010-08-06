Feature: Managing permissions on a subject
  In order to ensure only certain actions are allowed on an object
  As a frustrated and lonely programmer
  I want to be able to declare permissions in a simple, declarative way

  Scenario: Allowing an action on a Class
    Given I have a class named "Item"
    And I have a class named "User"
    When I include the "Cannibal::Subject" module into "Item"
    And I declare that a "User" can "edit" the "name" of an "Item"
    And I create a new instance of "User" and assign it to an instance variable "user"
    Then the instance variable "user" should be allowed to "edit" the "name" of an "Item"

  Scenario: Disallowing an action on a Class
    Given I have a class named "Item"
    And I have a class named "User"
    When I include the "Cannibal::Subject" module into "Item"
    And I declare that a "User" cannot "edit" the "created_at" of an "Item"
    And I create a new instance of "User" and assign it to an instance variable "user"
    Then the instance variable "user" should not be allowed to "edit" the "created_at" of an "Item"

    