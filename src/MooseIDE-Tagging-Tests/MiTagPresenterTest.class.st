Class {
	#name : 'MiTagPresenterTest',
	#superclass : 'MiAbstractApplicationTest',
	#instVars : [
		'browser',
		'presenter'
	],
	#category : 'MooseIDE-Tagging-Tests',
	#package : 'MooseIDE-Tagging-Tests'
}

{ #category : 'testing' }
MiTagPresenterTest class >> isAbstract [

	^ self == MiTagPresenterTest
]

{ #category : 'API - tags' }
MiTagPresenterTest >> createCategory: aName [

	browser specModel addCategory: aName
]

{ #category : 'API - tags' }
MiTagPresenterTest >> createExtentTag: aName [

	^ browser specModel
		  createTag: aName
		  description: nil
		  color: Color red
		  category: nil
]

{ #category : 'API - tags' }
MiTagPresenterTest >> createIntentTag: aName [

	browser specModel
		createDynamicTag: aName
		description: nil
		color: Color blue
		category: nil
		query: nil
]

{ #category : 'helpers' }
MiTagPresenterTest >> presenterClass [

	self subclassResponsibility
]

{ #category : 'helpers' }
MiTagPresenterTest >> presenterOwner [

	self subclassResponsibility
]

{ #category : 'running' }
MiTagPresenterTest >> setUp [

	  | mooseModel |
	  super setUp.
	  mooseModel := MooseModel with: MooseEntity new.
	  browser := MiTagBrowser
		             newApplication: self application
		             model: MiTagBrowserModel new.
	  browser receiveEntity: mooseModel.
	  presenter := self presenterOwner
		               instantiate: self presenterClass
		               on: browser specModel
]
