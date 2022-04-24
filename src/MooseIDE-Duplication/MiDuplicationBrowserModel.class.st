"
The model behing the Duplication Browser

Instance variables:
- #entities among which to search for code clones
- #replicas -- list of clones found
"
Class {
	#name : #MiDuplicationBrowserModel,
	#superclass : #Object,
	#instVars : [
		'browser',
		'repDetector',
		'entities',
		'replicatedFragments',
		'settings'
	],
	#category : #'MooseIDE-Duplication'
}

{ #category : #accessing }
MiDuplicationBrowserModel >> browser [

	^ browser
]

{ #category : #accessing }
MiDuplicationBrowserModel >> browser: anObject [

	browser := anObject
]

{ #category : #private }
MiDuplicationBrowserModel >> codeCleanerClass [
	"could also ask the mooseModel ?"
	^self settings codeCleanerClass
]

{ #category : #private }
MiDuplicationBrowserModel >> currentMooseModel [
	^entities anyOne mooseModel
]

{ #category : #accessing }
MiDuplicationBrowserModel >> entities [

	^ entities
]

{ #category : #accessing }
MiDuplicationBrowserModel >> entities: aCollection [

	entities := aCollection.
	browser showEntities: aCollection
]

{ #category : #api }
MiDuplicationBrowserModel >> findReplicas [

	replicatedFragments := (self newDetector runOn: entities) replicatedFragments.
	browser showReplicatedFragments: replicatedFragments
]

{ #category : #initialization }
MiDuplicationBrowserModel >> initialize [
	entities := #().
	settings := MiDuplicationBrowserSettings new
]

{ #category : #private }
MiDuplicationBrowserModel >> newDetector [
	^FamixRepDetector new
		configuration: self newRepConfig ;
		yourself
]

{ #category : #private }
MiDuplicationBrowserModel >> newRepConfig [

	^ FamixRepConfiguration new
		  minimumNumberOfReplicas: settings minNumberOfReplicas;
		  minimumNumberOfLines: settings minNumberOfLines;
		  minimumNumberOfCharacters: settings minNumberOfCharacters;
		  sourcesCleaner: self codeCleanerClass new;
		  yourself
]

{ #category : #accessing }
MiDuplicationBrowserModel >> replicatedFragments [

	^ replicatedFragments
]

{ #category : #api }
MiDuplicationBrowserModel >> selectedFragment: aReplicatedFragment [
	browser showReplicas: aReplicatedFragment replicas

	
]

{ #category : #accessing }
MiDuplicationBrowserModel >> settings [

	^ settings
]

{ #category : #accessing }
MiDuplicationBrowserModel >> settings: anObject [

	settings := anObject
]
