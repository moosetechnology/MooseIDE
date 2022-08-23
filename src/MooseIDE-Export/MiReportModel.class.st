Class {
	#name : #MiReportModel,
	#superclass : #Object,
	#instVars : [
		'browser',
		'mooseModel',
		'textEdited'
	],
	#category : #'MooseIDE-Export-Report'
}

{ #category : #accessing }
MiReportModel >> browser: aMiReportBrowser [ 
	browser := aMiReportBrowser
]

{ #category : #'as yet unclassified' }
MiReportModel >> exportReportTo: aFile [
	aFile ifNotNil: [
		aFile writeStreamDo: [ :stream | textEdited printOn: stream ].
		browser reportExported: aFile
	].
]

{ #category : #'as yet unclassified' }
MiReportModel >> exportToText [
	| aFile |
	aFile := browser chooseTextFile: 'Chose export destination'
		        extensions: #( 'md' )
		        path: 'mooseReport.md'.
	aFile ifNotNil: [
		textEdited := browser getText.
		aFile writeStreamDo: [ :stream | textEdited printOn: stream ].
		browser reportExported: aFile
	].
]

{ #category : #actions }
MiReportModel >> followEntity: aMooseModel [
	mooseModel := aMooseModel 
]

{ #category : #'as yet unclassified' }
MiReportModel >> previewReport [
	textEdited := browser getText.
	browser previewReport: textEdited
]
