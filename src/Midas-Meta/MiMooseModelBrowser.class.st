"
Shows entities in a MooseModel grouped by entity type.

- Follow:
Receives a MooseModel.

- Highlight:
<TODO>

- Propagate:
Selected entities of there are some.
<TODO> Improvement: not a collection but a mooseGroup.
"
Class {
	#name : #MiMooseModelBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'modelPresenter',
		'searchField'
	],
	#category : #'Midas-Meta-MooseModelBrowser'
}

{ #category : #specs }
MiMooseModelBrowser class >> defaultSpec [
	^ super defaultSpec
	"	add: #searchField
			withConstraints: [ :constraints | constraints height: self toolbarHeight ];"
		add: #modelPresenter;
		yourself
]

{ #category : #specs }
MiMooseModelBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #MooseModelBrowser)
		parent: self toolbarMetaName;
		label: self title;
		icon: (self iconNamed: #mooseNavigation);
		order: 2.0;
		help: self helpMessage;
		action: [ self runMe ]
]

{ #category : #'instance creation' }
MiMooseModelBrowser class >> mostRecentModel [
	^ self currentApplication defaultBus logger mostRecentEntity
		ifNotNil: [ :entity | entity mooseModel ]
		ifNil: [ MooseModel new ]
]

{ #category : #'instance creation' }
MiMooseModelBrowser class >> newModel [
	^ MiMooseModelBrowserModel model: self mostRecentModel
]

{ #category : #specs }
MiMooseModelBrowser class >> runMe [
	<script>
	^ super runMe
]

{ #category : #initialization }
MiMooseModelBrowser class >> title [
	^ 'MooseModel'
]

{ #category : #specs }
MiMooseModelBrowser class >> windowSize [
	^ 600 @ 400
]

{ #category : #testing }
MiMooseModelBrowser >> accept: anObject [
	^ anObject isKindOf: MooseModel
]

{ #category : #initialization }
MiMooseModelBrowser >> childrenOf: class [
	^ class isFM3Class
		ifTrue: [ class implementingClass isTrait
				ifTrue: [ {} ]
				ifFalse: [ (model model allWithSubTypesOf: class implementingClass)
						sorted: #name ascending ] ]
		ifFalse: [ {} ]
]

{ #category : #initialization }
MiMooseModelBrowser >> computeModelPresenterRoot [
	modelPresenter
		roots:
			((model model metamodel classes
				reject: [ :a | 
					a implementingClass isTrait
						or: [ (model model allWithSubTypesOf: a implementingClass) isEmpty ] ])
				sorted: #name ascending)
]

{ #category : #actions }
MiMooseModelBrowser >> followAction [
	((self needUpdate: toSelect) and: [ self accept: toSelect ])
		ifFalse: [ ^ self ].
	model model: toSelect.
	self computeModelPresenterRoot.
	self updateWindowTitle
]

{ #category : #initialization }
MiMooseModelBrowser >> initializePresenters [
	super initializePresenters.
	self initializeTable.
	"self initializeSearchField."
	modelPresenter
		whenSelectionChangedDo: [ :selected | self selectionAction: selected ]
]

{ #category : #initialization }
MiMooseModelBrowser >> initializeSearchField [
	searchField := self newTextInput
		placeholder: 'TODO: Search...';
		yourself.
	searchField acceptOnCR: true.
	searchField whenTextIsAcceptedDo: [ :text | modelPresenter searchFor: text ]
]

{ #category : #initialization }
MiMooseModelBrowser >> initializeTable [
	| title |
	modelPresenter := self newTreeTable.
	title := 'Source code components'.
	modelPresenter
		addColumn:
			(SpCompositeTableColumn new
				title: title;
				addColumn:
					((SpImageTableColumn evaluated: #midasIcon)
						width: 20;
						yourself);
				addColumn: (SpStringTableColumn evaluated: #name);
				yourself);
		children: [ :class | self childrenOf: class ];
		beResizable;
		beMultipleSelection;
		lazilyComputeChildren;
		contextMenu: [ self rootCommandsGroup asMenuPresenter ].
	self computeModelPresenterRoot
]

{ #category : #accessing }
MiMooseModelBrowser >> miSelectedItem [
	^ modelPresenter selection selectedItem
]

{ #category : #accessing }
MiMooseModelBrowser >> modelPresenter [
	^ modelPresenter
]

{ #category : #testing }
MiMooseModelBrowser >> needUpdate: anEntity [
	^ model selected ~= anEntity
]

{ #category : #accessing }
MiMooseModelBrowser >> selected [
	^ model selected
]

{ #category : #accessing }
MiMooseModelBrowser >> selectedObject [
	^ modelPresenter selection selectedItem
]

{ #category : #actions }
MiMooseModelBrowser >> selectionAction: selection [
	| entities |
	entities := (MooseGroup withAll: selection selectedItems)
		select: #isMooseEntity.
	entities ifEmpty: [ ^ self ].
	model
		selected:
			(entities size = 1
				ifTrue: [ entities anyOne ]
				ifFalse: [ entities ]).
	self buses do: [ :bus | bus globallySelect: model selected ]
]

{ #category : #initialization }
MiMooseModelBrowser >> setModelPresenterSelection [
	modelPresenter selectItem: modelPresenter roots first
]

{ #category : #actions }
MiMooseModelBrowser >> updateWindowTitle [
	self
		withWindowDo:
			[ :window | window title: self class title , ' (' , model model name , ')' ]
]
