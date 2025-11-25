Class {
	#name : 'MiBulkEditorAbstractTest',
	#superclass : 'TestCase',
	#instVars : [
		'bulkEditor',
		'sourceFile'
	],
	#category : 'MooseIDE-BulkEditor-Tests',
	#package : 'MooseIDE-BulkEditor-Tests'
}

{ #category : 'running' }
MiBulkEditorAbstractTest >> commentMethod: aMethod withPos: pos [

	^FamixJavaComment new
		commentedEntity: aMethod ;
		sourceAnchor: (FamixJavaIndexedFileAnchor new 
			startPos: pos x ;
			endPos: pos y ;
			fileName: 'SourceFile.test')
]

{ #category : 'running' }
MiBulkEditorAbstractTest >> fileReferenceFor: aFileName [

	^FileSystem memory root / aFileName
]

{ #category : 'running' }
MiBulkEditorAbstractTest >> join: lines with: separator [

	^String streamContents: [ :st |
		lines
			do: [ :aLine | st << aLine ]
			separatedBy: [ st << separator ]
	]
]

{ #category : 'running' }
MiBulkEditorAbstractTest >> methodWithPos: pos [

	^FamixJavaMethod new
		sourceAnchor: (FamixJavaIndexedFileAnchor new 
			startPos: pos x ;
			endPos: pos y ;
			fileName: 'SourceFile.test')
]

{ #category : 'running' }
MiBulkEditorAbstractTest >> setUp [

	super setUp.

	bulkEditor := self classToTest new.

]
