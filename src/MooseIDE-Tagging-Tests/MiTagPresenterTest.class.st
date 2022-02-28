Class {
	#name : #MiTagPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'browser',
		'presenter'
	],
	#category : #'MooseIDE-Tagging-Tests'
}

{ #category : #'API - tags' }
MiTagPresenterTest >> createCategory: aName [

	browser tagModel addCategory: aName
]

{ #category : #'API - tags' }
MiTagPresenterTest >> createExtentTag: aName [

	browser
		createTag: aName
		description: nil
		color: Color red
		category: nil
]

{ #category : #'API - tags' }
MiTagPresenterTest >> createIntentTag: aName [

	browser
		createDynamicTag: aName
		description: nil
		color: Color blue
		category: nil
		query: nil
]

{ #category : #helpers }
MiTagPresenterTest >> presenterClass [

	self subclassResponsibility
]

{ #category : #helpers }
MiTagPresenterTest >> presenterOwner [

	self subclassResponsibility
]

{ #category : #running }
MiTagPresenterTest >> setUp [

	| mooseModel |
	super setUp.
	mooseModel := MooseModel with: MooseEntity new.
	browser := MiTagBrowser
		           newApplication: MiTestApplication current
		           model: MiTagBrowserModel new.
	browser receiveEntity: mooseModel.
	presenter := self presenterOwner
		             instantiate: self presenterClass
		             on: browser tagModel
]

{ #category : #running }
MiTagPresenterTest >> tearDown [

	MiTestApplication reset
]
