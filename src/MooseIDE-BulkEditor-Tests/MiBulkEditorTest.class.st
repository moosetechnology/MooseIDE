"
A P16BulkEditorTest is a test class for testing the behavior of P16BulkEditor
"
Class {
	#name : 'MiBulkEditorTest',
	#superclass : 'TestCase',
	#instVars : [
		'bulkEditor'
	],
	#category : 'MooseIDE-BulkEditor-Tests',
	#package : 'MooseIDE-BulkEditor-Tests'
}

{ #category : 'running' }
MiBulkEditorTest >> bulkEditorLines: lines [

	bulkEditor instVarNamed: #lines put: lines asOrderedCollection 
]

{ #category : 'running' }
MiBulkEditorTest >> methodWithPos: pos [

	^FamixJavaMethod new
		sourceAnchor: (FamixJavaIndexedFileAnchor new 
			startPos: pos x ;
			endPos: pos y)
]

{ #category : 'running' }
MiBulkEditorTest >> setUp [

	bulkEditor := MiBulkEditor new.

	self bulkEditorLines: #( 'l1*/5' 'l2_4' 'l3*/_*/10').

]

{ #category : 'tests' }
MiBulkEditorTest >> testCommentFirst [

	bulkEditor commentOutInterval: (1 to: 2).

	self assert: bulkEditor lines size equals: 5.
	self assert: (bulkEditor lines at: 1) equals: '/* --- dead code removal ---'.
	self assert: (bulkEditor lines at: 2) equals: 'l1*_/5'.
	self assert: (bulkEditor lines at: 3) equals: 'l2_4'.
	self assert: (bulkEditor lines at: 4) equals: ' --- dead code removal --- */'.
]

{ #category : 'tests' }
MiBulkEditorTest >> testCommentInside [

	bulkEditor commentOutInterval: (2 to: 2).

	self assert: bulkEditor lines size equals: 5.
	self assert: (bulkEditor lines at: 2) equals: '/* --- dead code removal ---'.
	self assert: (bulkEditor lines at: 3) equals: 'l2_4'.
	self assert: (bulkEditor lines at: 4) equals: ' --- dead code removal --- */'.
]

{ #category : 'tests' }
MiBulkEditorTest >> testCommentLast [

	bulkEditor commentOutInterval: (3 to: 3).

	self assert: bulkEditor lines size equals: 5.
	self assert: (bulkEditor lines at: 3) equals: '/* --- dead code removal ---'.
	self assert: (bulkEditor lines at: 4) equals: 'l3*_/_*_/10'.
	self assert: (bulkEditor lines at: 5) equals: ' --- dead code removal --- */'.
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
	self assert: (bulkEditor lines at: 1) equals: 'l3*/_*/10'
]

{ #category : 'tests' }
MiBulkEditorTest >> testRemoveInside [

	bulkEditor removeInterval: (2 to: 2).

	self assert: bulkEditor lines size equals: 2.
	self assert: (bulkEditor lines at: 1) equals: 'l1*/5'.
	self assert: (bulkEditor lines at: 2) equals: 'l3*/_*/10'.
]

{ #category : 'tests' }
MiBulkEditorTest >> testRemoveLast [

	bulkEditor removeInterval: (3 to: 3).

	self assert: bulkEditor lines size equals: 2.
	self assert: (bulkEditor lines at: 1) equals: 'l1*/5'.
	self assert: (bulkEditor lines at: 2) equals: 'l2_4'
]

{ #category : 'tests' }
MiBulkEditorTest >> testUncloseCommentBetween [

	bulkEditor uncloseCommentBetween: (1 to: 3).

	self assert: (bulkEditor lines at: 1) equals: 'l1*_/5'.
	self assert: (bulkEditor lines at: 2) equals: 'l2_4'.
	self assert: (bulkEditor lines at: 3) equals: 'l3*_/_*_/10'
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
