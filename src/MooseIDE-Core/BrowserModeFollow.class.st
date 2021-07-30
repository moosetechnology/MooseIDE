Class {
	#name : #BrowserModeFollow,
	#superclass : #AbstractBrowserMode,
	#category : #'MooseIDE-Core-BrowseAction'
}

{ #category : #'as yet unclassified' }
BrowserModeFollow class >> mode: aBrowser [
	^ aBrowser isFollow
]

{ #category : #hook }
BrowserModeFollow >> applyOn: aBrowser [
	^ aBrowser followAction
]
