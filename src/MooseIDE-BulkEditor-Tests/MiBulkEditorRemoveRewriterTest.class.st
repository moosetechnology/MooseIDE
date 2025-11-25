Class {
	#name : 'MiBulkEditorRemoveRewriterTest',
	#superclass : 'MiBulkEditorAbstractTest',
	#category : 'MooseIDE-BulkEditor-Tests',
	#package : 'MooseIDE-BulkEditor-Tests'
}

{ #category : 'running' }
MiBulkEditorRemoveRewriterTest >> classToTest [ 

	^MiBulkEditorRemoveRewriter 
]

{ #category : 'running' }
MiBulkEditorRemoveRewriterTest >> join: lines with: separator [

	^String streamContents: [ :st |
		lines
			do: [ :aLine | st << aLine ]
			separatedBy: [ st << separator ]
	]
]

{ #category : 'tests' }
MiBulkEditorRemoveRewriterTest >> setUp [ 

	super setUp.

	bulkEditor stream: String new writeStream.

]

{ #category : 'tests' }
MiBulkEditorRemoveRewriterTest >> testRemoveFirstCR [

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
MiBulkEditorRemoveRewriterTest >> testRemoveFirstCRLF [

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
MiBulkEditorRemoveRewriterTest >> testRemoveFirstLF [

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
MiBulkEditorRemoveRewriterTest >> testRemoveInsideCR [

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
MiBulkEditorRemoveRewriterTest >> testRemoveInsideCRLF [

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
MiBulkEditorRemoveRewriterTest >> testRemoveInsideLF [

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
MiBulkEditorRemoveRewriterTest >> testRemoveLastCR [

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
MiBulkEditorRemoveRewriterTest >> testRemoveLastCRLF [

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
MiBulkEditorRemoveRewriterTest >> testRemoveLastLF [

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
MiBulkEditorRemoveRewriterTest >> testRemoveMultipleIntervalsCR [

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
MiBulkEditorRemoveRewriterTest >> testRemoveMultipleIntervalsCRLF [

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
MiBulkEditorRemoveRewriterTest >> testRemoveMultipleIntervalsLF [

	bulkEditor content: ( self
		join: #( 'l1*/5' 'l2_4' 'l3*/_*/10')
		with: Character lf ).

	bulkEditor editIntervals: { 1 to: 5 . 12 to: 20}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: 'l2_4', String lf
]
