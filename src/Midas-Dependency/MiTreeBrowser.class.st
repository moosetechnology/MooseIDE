"
Shows the containment tree (direct relations for now) between the entities.

- Follow: Accepts a MooseEntity using TEntityMetaLevelDependency.
- Highlight: Entities if present.
- Propagate: <TODO>
"
Class {
	#name : #MiTreeBrowser,
	#superclass : #MiAbstractDependencyBrowser,
	#instVars : [
		'tree'
	],
	#category : #'Midas-Dependency-Tree'
}

{ #category : #specs }
MiTreeBrowser class >> defaultSpec [
	^ super defaultSpec
		add: #tree;
		yourself
]

{ #category : #specs }
MiTreeBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #TreeBrowser)
		parent: self toolbarDependencyName;
		label: self title;
		order: 1.0;
		icon: (self iconNamed: #mooseTree);
		help: self helpMessage;
		action: [ self runMe ]
]

{ #category : #'as yet unclassified' }
MiTreeBrowser class >> newModel [
	^ MiTreeBrowserModel new
]

{ #category : #specs }
MiTreeBrowser class >> runMe [
	<script>
	^ super runMe
]

{ #category : #'as yet unclassified' }
MiTreeBrowser class >> title [
	^ 'Tree'
]

{ #category : #'as yet unclassified' }
MiTreeBrowser >> accept: anObject [
	^ anObject usesFamixTrait: TEntityMetaLevelDependency
]

{ #category : #'as yet unclassified' }
MiTreeBrowser >> followAction [
	(self accept: toSelect)
		ifFalse: [ ^ self ].
	self model selected: toSelect.
	self model root: toSelect.
	self refresh
]

{ #category : #'as yet unclassified' }
MiTreeBrowser >> initialize [
	super initialize.
	model := MiTreeBrowserModel new
]

{ #category : #'as yet unclassified' }
MiTreeBrowser >> initializePresenters [
	super initializePresenters.
	tree := self newTreeTable.
	tree
		addColumn:
			(SpCompositeTableColumn new
				addColumn:
					((SpImageTableColumn evaluated: #midasIcon)
						width: 20;
						yourself);
				addColumn: (SpStringTableColumn evaluated: #name);
				yourself);
		children: [ :aClass | aClass children asOrderedCollection ];
		beMultipleSelection;
		beResizable.
	tree
		whenSelectionChangedDo: [ :selected | 
			self
				freezeDuring: [ selected selectedItems size = 1
						ifTrue: [ model selected: selected selectedItem.
							self buses
								do: [ :bus | bus globallySelect: selected selectedItem ] ]
						ifFalse: [ | mooseGroup |
							mooseGroup := MooseGroup withAll: selected selectedItems.
							model selected: mooseGroup.
							self buses do: [ :bus | bus globallySelect: mooseGroup ] ] ] ]
]

{ #category : #'as yet unclassified' }
MiTreeBrowser >> refresh [
	tree roots: { self model root }
]
