Class {
	#name : #MiSourceTextBrowserModel,
	#superclass : #Object,
	#instVars : [
		'selected'
	],
	#category : #'MooseIDE-Famix-SourceText'
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
