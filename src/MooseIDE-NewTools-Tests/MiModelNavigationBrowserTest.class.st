Class {
	#name : 'MiModelNavigationBrowserTest',
	#superclass : 'TestCase',
	#instVars : [
		'browser',
		'inspectedModel'
	],
	#category : 'MooseIDE-NewTools-Tests',
	#package : 'MooseIDE-NewTools-Tests'
}

{ #category : 'tests' }
MiModelNavigationBrowserTest >> clickOnAllClasses [

	| navigationTreeTable |
	navigationTreeTable := browser presenterAt: #navigation.
	navigationTreeTable selectItem: navigationTreeTable roots first
]

{ #category : 'running' }
MiModelNavigationBrowserTest >> setUp [

	super setUp.

	inspectedModel := FamixStModel new
		                  newClassNamed: #C1;
		                  newClassNamed: #C2;
		                  yourself.

	browser := MiMetaModelNavigationBrowser on: inspectedModel
]

{ #category : 'running' }
MiModelNavigationBrowserTest >> tearDown [

	browser withWindowDo: [ :window | window close ].

	super tearDown
]

{ #category : 'tests' }
MiModelNavigationBrowserTest >> testClickingOpensMooseGroup [

	self clickOnAllClasses.

	self assert: browser selectedObject equals: (inspectedModel allWithType: FamixStClass)
]
