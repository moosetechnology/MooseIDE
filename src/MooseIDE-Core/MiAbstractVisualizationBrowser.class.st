Class {
	#name : #MiAbstractVisualizationBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'visualization'
	],
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #actions }
MiAbstractVisualizationBrowser >> canHighlight [

	^ true
]

{ #category : #export }
MiAbstractVisualizationBrowser >> exportToPDF [

	self exportWith: RSPDFCairoExporter
]

{ #category : #export }
MiAbstractVisualizationBrowser >> exportToPNG [

	self exportWith: RSPNGExporter
]

{ #category : #export }
MiAbstractVisualizationBrowser >> exportToSVG [

	self exportWith: RSSVGCairoExporter
]

{ #category : #export }
MiAbstractVisualizationBrowser >> exportVisualization [

	SpMenuPresenter new
		addItem: [ :item | item name: 'Export to SVG'; action: [ self exportToSVG ] ];
		addItem: [ :item | item name: 'Export to PNG'; action: [ self exportToPNG ] ];
		addItem: [ :item | item name: 'Export to PDF'; action: [ self exportToPDF ] ];
		openWithSpecAtPointer
]

{ #category : #export }
MiAbstractVisualizationBrowser >> exportWith: roassalExporter [

	| file |
	file := UIManager default
		        chooseForSaveFileReference: 'Chose export destination'
		        extensions: roassalExporter extension
		        path: 'visualization.' , roassalExporter extension.

	file ifNotNil: [
		roassalExporter new
			canvas: visualization canvas;
			zoomToShapes;
			exportToFile: file ]
]

{ #category : #testing }
MiAbstractVisualizationBrowser >> hasVisualization [

	^ true
]

{ #category : #highlighting }
MiAbstractVisualizationBrowser >> highlightEntity: entities [

	visualization highlightEntities: entities
]

{ #category : #accessing }
MiAbstractVisualizationBrowser >> miSelectedItem [

	^ visualization miSelectedItem ifEmpty: [
		  specModel ifNil: [ ^ #(  ) ].
		  specModel entities mooseInterestingEntity ]
]
