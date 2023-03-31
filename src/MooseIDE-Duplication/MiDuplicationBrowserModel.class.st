"
The model behing the Duplication Browser

Instance variables:
- #entities among which to search for code clones
- #replicas -- list of clones found
"
Class {
	#name : #MiDuplicationBrowserModel,
	#superclass : #MiAbstractModel,
	#instVars : [
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

{ #category : #settings }
MiDuplicationBrowserModel >> codeCleanerClass [
	^#codeCleanerClass
]

{ #category : #private }
MiDuplicationBrowserModel >> currentMooseModel [
	^self entities
		ifEmpty: [ nil ]
		ifNotEmpty: [ :list | list anyOne mooseModel]
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

	entities := aCollection asCollection sorted: [ :a :b |
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
		(entitiesToHighlight flatCollectAsSet: [ :entity | 
			 entity replicas collect: #replicatedFragment ])
]

{ #category : #initialization }
MiDuplicationBrowserModel >> initialize [

	entities := #(  ).
	selectedEntities := #().
	replicatedFragmentsHierarchy := Dictionary new.

	self initializeSettings 
]

{ #category : #initialization }
MiDuplicationBrowserModel >> initializeSettings [ 
	settings := super initializeSettings
		addItem: self itemMinNumberOfLines 		named: self minNumberOfLines ;
		addItem: self itemMinNumberOfCharacters named: self minNumberOfCharacters ;
		addItem: self itemMinNumberOfReplicas 	named: self minNumberOfReplicas ;
		addItem: self itemCodeCleanerClass 		named: self codeCleanerClass ;
		addItem: self itemMaxReplicasShowed 		named: self maxReplicasShowed ;
		yourself
	
]

{ #category : #api }
MiDuplicationBrowserModel >> isSelected: anEntity [
	^selectedEntities includes: anEntity 
]

{ #category : #settings }
MiDuplicationBrowserModel >> itemCodeCleanerClass [
	^MiAbstractSettingItem droplistSetting
		possibleValues: FamixRepSourcesCleaner allAvailableCleaners ;
		setValue: FamixRepCLikeCleaner ;
		label: 'Code cleaning startegy' ;
		help: 'The cleaner used to clean the code before detecting duplication. The cleaner removes extra whitespaces and/or comments. Cleaners are programming language specific.' ;
		yourself
]

{ #category : #settings }
MiDuplicationBrowserModel >> itemMaxReplicasShowed [
	^MiAbstractSettingItem integerSetting
		setValue: 10 ;
		label: 'Maximum number of tab shown' ;
		help: 'Maximum number of entities shown in the browser. If a code snippet is duplicated too many times, will only show that much occurences.' ;
		yourself
]

{ #category : #settings }
MiDuplicationBrowserModel >> itemMinNumberOfCharacters [
	^MiAbstractSettingItem integerSetting
		setValue: 80 ;
		label: 'Minimum number of character' ;
		help: 'Minimum number of characters in duplicated fragment. Code fragments that are too small are not interesting.' ;
		yourself
]

{ #category : #settings }
MiDuplicationBrowserModel >> itemMinNumberOfLines [
	^MiAbstractSettingItem integerSetting
		setValue: 10 ;
		label: 'Minimum number of line' ;
		help: 'Minimum number of lines of code in a duplicated code snipet. The larger, the less duplicated snippets found.' ;
		yourself
]

{ #category : #settings }
MiDuplicationBrowserModel >> itemMinNumberOfReplicas [
	^MiAbstractSettingItem integerSetting
		setValue: 2 ;
		label: 'Minimum number of replica' ;
		help: 'The minimum number of times a code snippet is duplicated. Cannot be less than 2. The larger, the less duplicated snippets found.' ;
		yourself
]

{ #category : #settings }
MiDuplicationBrowserModel >> maxReplicasShowed [
	^#maxReplicasShowed
]

{ #category : #settings }
MiDuplicationBrowserModel >> minNumberOfCharacters [
	^#minNumberOfCharacters
]

{ #category : #settings }
MiDuplicationBrowserModel >> minNumberOfLines [
	^#minNumberOfLines
]

{ #category : #settings }
MiDuplicationBrowserModel >> minNumberOfReplicas [
	^#minNumberOfReplicas
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
		  minimumNumberOfReplicas: (settings getItemValue: self minNumberOfReplicas) ;
		  minimumNumberOfLines: (settings getItemValue: self minNumberOfLines) ;
		  minimumNumberOfCharacters: (settings getItemValue: self minNumberOfCharacters) ;
		  sourcesCleaner: (settings getItemValue: self codeCleanerClass) new;
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

{ #category : #accessing }
MiDuplicationBrowserModel >> openSettings [ 
	settings open
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
MiDuplicationBrowserModel >> selectedFragments: selectedFragments [

	| allReplicas |
	allReplicas := selectedFragments flatCollect: #replicas.
	allReplicas size > (settings getItemValue: self maxReplicasShowed)
		ifTrue: [ allReplicas first: (settings getItemValue: self maxReplicasShowed) ]
		ifFalse: [ allReplicas ].

	self selectedEntities:
		(allReplicas collectAsSet: #entity) asMooseGroup.
	browser showReplicas: allReplicas
]

{ #category : #accessing }
MiDuplicationBrowserModel >> settings [

	^ settings
]
