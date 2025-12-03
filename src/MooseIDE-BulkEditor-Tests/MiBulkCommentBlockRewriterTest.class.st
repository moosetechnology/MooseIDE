Class {
	#name : 'MiBulkCommentBlockRewriterTest',
	#superclass : 'MiBulkRewriterAbstractTest',
	#category : 'MooseIDE-BulkEditor-Tests',
	#package : 'MooseIDE-BulkEditor-Tests'
}

{ #category : 'running' }
MiBulkCommentBlockRewriterTest >> classToTest [ 

	^MiBulkCommentBlockRewriter 
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunFirstLine_eolCR [

	bulkEditor content: ( self
		join: #( 'l1__5' 'l2_4' 'l3______10')
		with: Character cr ).

	bulkEditor editIntervals: {1 to: 10}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: ('/* --- dead code removal ---' , Smalltalk os lineEnding ,
		'l1__5' , String cr ,
		'l2_4' , String cr ,
		' --- dead code removal --- */' , Smalltalk os lineEnding ,
		'l3______10')
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunFirstLine_eolCRLF [

	bulkEditor content: ( self
		join: #( 'l1__5' 'l2_4' 'l3______10')
		with: String crlf ).

	bulkEditor editIntervals: {1 to: 10}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: ('/* --- dead code removal ---' , Smalltalk os lineEnding ,
		'l1__5' , String crlf ,
		'l2_4' , String crlf ,
		' --- dead code removal --- */' , Smalltalk os lineEnding ,
		'l3______10')
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunFirstLine_eolLF [

	bulkEditor content: ( self
		join: #( 'l1__5' 'l2_4' 'l3______10')
		with: Character lf ).

	bulkEditor editIntervals: {1 to: 10}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: ('/* --- dead code removal ---' , Smalltalk os lineEnding ,
		'l1__5' , String lf ,
		'l2_4' , String lf ,
		' --- dead code removal --- */' , Smalltalk os lineEnding ,
		'l3______10')
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunLastLineNoEnd_eolCR [
	"last interval go until end of file and there is no end-of-line"

	bulkEditor content: ( self
		join: #( 'l1__5' 'l2_4' 'l3______10')
		with: Character cr ).

	bulkEditor editIntervals: {12 to: 21}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: (	'l1__5' , String cr ,
		'l2_4' , String cr ,
		'/* --- dead code removal ---' , Smalltalk os lineEnding ,
		'l3______10' , Smalltalk os lineEnding ,
		' --- dead code removal --- */' , Smalltalk os lineEnding)
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunLastLineNoEnd_eolCRLF [
	"last interval go until end of file and there is no end-of-line"

	bulkEditor content: ( self
		join: #( 'l1__5' 'l2_4' 'l3______10')
		with: String crlf ).

	bulkEditor editIntervals: {14 to: 23}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: (	'l1__5' , String crlf ,
		'l2_4' , String crlf ,
		'/* --- dead code removal ---' , Smalltalk os lineEnding ,
		'l3______10' , Smalltalk os lineEnding ,
		' --- dead code removal --- */' , Smalltalk os lineEnding)
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunLastLineNoEnd_eolLF [
	"last interval go until end of file and there is no end-of-line"

	bulkEditor content: ( self
		join: #( 'l1__5' 'l2_4' 'l3______10')
		with: Character lf ).

	bulkEditor editIntervals: {12 to: 21}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: (	'l1__5' , String lf ,
		'l2_4' , String lf ,
		'/* --- dead code removal ---' , Smalltalk os lineEnding ,
		'l3______10' , Smalltalk os lineEnding ,
		' --- dead code removal --- */' , Smalltalk os lineEnding)
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunLastLineWithEnd_eolCR [
	"last interval go until end of file and there is an end-of-line"

	bulkEditor content: ( self
		join: #( 'l1__5' 'l2_4' 'l3______10' '')
		with: Character cr ).

	bulkEditor editIntervals: {12 to: 21}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: (	'l1__5' , String cr ,
		'l2_4' , String cr ,
		'/* --- dead code removal ---' , Smalltalk os lineEnding ,
		'l3______10' , String cr ,
		' --- dead code removal --- */' , Smalltalk os lineEnding)
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunLastLineWithEnd_eolCRLF [
	"last interval go until end of file and there is an end-of-line"

	bulkEditor content: ( self
		join: #( 'l1__5' 'l2_4' 'l3______10' '')
		with: String crlf ).

	bulkEditor editIntervals: {14 to: 23}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: (	'l1__5' , String crlf ,
		'l2_4' , String crlf ,
		'/* --- dead code removal ---' , Smalltalk os lineEnding ,
		'l3______10' , String crlf ,
		' --- dead code removal --- */' , Smalltalk os lineEnding)
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunLastLineWithEnd_eolLF [
	"last interval go until end of file and there is an end-of-line"

	bulkEditor content: ( self
		join: #( 'l1__5' 'l2_4' 'l3______10' '')
		with: Character lf ).

	bulkEditor editIntervals: {12 to: 21}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: (	'l1__5' , String lf ,
		'l2_4' , String lf ,
		'/* --- dead code removal ---' , Smalltalk os lineEnding ,
		'l3______10' , String lf ,
		' --- dead code removal --- */' , Smalltalk os lineEnding)
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunLineWithComment [

	bulkEditor content: ( self
		join: #( 'l1*/5' 'l2_4' 'l3______10')
		with: Character cr ).

	bulkEditor editIntervals: {1 to: 10}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: ('/* --- dead code removal ---' , Smalltalk os lineEnding ,
			'l1*_/5' , String cr ,
			'l2_4' , String cr ,
			' --- dead code removal --- */' , Smalltalk os lineEnding ,
			'l3______10')
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunMiddleLine_eolCR [

	bulkEditor content: ( self
		join: #( 'l1__5' 'l2_4' 'l3______10')
		with: Character cr ).

	bulkEditor editIntervals: {7 to: 10}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: (	'l1__5' , String cr ,
			'/* --- dead code removal ---' , Smalltalk os lineEnding ,
			'l2_4' , String cr ,
			' --- dead code removal --- */' , Smalltalk os lineEnding ,
			'l3______10')
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunMiddleLine_eolCRLF [

	bulkEditor content: ( self
		join: #( 'l1__5' 'l2_4' 'l3______10')
		with: String crlf ).

	bulkEditor editIntervals: {8 to: 11}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: (	'l1__5' , String crlf ,
			'/* --- dead code removal ---' , Smalltalk os lineEnding ,
			'l2_4' , String crlf ,
			' --- dead code removal --- */' , Smalltalk os lineEnding ,
			'l3______10')
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunMiddleLine_eolLF [

	bulkEditor content: ( self
		join: #( 'l1__5' 'l2_4' 'l3______10')
		with: Character lf ).

	bulkEditor editIntervals: {7 to: 10}.

	bulkEditor run.

	self
		assert: bulkEditor stream contents
		equals: (	'l1__5' , String lf ,
			'/* --- dead code removal ---' , Smalltalk os lineEnding ,
			'l2_4' , String lf ,
			' --- dead code removal --- */' , Smalltalk os lineEnding ,
			'l3______10')
]
