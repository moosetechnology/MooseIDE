Class {
	#name : #MiTreeWidget,
	#superclass : #MiDraggableAbstractWidget,
	#instVars : [
		'tree',
		'whenSelectionChangedDo'
	],
	#category : #'MooseIDE-Tagging-Manager'
}

{ #category : #specs }
MiTreeWidget class >> buildCommandsGroupWith: presenterInstance forRoot: rootCommandGroup [

	rootCommandGroup register:
		(MiPropagateCommand forSpecContext: presenterInstance).
	rootCommandGroup register:
		(MiSystemInspectCommand forSpecContext: presenterInstance).
	
]

{ #category : #specs }
MiTreeWidget class >> defaultSpec [

	^ super defaultSpec
		  add: #tree;
		  yourself
]

{ #category : #opening }
MiTreeWidget >> childrenFor: anEntry [

	self subclassResponsibility
]

{ #category : #opening }
MiTreeWidget >> contextMenu: aBlock [

	tree contextMenu: aBlock
]

{ #category : #opening }
MiTreeWidget >> display: anObject [

	^ anObject displayString
]

{ #category : #opening }
MiTreeWidget >> iconFor: anEntry [

	^ nil
]

{ #category : #opening }
MiTreeWidget >> initializePresenters [

	super initializePresenters.

	tree := self newTreeTable.
	tree beMultipleSelection.
	tree
		contextMenu: [ self rootCommandsGroup asMenuPresenter ];
		whenSelectionChangedDo: [ :e | self selection: e ].
	tree
		addColumn: (SpCompositeTableColumn new
				 title: '';
				 addColumn:
					 ((SpImageTableColumn evaluated: [ :each | self iconFor: each ])
						  width: 20;
						  yourself);
				 addColumn:
				 (SpImageTableColumn evaluated: [ :each | self display: each ]);
				 yourself);
		children: [ :entry | self childrenFor: entry ]
]

{ #category : #opening }
MiTreeWidget >> selection: aSelection [

	whenSelectionChangedDo ifNotNil: [ 
		whenSelectionChangedDo cull: aSelection ].
	super selection: aSelection
]

{ #category : #opening }
MiTreeWidget >> whenSelectionChangedDo: aBlock [

	whenSelectionChangedDo := aBlock
]
