"
I am the model of the report builder.
"
Class {
	#name : #MiReportModel,
	#superclass : #Object,
	#instVars : [
		'browser',
		'mooseModel',
		'textEdited',
		'textEditedSource',
		'sourceText',
		'needToUpdate',
		'micDocument',
		'cellList',
		'context'
	],
	#category : #'MooseIDE-Export-Report'
}

{ #category : #accessing }
MiReportModel >> cellList [

	^ cellList
]

{ #category : #accessing }
MiReportModel >> cellList: anObject [

	cellList := anObject
]

{ #category : #actions }
MiReportModel >> checkTextEdited [

	sourceText ifNil: [ 
		self inform: 'There is no source to export.'.
		^ false ].
	^ true
]

{ #category : #accessing }
MiReportModel >> context [

	^ context
]

{ #category : #initialization }
MiReportModel >> defaultBindings [

	^ { 
		  ('mooseModel' -> mooseModel).
		  ('stream' -> nil).
		  ('printer' -> nil) }
]

{ #category : #initialization }
MiReportModel >> defaultBindingsWithStream: aStream [

	^ { 
		  ('mooseModel' -> mooseModel).
		  ('stream' -> aStream).
		  ('printer' -> nil) }
]

{ #category : #actions }
MiReportModel >> executeAllCells [

	^ String streamContents: [ :s | 
		  self initializeContextWithStream: s.
		  cellList do: [ :cell | 
			  cell printContentIn: s withContext: context.
			  s nextPut: Character cr ] ]
]

{ #category : #actions }
MiReportModel >> executeAllCellsAsTextCollection [

	self initializeContext.
	^ cellList collect: [ :cell | 
		  String streamContents: [ :s | 
			  cell printContentIn: s withContext: context ] ]
]

{ #category : #actions }
MiReportModel >> exportToHTML [

	| aFile |
	self checkTextEdited ifFalse: [ ^self ].
	aFile := browser
		         chooseTextFile: 'Chose export destination'
		         extensions: #( 'html' )
		         path: 'mooseReport.html'.
	aFile ifNotNil: [ 
		aFile writeStreamDo: [ :stream | 
			stream nextPutAll: (MicHTMLVisitor asHTMLString: self generateMicrodown) ].
		browser reportExported: aFile ]
]

{ #category : #actions }
MiReportModel >> exportToText [

	| aFile |
	aFile := '/Users/slabsar/Documents/cells.ston' asFileReference.
	aFile ensureCreateFile.
	aFile ifNotNil: [ 
		aFile writeStreamDo: [ :s | 
		STON put: cellList onStream: s ] ]
]

{ #category : #actions }
MiReportModel >> followEntity: aMooseModel [
	mooseModel := aMooseModel 
]

{ #category : #actions }
MiReportModel >> generateMicrodown [

	needToUpdate ifFalse: [ ^ textEdited ].
	needToUpdate := false.
	micDocument := MiCodeEvaluator new
		               model: mooseModel;
		               visit: (Microdown parse: self sourceText).
	self textEdited: (MiMicrodownPrettyPrinter new visit: micDocument).
	^ textEdited
]

{ #category : #actions }
MiReportModel >> importCellsFrom: aFileReference [

	| cells |
	cells := STON fromString: aFileReference contents.
	cellList := cells.
]

{ #category : #initialization }
MiReportModel >> initialize [

	super initialize.
	needToUpdate := false.
	cellList := OrderedCollection new
]

{ #category : #initialization }
MiReportModel >> initializeContext [

	context := CompilationContext new
		           bindings: (self defaultBindings);
		           yourself
]

{ #category : #initialization }
MiReportModel >> initializeContextWithStream: aStream [

	context := CompilationContext new
		           bindings: (self defaultBindingsWithStream: aStream);
		           yourself
]

{ #category : #accessing }
MiReportModel >> micDocument [

	^ micDocument
]

{ #category : #accessing }
MiReportModel >> mooseModel [

	^ mooseModel 
]

{ #category : #accessing }
MiReportModel >> sourceText [

	^ sourceText
]

{ #category : #accessing }
MiReportModel >> sourceText: anObject [

	needToUpdate := true.
	sourceText := anObject
]

{ #category : #accessing }
MiReportModel >> textEdited [

	^ textEdited
]

{ #category : #accessing }
MiReportModel >> textEdited: anObject [

	textEdited := anObject.
]
