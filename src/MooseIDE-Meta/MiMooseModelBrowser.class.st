"
Shows entities in a MooseModel grouped by entity type.

- Follow: Receives a MooseModel.
- Highlight: <TODO>
- Propagate: Selected entities if there are some.
<TODO> Improvement: not a collection but a mooseGroup.
"
Class {
	#name : #MiMooseModelBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'modelPresenter',
		'searchField'
	],
	#category : #'MooseIDE-Meta-MooseModelBrowser'
}

{ #category : #layout }
MiMooseModelBrowser class >> defaultLayout [
	^ super defaultLayout
	"	add: #searchField
			withConstraints: [ :constraints | constraints height: self toolbarHeight ];"
		add: #modelPresenter;
		yourself
]

{ #category : #'world menu' }
MiMooseModelBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #MooseModelBrowser)
		parent: (self metaBrowsersMenuLabel);
		label: (self title);
		icon: (self iconNamed: #mooseNavigation);
		order: 2;
		help: (self helpMessage);
		action: [ self open ]
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

{ #category : #'instance creation' }
MiMooseModelBrowser class >> open [
	<script>
	^ super open
]

{ #category : #specs }
MiMooseModelBrowser class >> title [
	^ 'MooseModel'
]

{ #category : #specs }
MiMooseModelBrowser class >> windowSize [
	^ 600 @ 400
]

{ #category : #testing }
MiMooseModelBrowser >> canFollowEntity: anEntity [

	^ (anEntity isKindOf: MooseModel) and: [ self needUpdate: anEntity ]
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
	model model ifNil: [ ^self ].

	modelPresenter
		roots:
			((model model metamodel classes
				reject: [ :a | 
					a implementingClass isTrait
						or: [ (model model allWithSubTypesOf: a implementingClass) isEmpty ] ])
				sorted: #name ascending)
]

{ #category : #actions }
MiMooseModelBrowser >> followEntity: aMooseModel [

	model model: aMooseModel.
	self computeModelPresenterRoot.
	self updateWindowTitle
]

{ #category : #initialization }
MiMooseModelBrowser >> initializePresenters [

	self initializeTable.
	self initializeSearchField
]

{ #category : #initialization }
MiMooseModelBrowser >> initializeSearchField [

	searchField := self newTextInput
		               placeholder: 'TODO: Search...';
		               yourself.

	searchField whenSubmitDo: [ :text | modelPresenter searchFor: text ]
]

{ #category : #initialization }
MiMooseModelBrowser >> initializeTable [

	| title |
	modelPresenter := self newTreeTable.
	title := 'Source code components'.
	modelPresenter
		addColumn: (SpCompositeTableColumn new
				 title: title;
				 addColumn: ((SpImageTableColumn evaluated: #midasIcon)
						  width: 20;
						  yourself);
				 addColumn: (SpStringTableColumn evaluated: #name);
				 yourself);
		children: [ :class | self childrenOf: class ];
		beResizable;
		beMultipleSelection;
		lazilyComputeChildren;
		contextMenu: [ 
			(self rootCommandsGroup commandOrGroupNamed: 'Actions') beRoot
				asMenuPresenter ].
	self computeModelPresenterRoot.
	modelPresenter whenSelectedItemChangedDo: [ :selectedItem | 
		self selectionAction: selectedItem ]
]

{ #category : #accessing }
MiMooseModelBrowser >> miSelectedItem [

	^ model selected
]

{ #category : #accessing }
MiMooseModelBrowser >> modelPresenter [
	^ modelPresenter
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
MiMooseModelBrowser >> selectionAction: selectedItem [

	| entities |
	entities := selectedItem isFM3Class
		            ifTrue: [ 
		            model model allMatching: selectedItem implementingClass ]
		            ifFalse: [ 
		            selectedItem asMooseGroup select: #isMooseEntity ].
	entities ifEmpty: [ ^ self ].

	model selected: entities mooseInterestingEntity.

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
