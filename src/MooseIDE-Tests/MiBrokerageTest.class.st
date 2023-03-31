Class {
	#name : #MiBrokerageTest,
	#superclass : #MiAbstractApplicationTest,
	#instVars : [
		'mockProducer',
		'mockConsumer',
		'mockProducerConsumer'
	],
	#category : #'MooseIDE-Tests-Application'
}

{ #category : #initialization }
MiBrokerageTest >> setUp [
	super setUp.
	mockConsumer := Mock named: 'consumer'.
	mockProducer := Mock named: 'producer'.
	mockProducerConsumer := Mock named: 'producerConsomer'
]

{ #category : #tests }
MiBrokerageTest >> testConsumeItemFromProducerConsumerShouldNotConsumeItsOwnItem [

	application registerProducer: mockProducerConsumer for: Integer.
	application registerConsumer: mockProducerConsumer for: Integer.
	application consumeItem: 42 from: mockProducerConsumer.

	mockConsumer should not receive consume: 42
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

	self assert:
		(application
			 produced: FamixStMethod
			 matchConsumed: FamixTWithComments)
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
MiBrokerageTest >> testRemoveItemFromProducerConsumerShouldNotRemoveItsOwnItem [

	application registerProducer: mockProducerConsumer for: Integer.
	application registerConsumer: mockProducerConsumer for: Integer.
	application removeItem: 42 from: mockProducerConsumer.

	mockConsumer should not receive remove: 42
]

{ #category : #tests }
MiBrokerageTest >> testRemoveItemNoConsumer [
	application removeItem: #blah.
	mockConsumer should not receive remove: Any.
]

{ #category : #tests }
MiBrokerageTest >> testRemoveItemWithConsumer [
	application registerConsumer: mockConsumer for: Integer. 
	application removeItem: 42.

	mockConsumer should receive remove: 42.
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

{ #category : #tests }
MiBrokerageTest >> testUpdateItemFromProducerConsumerShouldNotUpdateItsOwnItem [

	application registerProducer: mockProducerConsumer for: Integer.
	application registerConsumer: mockProducerConsumer for: Integer.
	application updateItem: 42 from: mockProducerConsumer.

	mockConsumer should not receive update: 42
]

{ #category : #tests }
MiBrokerageTest >> testUpdateItemNoConsumer [
	application updateItem: #blah.
	mockConsumer should not receive update: Any.
]

{ #category : #tests }
MiBrokerageTest >> testUpdateItemWithConsumer [
	application registerConsumer: mockConsumer for: Integer. 
	application updateItem: 42.

	mockConsumer should receive update: 42.
]
