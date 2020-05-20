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
MiMooseModelBrowser class >> buildCommandsGroupWith: presenterInstance forRoot: rootCommandGroup [
	rootCommandGroup register: (MiPropagateCommand forSpecContext: presenterInstance).
	rootCommandGroup register: (StInspectorInspectSelectedCommand forSpecContext: presenterInstance)
]

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
	(aBuilder item: #MooseModelBrowser)
		parent: self toolbarMetaName;
		label: 'Moose Model browser';
		icon: (self iconNamed: #mooseNavigation);
		order: 2.0;
		action: [ self runMe ]
]

{ #category : #specs }
MiMooseModelBrowser class >> runMe [
	<script>
	^ super runMe
]

{ #category : #accessing }
MiMooseModelBrowser >> accept: anObject [
	^ anObject isKindOf: MooseModel
]

{ #category : #initialization }
MiMooseModelBrowser >> computeModelPresenterRoot [
	modelPresenter
		roots:
			((model model metamodel classes reject: [ :a | a implementingClass isTrait or: [ (model model allWithSubTypesOf: a implementingClass) isEmpty ] ])
				sorted: #name ascending)
]

{ #category : #initialization }
MiMooseModelBrowser >> followAction [
	((self needUpdate: toSelect) and: [ self accept: toSelect ])
		ifFalse: [ ^ self ].
	model model: toSelect.
	self computeModelPresenterRoot
]

{ #category : #initialization }
MiMooseModelBrowser >> initializePresenters [
	super initializePresenters.
	model := MiMooseModelBrowserModel new.
	self initializeTable.
	"self initializeSearchField."
	modelPresenter
		whenSelectionChangedDo: [ :selected | 
			selected selectedItems size = 1
				ifTrue: [ selected selectedItem isMooseEntity
						ifTrue: [ model selected: selected selectedItem.
							self application globallySelect: selected selectedItem ] ]
				ifFalse: [ (selected selectedItems allSatisfy: #isMooseEntity)
						ifTrue: [ model selected: selected selectedItems.
							self application globallySelect: (MooseGroup withAll: selected selectedItems) ] ] ]
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
		children: [ :class | 
			class isFM3Class
				ifTrue: [ class implementingClass isTrait ifTrue: [ {} ] ifFalse: [ (model model allWithSubTypesOf: class implementingClass) sorted: #name ascending ] ]
				ifFalse: [ {} ] ];
		beResizable;
		beMultipleSelection.
	modelPresenter contextMenu: [ self rootCommandsGroup asMenuPresenter ].
	self computeModelPresenterRoot
]

{ #category : #initialization }
MiMooseModelBrowser >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	aWindowPresenter initialExtent: 600 @ 400
]

{ #category : #initialization }
MiMooseModelBrowser >> miSelectedItem [
	^ modelPresenter selection selectedItem
]

{ #category : #initialization }
MiMooseModelBrowser >> modelPresenter [
	^ modelPresenter
]

{ #category : #initialization }
MiMooseModelBrowser >> needUpdate: anEntity [
	^ model selected ~= anEntity
]

{ #category : #initialization }
MiMooseModelBrowser >> selected [
	^ model selected
]

{ #category : #initialization }
MiMooseModelBrowser >> selectedObject [
	^ modelPresenter selection selectedItem
]

{ #category : #initialization }
MiMooseModelBrowser >> setModelPresenterSelection [
	modelPresenter selectItem: modelPresenter roots first
]

{ #category : #initialization }
MiMooseModelBrowser >> title [
	^ 'MooseModel Browser'
]
