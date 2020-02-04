Class {
	#name : #MiSourceTextBrowserModel,
	#superclass : #Object,
	#instVars : [
		'selected'
	],
	#category : #'Midas-SourceTextBrowser'
}

{ #category : #accessing }
MiSourceTextBrowserModel >> selected [
	^ selected
]

{ #category : #accessing }
MiSourceTextBrowserModel >> selected: anObject [
	selected := anObject
]

{ #category : #accessing }
MiSourceTextBrowserModel >> sourceText [
	^ selected sourceText
]
