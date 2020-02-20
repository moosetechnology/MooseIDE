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
	^ SpBoxLayout newVertical
		"position: 90 percent;"
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
				box := RSBox new size: 100.
					label := RSLabel new text: ent name.
					RSLocation new
						above;
						move: box on: label.
					composite := RSComposite new.
					composite
						shapes: {label . box};
						model: ent.
					composite @ RSDraggable.
					composite
				 ].
	aCanvas addAll: boxes.
	RSGridLayout on: boxes.
	aCanvas @ RSCanvasController.
	^ aCanvas
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> initializeDiagram [
	diagram := self instantiate: SpRoassalPresenter.
	diagram script: [ :canvas | self drawOn: canvas ]
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> initializePresenters [
	model := MiNonUsedFunctionBrowserModel new.
	self refresh
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> refresh [
	model model isEmpty
		ifTrue: [ diagram := self instantiate: RoassalModel
			"diagram := self newNullPresenter" ]
		ifFalse: [ self initializeDiagram ].
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
