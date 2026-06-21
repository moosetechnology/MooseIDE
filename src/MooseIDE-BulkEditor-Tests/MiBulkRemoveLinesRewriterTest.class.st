Class {
	#name : 'MiBulkRemoveLinesRewriterTest',
	#superclass : 'MiBulkRewriterAbstractTest',
	#category : 'MooseIDE-BulkEditor-Tests',
	#package : 'MooseIDE-BulkEditor-Tests'
}

{ #category : 'running' }
MiBulkRemoveLinesRewriterTest >> rewriterClass [ 

	^MiBulkRemoveLinesRewriter 
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunFirst_eolCR [

	self runOnIntervals: { (1 to: 10) } withLineEnder: Character cr.

	self assert: bulkRewriter stream contents equals: 'l3______10'
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunFirst_eolCRLF [

	self runOnIntervals: { (1 to: 10) } withLineEnder: String crlf.

	self assert: bulkRewriter stream contents equals: 'l3______10'
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunFirst_eolLF [

	self runOnIntervals: { (1 to: 10) } withLineEnder: Character lf.

	self assert: bulkRewriter stream contents equals: 'l3______10'
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunInside_eolCR [

	self runOnIntervals: { (7 to: 10) } withLineEnder: Character cr.

	self
		assert: bulkRewriter stream contents
		equals: 'l1__5' , String cr , 'l3______10'
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunInside_eolCRLF [

	self runOnIntervals: { (8 to: 11) } withLineEnder: String crlf.

	self
		assert: bulkRewriter stream contents
		equals: 'l1__5' , String crlf , 'l3______10'
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunInside_eolLF [

	self runOnIntervals: { (7 to: 10) } withLineEnder: Character lf.

	self
		assert: bulkRewriter stream contents
		equals: 'l1__5' , String lf , 'l3______10'
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunLast_eolCR [

	self runOnIntervals: { (12 to: 20) } withLineEnder: Character cr.

	self
		assert: bulkRewriter stream contents
		equals: 'l1__5' , String cr , 'l2_4' , String cr
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunLast_eolCRLF [

	self runOnIntervals: { (14 to: 22) } withLineEnder: String crlf.

	self
		assert: bulkRewriter stream contents
		equals: 'l1__5' , String crlf , 'l2_4' , String crlf
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunLast_eolLF [

	self runOnIntervals: { (12 to: 20) } withLineEnder: Character lf.

	self
		assert: bulkRewriter stream contents
		equals: 'l1__5' , String lf , 'l2_4' , String lf
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunMultipleIntervals_eolCR [

	self
		runOnIntervals: {
				(1 to: 5).
				(12 to: 20) }
		withLineEnder: Character cr.

	self assert: bulkRewriter stream contents equals: 'l2_4' , String cr
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunMultipleIntervals_eolCRLF [

	self
		runOnIntervals: {
				(1 to: 5).
				(14 to: 22) }
		withLineEnder: String crlf.

	self assert: bulkRewriter stream contents equals: 'l2_4' , String crlf
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunMultipleIntervals_eolLF [

	self
		runOnIntervals: {
				(1 to: 5).
				(12 to: 20) }
		withLineEnder: Character lf.

	self assert: bulkRewriter stream contents equals: 'l2_4' , String lf
]
