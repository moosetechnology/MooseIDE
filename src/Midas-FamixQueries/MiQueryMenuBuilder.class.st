Class {
	#name : #MiQueryMenuBuilder,
	#superclass : #Object,
	#instVars : [
		'browser',
		'showPropagate'
	],
	#category : #'Midas-FamixQueries-Tools'
}

{ #category : #'instance creation' }
MiQueryMenuBuilder class >> on: aBrowser [
	^ self new
		browser: aBrowser;
		yourself
]

{ #category : #accessing }
MiQueryMenuBuilder >> browser: aBrowser [
	browser := aBrowser
]

{ #category : #building }
MiQueryMenuBuilder >> buildAdditionalItemsIn: aMenu [
	aMenu
		addItem: [ :item | 
			item
				description: 'Inspect query';
				icon: (self iconNamed: #glamorousInspect);
				action: [ browser selectedQuery inspect ] ];
		addItem: [ :item | 
			item
				description: 'Save this query';
				icon: (self iconNamed: #smallSave);
				action: [ (MiAddQueryToLibraryCommand forContext: browser) execute ] ];
		addItem: [ :item | 
			item
				description: 'Save this query sequence';
				icon: (self iconNamed: #smallSave);
				action: [ (MiAddQuerySequenceToLibraryCommand forContext: browser) execute ] ];
		addItem: [ :item | 
			item
				description: 'Remove this query';
				icon: (self iconNamed: #remove);
				action: [ browser removeSelectedQuery ] ]
]

{ #category : #building }
MiQueryMenuBuilder >> buildCommonItemsIn: aMenu [
	aMenu
		addItem: [ :item | 
			item
				description: 'Create a new query after this one';
				icon: (self iconNamed: #add);
				action: [ browser openQueryCreationPresenter ] ];
		addItem: [ :item | 
			item
				name: 'Create query from Library';
				description: 'Choose a query in library';
				subMenu: (aMenu newMenu addGroup: [ :aGroup | self librarySubMenu: aGroup ]) ];
		addItem: [ :item | 
			item
				description: 'Inspect result';
				icon: (self iconNamed: #glamorousInspect);
				action: [ browser selectedQuery result inspect ] ].
	showPropagate
		ifTrue: [ aMenu
				addItem: [ :item | 
					item
						description: 'Propagate result';
						icon: (self iconNamed: #moosePropagate);
						action: [ (MiPropagateCommand forContext: browser) execute ] ] ]
]

{ #category : #building }
MiQueryMenuBuilder >> buildMenu: aMenu [
	self buildCommonItemsIn: aMenu.
	browser selectedQuery isRootQuery
		ifFalse: [ self buildAdditionalItemsIn: aMenu ].
	^ aMenu
]

{ #category : #initialization }
MiQueryMenuBuilder >> initialize [
	super initialize.
	showPropagate := true
]

{ #category : #building }
MiQueryMenuBuilder >> librarySubMenu: aGroup [
	FQQueriesLibrary current savedQueriesNames
		do: [ :name | 
			aGroup
				addItem: [ :item | 
					item
						name: name;
						action: [ browser
								updateForQuery:
									((FQQueriesLibrary current createQueryNamed: name)
										name: name;
										beChildOf: browser selectedQuery) ] ] ]
]

{ #category : #'instance creation' }
MiQueryMenuBuilder >> newMenu [
	| menu |
	menu := self buildMenu: SpMenuPresenter new.
	menu defaultGroup menuItems
		do: [ :item | item name ifEmpty: [ item name: item description ] ].
	^ menu
]

{ #category : #'instance creation' }
MiQueryMenuBuilder >> newMenuBar [
	self noPropagateButton.
	^ self buildMenu: (browser instantiate: SpMenuBarPresenter)
]

{ #category : #building }
MiQueryMenuBuilder >> noPropagateButton [
	showPropagate := false
]
