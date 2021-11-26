"
Abstract super class for the browsers receiving modes.
"
Class {
	#name : #MiBrowserReceivingMode,
	#superclass : #Object,
	#category : #'MooseIDE-Core-ReceivingMode'
}

{ #category : #action }
MiBrowserReceivingMode class >> browser: aBrowser actOnEntity: anEntity [

	self subclassResponsibility
]
