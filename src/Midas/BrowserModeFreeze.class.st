Class {
	#name : #BrowserModeFreeze,
	#superclass : #AbstractBrowserMode,
	#category : #'Midas-Tests'
}

{ #category : #'as yet unclassified' }
BrowserModeFreeze class >> mode: aBrowser [
	^ aBrowser isFreeze
]

{ #category : #hook }
BrowserModeFreeze >> applyOn: aBrowser [
	^ aBrowser freezeAction
]
