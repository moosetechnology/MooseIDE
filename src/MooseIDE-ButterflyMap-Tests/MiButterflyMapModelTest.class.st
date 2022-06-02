Class {
	#name : #MiButterflyMapModelTest,
	#superclass : #TestCase,
	#instVars : [
		'model'
	],
	#category : #'MooseIDE-ButterflyMap-Tests-Model'
}

{ #category : #running }
MiButterflyMapModelTest >> setUp [
	super setUp.
	model := MiButterflyMapModel new browser: Mock new.
	model currentEntity: Mock new.

]

{ #category : #running }
MiButterflyMapModelTest >> testChildrenFor [

	| children |
	children := model childrenFor: MooseEntity new.
	self assert: children isMooseObject
	
]

{ #category : #running }
MiButterflyMapModelTest >> testDefaultChildrenQueryIsNotNil [

	self assert: model defaultChildrenQuery isNotNil
	.self assert: model defaultChildrenQuery isValid

]

{ #category : #running }
MiButterflyMapModelTest >> testDefaultLeftEntitiesQueryIsNotNil [

	self assert: model defaultLeftEntitiesQuery isNotNil
]

{ #category : #running }
MiButterflyMapModelTest >> testDefaultRightEntitiesQueryIsNotNil [

	self assert: model defaultRightEntitiesQuery isNotNil
]

{ #category : #running }
MiButterflyMapModelTest >> testSetCurrentEntityShouldNotifyBrowser [

	model currentEntity: Mock new.
	model browser should receive run
]
