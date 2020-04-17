Class {
	#name : #AbstractBrowserMode,
	#superclass : #Object,
	#category : #'Midas-Tests'
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
