Class {
	#name : 'MiBulkRemoveLinesRewriterTest',
	#superclass : 'MiBulkRewriterAbstractTest',
	#category : 'MooseIDE-BulkEditor-Tests',
	#package : 'MooseIDE-BulkEditor-Tests'
}

{ #category : 'running' }
MiBulkRemoveLinesRewriterTest >> classToTest [ 

	^MiBulkRemoveLinesRewriter 
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunFirst_eolCR [

	bulkEditor content: (self joinLinesWith: Character cr).

	bulkEditor editIntervals: {1 to: 10}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: 'l3______10'
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunFirst_eolCRLF [

	bulkEditor content: (self joinLinesWith: String crlf).

	bulkEditor editIntervals: {1 to: 10}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: 'l3______10'
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunFirst_eolLF [

	bulkEditor content: (self joinLinesWith: Character lf).

	bulkEditor editIntervals: {1 to: 10}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: 'l3______10'
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunInside_eolCR [

	bulkEditor content: (self joinLinesWith: Character cr).

	bulkEditor editIntervals: {7 to: 10}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: ('l1__5' , String cr , 'l3______10')
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunInside_eolCRLF [

	bulkEditor content: (self joinLinesWith: String crlf).

	bulkEditor editIntervals: {8 to: 11}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: ('l1__5' , String crlf , 'l3______10')
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunInside_eolLF [

	bulkEditor content: (self joinLinesWith: Character lf).

	bulkEditor editIntervals: {7 to: 10}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: ('l1__5' , String lf , 'l3______10')
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunLast_eolCR [

	bulkEditor content: (self joinLinesWith: Character cr).

	bulkEditor editIntervals: {12 to: 20}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: ('l1__5' , String cr , 'l2_4' , String cr)
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunLast_eolCRLF [

	bulkEditor content: (self joinLinesWith: String crlf).

	bulkEditor editIntervals: {14 to: 22}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: ('l1__5' , String crlf , 'l2_4' , String crlf)
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunLast_eolLF [

	bulkEditor content: (self joinLinesWith: Character lf).

	bulkEditor editIntervals: {12 to: 20}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: ('l1__5' , String lf , 'l2_4' , String lf)
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunMultipleIntervals_eolCR [

	bulkEditor content: (self joinLinesWith: Character cr).

	bulkEditor editIntervals: { 1 to: 5 . 12 to: 20}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: 'l2_4', String cr
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunMultipleIntervals_eolCRLF [

	bulkEditor content: (self joinLinesWith: String crlf).

	bulkEditor editIntervals: { 1 to: 5 . 14 to: 22}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: 'l2_4', String crlf
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunMultipleIntervals_eolLF [

	bulkEditor content: (self joinLinesWith: Character lf).

	bulkEditor editIntervals: { 1 to: 5 . 12 to: 20}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: 'l2_4', String lf
]
