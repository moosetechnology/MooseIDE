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
	#name : 'MiDuplicationModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'selectedEntities',
		'replicatedFragmentsHierarchy',
		'entities',
		'maximumShownReplicas',
		'repConfiguration'
	],
	#category : 'MooseIDE-Duplication-Model',
	#package : 'MooseIDE-Duplication',
	#tag : 'Model'
}

{ #category : 'settings management' }
MiDuplicationModel class >> availableSourcesCleaners [

	^ FamixRepSourcesCleaner allAvailableCleaners collect: #new
]

{ #category : 'settings management' }
MiDuplicationModel class >> defaultConfiguration [

	^ MiDuplicationSettingsConfiguration new
		  minimumNumberOfLines: self defaultMinimumNumberOfLines;
		  minimumNumberOfCharacters: self defaultMinimumNumberOfCharacters;
		  minimumNumberOfReplicas: self defaultMinimumNumberOfReplicas;
		  sourcesCleaner: self defaultSourcesCleaner;
		  availableSourceCleaners: self availableSourcesCleaners;
		  maximumShownReplicas: self defaultMaximumShownReplicas;
		  yourself
]

{ #category : 'settings management' }
MiDuplicationModel class >> defaultMaximumShownReplicas [

	^ 10
]

{ #category : 'settings management' }
MiDuplicationModel class >> defaultMinimumNumberOfCharacters [

	^ 80
]

{ #category : 'settings management' }
MiDuplicationModel class >> defaultMinimumNumberOfLines [

	^ 10
]

{ #category : 'settings management' }
MiDuplicationModel class >> defaultMinimumNumberOfReplicas [

	^ 2
]

{ #category : 'settings management' }
MiDuplicationModel class >> defaultRepConfiguration [

	^ FamixRepConfiguration
		  sourcesCleaner: self defaultSourcesCleaner
		  minimumNumberOfReplicas: self defaultMinimumNumberOfReplicas
		  ofLines: self defaultMinimumNumberOfLines
		  ofCharacters: self defaultMinimumNumberOfCharacters
]

{ #category : 'settings management' }
MiDuplicationModel class >> defaultSourcesCleaner [

	^ FamixRepCLikeCleaner new
]

{ #category : 'accessing' }
MiDuplicationModel >> allReplicatedFragments [

	^ replicatedFragmentsHierarchy keys
]

{ #category : 'private' }
MiDuplicationModel >> ancestorsOf: aFragment in: aFragmentCollection [

	^ aFragmentCollection select: [ :anotherFragment |
		  self fragment: anotherFragment includes: aFragment ]
]

{ #category : 'api' }
MiDuplicationModel >> childrenFragments: aFragment [

	^ replicatedFragmentsHierarchy at: aFragment
]

{ #category : 'settings management' }
MiDuplicationModel >> currentConfiguration [

	^ MiDuplicationSettingsConfiguration new
		  minimumNumberOfLines: repConfiguration minimumNumberOfLines;
		  minimumNumberOfCharacters: repConfiguration minimumNumberOfCharacters;
		  minimumNumberOfReplicas: repConfiguration minimumNumberOfReplicas;
		  sourcesCleaner: repConfiguration sourcesCleaner;
		  maximumShownReplicas: maximumShownReplicas;
		  availableSourceCleaners: self class availableSourcesCleaners;
		  yourself
]

{ #category : 'settings management' }
MiDuplicationModel >> defaultConfiguration [

	^ self class defaultConfiguration
]

{ #category : 'private' }
MiDuplicationModel >> directParentOf: aFragment in: aFragmentCollection [
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

{ #category : 'accessing' }
MiDuplicationModel >> entities [

	^ entities
]

{ #category : 'accessing' }
MiDuplicationModel >> entities: aCollection [

	entities := aCollection sorted: #name ascending.
	self setConfigurationForEntities
]

{ #category : 'api' }
MiDuplicationModel >> findReplicas [
	"Compute all duplication fragments between all entities"

	entities do: [ :entity | entity replicas removeAll ].

	replicatedFragmentsHierarchy := self hierarchyOfReplicatedFragment:
		                                (self newDetector runOn: entities)
			                                replicatedFragments.

	browser showReplicatedFragments: self rootFragments
]

{ #category : 'private' }
MiDuplicationModel >> fragment: aFragment includes: anotherFragment [

	anotherFragment = aFragment ifTrue: [ ^false ].
	aFragment replicas size <= anotherFragment replicas size ifTrue: [ ^false ].
	((aFragment replicas collect: #entity) includesAll:
					   (anotherFragment replicas collect: #entity)) ifFalse: [ ^false ].
	^ (anotherFragment codeText findString: aFragment codeText) > 0
]

{ #category : 'api' }
MiDuplicationModel >> fragmentsSelection: selectedFragments [
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

{ #category : 'testing' }
MiDuplicationModel >> hasSettings [

	^ true
]

{ #category : 'private' }
MiDuplicationModel >> hierarchyOfReplicatedFragment: aCollectionOfFragments [

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

{ #category : 'api' }
MiDuplicationModel >> highlightEntities: entitiesToHighlight [

	browser selectFragments:
		(entitiesToHighlight flatCollectAsSet: [ :entity | 
			 entity replicas collect: #replicatedFragment ])
]

{ #category : 'initialization' }
MiDuplicationModel >> initialize [

	super initialize.

	entities := #(  ).
	selectedEntities := #(  ).
	replicatedFragmentsHierarchy := Dictionary new.

	self initializeSettings
]

{ #category : 'initialization' }
MiDuplicationModel >> initializeSettings [

	self setConfigurationForEntities.
	maximumShownReplicas := self class defaultMaximumShownReplicas
]

{ #category : 'api' }
MiDuplicationModel >> isSelected: anEntity [

	^ selectedEntities includes: anEntity
]

{ #category : 'accessing' }
MiDuplicationModel >> miSelectedItem [

	^ selectedEntities ifEmpty: [ entities ]
]

{ #category : 'private' }
MiDuplicationModel >> newDetector [

	^ FamixRepDetector new
		  configuration: repConfiguration;
		  yourself
]

{ #category : 'api' }
MiDuplicationModel >> numberOfEntities [

	^ entities size
]

{ #category : 'api' }
MiDuplicationModel >> numberOfEntitiesInReplicas [

	^ (replicatedFragmentsHierarchy keys flatCollectAsSet: [ :fragment |
		   fragment replicas collect: #entity ]) size
]

{ #category : 'api' }
MiDuplicationModel >> numberOfFragments [

	^ replicatedFragmentsHierarchy size
]

{ #category : 'api' }
MiDuplicationModel >> numberOfSelectedEntities [

	^ selectedEntities size
]

{ #category : 'api' }
MiDuplicationModel >> numberOfSelectedFragments [
	^browser lstReplicatedFragments selectedItems size
]

{ #category : 'accessing' }
MiDuplicationModel >> replicatedFragmentsHierarchy [

	^ replicatedFragmentsHierarchy
]

{ #category : 'accessing' }
MiDuplicationModel >> replicatedFragmentsHierarchy: aCollection [

	replicatedFragmentsHierarchy := aCollection
]

{ #category : 'api' }
MiDuplicationModel >> rootFragments [
	"get children of any fragment and reject any fragment in this list "
	| allChildFragments |
	allChildFragments := replicatedFragmentsHierarchy associations flatCollect: #value.

	^ self allReplicatedFragments reject: [ :fragment |
		  allChildFragments includes: fragment ]
]

{ #category : 'accessing' }
MiDuplicationModel >> selectEntities: entityCollection [

	selectedEntities := entityCollection.
	browser updateToolbar
]

{ #category : 'initialization' }
MiDuplicationModel >> setConfigurationForEntities [

	repConfiguration := self class defaultRepConfiguration.

	entities ifNotNil: [
			entities detect: #hasMooseModel ifFound: [ :entity |
					entity mooseModel replicationDetectionConfiguration ifNotNil: [
						:modelConfiguration | repConfiguration := modelConfiguration ] ] ]
]

{ #category : 'settings management' }
MiDuplicationModel >> settingsPresenterExtent [

	^ 425 @ 350
]

{ #category : 'settings management' }
MiDuplicationModel >> updateFromConfiguration: aConfiguration [

	repConfiguration
		minimumNumberOfLines: aConfiguration minimumNumberOfLines;
		minimumNumberOfCharacters: aConfiguration minimumNumberOfCharacters;
		minimumNumberOfReplicas: aConfiguration minimumNumberOfReplicas;
		sourcesCleaner: aConfiguration sourcesCleaner.

	maximumShownReplicas := aConfiguration maximumShownReplicas
]
