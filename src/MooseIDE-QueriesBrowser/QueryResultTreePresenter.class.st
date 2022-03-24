"
I am a presenter thas shows the result of the current selected query in a tree presenter.
"
Class {
	#name : #QueryResultTreePresenter,
	#superclass : #SpTreeTablePresenter,
	#instVars : [
		'sortedEntitiesCache'
	],
	#category : #'MooseIDE-QueriesBrowser-Widgets'
}

{ #category : #commands }
QueryResultTreePresenter class >> buildCommandsGroupWith: presenter forRoot: aCmCommandsGroup [

	aCmCommandsGroup
		register:
			((MiInspectCommand forSpecWithIconNamed: #glamorousInspect) 
				 context: presenter owner);
		register: (MiPropagateCommand new asSpecCommand
				 iconName: #moosePropagate;
				 context: presenter owner);
		register: (MiPropagateCommand new doNotFreezeBrowser asSpecCommand
				 iconName: #glamorousRestart;
				 name: 'Use as root for queries';
				 context: presenter owner)
]

{ #category : #accessing }
QueryResultTreePresenter class >> headerTitle [
	^ 'Result of current query'
]

{ #category : #initialization }
QueryResultTreePresenter >> childrenOf: item [
	^ (self roots includes: item)
		ifTrue: [ sortedEntitiesCache at: item ifAbsentPut: [ item entities sort: #name ascending ] ]
		ifFalse: {}
]

{ #category : #initialization }
QueryResultTreePresenter >> initialize [

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
QueryResultTreePresenter >> items [
	^ self roots flatCollect: [ :root | self childrenOf: root ]
]

{ #category : #accessing }
QueryResultTreePresenter >> miSelectedItem [
	^ (self selectedItems
		collect: [ :item | 
			item isCollection
				ifTrue: [ item entities ]
				ifFalse: [ item ] ]) flattened copyWithoutDuplicates asMooseGroup
]

{ #category : #naming }
QueryResultTreePresenter >> stringForItem: item [
	(self roots includes: item) ifTrue: [ ^ item description ].
	^ item name
]

{ #category : #update }
QueryResultTreePresenter >> updateForEntities: entities [

	| groups |
	groups := (entities allEntityTypes collect: [ :type | 
		           entities allWithType: type ]) asOrderedCollection.
	groups do: [ :group | group description: group details ].
	self roots:
		(groups sort: [ :group | group description onlyLetters ] ascending)
]

{ #category : #update }
QueryResultTreePresenter >> updateForQuery: aQuery [

	self updateForEntities: (aQuery isValid
			 ifTrue: [ aQuery result ]
			 ifFalse: [ MooseGroup new ])
]
