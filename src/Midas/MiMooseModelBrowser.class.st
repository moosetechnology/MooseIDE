Class {
	#name : #MiMooseModelBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'modelPresenter',
		'searchField'
	],
	#category : #'Midas-MooseModelBrowser'
}

{ #category : #specs }
MiMooseModelBrowser class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #searchField
			withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		add: #modelPresenter;
		yourself
]

{ #category : #specs }
MiMooseModelBrowser class >> runMe [
	<script>
	self new openWithSpec
]

{ #category : #accessing }
MiMooseModelBrowser >> accept: anObject [
	^ anObject isKindOf: MooseModel
]

{ #category : #initialization }
MiMooseModelBrowser >> initializePresenters [
	model := MiMooseModelBrowserModel new.
	self initializeTable.
	self initializeSearchField.
	modelPresenter
		whenSelectionChangedDo: [ :selected | 
			model selected: selected selectedItem.
			self application globallySelect: selected selectedItem ].
	searchField
		whenTextIsAcceptedDo: [ :text | modelPresenter searchFor: text ]
]

{ #category : #initialization }
MiMooseModelBrowser >> initializeSearchField [
	searchField := self newTextInput
		placeholder: 'Search...';
		yourself.
	searchField acceptOnCR: true
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
					((SpImageTableColumn evaluated: #systemIcon)
						width: 20;
						yourself);
				addColumn: (SpStringTableColumn evaluated: #name);
				yourself);
		roots: model model entities;
		"children: [ :elt | elt content ];"
		beResizable
]

{ #category : #initialization }
MiMooseModelBrowser >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	aWindowPresenter initialExtent: 600 @ 400
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
MiMooseModelBrowser >> selectEntity: anEntity [
	((self needUpdate: anEntity) and: [ self accept: anEntity ])
		ifFalse: [ ^ self ].
	modelPresenter selectItem: anEntity
	"self needRebuild: false.
	self buildWithSpec"
]

{ #category : #initialization }
MiMooseModelBrowser >> selected [
	^ model selected
]

{ #category : #initialization }
MiMooseModelBrowser >> setModelPresenterSelection [
	modelPresenter selectItem: modelPresenter roots first
]

{ #category : #initialization }
MiMooseModelBrowser >> title [
	^ 'MooseModel Browser'
]
