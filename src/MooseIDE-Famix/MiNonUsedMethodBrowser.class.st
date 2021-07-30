"
Shows dead methods contained in an entity.

- Follow: Receives a MooseEntity.
- Highlight: <TODO> Methods if present.
- Propagate: <TODO>
"
Class {
	#name : #MiNonUsedMethodBrowser,
	#superclass : #MiAbstractFamixBrowser,
	#instVars : [
		'diagram',
		'view'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #specs }
MiNonUsedMethodBrowser class >> defaultSpec [
	^ super defaultSpec
		add: #diagram;
		yourself
]

{ #category : #specs }
MiNonUsedMethodBrowser class >> launchOn: anObject [
	^ self new
		selected: anObject;
		openWithSpec
]

{ #category : #specs }
MiNonUsedMethodBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #NonUsedMethodBrowser)
		parent: (self toolbarFamixName);
		label: (self title);
		order: 2;
		help: (self helpMessage);
		action: [ self runMe ]
]

{ #category : #specs }
MiNonUsedMethodBrowser class >> runMe [
	<script>
	^ super runMe
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser class >> title [
	^ 'Dead methods'
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
				color: self theme selectionColor.
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
MiNonUsedMethodBrowser >> followAction [
	((self accept: toSelect) and: (self needUpdate: toSelect))
		ifFalse: [ ^ self ].
	model selected: toSelect.
	self updateWindowTitle.
	self refresh
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
MiNonUsedMethodBrowser >> selected [
	^ model selected
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> selected: aFamixWithMethod [
	model selected: aFamixWithMethod
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser >> updateWindowTitle [
	self
		withWindowDo:
			[ :window | window title: self class title , ' in ' , self selected name ]
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
