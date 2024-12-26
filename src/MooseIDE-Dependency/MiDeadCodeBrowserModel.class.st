"
The spec model for the MiDeadCodeBrowser

Responsible for handling all interactions as well as computing the dead entities
"
Class {
	#name : #MiDeadCodeBrowserModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'deadEntities',
		'candidateEntities'
	],
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #accessing }
MiDeadCodeBrowserModel >> entities [

	^candidateEntities
]

{ #category : #actions }
MiDeadCodeBrowserModel >> followEntity: aCollection [

	candidateEntities := aCollection 
]

{ #category : #initialization }
MiDeadCodeBrowserModel >> initialize [ 

	super initialize.

	deadEntities := OrderedCollection new
]

{ #category : #accessing }
MiDeadCodeBrowserModel >> miSelectedItem [

	^#()
]
