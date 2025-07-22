"
I am a presenter thas shows the result of the current selected query in a tree presenter.
"
Class {
	#name : 'MiMooseGroupsTreeTablePresenter',
	#superclass : 'SpTreeTablePresenter',
	#instVars : [
		'sortedEntitiesCache',
		'headerTitle',
		'childrenSortingBlock',
		'extensionMenuItems',
		'manageNodesFromMenu'
	],
	#category : 'MooseIDE-Core-Widgets',
	#package : 'MooseIDE-Core',
	#tag : 'Widgets'
}

{ #category : 'commands' }
MiMooseGroupsTreeTablePresenter class >> buildCommandsGroupWith: presenterInstance forRoot: aCmCommandsGroup [

	aCmCommandsGroup register:
		(MiInspectCommand forSpecContext: presenterInstance)
]

{ #category : 'menu' }
MiMooseGroupsTreeTablePresenter >> addExtensionMenugroupIn: aContextMenu [

	extensionMenuItems ifEmpty: [ ^ self ].

	aContextMenu addGroup: [ :group |
		extensionMenuItems do: [ :item | group addItem: item ] ]
]

{ #category : 'api' }
MiMooseGroupsTreeTablePresenter >> addMenuItem: aBlockOrMenuItem [

	extensionMenuItems add: aBlockOrMenuItem
]

{ #category : 'menu' }
MiMooseGroupsTreeTablePresenter >> addNodesManagementMenuGroupIn: aContextMenu [

	manageNodesFromMenu ifFalse: [ ^ self ].

	aContextMenu addGroup: [ :group |
		group
			addItem: [ :item |
				item
					name: 'Collapse all';
					icon: self theme treeUnexpandedForm;
					action: [ self collapseAll ] ];
			addItem: [ :item |
				item
					name: 'Expand all';
					icon: self theme treeExpandedForm;
					action: [ self expandAll ] ] ]
]

{ #category : 'testing' }
MiMooseGroupsTreeTablePresenter >> canPropagate [

	^ true
]

{ #category : 'accessing' }
MiMooseGroupsTreeTablePresenter >> childrenSortingBlock [

	^ childrenSortingBlock ifNil: [ #displayString ascending ]
]

{ #category : 'accessing' }
MiMooseGroupsTreeTablePresenter >> childrenSortingBlock: aBlock [

	childrenSortingBlock := aBlock
]

{ #category : 'api' }
MiMooseGroupsTreeTablePresenter >> displayIcon: aValuable [

	columns := columns copyWithFirst: (SpImageTableColumn new
			            evaluated: aValuable;
			            width: 35;
			            yourself)
]

{ #category : 'initialization' }
MiMooseGroupsTreeTablePresenter >> initialize [

	super initialize.

	self addColumn:
		(SpStringTableColumn evaluated: [ :item | self stringForItem: item ]).

	self initializeChildrenBlock.
	self beMultipleSelection.
	self initializeContextMenu.
	self setDoubleClickInspect.
	self hideColumnHeaders.

	self whenRootsChangedDo: [ self resetEntitiesCache ].

	manageNodesFromMenu := false
]

{ #category : 'initialization' }
MiMooseGroupsTreeTablePresenter >> initializeChildrenBlock [

	self children: [ :item |
		(self roots includes: item)
			ifTrue: [
				sortedEntitiesCache
					at: item
					ifAbsentPut: [ item entities sort: self childrenSortingBlock ] ]
			ifFalse: [ {  } ] ]
]

{ #category : 'initialization' }
MiMooseGroupsTreeTablePresenter >> initializeContextMenu [

	self contextMenu: [
		| menu |
		menu := self rootCommandsGroup asMenuPresenter.
		self addNodesManagementMenuGroupIn: menu.
		self addExtensionMenugroupIn: menu.
		menu ].

	extensionMenuItems := OrderedCollection new
]

{ #category : 'menu' }
MiMooseGroupsTreeTablePresenter >> manageNodesFromMenu [

	manageNodesFromMenu := true
]

{ #category : 'as yet unclassified' }
MiMooseGroupsTreeTablePresenter >> miInspect [

	self selectedItem miInspect
]

{ #category : 'as yet unclassified' }
MiMooseGroupsTreeTablePresenter >> miPropagate [

	self selectedItem miPropagate
]

{ #category : 'accessing' }
MiMooseGroupsTreeTablePresenter >> miSelectedItem [

	^ self selectedItem ifNil: [ {  } ]
]

{ #category : 'update' }
MiMooseGroupsTreeTablePresenter >> resetEntitiesCache [

	^ sortedEntitiesCache := IdentityDictionary new
]

{ #category : 'accessing' }
MiMooseGroupsTreeTablePresenter >> rootBrowser [

	^ owner rootBrowser
]

{ #category : 'initialization' }
MiMooseGroupsTreeTablePresenter >> setDoubleClickInspect [

	self
		activateOnDoubleClick;
		whenActivatedDo: [ :each | each selectedItem miInspect ]
]

{ #category : 'naming' }
MiMooseGroupsTreeTablePresenter >> stringForItem: item [

	(self roots includes: item) ifTrue: [ ^ item description ].

	^ item displayString
]

{ #category : 'update' }
MiMooseGroupsTreeTablePresenter >> updateForEntities: entities [

	| groups |
	groups := (entities allEntityTypes collect: [ :type |
		           entities allWithType: type ]) asOrderedCollection.

	groups do: [ :group | group description: group details ].

	self roots:
		(groups sort: [ :group | group description onlyLetters ] ascending)
]
