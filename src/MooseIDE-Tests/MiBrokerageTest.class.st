Class {
	#name : #MiBrokerageTest,
	#superclass : #TestCase,
	#instVars : [
		'application',
		'mockProducer',
		'mockConsumer'
	],
	#category : #'MooseIDE-Tests-Application'
}

{ #category : #initialization }
MiBrokerageTest >> setUp [
	application := MiTestApplication new.
	mockConsumer := Mock named: 'consumer'.
	mockProducer := Mock named: 'producer'
]

{ #category : #tests }
MiBrokerageTest >> testConsumeItemNoConsumer [
	application consumeItem: #blah.
	mockConsumer should not receive consume: Any.
]

{ #category : #tests }
MiBrokerageTest >> testConsumeItemWithConsumer [
	application registerConsumer: mockConsumer for: Integer. 
	application consumeItem: 42.

	mockConsumer should receive consume: 42.
]

{ #category : #tests }
MiBrokerageTest >> testItemsForNoProducers [
	self assertCollection: (application itemsFor: Integer) hasSameElements: #()

]

{ #category : #tests }
MiBrokerageTest >> testItemsForOneProducer [
	(mockProducer stub itemsFor: Integer) willReturn: #(42 25).
	application registerProducer: mockProducer for: Integer.
	self assertCollection: (application itemsFor: Integer) hasSameElements: #(42 25)

]

{ #category : #tests }
MiBrokerageTest >> testItemsForTwoProducers [
	| otherProducer |
	(mockProducer stub itemsFor: Integer) willReturn: #(42).
	application registerProducer: mockProducer for: Integer.

	otherProducer := Mock named: 'anotherProducer'.
	(otherProducer stub itemsFor: Integer) willReturn: #(25).
	application registerProducer: otherProducer for: Integer.

	self assertCollection: (application itemsFor: Integer) hasSameElements: #(42 25)

]

{ #category : #tests }
MiBrokerageTest >> testProducedDoesNotMatchConsumeSuperClass [
	self deny: (application produced: Integer matchConsumed: LargeNegativeInteger)

]

{ #category : #tests }
MiBrokerageTest >> testProducedItemNoConsumer [
	application consumeItem: #blah.
	mockConsumer should not receive consume: Any.
]

{ #category : #tests }
MiBrokerageTest >> testProducedMatchConsumeClassUseTrait [
	self assert: (application produced: FAMIXSourcedEntity matchConsumed: FamixTWithComments)

]

{ #category : #tests }
MiBrokerageTest >> testProducedMatchConsumeSameClass [
	self assert: (application produced: Integer matchConsumed: Integer)

]

{ #category : #tests }
MiBrokerageTest >> testProducedMatchConsumeSubclass [
	self assert: (application produced: LargeNegativeInteger matchConsumed: Integer)

]

{ #category : #tests }
MiBrokerageTest >> testProducedMatchConsumeTraitUseTrait [
	self assert: (application produced: FamixTClass matchConsumed: FamixTWithComments)

]

{ #category : #tests }
MiBrokerageTest >> testRegisterConsumer [
	self assert: (application consumersOf: Integer) size equals: 0.

	application registerConsumer: mockConsumer for: Integer.

	self assert: (application consumersOf: Integer) size equals: 1.

]

{ #category : #tests }
MiBrokerageTest >> testRegisterConsumerForSiblingClass [
	self assert: (application consumersOf: LargeNegativeInteger) size equals: 0.

	application registerConsumer: mockConsumer for: LargePositiveInteger.

	self assert: (application consumersOf: LargeNegativeInteger) size equals: 0.

]

{ #category : #tests }
MiBrokerageTest >> testRegisterConsumerForSuperClass [
	self assert: (application consumersOf: LargeNegativeInteger) size equals: 0.

	application registerConsumer: mockConsumer for: Number.

	self assert: (application consumersOf: LargeNegativeInteger) size equals: 1.

]

{ #category : #tests }
MiBrokerageTest >> testRegisterProducer [
	self assert: (application producersOf: Integer) size equals: 0.

	application registerProducer: mockProducer for: Integer.

	self assert: (application producersOf: Integer) size equals: 1.

]

{ #category : #tests }
MiBrokerageTest >> testUnregisterConsumer [
	application registerConsumer: mockConsumer for: Integer.
	self assert: (application consumersOf: Integer) size equals: 1.

	application unregisterConsumer: mockConsumer.
	self assert: (application consumersOf: Integer) size equals: 0.

]

{ #category : #tests }
MiBrokerageTest >> testUnregisterProducer [
	application registerProducer: mockProducer for: Integer.
	self assert: (application producersOf: Integer) size equals: 1.

	application unregisterProducer: mockProducer.
	self assert: (application producersOf: Integer) size equals: 0.

]
