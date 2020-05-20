"
This extension is signal when a user try to propagate an entity but there is no selected entity
"
Class {
	#name : #MiNoSelectedElementToPropagateException,
	#superclass : #MiException,
	#category : #'Midas-Core-Exception'
}

{ #category : #initialization }
MiNoSelectedElementToPropagateException >> defaultAction [
	"The default action taken if the exception is signaled."
	self inform: self messageText
]

{ #category : #initialization }
MiNoSelectedElementToPropagateException >> initialize [
	super initialize.
	messageText := 'No Moose element is selected in this browser or the functionnality is not available yet. Please consider opening an issue: https://github.com/moosetechnology/Midas'
]
