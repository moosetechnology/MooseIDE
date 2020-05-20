Class {
	#name : #MiNoSelectedElementToPropagateException,
	#superclass : #MiException,
	#category : #'Midas-Core-Exception'
}

{ #category : #initialization }
MiNoSelectedElementToPropagateException >> initialize [
	super initialize.
	messageText := 'No Moose element is selected in this browser or the functionnality is not available yet. Please consider opening an issue: https://github.com/moosetechnology/Midas'
]
