Class {
	#name : #MiNonUsedMethodBrowser,
	#superclass : #MiAbstractFamixBrowser,
	#instVars : [
		'diagram',
		'view'
	],
	#category : #'Midas-Famix-SourceText'
}

{ #category : #specs }
MiNonUsedMethodBrowser class >> defaultSpec [
	^ super defaultSpec
		add: #diagram;
		yourself
]

{ #category : #specs }
MiNonUsedMethodBrowser class >> lunchOn: anObject [
	^ self new
		selected: anObject;
		openWithSpec
]

{ #category : #specs }
MiNonUsedMethodBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #NonUsedMethodBrowser)
		parent: self toolbarFamixName;
		label: 'Non used method browser';
		action: [ self runMe ]
]

{ #category : #specs }
MiNonUsedMethodBrowser class >> runMe [
	<script>
	self new openWithSpec
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> accept: anObject [
	^ anObject usesFamixTrait: FamixTWithMethods
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> diagram [
	^ diagram
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> diagram: anObject [
	diagram := anObject
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> drawOn: aCanvas [
	| boxes |
	boxes := self model model
		collect: [ :ent | 
			| box label composite |
			box := RSBox new
				size: 100;
				color: Color blue.
			label := RSLabel new
				text: ent name;
				color: self theme textColor.
			RSLocation new
				above;
				move: box on: label.
			composite := RSComposite new.
			composite
				shapes: {label . box};
				model: ent.
			composite @ RSDraggable.
			composite ].
	aCanvas addAll: boxes.
	RSGridLayout on: boxes.
	aCanvas @ RSCanvasController.
	^ aCanvas
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> initializeDiagram [
	diagram
		script: [ :canvas | 
			canvas color: self theme backgroundColor.
			self drawOn: canvas ]
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> initializePresenters [
	super initializePresenters.
	model := MiNonUsedFunctionBrowserModel new.
	diagram := self instantiate: SpRoassalPresenter.
	diagram script: [ :canvas | canvas color: self theme backgroundColor ].
	self refresh
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> refresh [
	model model
		ifNotEmpty: [ self initializeDiagram.
			diagram refresh ].
	self needRebuild: false.
	self buildWithSpec
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> selectEntity: anEntity [
	((self accept: anEntity)
		and: ((self needUpdate: anEntity) and: self isNotFreeze))
		ifFalse: [ ^ self ].
	model selected: anEntity.
	self refresh
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> selected [
	^ model selected
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> selected: aFamixWithMethod [
	model selected: aFamixWithMethod
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> title [
	^ 'Dead methods Browser'
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> view [
	^ view
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> view: anObject [
	view := anObject
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> zoomIn [
	RTZoomInMove on: view
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> zoomOut [
	RTZoomOutMove on: view
]
