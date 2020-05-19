Class {
	#name : #BrowserModeHighlight,
	#superclass : #AbstractBrowserMode,
	#category : #'Midas-BrowseAction'
}

{ #category : #'as yet unclassified' }
BrowserModeHighlight class >> mode: aBrowser [
	^ aBrowser isHighlight
]

{ #category : #hook }
BrowserModeHighlight >> applyOn: aBrowser [
	^ aBrowser highlightAction
]
