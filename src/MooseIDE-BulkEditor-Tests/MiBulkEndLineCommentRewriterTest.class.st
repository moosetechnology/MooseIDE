Class {
	#name : 'MiBulkEndLineCommentRewriterTest',
	#superclass : 'MiBulkRewriterAbstractTest',
	#category : 'MooseIDE-BulkEditor-Tests',
	#package : 'MooseIDE-BulkEditor-Tests'
}

{ #category : 'running' }
MiBulkEndLineCommentRewriterTest >> interval: start to: end [

	^MiBulkInterval
		from: start
		to: end 
		data: (	#x -> { self stubEntity: #a . self stubEntity: #b })
]

{ #category : 'running' }
MiBulkEndLineCommentRewriterTest >> rewriterClass [

	^MiBulkEndLineCommentRewriter 
]

{ #category : 'running' }
MiBulkEndLineCommentRewriterTest >> setUp [ 

	super setUp.

	lines := { 'l1__5' . 'l2_4' . 'l3______10' }.


]

{ #category : 'running' }
MiBulkEndLineCommentRewriterTest >> stubEntity: aString [

	| entity |
	entity := (Mock named: aString).
	entity stub mooseName willReturn: aString.

	^entity
]

{ #category : 'tests' }
MiBulkEndLineCommentRewriterTest >> testRunLastLine_eolCR [

	self
		runOnIntervals: { (self interval: 12 to: 20) }
		withLineEnder: Character cr.

	lines at: 3 put: 'l3______10 // same constant as: a, b'.
	self
		assert: bulkRewriter stream contents
		equals: (self joinLinesWith: Character cr)
]

{ #category : 'tests' }
MiBulkEndLineCommentRewriterTest >> testRunLastLine_eolCRLF [

	self
		runOnIntervals: { (self interval: 12 to: 20) }
		withLineEnder: String crlf.

	lines at: 3 put: 'l3______10 // same constant as: a, b'.
	self
		assert: bulkRewriter stream contents
		equals: (self joinLinesWith: String crlf)
]

{ #category : 'tests' }
MiBulkEndLineCommentRewriterTest >> testRunLastLine_eolLF [

	self
		runOnIntervals: { (self interval: 12 to: 20) }
		withLineEnder: Character lf.

	lines at: 3 put: 'l3______10 // same constant as: a, b'.
	self
		assert: bulkRewriter stream contents
		equals: (self joinLinesWith: Character lf)
]

{ #category : 'tests' }
MiBulkEndLineCommentRewriterTest >> testRun_eolCR [

	self
		runOnIntervals: { (self interval: 1 to: 4) }
		withLineEnder: Character cr.

	lines at: 1 put: 'l1__5 // same constant as: a, b'.
	self
		assert: bulkRewriter stream contents
		equals: (self joinLinesWith: Character cr)
]

{ #category : 'tests' }
MiBulkEndLineCommentRewriterTest >> testRun_eolCRLF [

	self
		runOnIntervals: { (self interval: 1 to: 4) }
		withLineEnder: String crlf.

	lines at: 1 put: 'l1__5 // same constant as: a, b'.
	self
		assert: bulkRewriter stream contents
		equals: (self joinLinesWith: String crlf)
]

{ #category : 'tests' }
MiBulkEndLineCommentRewriterTest >> testRun_eolLF [

	self
		runOnIntervals: { (self interval: 1 to: 4) }
		withLineEnder: Character lf.

	lines at: 1 put: 'l1__5 // same constant as: a, b'.
	self
		assert: bulkRewriter stream contents
		equals: (self joinLinesWith: Character lf)
]
