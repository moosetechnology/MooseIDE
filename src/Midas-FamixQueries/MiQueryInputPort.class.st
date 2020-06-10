Class {
	#name : #MiQueryInputPort,
	#superclass : #SpInputPort,
	#category : #'Midas-FamixQueries-Tools'
}

{ #category : #accessing }
MiQueryInputPort class >> portName [
	^ #queryInputPort
]

{ #category : #'handling transmission' }
MiQueryInputPort >> incomingTransmission: aQuery from: outPort [
	self presenter updateForQuery: aQuery
]
