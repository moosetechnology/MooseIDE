Class {
	#name : #MiModelNavigationBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'browser',
		'inspectedModel'
	],
	#category : #'MooseIDE-NewTools-Tests'
}

{ #category : #tests }
MiModelNavigationBrowserTest >> clickOnAllClasses [

	| navigationTable |
	navigationTable := browser presenterAt: #navigation.

	navigationTable selectItem:
		(navigationTable items detect: [ :item | item key = 'All classes' ])
]

{ #category : #running }
MiModelNavigationBrowserTest >> setUp [

	super setUp.

	inspectedModel := FamixStModel new
		                  newClassNamed: #C1;
		                  newClassNamed: #C2;
		                  yourself.

	browser := MiModelNavigationBrowser on: inspectedModel
]

{ #category : #running }
MiModelNavigationBrowserTest >> tearDown [

	browser withWindowDo: [ :window | window close ].

	super tearDown
]

{ #category : #tests }
MiModelNavigationBrowserTest >> testClickingOpensMooseGroup [

	self clickOnAllClasses.

	self assert: browser selectedObject equals: inspectedModel allClasses
]
