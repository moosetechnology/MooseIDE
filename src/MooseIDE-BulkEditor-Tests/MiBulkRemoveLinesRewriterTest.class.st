Class {
	#name : 'MiBulkRemoveLinesRewriterTest',
	#superclass : 'MiBulkAbstractTest',
	#category : 'MooseIDE-BulkEditor-Tests',
	#package : 'MooseIDE-BulkEditor-Tests'
}

{ #category : 'running' }
MiBulkRemoveLinesRewriterTest >> classToTest [ 

	^MiBulkRemoveLinesRewriter 
]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> setUp [ 

	super setUp.

	bulkEditor stream: String new writeStream.

]

{ #category : 'tests' }
MiBulkRemoveLinesRewriterTest >> testRemoveFirst_eolCR [

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
MiBulkRemoveLinesRewriterTest >> testRemoveFirst_eolCRLF [

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
MiBulkRemoveLinesRewriterTest >> testRemoveFirst_eolLF [

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
MiBulkRemoveLinesRewriterTest >> testRemoveInside_eolCR [

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
MiBulkRemoveLinesRewriterTest >> testRemoveInside_eolCRLF [

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
MiBulkRemoveLinesRewriterTest >> testRemoveInside_eolLF [

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
MiBulkRemoveLinesRewriterTest >> testRemoveLast_eolCR [

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
MiBulkRemoveLinesRewriterTest >> testRemoveLast_eolCRLF [

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
MiBulkRemoveLinesRewriterTest >> testRemoveLast_eolLF [

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
MiBulkRemoveLinesRewriterTest >> testRemoveMultipleIntervals_eolCR [

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
MiBulkRemoveLinesRewriterTest >> testRemoveMultipleIntervals_eolCRLF [

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
MiBulkRemoveLinesRewriterTest >> testRemoveMultipleIntervals_eolLF [

	bulkEditor content: ( self
		join: #( 'l1*/5' 'l2_4' 'l3*/_*/10')
		with: Character lf ).

	bulkEditor editIntervals: { 1 to: 5 . 12 to: 20}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: 'l2_4', String lf
]
