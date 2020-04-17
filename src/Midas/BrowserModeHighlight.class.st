Class {
	#name : #BrowserModeHighlight,
	#superclass : #AbstractBrowserMode,
	#category : #'Midas-Tests'
}

{ #category : #'as yet unclassified' }
BrowserModeHighlight class >> mode: aBrowser [
	^ aBrowser isHighlight
]

{ #category : #hook }
BrowserModeHighlight >> applyOn: aBrowser [
	^ aBrowser highlightAction
]
