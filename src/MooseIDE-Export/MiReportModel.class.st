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
		'micDocument'
	],
	#category : #'MooseIDE-Export-Report'
}

{ #category : #accessing }
MiReportModel >> browser: aMiReportBrowser [ 
	browser := aMiReportBrowser
]

{ #category : #actions }
MiReportModel >> checkTextEdited [

	sourceText ifNil: [ 
		self inform: 'There is no source to export.'.
		^ false ].
	^ true
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
	self checkTextEdited ifFalse: [ ^ self ].
	aFile := browser
		         chooseTextFile: 'Chose export destination'
		         extensions: #( 'md' )
		         path: 'mooseReport.md'.
	aFile ifNotNil: [ 
		aFile writeStreamDo: [ :stream | stream nextPutAll: self generateMicrodown ].
		browser reportExported: aFile ]
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

{ #category : #initialization }
MiReportModel >> initialize [ 

	super initialize.
	needToUpdate := false.
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
	browser renderText.
]
