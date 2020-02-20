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
MiNonUsedMethodBrowser >> drawOn: aView [
	| es |
	aView @ RTDraggableView @ RTZoomableView.
	es := (RTBox new
		size: 15;
		color: Color gray) elementsOn: model model.
	aView addAll: es.
	es @ RTDraggable.
	es
		@
			(RTLabeled new
				fontSize: 5;
				top;
				text: [ :method | 
					(method parentType
						ifNotNil: [ method parentType name , '.' ]
						ifNil: [ '' ]) , method name ]).
	RTMetricNormalizer new
		elements: es;
		normalizeSize: #numberOfLinesOfCode.
	RTCircleLayout new on: aView elements.
	^ aView build
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> gloup [
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> initializeDiagram [
	diagram := self instantiate: RoassalModel.
	diagram
		script: [ :aView :canvas | 
			self drawOn: aView.
			view := aView.
			aView canvas focusOnCenterScaled ]
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
