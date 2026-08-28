Class {
	#name : 'MiAbstractVisualizationBrowser',
	#superclass : 'MiAbstractBrowser',
	#instVars : [
		'mainPresenter'
	],
	#category : 'MooseIDE-Core-Browser',
	#package : 'MooseIDE-Core',
	#tag : 'Browser'
}

{ #category : 'testing' }
MiAbstractVisualizationBrowser class >> isAbstract [

	^ self == MiAbstractVisualizationBrowser
]

{ #category : 'testing' }
MiAbstractVisualizationBrowser >> canHighlight [

	^ true
]

{ #category : 'export' }
MiAbstractVisualizationBrowser >> exportToPDF [

	self exportWith: RSPDFCairoExporter
]

{ #category : 'export' }
MiAbstractVisualizationBrowser >> exportToPNG [

	self exportWith: RSPNGExporter
]

{ #category : 'export' }
MiAbstractVisualizationBrowser >> exportToSVG [

	self exportWith: RSSVGCairoExporter
]

{ #category : 'export' }
MiAbstractVisualizationBrowser >> exportVisualization [

	SpMenuPresenter new
		addItem: [ :item | item name: 'Export to SVG'; action: [ self exportToSVG ] ];
		addItem: [ :item | item name: 'Export to PNG'; action: [ self exportToPNG ] ];
		addItem: [ :item | item name: 'Export to PDF'; action: [ self exportToPDF ] ];
		openWithSpecAtPointer
]

{ #category : 'export' }
MiAbstractVisualizationBrowser >> exportWith: roassalExporter [

	| file fileName |
	fileName := (self class title copyReplaceAll: ' ' with: '_') uncapitalized, '.', roassalExporter extension.
	file := UIManager default
		        chooseForSaveFileReference: 'Chose export destination'
		        extensions: {roassalExporter extension}
		        path: fileName asFileReference.

	file ifNotNil: [
		roassalExporter new
			canvas: mainPresenter canvas;
			zoomToShapes;
			exportToFile: file ]
]

{ #category : 'testing' }
MiAbstractVisualizationBrowser >> hasVisualization [

	^ true
]

{ #category : 'highlighting' }
MiAbstractVisualizationBrowser >> highlightEntity: entities [

	mainPresenter highlightEntities: entities
]

{ #category : 'initialization' }
MiAbstractVisualizationBrowser >> initializeLayout [

	self layout: (SpScrollableLayout with: mainPresenter)
]

{ #category : 'initialization' }
MiAbstractVisualizationBrowser >> initializePresenters [

	mainPresenter := self class mapClass owner: self.
	self initializeLayout
]

{ #category : 'accessing' }
MiAbstractVisualizationBrowser >> miSelectedItem [

	^ mainPresenter miSelectedItem ifEmpty: [
		  specModel ifNil: [ ^ #(  ) ].
		  specModel entities ]
]

{ #category : 'actions' }
MiAbstractVisualizationBrowser >> runVisualization [

	mainPresenter run
]

{ #category : 'interactions' }
MiAbstractVisualizationBrowser >> selectRelatedTo: anEntity [

	"empty to avoid crashes
	 should be specialized for each visualization"
]
