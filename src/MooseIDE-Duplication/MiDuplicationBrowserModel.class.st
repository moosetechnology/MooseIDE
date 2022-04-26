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
		'settings',
		'selectedEntity'
	],
	#category : #'MooseIDE-Duplication'
}

{ #category : #private }
MiDuplicationBrowserModel >> ancestorsOf: aFragment in: aFragmentCollection [
	^aFragmentCollection select: [ :anotherFragment | 
		           self fragment: anotherFragment includes: aFragment ]
]

{ #category : #accessing }
MiDuplicationBrowserModel >> browser [

	^ browser
]

{ #category : #accessing }
MiDuplicationBrowserModel >> browser: anObject [

	browser := anObject
]

{ #category : #api }
MiDuplicationBrowserModel >> childrenFragments: aFragment [

	^ replicatedFragments at: aFragment
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

{ #category : #private }
MiDuplicationBrowserModel >> directParentOf: aFragment in: aFragmentCollection [

	| parents |
	parents := self ancestorsOf: aFragment in: aFragmentCollection.
	parents ifEmpty: [ ^ nil ].
	^((parents collect: [ :fr | fr -> (self ancestorsOf: fr in: parents) ])
	sorted: [ :a :b | a value size > b value size ])
	first key
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

	replicatedFragments := self hierarchyOfReplicatedFragment:
		                       (self newDetector runOn: entities)
			                       replicatedFragments.
	browser showReplicatedFragments: (self rootFragments)
]

{ #category : #private }
MiDuplicationBrowserModel >> fragment: aFragment includes: anotherFragment [

	anotherFragment = aFragment ifTrue: [ ^false ].
	aFragment replicas size <= anotherFragment replicas size ifTrue: [ ^false ].
	((aFragment replicas collect: #entity) includesAll:
					   (anotherFragment replicas collect: #entity)) ifFalse: [ ^false ].
	^ (anotherFragment codeText findString: aFragment codeText) > 0
]

{ #category : #private }
MiDuplicationBrowserModel >> hierarchyOfReplicatedFragment: aCollectionOfFragments [

	| hierarchy |
	hierarchy := Dictionary new: aCollectionOfFragments size.
	aCollectionOfFragments do: [ :fragment | 
		hierarchy at: fragment put: (OrderedCollection new: 2) ].
	aCollectionOfFragments do: [ :fragment | 
		(self directParentOf: fragment in: aCollectionOfFragments) 
			ifNotNil: [ :parent | 
				| children |
				children := hierarchy at: parent.
				children add: fragment.
				hierarchy at: parent put: children ] ].
	^ hierarchy
]

{ #category : #initialization }
MiDuplicationBrowserModel >> initialize [

	entities := #(  ).
	selectedEntity := #().
	settings := MiDuplicationBrowserSettings new
]

{ #category : #api }
MiDuplicationBrowserModel >> isSelected: anEntity [
	^selectedEntity includes: anEntity 
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

{ #category : #'accessing - testing' }
MiDuplicationBrowserModel >> replicatedFragments: aCollection [

	replicatedFragments := aCollection
]

{ #category : #api }
MiDuplicationBrowserModel >> rootFragments [
	| children |
	children := replicatedFragments associations flatCollect: #value.
	^replicatedFragments keys reject: [ :fragment | children includes: fragment]
	
]

{ #category : #accessing }
MiDuplicationBrowserModel >> selectedEntity [

	^selectedEntity
]

{ #category : #accessing }
MiDuplicationBrowserModel >> selectedEntity: anEntity [

	selectedEntity := anEntity.
	browser highlightEntities: selectedEntity.
	browser updateToolbar
]

{ #category : #api }
MiDuplicationBrowserModel >> selectedFragment: aReplicatedFragment [

	self selectedEntity: (aReplicatedFragment replicas collect: #entity) asMooseGroup.
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
