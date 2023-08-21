Class {
	#name : #MiLayerVisualizationBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'visualization'
	],
	#category : #'MooseIDE-LayerVisualization-Presenters'
}

{ #category : #'world menu' }
MiLayerVisualizationBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiLayerVisualizationBrowser class >> menuItem [

	^ #MiLayerVisualizationBrowser
]

{ #category : #'world menu' }
MiLayerVisualizationBrowser class >> menuPriority [

	^ self menuVisualizationToolsPriority + 1
]

{ #category : #'world menu' }
MiLayerVisualizationBrowser class >> title [

	^ 'Layer visualization'
]

{ #category : #'instance creation' }
MiLayerVisualizationBrowser class >> visualizationBuilder [

	^ MiLayerVisualizationBuilder new
]

{ #category : #testing }
MiLayerVisualizationBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject
]

{ #category : #actions }
MiLayerVisualizationBrowser >> followEntity: anEntity [

	| mooseModel modelClass |
	mooseModel := anEntity isMooseModel
		              ifTrue: [ anEntity ]
		              ifFalse: [ anEntity mooseModel ].

	modelClass := MiLayerVisualizationModel findModelApplicableTo:
		              mooseModel.
	modelClass ifNil: [ ^ self ].
	specModel := modelClass new
		             browser: self;
		             yourself.
	specModel followEntity: anEntity
]

{ #category : #initialization }
MiLayerVisualizationBrowser >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: visualization;
			 yourself)
]

{ #category : #initialization }
MiLayerVisualizationBrowser >> initializePresenters [

	visualization := self instantiate: MiLayerVisualization.
	self initializeLayout
]

{ #category : #accessing }
MiLayerVisualizationBrowser >> initializeWindow: aMiWindowPresenter [

	super initializeWindow: aMiWindowPresenter.
	aMiWindowPresenter initialExtent: self currentWorld extent
]

{ #category : #accessing }
MiLayerVisualizationBrowser >> miSelectedItem [

	^ nil
]

{ #category : #actions }
MiLayerVisualizationBrowser >> runVisualization [

	| builder |
	builder := self class visualizationBuilder
		           mapModel: self model;
		           container: visualization canvas;
		           yourself.
	builder build
]
