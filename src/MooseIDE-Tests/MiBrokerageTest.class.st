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
MiBrokerageTest >> testRegisterConsumerConsumesAllItems [
	"allItems produced by mockProducer are 42 and 25
	 when registering mockProducer the mockConsumer is invited to comsume these 2 numbers
	and no other one (33 here)"

	(mockProducer stub itemsFor: Integer) willReturn: #(42 25). 
	application registerProducer: mockProducer for: Integer.

	application registerConsumer: mockConsumer for: Integer.

	mockConsumer should receive consume: 42.
	mockConsumer should receive consume: 25.
	mockConsumer should not receive consume: 33.
	

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
MiBrokerageTest >> testRegisterProducerConsumesAllItems [
	"allItems produced by mockProducer are 42 and 25
	 when registering mockProducer the mockConsumer is invited to comsume these 2 numbers
	and no other one (33 here)"
	application registerConsumer: mockConsumer for: Integer.

	(mockProducer stub itemsFor: Integer) willReturn: #(42 25). 
	application registerProducer: mockProducer for: Integer.

	mockConsumer should receive consume: 42.
	mockConsumer should receive consume: 25.
	mockConsumer should not receive consume: 33.
	

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
