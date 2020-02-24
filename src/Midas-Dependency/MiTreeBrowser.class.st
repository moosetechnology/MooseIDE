"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	noteBook:		<Object>
	sourceCodePage:		<Object>
	sourceText:		<Object>


    Implementation Points
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
	(aBuilder item: #TreeBrowser)
		parent: self toolbarDependencyName;
		label: 'Tree browser';
		order: 1.0;
		icon: (self iconNamed: #mooseTree);
		action: [ self runMe ]
]

{ #category : #specs }
MiTreeBrowser class >> runMe [
	<script>
	self new openWithSpec
]

{ #category : #'as yet unclassified' }
MiTreeBrowser >> accept: anObject [
	^ self isNotFreeze and: [ anObject usesFamixTrait: TEntityMetaLevelDependency ]
]

{ #category : #'as yet unclassified' }
MiTreeBrowser >> initializePresenters [
	super initializePresenters.
	self model: MiTreeBrowserModel new.
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
							MiApplication current globallySelect: selected selectedItem ]
						ifFalse: [ | mooseGroup |
							mooseGroup := MooseGroup withAll: selected selectedItems.
							model selected: mooseGroup.
							MiApplication current globallySelect: mooseGroup ] ] ]
]

{ #category : #'as yet unclassified' }
MiTreeBrowser >> refresh [
	tree roots: { self model root }
]

{ #category : #'as yet unclassified' }
MiTreeBrowser >> selectEntity: anEntity [
	(self accept: anEntity)
		ifFalse: [ ^ self ].
	self model selected: anEntity.
	self model root: anEntity.
	self refresh
]

{ #category : #'as yet unclassified' }
MiTreeBrowser >> title [
	^ 'Tree Browser'
]
