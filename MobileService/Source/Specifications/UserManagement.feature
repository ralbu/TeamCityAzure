Feature: UserManagement
	In order to manage users
	As an administrator
	I want to see and create new users

Scenario: Administrator requests list of users
	Given I am an administrator for user management application
	When I request all users
	Then I recieve a 200 Http Status Code

Scenario: Administrator adds a new user
	Given I am an administrator for user management application
	And I have a new user
	When I create a new user
	Then I recieve a 201 Http Status Code
