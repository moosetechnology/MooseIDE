"
Shows the containment tree (direct relations for now) between the entities.

- Accepted entities: a MooseEntity using TEntityMetaLevelDependency.
- Highlight: Entities if present.
- Propagate: <TODO>
"
Class {
	#name : #MiTreeBrowser,
	#superclass : #MiAbstractDependencyBrowser,
	#instVars : [
		'tree'
	],
	#category : #'MooseIDE-Dependency-Tree'
}

{ #category : #layout }
MiTreeBrowser class >> defaultLayout [
	^ super defaultLayout
		add: #tree;
		yourself
]

{ #category : #'world menu' }
MiTreeBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiTreeBrowser class >> menuIconName [

	^ #mooseTree
]

{ #category : #'world menu' }
MiTreeBrowser class >> menuItem [

	^ #TreeBrowser
]

{ #category : #'world menu' }
MiTreeBrowser class >> menuParent [

	^ self dependencyMenuRoot
]

{ #category : #'world menu' }
MiTreeBrowser class >> menuPriority [

	^ 1.0
]

{ #category : #'instance creation' }
MiTreeBrowser class >> newModel [

	^ MiTreeBrowserModel new
]

{ #category : #'instance creation' }
MiTreeBrowser class >> open [
	<script>
	^ super open
]

{ #category : #specs }
MiTreeBrowser class >> title [

	^ 'Tree'
]

{ #category : #testing }
MiTreeBrowser >> canFollowEntity: anObject [

	^ anObject usesFamixTrait: TEntityMetaLevelDependency
]

{ #category : #testing }
MiTreeBrowser >> canTagEntities [ 
	self flag: 'Remove browser ? (issue #810)'.
	^false
]

{ #category : #actions }
MiTreeBrowser >> followEntity: anEntity [

	self model root: anEntity.
	self model selected: anEntity.

	self refreshTree
]

{ #category : #initialization }
MiTreeBrowser >> initializePresenters [

	tree := self newTreeTable.
	tree
		addColumn: (SpCompositeTableColumn new
				 addColumn: ((SpImageTableColumn evaluated: #midasIcon)
						  width: 20;
						  yourself);
				 addColumn: (SpStringTableColumn evaluated: #name);
				 yourself);
		children: [ :aClass | aClass children asOrderedCollection ];
		beMultipleSelection;
		beResizable.
	tree whenSelectedItemChangedDo: [ :entityOrGroup | 
		self freezeDuring: [ 
			specModel selected: entityOrGroup mooseInterestingEntity.
			self buses do: [ :bus | bus globallySelect: entityOrGroup ] ] ]
]

{ #category : #accessing }
MiTreeBrowser >> miSelectedItem [

	^ specModel selected
]

{ #category : #actions }
MiTreeBrowser >> refreshTree [

	tree
		roots: { self model root };
		expandPath: #( 1 ).

	self freezeDuring: [ tree selectItem: specModel root ]
]
