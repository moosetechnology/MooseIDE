Class {
	#name : #MiCriticBrowserToolsTest,
	#superclass : #MiAbstractApplicationTest,
	#instVars : [
		'browser',
		'contextBuilder'
	],
	#category : #'MooseIDE-CriticBrowser-Tests'
}

{ #category : #testing }
MiCriticBrowserToolsTest class >> isAbstract [

	^ self == MiCriticBrowserToolsTest
]

{ #category : #running }
MiCriticBrowserToolsTest >> ruleComponentToEdit [

	self subclassResponsibility
]

{ #category : #running }
MiCriticBrowserToolsTest >> setUp [

	super setUp.
	browser := MiCriticBrowser openForTests: self application.
	(browser presenterAt: #rules) selectPath: { 1 }
]

{ #category : #running }
MiCriticBrowserToolsTest >> setUpBuilderAsCreator [

	contextBuilder := self toolClass on: browser model
]

{ #category : #running }
MiCriticBrowserToolsTest >> setUpBuilderAsEditor [

	| contextToEdit |
	contextToEdit := self ruleComponentToEdit.

	browser model addChildToRootContext: contextToEdit.
	browser updateRulesList.

	(browser presenterAt: #rules) selectItem: contextToEdit.

	contextBuilder := (self toolClass on: browser model)
		                        beForEdition;
		                        yourself
]

{ #category : #running }
MiCriticBrowserToolsTest >> tearDown [

	browser ifNotNil: [ browser withWindowDo: [ :window | window close ] ].
	super tearDown
]

{ #category : #accessing }
MiCriticBrowserToolsTest >> toolClass [

	self subclassResponsibility
]
