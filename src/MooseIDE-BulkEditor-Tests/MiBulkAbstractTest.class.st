Class {
	#name : 'MiBulkAbstractTest',
	#superclass : 'TestCase',
	#instVars : [
		'bulkEditor',
		'sourceFile'
	],
	#category : 'MooseIDE-BulkEditor-Tests',
	#package : 'MooseIDE-BulkEditor-Tests'
}

{ #category : 'running' }
MiBulkAbstractTest >> classToTest [

	self subclassResponsibility 
]

{ #category : 'running' }
MiBulkAbstractTest >> commentMethod: aMethod withPos: pos [

	^FamixJavaComment new
		commentedEntity: aMethod ;
		sourceAnchor: (FamixJavaIndexedFileAnchor new 
			startPos: pos x ;
			endPos: pos y ;
			fileName: 'SourceFile.test')
]

{ #category : 'running' }
MiBulkAbstractTest >> fileReferenceFor: aFileName [

	^FileSystem memory root / aFileName
]

{ #category : 'running' }
MiBulkAbstractTest >> methodWithPos: pos [

	^FamixJavaMethod new
		sourceAnchor: (FamixJavaIndexedFileAnchor new 
			startPos: pos x ;
			endPos: pos y ;
			fileName: 'SourceFile.test')
]

{ #category : 'running' }
MiBulkAbstractTest >> setUp [

	super setUp.

	bulkEditor := self classToTest new.

]
