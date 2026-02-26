Class {
	#name : 'MiButterflyMapModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'model'
	],
	#category : 'MooseIDE-ButterflyMap-Tests-Model',
	#package : 'MooseIDE-ButterflyMap-Tests',
	#tag : 'Model'
}

{ #category : 'running' }
MiButterflyMapModelTest >> setUp [

	| browser |
	super setUp.

	browser := Mock new.
	browser stub application willReturn: MiApplication current.

	model := MiButterflyMapModel new
		         browser: browser;
		         yourself.

	model currentEntity: Mock new
]

{ #category : 'running' }
MiButterflyMapModelTest >> testChildrenFor [

	| children |
	children := model childrenFor: MooseEntity new.
	self assert: children isMooseObject
]

{ #category : 'running' }
MiButterflyMapModelTest >> testDefaultChildrenQueryIsNotNil [

	self assert: model defaultChildrenQuery isNotNil.
	self assert: model defaultChildrenQuery isValid
]

{ #category : 'running' }
MiButterflyMapModelTest >> testDefaultClientsQuery [

	self assert: (model instVarNamed: #clientsQuery) isNotNil
]

{ #category : 'running' }
MiButterflyMapModelTest >> testDefaultProvidersQuery [

	self assert: (model instVarNamed: #providersQuery) isNotNil
]

{ #category : 'running' }
MiButterflyMapModelTest >> testSetCurrentEntityShouldNotifyBrowser [

	model currentEntity: Mock new.
	model browser should receive runVisualization
]
