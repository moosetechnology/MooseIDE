"
The model behing the Duplication Browser

Instance variables:
- #entities among which to search for code clones
- #replicas -- list of clones found

The class model of clones is:

Entity -* Replica *- ReplicatedFragment

A Replica is a clone in a file, it has a sourceanchor (fileName, startLine, endLine)
A ReplicatedFragment must have at least 2 Replica-s
"
Class {
	#name : #MiDuplicationBrowserModel,
	#superclass : #MiAbstractModel,
	#traits : 'MiTSpecModelWithSettings',
	#classTraits : 'MiTSpecModelWithSettings classTrait',
	#instVars : [
		'selectedEntities',
		'replicatedFragmentsHierarchy',
		'entities',
		'configuration',
		'maximumShownReplicas'
	],
	#category : #'MooseIDE-Duplication'
}

{ #category : #'as yet unclassified' }
MiDuplicationBrowserModel class >> availableSourcesCleaners [

	^ FamixRepSourcesCleaner allAvailableCleaners collect: #new
]

{ #category : #'settings management' }
MiDuplicationBrowserModel class >> defaultMaximumShownReplicas [

	^ 10
]

{ #category : #'settings management' }
MiDuplicationBrowserModel class >> defaultMinimumNumberOfCharacters [

	^ 80
]

{ #category : #'settings management' }
MiDuplicationBrowserModel class >> defaultMinimumNumberOfLines [

	^ 10
]

{ #category : #'settings management' }
MiDuplicationBrowserModel class >> defaultMinimumNumberOfReplicas [

	^ 2
]

{ #category : #'settings management' }
MiDuplicationBrowserModel class >> defaultSourcesCleaner [

	^ FamixRepCLikeCleaner new
]

{ #category : #'settings management' }
MiDuplicationBrowserModel class >> newMementoForDefaultValues [

	^ MiDuplicationMemento new
		  minimumNumberOfLines: self defaultMinimumNumberOfLines;
		  minimumNumberOfCharacters: self defaultMinimumNumberOfCharacters;
		  minimumNumberOfReplicas: self defaultMinimumNumberOfReplicas;
		  sourcesCleaner: self defaultSourcesCleaner;
		  availableSourceCleaners: self availableSourcesCleaners;
		  maximumShownReplicas: self defaultMaximumShownReplicas;
		  yourself
]

{ #category : #accessing }
MiDuplicationBrowserModel >> allReplicatedFragments [

	^ replicatedFragmentsHierarchy keys
]

{ #category : #private }
MiDuplicationBrowserModel >> ancestorsOf: aFragment in: aFragmentCollection [

	^ aFragmentCollection select: [ :anotherFragment |
		  self fragment: anotherFragment includes: aFragment ]
]

{ #category : #api }
MiDuplicationBrowserModel >> childrenFragments: aFragment [

	^ replicatedFragmentsHierarchy at: aFragment
]

{ #category : #private }
MiDuplicationBrowserModel >> directParentOf: aFragment in: aFragmentCollection [
	"first compute all ancestors of aFragment
	 then sort them in decreasing order of their own ancestors inside the 1st list
	 the first one has the most ancestors and therefore must be a direct parent of aFragment"

	| parents |
	parents := self ancestorsOf: aFragment in: aFragmentCollection.
	parents ifEmpty: [ ^ nil ].
	^ ((parents collect: [ :fr |
		    fr -> (self ancestorsOf: fr in: parents) ]) sorted: [ :a :b |
		   a value size > b value size ]) first key
]

{ #category : #accessing }
MiDuplicationBrowserModel >> entities [

	^ entities
]

{ #category : #accessing }
MiDuplicationBrowserModel >> entities: anObject [

	entities := anObject
]

{ #category : #api }
MiDuplicationBrowserModel >> findReplicas [
	"Compute all duplication fragments between all entities"

	entities do: [ :entity | entity replicas removeAll ].

	replicatedFragmentsHierarchy := self hierarchyOfReplicatedFragment:
		                                (self newDetector runOn: entities)
			                                replicatedFragments.

	browser showReplicatedFragments: self rootFragments
]

{ #category : #private }
MiDuplicationBrowserModel >> fragment: aFragment includes: anotherFragment [

	anotherFragment = aFragment ifTrue: [ ^false ].
	aFragment replicas size <= anotherFragment replicas size ifTrue: [ ^false ].
	((aFragment replicas collect: #entity) includesAll:
					   (anotherFragment replicas collect: #entity)) ifFalse: [ ^false ].
	^ (anotherFragment codeText findString: aFragment codeText) > 0
]

{ #category : #api }
MiDuplicationBrowserModel >> fragmentsSelection: selectedFragments [
	"called when some clone(s) are selected in the listOfReplicatedFragments (middle list)
	 - Displays the code of the clones (right pane)
	   Note: there is a limit on the number of entities shown (see settings)
	 - Displays the cloned entities (left list)"

	| allReplicas |
	allReplicas := selectedFragments flatCollect: #replicas.
	browser showSelectedClones: allReplicas.

	"limit the number of code tabs shown"
	allReplicas size > maximumShownReplicas ifTrue: [
		allReplicas := allReplicas first: maximumShownReplicas ].

	self selectEntities: (allReplicas collectAsSet: #entity) asMooseGroup.
	browser showReplicas: allReplicas
]

{ #category : #private }
MiDuplicationBrowserModel >> hierarchyOfReplicatedFragment: aCollectionOfFragments [

	| hierarchy |
	hierarchy := Dictionary new: aCollectionOfFragments size.
	aCollectionOfFragments do: [ :fragment |
		"there should rarely be more than 2 children for each fragment"
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
MiDuplicationBrowserModel >> highlightEntities: entitiesToHighlight [

	browser selectFragments:
		(entitiesToHighlight flatCollectAsSet: [ :entity | 
			 entity replicas collect: #replicatedFragment ])
]

{ #category : #initialization }
MiDuplicationBrowserModel >> initialize [

	super initialize.

	entities := #(  ).
	selectedEntities := #(  ).
	replicatedFragmentsHierarchy := Dictionary new.

	self initializeSettings
]

{ #category : #initialization }
MiDuplicationBrowserModel >> initializeSettings [

	configuration := FamixRepConfiguration
		                 sourcesCleaner: self class defaultSourcesCleaner
		                 minimumNumberOfReplicas:
		                 self class defaultMinimumNumberOfReplicas
		                 ofLines: self class defaultMinimumNumberOfLines
		                 ofCharacters:
		                 self class defaultMinimumNumberOfCharacters.

	maximumShownReplicas := self class defaultMaximumShownReplicas
]

{ #category : #api }
MiDuplicationBrowserModel >> isSelected: anEntity [

	^ selectedEntities includes: anEntity
]

{ #category : #accessing }
MiDuplicationBrowserModel >> miSelectedItem [

	^ selectedEntities ifEmpty: [ entities ]
]

{ #category : #private }
MiDuplicationBrowserModel >> newDetector [

	^ FamixRepDetector new
		  configuration: configuration;
		  yourself
]

{ #category : #'settings management' }
MiDuplicationBrowserModel >> newMemento [

	^ MiDuplicationMemento new
		  minimumNumberOfLines: configuration minimumNumberOfLines;
		  minimumNumberOfCharacters: configuration minimumNumberOfCharacters;
		  minimumNumberOfReplicas: configuration minimumNumberOfReplicas;
		  sourcesCleaner: configuration sourcesCleaner;
		  maximumShownReplicas: maximumShownReplicas;
		  availableSourceCleaners: self class availableSourcesCleaners;
		  yourself
]

{ #category : #'settings management' }
MiDuplicationBrowserModel >> newMementoForDefaultValues [

	^ self class newMementoForDefaultValues
]

{ #category : #api }
MiDuplicationBrowserModel >> numberOfEntities [

	^ entities size
]

{ #category : #api }
MiDuplicationBrowserModel >> numberOfEntitiesInReplicas [

	^ (replicatedFragmentsHierarchy keys flatCollectAsSet: [ :fragment |
		   fragment replicas collect: #entity ]) size
]

{ #category : #api }
MiDuplicationBrowserModel >> numberOfFragments [

	^ replicatedFragmentsHierarchy size
]

{ #category : #api }
MiDuplicationBrowserModel >> numberOfSelectedEntities [

	^ selectedEntities size
]

{ #category : #api }
MiDuplicationBrowserModel >> numberOfSelectedFragments [
	^browser lstReplicatedFragments selectedItems size
]

{ #category : #accessing }
MiDuplicationBrowserModel >> replicatedFragmentsHierarchy [

	^ replicatedFragmentsHierarchy
]

{ #category : #accessing }
MiDuplicationBrowserModel >> replicatedFragmentsHierarchy: aCollection [

	replicatedFragmentsHierarchy := aCollection
]

{ #category : #api }
MiDuplicationBrowserModel >> rootFragments [
	"get children of any fragment and reject any fragment in this list "
	| allChildFragments |
	allChildFragments := replicatedFragmentsHierarchy associations flatCollect: #value.

	^ self allReplicatedFragments reject: [ :fragment |
		  allChildFragments includes: fragment ]
]

{ #category : #accessing }
MiDuplicationBrowserModel >> selectEntities: entityCollection [

	selectedEntities := entityCollection.
	browser updateToolbar
]

{ #category : #'settings management' }
MiDuplicationBrowserModel >> updateFromMemento: aMemento [

	configuration
		minimumNumberOfLines: aMemento minimumNumberOfLines;
		minimumNumberOfCharacters: aMemento minimumNumberOfCharacters;
		minimumNumberOfReplicas: aMemento minimumNumberOfReplicas;
		sourcesCleaner: aMemento sourcesCleaner.

	maximumShownReplicas := aMemento maximumShownReplicas
]
