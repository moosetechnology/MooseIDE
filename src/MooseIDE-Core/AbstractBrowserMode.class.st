"
Abstract super class for the  ""incoming mode"" stategies


Incoming modes are:
- follow -- selected entities in the application are display in the browser
- highlight -- entities in the browser remain the same, but those that were selected in the application are highlighted
- frozen -- ignore entities selected in application 
"
Class {
	#name : #AbstractBrowserMode,
	#superclass : #Object,
	#category : #'MooseIDE-Core-BrowseAction'
}

{ #category : #'as yet unclassified' }
AbstractBrowserMode class >> actionFor: aBrowser [
	^ (self subclasses detect: [ :aStrategy | aStrategy mode: aBrowser ])
		new applyOn: aBrowser
]

{ #category : #'as yet unclassified' }
AbstractBrowserMode class >> mode: aBrowser [
	^ self subclassResponsibility
]

{ #category : #hook }
AbstractBrowserMode >> applyOn: aBrowser [
	^ self subclassResponsibility
]
