"
This extension is signal when a user try to propagate an entity but there is no selected entity
"
Class {
	#name : #MiNoSelectedElementToPropagateException,
	#superclass : #MiException,
	#instVars : [
		'browser'
	],
	#category : #'MooseIDE-Core-Exception'
}

{ #category : #accessing }
MiNoSelectedElementToPropagateException class >> browser: aMiBrowser [
	^ self new
		browser: aMiBrowser;
		yourself
]

{ #category : #accessing }
MiNoSelectedElementToPropagateException >> browser [
	^ browser
]

{ #category : #accessing }
MiNoSelectedElementToPropagateException >> browser: anObject [
	browser := anObject
]

{ #category : #handling }
MiNoSelectedElementToPropagateException >> defaultAction [

	"The default action taken if the exception is signaled."

	self inform: self browser class title , ': ' , self messageText
]

{ #category : #initialization }
MiNoSelectedElementToPropagateException >> initialize [
	super initialize.
	messageText := 'This browser does not handle properly item selection. Please consider opening an issue: https://github.com/moosetechnology/MooseIDE'
]
