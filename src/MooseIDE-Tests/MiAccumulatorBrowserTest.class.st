Class {
	#name : 'MiAccumulatorBrowserTest',
	#superclass : 'MiAbstractBrowserTest',
	#category : 'MooseIDE-Tests-Browsers',
	#package : 'MooseIDE-Tests',
	#tag : 'Browsers'
}

{ #category : 'running' }
MiAccumulatorBrowserTest >> browserClass [

	^MiAggregatorBrowser
]

{ #category : 'running' }
MiAccumulatorBrowserTest >> mooseObjects [
	"overriding because aggregatorBrowser cannot accept MooseObject-s"

	^{ self anEntity: 'a' . self anEntity: 'b' }
]

{ #category : 'tests - opening' }
MiAccumulatorBrowserTest >> testCanOpenOnMooseEntity [

	| newBrowser |
	self bus globallySelect: (self anEntity: 'a').
	self
		shouldnt: [ 
			newBrowser := self browserClass openForTests: self application.
			newBrowser window close ]
		raise: Error
]

{ #category : 'running' }
MiAccumulatorBrowserTest >> testCanPropagateAfterFollow [

	browser followEntity: self mooseObjects.

	self assert: browser canPropagate.

]

{ #category : 'running' }
MiAccumulatorBrowserTest >> testCannotPropagateWhenEmpty [

	self deny: browser canPropagate.

]

{ #category : 'running' }
MiAccumulatorBrowserTest >> testClearEntities [

	browser followEntity: self mooseObjects.

	self denyEmpty: browser specModel entities.

	browser btnClear click.
	self assertEmpty: browser specModel entities
]

{ #category : 'tests - buses' }
MiAccumulatorBrowserTest >> testFollowBusTriggersSelectEntity [

	| propagatedEntity |
	propagatedEntity := self anEntity: 'a'.
	
	browser stub.
	
	self bus globallySelect: propagatedEntity.
	
	browser followBus: self bus.
	browser should receive receiveEntity: propagatedEntity
]

{ #category : 'running' }
MiAccumulatorBrowserTest >> testFollowEntity [

	self assertEmpty: browser specModel entities.

	browser followEntity: self mooseObjects.

	self assert: browser specModel entities size equals: 2
]

{ #category : 'running' }
MiAccumulatorBrowserTest >> testMiSelectedItemWithSelection [

	| entities |
	entities := self mooseObjects.

	browser followEntity: entities.
	browser specModel selectedEntities: { entities first }.

	self assert: browser miSelectedItem size equals: 1
]

{ #category : 'running' }
MiAccumulatorBrowserTest >> testMiSelectedItemWithoutSelection [

	browser followEntity: self mooseObjects.

	self assert: browser miSelectedItem size equals: 2
]

{ #category : 'running' }
MiAccumulatorBrowserTest >> testRemoveEntities [

	| entities |
	entities := self mooseObjects.

	browser followEntity: entities.
	browser specModel selectedEntities: { entities first }.

	self assert: browser specModel entities size equals: 2.

	browser btnRemove click.

	self assert: browser specModel entities size equals: 1
]
