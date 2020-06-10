Class {
	#name : #MiQueryOutputPort,
	#superclass : #SpOutputPort,
	#category : #'Midas-FamixQueries-Tools'
}

{ #category : #accessing }
MiQueryOutputPort class >> portName [

	^ #queryOutputPort
]

{ #category : #attaching }
MiQueryOutputPort >> attachTransmission: aTransmission [
	self presenter
		property: #query
		whenChangedDo: [ self
				transmitWith: aTransmission
				value: self destinationPresenter query ]
]
