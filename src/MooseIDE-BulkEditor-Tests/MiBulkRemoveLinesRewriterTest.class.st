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

	bulkEditor content: ( self
		join: #( 'l1*/5' 'l2_4' 'l3*/_*/10')
		with: Character cr ).

	bulkEditor editIntervals: {1 to: 10}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: 'l3*/_*/10'
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunFirst_eolCRLF [

	bulkEditor content: ( self
		join: #( 'l1*/5' 'l2_4' 'l3*/_*/10')
		with: String crlf ).

	bulkEditor editIntervals: {1 to: 10}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: 'l3*/_*/10'
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunFirst_eolLF [

	bulkEditor content: ( self
		join: #( 'l1*/5' 'l2_4' 'l3*/_*/10')
		with: Character lf ).

	bulkEditor editIntervals: {1 to: 10}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: 'l3*/_*/10'
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunInside_eolCR [

	bulkEditor content: ( self
		join: #( 'l1*/5' 'l2_4' 'l3*/_*/10')
		with: Character cr ).

	bulkEditor editIntervals: {7 to: 10}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: ('l1*/5' , String cr , 'l3*/_*/10')
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunInside_eolCRLF [

	bulkEditor content: ( self
		join: #( 'l1*/5' 'l2_4' 'l3*/_*/10')
		with: String crlf ).

	bulkEditor editIntervals: {8 to: 11}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: ('l1*/5' , String crlf , 'l3*/_*/10')
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunInside_eolLF [

	bulkEditor content: ( self
		join: #( 'l1*/5' 'l2_4' 'l3*/_*/10')
		with: Character lf ).

	bulkEditor editIntervals: {7 to: 10}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: ('l1*/5' , String lf , 'l3*/_*/10')
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunLast_eolCR [

	bulkEditor content: ( self
		join: #( 'l1*/5' 'l2_4' 'l3*/_*/10')
		with: Character cr ).

	bulkEditor editIntervals: {12 to: 20}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: ('l1*/5' , String cr , 'l2_4' , String cr)
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunLast_eolCRLF [

	bulkEditor content: ( self
		join: #( 'l1*/5' 'l2_4' 'l3*/_*/10')
		with: String crlf ).

	bulkEditor editIntervals: {14 to: 22}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: ('l1*/5' , String crlf , 'l2_4' , String crlf)
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunLast_eolLF [

	bulkEditor content: ( self
		join: #( 'l1*/5' 'l2_4' 'l3*/_*/10')
		with: Character lf ).

	bulkEditor editIntervals: {12 to: 20}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: ('l1*/5' , String lf , 'l2_4' , String lf)
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunMultipleIntervals_eolCR [

	bulkEditor content: ( self
		join: #( 'l1*/5' 'l2_4' 'l3*/_*/10')
		with: Character cr ).

	bulkEditor editIntervals: { 1 to: 5 . 12 to: 20}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: 'l2_4', String cr
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunMultipleIntervals_eolCRLF [

	bulkEditor content: ( self
		join: #( 'l1*/5' 'l2_4' 'l3*/_*/10')
		with: String crlf ).

	bulkEditor editIntervals: { 1 to: 5 . 14 to: 22}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: 'l2_4', String crlf
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRunMultipleIntervals_eolLF [

	bulkEditor content: ( self
		join: #( 'l1*/5' 'l2_4' 'l3*/_*/10')
		with: Character lf ).

	bulkEditor editIntervals: { 1 to: 5 . 12 to: 20}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: 'l2_4', String lf
]
