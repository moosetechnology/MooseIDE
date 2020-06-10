Class {
	#name : #MiResultTreePresenter,
	#superclass : #SpTreeTablePresenter,
	#instVars : [
		'browser',
		'items'
	],
	#category : #'Midas-FamixQueries-Widgets'
}

{ #category : #commands }
MiResultTreePresenter class >> buildCommandsGroupWith: presenter forRoot: aCmCommandsGroup [
	aCmCommandsGroup
		register:
			((MiInspectCommand forSpecWithIconNamed: #glamorousInspect)
				context: presenter);
		register:
			((MiPropagateCommand forSpecWithIconNamed: #moosePropagate)
				context: presenter);
		register:
			((MiTypeQueryCreationCommand forSpecWithIconNamed: #add)
				context: presenter) beHiddenWhenCantBeRun
]

{ #category : #accessing }
MiResultTreePresenter class >> headerTitle [
	^ 'Result of current query'
]

{ #category : #testing }
MiResultTreePresenter >> canCreateQueries [
	^ owner == browser
]

{ #category : #initialization }
MiResultTreePresenter >> childrenOf: item [
	^ (self roots includes: item)
		ifTrue: [ item entities sort: #name ascending ]
		ifFalse: {}
]

{ #category : #action }
MiResultTreePresenter >> createQueryForType: aClass [
	browser
		updateForQuery:
			(FQTypeQuery new
				type: aClass;
				beChildOf: browser selectedQuery)
]

{ #category : #action }
MiResultTreePresenter >> createQueryForTypes: classes [
	| newTypeQuery |
	newTypeQuery := FQTypeQuery new beChildOf: browser selectedQuery.
	classes do: [ :aClass | newTypeQuery type: aClass ].
	browser updateForQuery: newTypeQuery
]

{ #category : #action }
MiResultTreePresenter >> createTypeQuery [
	^ self
		createQueryForTypes: (self selectedItems flatten collect: #class) copyWithoutDuplicates
]

{ #category : #initialization }
MiResultTreePresenter >> initialize [
	super initialize.
	"self lazilyComputeChildren"	"useful in case of slowdown. See implementor"
	self
		addColumn:
			((SpCompositeTableColumn new title: self class headerTitle)
				addColumn:
					(SpStringTableColumn new
						evaluated: [ :item | self stringForItem: item ]));
		whenSelectionChangedDo: [ :selection | self updateMenu ];
		children: [ :item | self childrenOf: item ];
		beMultipleSelection
]

{ #category : #accessing }
MiResultTreePresenter >> items [
	^ items ifNil: [ items := MooseGroup new ]
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
	(self roots includes: item)
		ifTrue: [ ^ item details ].
	^ item name
]

{ #category : #update }
MiResultTreePresenter >> updateForEntities: entities [
	items := entities.
	self
		roots:
			(((entities collectAsSet: #class)
				collect:
					[ :type | (items select: [ :entity | entity class == type ]) asMooseGroup ])
				asOrderedCollection
				sort: [ :root | root commonSuperclass name ] ascending).
	self update
]

{ #category : #update }
MiResultTreePresenter >> updateMenu [
	self contextMenuFromCommandsGroup: [ self rootCommandsGroup ]
]
