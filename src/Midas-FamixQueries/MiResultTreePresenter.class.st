Class {
	#name : #MiResultTreePresenter,
	#superclass : #SpTreeTablePresenter,
	#instVars : [
		'browser',
		'items',
		'sortedEntitiesCache'
	],
	#category : #'Midas-FamixQueries-Widgets'
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
		addColumn: (SpStringTableColumn title: self class headerTitle evaluated: [ :item | self stringForItem: item ]);
		whenSelectionChangedDo: [ :selection | self updateMenu ];
		children: [ :item | self childrenOf: item ];
		beMultipleSelection
]

{ #category : #accessing }
MiResultTreePresenter >> miSelectedItem [
	^ (self selectedItems
		collect: [ :item | 
			item isCollection
				ifTrue: [ item entities ]
				ifFalse: [ item ] ]) flattened copyWithoutDuplicates asMooseGroup
]

{ #category : #'accessing model' }
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
	groups := (entities allEntityTypes collect: [ :type | entities allWithType: type ]) asOrderedCollection.
	groups do: [ :group | group description: group details ].

	self roots: (groups sort: #description ascending).
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

{ #category : #update }
MiResultTreePresenter >> updateMenu [
	self owner class == MiQueriesBrowser
		ifTrue: [ self contextMenuFromCommandsGroup: [ self rootCommandsGroup ] ]
]
