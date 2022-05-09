Class {
	#name : #MiDuplicationBrowserSettings,
	#superclass : #Object,
	#instVars : [
		'minNumberOfReplicas',
		'minNumberOfLines',
		'minNumberOfCharacters',
		'codeCleanerClass',
		'maxReplicasShowed'
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
	codeCleanerClass := FamixRepCLikeCleaner.
	maxReplicasShowed := 10
]

{ #category : #accessing }
MiDuplicationBrowserSettings >> maxReplicasShowed [
	^maxReplicasShowed
]

{ #category : #accessing }
MiDuplicationBrowserSettings >> maxReplicasShowed: anInteger [
	maxReplicasShowed := 1 max: anInteger 
]

{ #category : #accessing }
MiDuplicationBrowserSettings >> minNumberOfCharacters [

	^ minNumberOfCharacters
]

{ #category : #accessing }
MiDuplicationBrowserSettings >> minNumberOfCharacters: aNumber [

	minNumberOfCharacters := 1 max: aNumber
]

{ #category : #accessing }
MiDuplicationBrowserSettings >> minNumberOfLines [

	^ minNumberOfLines
]

{ #category : #accessing }
MiDuplicationBrowserSettings >> minNumberOfLines: aNumber [

	minNumberOfLines := 1 max: aNumber
]

{ #category : #accessing }
MiDuplicationBrowserSettings >> minNumberOfReplicas [

	^ minNumberOfReplicas
]

{ #category : #accessing }
MiDuplicationBrowserSettings >> minNumberOfReplicas: aNumber [

	minNumberOfReplicas := 2 max: aNumber
]
