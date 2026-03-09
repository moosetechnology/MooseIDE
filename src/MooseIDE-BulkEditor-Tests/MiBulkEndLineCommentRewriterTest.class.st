Class {
	#name : 'MiBulkEndLineCommentRewriterTest',
	#superclass : 'MiBulkRewriterAbstractTest',
	#category : 'MooseIDE-BulkEditor-Tests',
	#package : 'MooseIDE-BulkEditor-Tests'
}

{ #category : 'running' }
MiBulkEndLineCommentRewriterTest >> classToTest [

	^MiBulkEndLineCommentRewriter 
]

{ #category : 'running' }
MiBulkEndLineCommentRewriterTest >> interval: start to: end [

	^MiBulkInterval
		from: start
		to: end 
		data: (	#x -> { self stubEntity: #a . self stubEntity: #b })
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

	bulkEditor content: (self joinLinesWith: Character cr).

	bulkEditor editIntervals: { self interval: 12 to: 20 }.

	bulkEditor run.

	lines at: 3 put: 'l3______10 // same constant as: a, b'.
	self
		assert: bulkEditor stream contents
		equals: (self joinLinesWith: Character cr)
]

{ #category : 'tests' }
MiBulkEndLineCommentRewriterTest >> testRunLastLine_eolCRLF [

	bulkEditor content: (self joinLinesWith: String crlf).

	bulkEditor editIntervals: { self interval: 12 to: 20 }.

	bulkEditor run.

	lines at: 3 put: 'l3______10 // same constant as: a, b'.
	self
		assert: bulkEditor stream contents
		equals: (self joinLinesWith: String crlf)
]

{ #category : 'tests' }
MiBulkEndLineCommentRewriterTest >> testRunLastLine_eolLF [

	bulkEditor content: (self joinLinesWith: Character lf).

	bulkEditor editIntervals: { self interval: 12 to: 20 }.

	bulkEditor run.

	lines at: 3 put: 'l3______10 // same constant as: a, b'.
	self
		assert: bulkEditor stream contents
		equals: (self joinLinesWith: Character lf)
]

{ #category : 'tests' }
MiBulkEndLineCommentRewriterTest >> testRun_eolCR [

	bulkEditor content: (self joinLinesWith: Character cr).

	bulkEditor editIntervals: { self interval: 1 to: 4 }.

	bulkEditor run.

	lines at: 1 put: 'l1__5 // same constant as: a, b'.
	self
		assert: bulkEditor stream contents
		equals: (self joinLinesWith: Character cr)
]

{ #category : 'tests' }
MiBulkEndLineCommentRewriterTest >> testRun_eolCRLF [

	bulkEditor content: (self joinLinesWith: String crlf).

	bulkEditor editIntervals: { self interval: 1 to: 4 }.

	bulkEditor run.

	lines at: 1 put: 'l1__5 // same constant as: a, b'.
	self
		assert: bulkEditor stream contents
		equals: (self joinLinesWith: String crlf)
]

{ #category : 'tests' }
MiBulkEndLineCommentRewriterTest >> testRun_eolLF [

	bulkEditor content: (self joinLinesWith: Character lf).

	bulkEditor editIntervals: { self interval: 1 to: 4 }.

	bulkEditor run.

	lines at: 1 put: 'l1__5 // same constant as: a, b'.
	self
		assert: bulkEditor stream contents
		equals: (self joinLinesWith: Character lf)
]
