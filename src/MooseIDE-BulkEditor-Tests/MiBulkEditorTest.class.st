"
A P16BulkEditorTest is a test class for testing the behavior of P16BulkEditor
"
Class {
	#name : 'MiBulkEditorTest',
	#superclass : 'MiBulkEditorAbstractTest',
	#category : 'MooseIDE-BulkEditor-Tests',
	#package : 'MooseIDE-BulkEditor-Tests'
}

{ #category : 'running' }
MiBulkEditorTest >> bulkEditorPreviousContent [

	^bulkEditor instVarNamed: #previousFileContent
]

{ #category : 'running' }
MiBulkEditorTest >> bulkEditorPreviousContent: aString [

	bulkEditor instVarNamed: #previousFileContent put: aString
]

{ #category : 'running' }
MiBulkEditorTest >> classToTest [

	^MiBulkEditor
]

{ #category : 'running' }
MiBulkEditorTest >> setUp [ 

	super setUp.

	self bulkEditorPreviousContent: 'l1__5
l2_4
l3______10'.

	sourceFile := self fileReferenceFor: 'SourceFile.test'.
	self writePreviousContentToFile: sourceFile
]

{ #category : 'tests' }
MiBulkEditorTest >> testEmptyLinesBetweenAnd_isFalse [

	self bulkEditorPreviousContent: 'l1__5
 x  
l2_4
l3______10'.

	self deny: (bulkEditor emptyLinesBetween: 5 and: 11).
]

{ #category : 'tests' }
MiBulkEditorTest >> testEmptyLinesBetweenAnd_isTrue [
	"2nd line contains spaces"

	self bulkEditorPreviousContent: 'l1__5
    
l2_4
l3______10'.

	self assert: (bulkEditor emptyLinesBetween: 5 and: 11).
]

{ #category : 'tests' }
MiBulkEditorTest >> testGroupByFile [

	| mths grouped fileMethods |
	mths := {
		self methodWithPos:  10 @ 42 .
		self methodWithPos:   7 @ 128 .
		self methodWithPos:  85 @ 729 .
		self methodWithPos: 318 @ 544
	}.
	mths second sourceAnchor fileName: 'otherFile.test'.
	mths third  sourceAnchor fileName: 'thirdFile.test'.

	grouped := bulkEditor groupByFile: mths.

	self assert: grouped size equals: 3.

	fileMethods := grouped
		at: 'SourceFile.test'
		ifAbsent: [self fail: 'Missing methods for "SourceFile.test"' ].
	self assertCollection: fileMethods value hasSameElements: { mths first . mths fourth } .

	fileMethods := grouped
		at: 'otherFile.test'
		ifAbsent: [self fail: 'Missing methods for "otherFile.test"' ].
	self assertCollection: fileMethods value hasSameElements: { mths second } .

	fileMethods := grouped
		at: 'thirdFile.test'
		ifAbsent: [self fail: 'Missing methods for "thirdFile.test"' ].
	self assertCollection: fileMethods value hasSameElements: { mths third }
]

{ #category : 'tests' }
MiBulkEditorTest >> testMergeInterval3to1 [
	"2nd line contains a TAB
	 merge 3 intervals into 1"

	| merged |
	self bulkEditorPreviousContent: 'l1__5
	
l2_4
l3______10'.

	merged := bulkEditor mergeIntervals: { 1 to: 5 . 9 to: 12 . 14 to: 23 }.

	self assertCollection: merged hasSameElements: { 1 to: 23 }
]

{ #category : 'tests' }
MiBulkEditorTest >> testMergeIntervalContiguousLines [

	| merged |

	merged := bulkEditor mergeIntervals: { 1 to: 5 . 7 to: 10 }.

	self assertCollection: merged hasSameElements: { 1 to: 10 }
]

{ #category : 'tests' }
MiBulkEditorTest >> testMergeIntervalEmptyLine [
	"2nd line is empty"

	| merged |
	self bulkEditorPreviousContent: 'l1__5

l2_4
l3______10'.

	merged := bulkEditor mergeIntervals: { 1 to: 5 . 8 to: 11}.

	self assertCollection: merged hasSameElements: { 1 to: 11 }
]

{ #category : 'tests' }
MiBulkEditorTest >> testMergeIntervalLineWithSpaces [
	"2nd line contains 3 spaces"

	| merged |
	self bulkEditorPreviousContent: 'l1__5
   
l2_4
l3______10'.

	merged := bulkEditor mergeIntervals: { 1 to: 5 . 11 to: 14}.

	self assertCollection: merged hasSameElements: { 1 to: 14 }
]

{ #category : 'tests' }
MiBulkEditorTest >> testMergeIntervalLineWithTab [
	"2nd line contains TAB"

	| merged |
	self bulkEditorPreviousContent: 'l1__5
	
l2_4
l3______10'.

	merged := bulkEditor mergeIntervals: { 1 to: 5 . 9 to: 12}.

	self assertCollection: merged hasSameElements: { 1 to: 12 }
]

{ #category : 'tests' }
MiBulkEditorTest >> testMergeIntervalNot [
	"Not merging as 2nd line is not empty"

	| merged |
	self bulkEditorPreviousContent: 'l1__5
 x 
l2_4
l3______10'.

	merged := bulkEditor mergeIntervals: { 1 to: 5 . 11 to: 14}.

	self assertCollection: merged hasSameElements: { 1 to: 5 . 11 to: 14}
]

{ #category : 'tests' }
MiBulkEditorTest >> testMethodWithCommentIntervalCommentAfter [
	"Comment is after the method (ignore it)"

	| mth |
	mth := self methodWithPos: 12 @ 17.
	self commentMethod: mth withPos: 18 @ 25.

	self assert: (bulkEditor methodWithCommentInterval: mth) equals: (12 to: 17)
]

{ #category : 'tests' }
MiBulkEditorTest >> testMethodWithCommentIntervalCommentInside [
	"Comment is inside the method"

	| mth |
	mth := self methodWithPos: 12 @ 17.
	self commentMethod: mth withPos: 13 @ 15.

	self assert: (bulkEditor methodWithCommentInterval: mth) equals: (12 to: 17)
]

{ #category : 'tests' }
MiBulkEditorTest >> testMethodWithCommentIntervalHeaderComment [
	"Comment is just before method"

	| mth |
	mth := self methodWithPos: 12 @ 17.
	self commentMethod: mth withPos: 6 @ 10.

	self assert: (bulkEditor methodWithCommentInterval: mth) equals: (6 to: 17)
]

{ #category : 'tests' }
MiBulkEditorTest >> testRewriteFile [

	self bulkEditorPreviousContent: 'l1*/5
l3*/_*/10'.

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

	sorted := bulkEditor sortByPosition: mths.

	self assert: sorted size equals: 4.

	self assert: sorted first  sourceAnchor startPos equals: 1.
	self assert: sorted second sourceAnchor startPos equals: 7.
	self assert: sorted third  sourceAnchor startPos equals: 18.
	self assert: sorted fourth sourceAnchor startPos equals: 35.
]

{ #category : 'running' }
MiBulkEditorTest >> writeLines: aStringCollection toFile: aFileReference [

	aFileReference writeStreamDo: [ :stream | stream << (Character cr join: aStringCollection) ]
]
