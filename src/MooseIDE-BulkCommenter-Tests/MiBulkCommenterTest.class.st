"
A P16BulkEditorTest is a test class for testing the behavior of P16BulkEditor
"
Class {
	#name : 'MiBulkCommenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'bulkCommenter'
	],
	#category : 'MooseIDE-BulkCommenter-Tests',
	#package : 'MooseIDE-BulkCommenter-Tests'
}

{ #category : 'running' }
MiBulkCommenterTest >> bulkCommenterLines: lines [

	bulkCommenter instVarNamed: #lines put: lines
]

{ #category : 'running' }
MiBulkCommenterTest >> methodWithPos: pos [

	^FamixJavaMethod new
		sourceAnchor: (FamixJavaIndexedFileAnchor new 
			startPos: pos x ;
			endPos: pos y)
]

{ #category : 'running' }
MiBulkCommenterTest >> setUp [

	bulkCommenter := MiBulkCommenter new.

	self bulkCommenterLines: #( 'l1*/5' 'l2_4' 'l3*/_*/10') asOrderedCollection.

]

{ #category : 'tests' }
MiBulkCommenterTest >> testCommentFirst [

	| mth |
	mth := self methodWithPos: 3@8.

	bulkCommenter comment: mth.

	self assert: bulkCommenter lines size equals: 5.
	self assert: (bulkCommenter lines at: 1) equals: '/* --- dead code removal ---'.
	self assert: (bulkCommenter lines at: 2) equals: 'l1*_/5'.
	self assert: (bulkCommenter lines at: 3) equals: 'l2_4'.
	self assert: (bulkCommenter lines at: 4) equals: ' --- dead code removal --- */'.
]

{ #category : 'tests' }
MiBulkCommenterTest >> testCommentInside [

	| mth |
	mth := self methodWithPos: 7@10.

	bulkCommenter comment: mth.

	self assert: bulkCommenter lines size equals: 5.
	self assert: (bulkCommenter lines at: 2) equals: '/* --- dead code removal ---'.
	self assert: (bulkCommenter lines at: 3) equals: 'l2_4'.
	self assert: (bulkCommenter lines at: 4) equals: ' --- dead code removal --- */'.
]

{ #category : 'tests' }
MiBulkCommenterTest >> testCommentLast [

	| mth |
	mth := self methodWithPos: 12@17.

	bulkCommenter comment: mth.

	self assert: bulkCommenter lines size equals: 5.
	self assert: (bulkCommenter lines at: 3) equals: '/* --- dead code removal ---'.
	self assert: (bulkCommenter lines at: 4) equals: 'l3*_/_*_/10'.
	self assert: (bulkCommenter lines at: 5) equals: ' --- dead code removal --- */'.
]

{ #category : 'tests' }
MiBulkCommenterTest >> testFirstLastLineFirstChar [

	self assert: (bulkCommenter firstLastLine: 1@7) equals: 1@2
]

{ #category : 'tests' }
MiBulkCommenterTest >> testFirstLastLineFirstLineChar [

	self assert: (bulkCommenter firstLastLine: 7@17) equals: 2@3
]

{ #category : 'tests' }
MiBulkCommenterTest >> testFirstLastLineLastChar [

	self assert: (bulkCommenter firstLastLine: 7@21) equals: 2@3
]

{ #category : 'tests' }
MiBulkCommenterTest >> testFirstLastLineLastLineChar [

	self assert: (bulkCommenter firstLastLine: 2@10) equals: 1@2
]

{ #category : 'tests' }
MiBulkCommenterTest >> testFirstLastLineLastSameLine [

	self assert: (bulkCommenter firstLastLine: 12@15) equals: 3@3
]

{ #category : 'tests' }
MiBulkCommenterTest >> testUncloseCommentBetween [

	bulkCommenter uncloseCommentBetween: 1@3.

	self assert: (bulkCommenter lines at: 1) equals: 'l1*_/5'.
	self assert: (bulkCommenter lines at: 2) equals: 'l2_4'.
	self assert: (bulkCommenter lines at: 3) equals: 'l3*_/_*_/10'
]

{ #category : 'tests' }
MiBulkCommenterTest >> testUncloseCommentsInMultiple [

	self assert: (bulkCommenter uncloseCommentsIn: 'xx*/xx*/') equals: 'xx*_/xx*_/'
]

{ #category : 'tests' }
MiBulkCommenterTest >> testUncloseCommentsInNone [

	self assert: (bulkCommenter uncloseCommentsIn: 'xxxxx') equals: 'xxxxx'
]

{ #category : 'tests' }
MiBulkCommenterTest >> testUncloseCommentsInOne [

	self assert: (bulkCommenter uncloseCommentsIn: 'xx*/xx') equals: 'xx*_/xx'
]
