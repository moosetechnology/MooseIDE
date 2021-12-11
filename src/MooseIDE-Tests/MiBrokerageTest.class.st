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
MiBrokerageTest >> testRegisterConsumer [
	self assert: (application consumersOf: Integer) size equals: 0.

	application registerConsumer: mockConsumer for: Integer.

	self assert: (application consumersOf: Integer) size equals: 1.

]

{ #category : #tests }
MiBrokerageTest >> testRegisterProducer [
	self assert: (application producersOf: Integer) size equals: 0.

	application registerProducer: mockProducer for: Integer.

	self assert: (application producersOf: Integer) size equals: 1.

]
