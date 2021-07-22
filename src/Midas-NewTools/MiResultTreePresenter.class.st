"
I am a presenter thas shows the result of the current selected query in a tree presenter.
"
Class {
	#name : #MiResultTreePresenter,
	#superclass : #SpTreeTablePresenter,
	#instVars : [
		'browser',
		'items',
		'sortedEntitiesCache'
	],
	#category : #'Midas-NewTools-Queries Browser widgets'
}

{ #category : #commands }
MiResultTreePresenter class >> buildCommandsGroupWith: presenter forRoot: aCmCommandsGroup [
	aCmCommandsGroup
		register:
			((MiInspectCommand forSpecWithIconNamed: #glamorousInspect)
				context: presenter owner);
		register:
			(MiPropagateCommand new asSpecCommand
				iconName: #moosePropagate;
				context: presenter owner);
		register:
			(MiPropagateCommand new doNotFreezeBrowser asSpecCommand
				iconName: #glamorousRestart;
				name: 'Use as root for queries';
				context: presenter owner).
	(presenter roots includesAll: presenter selectedItems)
		ifTrue: [ aCmCommandsGroup
				register:
					((MiTypeQueryCreationCommand forSpecWithIconNamed: #add)
						context: presenter owner) beHiddenWhenCantBeRun ]
]

{ #category : #accessing }
MiResultTreePresenter class >> headerTitle [
	^ 'Result of current query'
]

{ #category : #initialization }
MiResultTreePresenter >> childrenOf: item [
	^ (self roots includes: item)
		ifTrue: [ sortedEntitiesCache at: item ifAbsentPut: [ item entities sort: #name ascending ] ]
		ifFalse: {}
]

{ #category : #initialization }
MiResultTreePresenter >> initialize [

	super initialize.

	self
		whenRootsChangedDo: [ sortedEntitiesCache := IdentityDictionary new ];
		addColumn: (SpStringTableColumn
				 title: self class headerTitle
				 evaluated: [ :item | self stringForItem: item ]);
		children: [ :item | self childrenOf: item ];
		beMultipleSelection
]

{ #category : #'private - for tests' }
MiResultTreePresenter >> items [
	^ self roots flatCollect: [ :root | self childrenOf: root ]
]

{ #category : #accessing }
MiResultTreePresenter >> miSelectedItem [
	^ (self selectedItems
		collect: [ :item | 
			item isCollection
				ifTrue: [ item entities ]
				ifFalse: [ item ] ]) flattened copyWithoutDuplicates asMooseGroup
]

{ #category : #'accessing - model' }
MiResultTreePresenter >> setModelBeforeInitialization: aBrowser [
	browser := aBrowser
]

{ #category : #naming }
MiResultTreePresenter >> stringForItem: item [
	(self roots includes: item) ifTrue: [ ^ item description ].
	^ item name
]

{ #category : #update }
MiResultTreePresenter >> updateForEntities: entities [
	| groups |
	groups := (entities allEntityTypes
		collect: [ :type | entities allWithType: type ]) asOrderedCollection.
	groups do: [ :group | group description: group details ].
	self
		roots: (groups sort: [ :group | group description onlyLetters ] ascending).
	self update
]

{ #category : #update }
MiResultTreePresenter >> updateForQuery: aQuery [
	self
		updateForEntities:
			(aQuery isValid
				ifTrue: [ aQuery result ]
				ifFalse: [ MooseGroup new ])
]
