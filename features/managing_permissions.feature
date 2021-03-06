Feature: Managing permissions on a subject
  In order to ensure only certain actions are allowed on an object
  As a frustrated and lonely programmer
  I want to be able to declare permissions in a simple, declarative way

  Scenario: Allowing an action on a Class
    Given I have a class named "Item"
    And I have a class named "User"
    When I include "Item" with "Cannibal::Subject"
    And I include "User" with "Cannibal::Actor"
    And I allow a "User" to "edit" the "name" of an "Item"
    And I create a new instance of "User" and assign it to an instance variable "@user"
    Then the instance variable "@user" should be allowed to "edit" the "name" of an "Item"

  Scenario: Disallowing an action on a Class
    Given I have a class named "Item"
    And I have a class named "User"
    When I extend "Item" with "Cannibal::Subject"
    And I extend "User" with "Cannibal::Actor"
    And I declare that a "User" cannot "edit" the "created_at" of an "Item"
    And I create a new instance of "User" and assign it to an instance variable "@user"
    Then the instance variable "@user" should not be allowed to "edit" the "created_at" of an "Item"

  Scenario: Allowing an action on an object by an actor with a specific role
    Given I have a class named "Item"
    And I have a class named "User"
    And I add the attribute "role" to the "User" class
    When I extend "Item" with "Cannibal::Subject"
    And I extend "User" with "Cannibal::Actor"
    And I create a new instance of "User" and assign it to an instance variable "@admin"
    And I create a new instance of "User" and assign it to an instance variable "@user"
    And I set the "role" attribute of the instance variable "@admin" to "administrator"
    And I set the "role" attribute of the instance variable "@user" to "user"
    And I declare that only a "User" with the role "administrator" can "edit" an "Item"
    Then the instance variable "@admin" should be allowed to "edit" the "name" of an "Item"
    And the instance variable "@user" should not be allowed to "edit" the "name" of an "Item"

  Scenario: Allowing an action on an object
    Given I have a class named "Item"
    And I add the attribute "owner" to the "Item" class
    And I have a class named "User"
    And I add the attribute "role" to the "User" class
    When I extend "Item" with "Cannibal::Subject"
    And I extend "User" with "Cannibal::Actor"
    And I create a new instance of "User" and assign it to an instance variable "@user_a"
    And I create a new instance of "User" and assign it to an instance variable "@user_b"
    And I create a new instance of "User" and assign it to an instance variable "@admin"
    And I set the "role" attribute of the instance variable "@admin" to "administrator"
    And I create a new instance of "Item" and assign it to an instance variable "@item"
    And I set the "owner" attribute of the instance variable "@item" to the instance variable "@user_a"
    And I allow "User" to "edit" the "name" of "Item" if they are the "owner" or have the role "administrator"
    Then the instance variable "@user_a" should be allowed to "edit" the "@item"
    And the instance variable "@user_b" should not be allowed to "edit" the "@item"
    And the instance variable "@admin" should be allowed to "edit" the "@item"

  Scenario: Ensuring object-object level permissions override object-class level permissions
    Given I have a class named "Item"
    And I add the attribute "owner" to the "Item" class
    And I have a class named "User"
    And I add the attribute "role" to the "User" class
    When I extend "Item" with "Cannibal::Subject"
    And I extend "User" with "Cannibal::Actor"
    And I create a new instance of "User" and assign it to an instance variable "@user_a"
    And I create a new instance of "User" and assign it to an instance variable "@user_b"
    And I create a new instance of "User" and assign it to an instance variable "@admin"
    And I set the "role" attribute of the instance variable "@admin" to "administrator"
    And I set the "role" attribute of the instance variable "@user_a" to "user"
    And I set the "role" attribute of the instance variable "@user_b" to "user"
    And I create a new instance of "Item" and assign it to an instance variable "@item"
    And I set the "owner" attribute of the instance variable "@item" to the instance variable "@user_a"
    And I declare that only a "User" with the role "administrator" can "edit" an "Item"
    And I disallow "User" to "edit" the "name" of an "Item" unless they are the "owner"
    Then the instance variable "@user_a" should be allowed to "edit" the "@item"
    And the instance variable "@user_b" should not be allowed to "edit" the "@item"
    And the instance variable "@admin" should not be allowed to "edit" the "@item"

  Scenario: Ensuring object-class level permissions override class level permissions
    Given I have a class named "Item"
    And I have a class named "User"
    And I add the attribute "role" to the "User" class
    When I extend "Item" with "Cannibal::Subject"
    And I extend "User" with "Cannibal::Actor"
    And I create a new instance of "User" and assign it to an instance variable "@admin"
    And I set the "role" attribute of the instance variable "@admin" to "administrator"
    And I create a new instance of "User" and assign it to an instance variable "@user"
    And I set the "role" attribute of the instance variable "@user" to "user"
    And I allow a "User" to "edit" the "name" of an "Item"
    And I declare that only a "User" with the role "administrator" can "edit" an "Item"
    Then the instance variable "@admin" should be allowed to "edit" the "name" of an "Item"
    And the instance variable "@user" should not be allowed to "edit" the "name" of an "Item"

  Scenario: Allowing an action on a field in an object by an actor with a specific role
    Given I have a class named "Item"
    And I add the attribute "name" to the "Item" class
    And I have a class named "User"
    And I add the attribute "role" to the "User" class
    When I extend "Item" with "Cannibal::Subject"
    And I extend "User" with "Cannibal::Actor"
    And I create a new instance of "User" and assign it to an instance variable "@admin"
    And I set the "role" attribute of the instance variable "@admin" to "administrator"
    And I create a new instance of "User" and assign it to an instance variable "@user"
    And I set the "role" attribute of the instance variable "@user" to "user"
    And I declare that only a "User" with the role "administrator" can "edit" the "name" of an "Item"
    Then the instance variable "@admin" should be allowed to "edit" the "name" of an "Item"
    And the instance variable "@user" should not be allowed to "edit" the "name" of an "Item"
