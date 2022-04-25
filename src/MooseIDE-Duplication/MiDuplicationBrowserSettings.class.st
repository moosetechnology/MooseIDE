Class {
	#name : #MiDuplicationBrowserSettings,
	#superclass : #Object,
	#instVars : [
		'minNumberOfReplicas',
		'minNumberOfLines',
		'minNumberOfCharacters',
		'codeCleanerClass'
	],
	#category : #'MooseIDE-Duplication'
}

{ #category : #accessing }
MiDuplicationBrowserSettings >> codeCleanerClass [

	^ codeCleanerClass
]

{ #category : #accessing }
MiDuplicationBrowserSettings >> codeCleanerClass: anObject [

	codeCleanerClass := anObject
]

{ #category : #initialization }
MiDuplicationBrowserSettings >> initialize [

	minNumberOfReplicas := 2.
	minNumberOfLines := 10.
	minNumberOfCharacters := 80.
	codeCleanerClass := FamixRepCLikeCleaner "temporarily, for testing, should be: FamixRepSourcesCleaner"
]

{ #category : #accessing }
MiDuplicationBrowserSettings >> minNumberOfCharacters [

	^ minNumberOfCharacters
]

{ #category : #accessing }
MiDuplicationBrowserSettings >> minNumberOfCharacters: anObject [

	minNumberOfCharacters := anObject
]

{ #category : #accessing }
MiDuplicationBrowserSettings >> minNumberOfLines [

	^ minNumberOfLines
]

{ #category : #accessing }
MiDuplicationBrowserSettings >> minNumberOfLines: anObject [

	minNumberOfLines := anObject
]

{ #category : #accessing }
MiDuplicationBrowserSettings >> minNumberOfReplicas [

	^ minNumberOfReplicas
]

{ #category : #accessing }
MiDuplicationBrowserSettings >> minNumberOfReplicas: anObject [

	minNumberOfReplicas := anObject
]
