"
A P16BulkEditorTest is a test class for testing the behavior of P16BulkEditor
"
Class {
	#name : 'MiBulkEditorTest',
	#superclass : 'TestCase',
	#instVars : [
		'bulkEditor',
		'sourceFile'
	],
	#category : 'MooseIDE-BulkEditor-Tests',
	#package : 'MooseIDE-BulkEditor-Tests'
}

{ #category : 'running' }
MiBulkEditorTest >> bulkEditorLines: lines [

	bulkEditor instVarNamed: #lines put: lines asOrderedCollection 
]

{ #category : 'running' }
MiBulkEditorTest >> fileReferenceFor: aFileName [

	^FileSystem memory root / aFileName
]

{ #category : 'running' }
MiBulkEditorTest >> methodWithPos: pos [

	^FamixJavaMethod new
		sourceAnchor: (FamixJavaIndexedFileAnchor new 
			startPos: pos x ;
			endPos: pos y ;
			fileName: 'SourceFile.test')
]

{ #category : 'running' }
MiBulkEditorTest >> setUp [

	super setUp.

	bulkEditor := MiBulkEditor new.

	self bulkEditorLines: #( 'l1*/5' 'l2_4' 'l3*/_*/10' ).

	sourceFile := self fileReferenceFor: 'SourceFile.test'.
	self writeLines: bulkEditor lines toFile: sourceFile
]

{ #category : 'tests' }
MiBulkEditorTest >> testCommentFirst [

	bulkEditor commentOutInterval: (1 to: 2).

	self assert: bulkEditor lines size equals: 5.

	self assert: bulkEditor lines first  equals: '/* --- dead code removal ---'.
	self assert: bulkEditor lines second equals: 'l1*_/5'.
	self assert: bulkEditor lines third  equals: 'l2_4'.
	self assert: bulkEditor lines fourth equals: ' --- dead code removal --- */'.
]

{ #category : 'tests' }
MiBulkEditorTest >> testCommentInside [

	bulkEditor commentOutInterval: (2 to: 2).

	self assert: bulkEditor lines size equals: 5.

	self assert: bulkEditor lines second equals: '/* --- dead code removal ---'.
	self assert: bulkEditor lines third  equals: 'l2_4'.
	self assert: bulkEditor lines fourth equals: ' --- dead code removal --- */'.
]

{ #category : 'tests' }
MiBulkEditorTest >> testCommentLast [

	bulkEditor commentOutInterval: (3 to: 3).

	self assert: bulkEditor lines size equals: 5.

	self assert: bulkEditor lines third  equals: '/* --- dead code removal ---'.
	self assert: bulkEditor lines fourth equals: 'l3*_/_*_/10'.
	self assert: bulkEditor lines fifth  equals: ' --- dead code removal --- */'.
]

{ #category : 'tests' }
MiBulkEditorTest >> testFirstLastLineFirstChar [

	| result |
	result := bulkEditor firstLastLine: (1 to: 7).

	self assert: result first equals: 1.
	self assert: result last equals: 2.
]

{ #category : 'tests' }
MiBulkEditorTest >> testFirstLastLineFirstLineChar [

	| result |
	result := bulkEditor firstLastLine: (7 to: 17).

	self assert: result first equals: 2.
	self assert: result last equals: 3
]

{ #category : 'tests' }
MiBulkEditorTest >> testFirstLastLineLastChar [

	| result |
	result := bulkEditor firstLastLine: (7 to: 21).

	self assert: result first equals: 2.
	self assert: result last equals: 3.
]

{ #category : 'tests' }
MiBulkEditorTest >> testFirstLastLineLastLineChar [

	| result |
	result := bulkEditor firstLastLine: (2 to: 10).

	self assert: result first equals: 1.
	self assert: result last equals: 2.
]

{ #category : 'tests' }
MiBulkEditorTest >> testFirstLastLineLastSameLine [

	| result |
	result := bulkEditor firstLastLine: (12 to: 15).

	self assert: result first equals: 3.
	self assert: result last equals: 3.
]

{ #category : 'tests' }
MiBulkEditorTest >> testLineIntervalsFirst [

	| mths |
	mths := OrderedCollection with: (self methodWithPos: 3 @ 8).

	self assertCollection: (bulkEditor lineIntervals: mths) hasSameElements: { 1 to: 2 }
]

{ #category : 'tests' }
MiBulkEditorTest >> testLineIntervalsInside [

	| mths |
	mths := OrderedCollection with: (self methodWithPos: 7 @ 10).

	self assertCollection: (bulkEditor lineIntervals: mths) hasSameElements: { 2 to: 2 }
]

{ #category : 'tests' }
MiBulkEditorTest >> testLineIntervalsLast [

	| mths |
	mths := OrderedCollection with: (self methodWithPos: 12 @ 17).

	self assertCollection: (bulkEditor lineIntervals: mths) hasSameElements: { 3 to: 3 }
]

{ #category : 'tests' }
MiBulkEditorTest >> testRemoveFirst [


	bulkEditor removeLines.
	bulkEditor removeInterval: (1 to: 2).

	self assert: bulkEditor lines size equals: 1.

	self assert: bulkEditor lines first equals: 'l3*/_*/10'
]

{ #category : 'tests' }
MiBulkEditorTest >> testRemoveInside [

	bulkEditor removeInterval: (2 to: 2).

	self assert: bulkEditor lines size equals: 2.

	self assert: bulkEditor lines first  equals: 'l1*/5'.
	self assert: bulkEditor lines second equals: 'l3*/_*/10'.
]

{ #category : 'tests' }
MiBulkEditorTest >> testRemoveLast [

	bulkEditor removeInterval: (3 to: 3).

	self assert: bulkEditor lines size equals: 2.

	self assert: bulkEditor lines first  equals: 'l1*/5'.
	self assert: bulkEditor lines second equals: 'l2_4'
]

{ #category : 'tests' }
MiBulkEditorTest >> testRewriteFile [

	self bulkEditorLines: { bulkEditor lines first . bulkEditor lines last }.

	bulkEditor rewriteFile: sourceFile.

	self 
		assert: sourceFile contents
		equals:
'l1*/5
l3*/_*/10
'
]

{ #category : 'tests' }
MiBulkEditorTest >> testSortByLine [

	| mths sorted |
	mths := {
		self methodWithPos: 7 @ 10 .
		self methodWithPos: 18 @ 32 .
		self methodWithPos: 1 @ 5 .
		self methodWithPos: 35 @ 42 .
		}.

	sorted := bulkEditor sortByLine: mths.

	self assert: sorted size equals: 4.

	self assert: sorted first  sourceAnchor startPos equals: 35.
	self assert: sorted second sourceAnchor startPos equals: 18.
	self assert: sorted third  sourceAnchor startPos equals: 7.
	self assert: sorted fourth sourceAnchor startPos equals: 1.
]

{ #category : 'tests' }
MiBulkEditorTest >> testUncloseCommentBetween [

	bulkEditor uncloseCommentBetween: (1 to: 3).

	self assert: bulkEditor lines first  equals: 'l1*_/5'.
	self assert: bulkEditor lines second equals: 'l2_4'.
	self assert: bulkEditor lines third  equals: 'l3*_/_*_/10'
]

{ #category : 'tests' }
MiBulkEditorTest >> testUncloseCommentsInMultiple [

	self assert: (bulkEditor uncloseCommentsIn: 'xx*/xx*/') equals: 'xx*_/xx*_/'
]

{ #category : 'tests' }
MiBulkEditorTest >> testUncloseCommentsInNone [

	self assert: (bulkEditor uncloseCommentsIn: 'xxxxx') equals: 'xxxxx'
]

{ #category : 'tests' }
MiBulkEditorTest >> testUncloseCommentsInOne [

	self assert: (bulkEditor uncloseCommentsIn: 'xx*/xx') equals: 'xx*_/xx'
]

{ #category : 'running' }
MiBulkEditorTest >> writeLines: aStringCollection toFile: aFileReference [

	aFileReference writeStreamDo: [ :stream | stream << (Character cr join: aStringCollection) ]
]
