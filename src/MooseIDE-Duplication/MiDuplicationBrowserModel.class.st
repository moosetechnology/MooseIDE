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
		'settings',
		'selectedEntities',
		'replicatedFragmentsHierarchy'
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

	^ replicatedFragmentsHierarchy at: aFragment
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

	entities := aCollection asOrderedCollection sorted: [ :a :b | 
		            a name < b name ].
	browser showEntities: entities
]

{ #category : #api }
MiDuplicationBrowserModel >> findReplicas [

	replicatedFragmentsHierarchy := self hierarchyOfReplicatedFragment:
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

{ #category : #api }
MiDuplicationBrowserModel >> highlightEntity: entitiesToHighlight [

	browser selectFragments:
		(replicatedFragmentsHierarchy keys select: [ :fragment | 
			 fragment replicas anySatisfy: [ :replica | 
				 entitiesToHighlight includes: replica entity ] ])
]

{ #category : #initialization }
MiDuplicationBrowserModel >> initialize [

	entities := #(  ).
	selectedEntities := #().
	replicatedFragmentsHierarchy := Dictionary new.
	settings := MiDuplicationBrowserSettings new
]

{ #category : #api }
MiDuplicationBrowserModel >> isSelected: anEntity [
	^selectedEntities includes: anEntity 
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
		  sourcesCleaner: settings codeCleanerClass new;
		  yourself
]

{ #category : #api }
MiDuplicationBrowserModel >> numberOfEntities [
	^entities size
]

{ #category : #api }
MiDuplicationBrowserModel >> numberOfEntitiesInReplicas [
	^(replicatedFragmentsHierarchy keys flatCollectAsSet: [ :fragment | fragment replicas collect: #entity ]) size
]

{ #category : #api }
MiDuplicationBrowserModel >> numberOfFragments [
	^replicatedFragmentsHierarchy size
]

{ #category : #api }
MiDuplicationBrowserModel >> numberOfSelectedEntities [
	^selectedEntities size
]

{ #category : #api }
MiDuplicationBrowserModel >> numberOfSelectedFragments [
	^browser lstReplicatedFragments selectedItems size
]

{ #category : #'accessing - testing' }
MiDuplicationBrowserModel >> replicatedFragmentsHierarchy [

	^ replicatedFragmentsHierarchy
]

{ #category : #'accessing - testing' }
MiDuplicationBrowserModel >> replicatedFragmentsHierarchy: aCollection [

	replicatedFragmentsHierarchy := aCollection
]

{ #category : #api }
MiDuplicationBrowserModel >> rootFragments [
	| children |
	children := replicatedFragmentsHierarchy associations flatCollect: #value.
	^replicatedFragmentsHierarchy keys reject: [ :fragment | children includes: fragment]
	
]

{ #category : #accessing }
MiDuplicationBrowserModel >> selectedEntities [

	^selectedEntities
]

{ #category : #accessing }
MiDuplicationBrowserModel >> selectedEntities: entityCollection [

	selectedEntities := entityCollection.
	"browser highlightEntity: selectedEntities."
	browser updateToolbar
]

{ #category : #api }
MiDuplicationBrowserModel >> selectedFragment: selectedFragments [

	| allReplicas |
	allReplicas := selectedFragments flatCollect: #replicas.
	allReplicas size > settings maxReplicasShowed
		ifTrue: [ allReplicas first: settings maxReplicasShowed ]
		ifFalse: [ allReplicas ].

	self selectedEntities:
		(allReplicas collectAsSet: #entity) asMooseGroup.
	browser showReplicas: allReplicas
]

{ #category : #accessing }
MiDuplicationBrowserModel >> settings [

	^ settings
]
