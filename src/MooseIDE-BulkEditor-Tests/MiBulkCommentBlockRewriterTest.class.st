Class {
	#name : 'MiBulkCommentBlockRewriterTest',
	#superclass : 'MiBulkRewriterAbstractTest',
	#category : 'MooseIDE-BulkEditor-Tests',
	#package : 'MooseIDE-BulkEditor-Tests'
}

{ #category : 'running' }
MiBulkCommentBlockRewriterTest >> rewriterClass [ 

	^MiBulkCommentBlockRewriter 
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunFirstLine_eolCR [

	self runOnIntervals: { 1 to: 10 } withLineEnder: Character cr.

	self
		assert: bulkRewriter stream contents
		equals:
			'/* --- dead code removal ---' , Smalltalk os lineEnding , 'l1__5'
			, String cr , 'l2_4' , String cr , ' --- dead code removal --- */'
			, Smalltalk os lineEnding , 'l3______10'
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunFirstLine_eolCRLF [

	self runOnIntervals: { (1 to: 10) } withLineEnder: String crlf.

	self
		assert: bulkRewriter stream contents
		equals:
			'/* --- dead code removal ---' , Smalltalk os lineEnding , 'l1__5'
			, String crlf , 'l2_4' , String crlf
			, ' --- dead code removal --- */' , Smalltalk os lineEnding
			, 'l3______10'
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunFirstLine_eolLF [

	self runOnIntervals: { (1 to: 10) } withLineEnder: Character lf.

	self
		assert: bulkRewriter stream contents
		equals:
			'/* --- dead code removal ---' , Smalltalk os lineEnding , 'l1__5'
			, String lf , 'l2_4' , String lf , ' --- dead code removal --- */'
			, Smalltalk os lineEnding , 'l3______10'
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunLastLineNoEnd_eolCR [
	"last interval go until end of file and there is no end-of-line"

	self runOnIntervals: { (12 to: 21) } withLineEnder: Character cr.

	self
		assert: bulkRewriter stream contents
		equals: 'l1__5' , String cr , 'l2_4' , String cr
			, '/* --- dead code removal ---' , Smalltalk os lineEnding
			, 'l3______10' , Smalltalk os lineEnding
			, ' --- dead code removal --- */' , Smalltalk os lineEnding
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunLastLineNoEnd_eolCRLF [
	"last interval go until end of file and there is no end-of-line"

	self runOnIntervals: { (14 to: 23) } withLineEnder: String crlf.

	self
		assert: bulkRewriter stream contents
		equals: 'l1__5' , String crlf , 'l2_4' , String crlf
			, '/* --- dead code removal ---' , Smalltalk os lineEnding
			, 'l3______10' , Smalltalk os lineEnding
			, ' --- dead code removal --- */' , Smalltalk os lineEnding
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunLastLineNoEnd_eolLF [
	"last interval go until end of file and there is no end-of-line"

	self runOnIntervals: { (12 to: 21) } withLineEnder: Character lf.

	self
		assert: bulkRewriter stream contents
		equals: 'l1__5' , String lf , 'l2_4' , String lf
			, '/* --- dead code removal ---' , Smalltalk os lineEnding
			, 'l3______10' , Smalltalk os lineEnding
			, ' --- dead code removal --- */' , Smalltalk os lineEnding
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunLastLineWithEnd_eolCR [
	"last interval go until end of file and there is an end-of-line"

	lines := lines , #( '' ).
	self runOnIntervals: { (12 to: 21) } withLineEnder: Character cr.

	self
		assert: bulkRewriter stream contents
		equals: 'l1__5' , String cr , 'l2_4' , String cr
			, '/* --- dead code removal ---' , Smalltalk os lineEnding
			, 'l3______10' , String cr , ' --- dead code removal --- */'
			, Smalltalk os lineEnding
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunLastLineWithEnd_eolCRLF [
	"last interval go until end of file and there is an end-of-line"

	lines := lines , #( '' ).
	self runOnIntervals: { (14 to: 23) } withLineEnder: String crlf.

	self
		assert: bulkRewriter stream contents
		equals: 'l1__5' , String crlf , 'l2_4' , String crlf
			, '/* --- dead code removal ---' , Smalltalk os lineEnding
			, 'l3______10' , String crlf , ' --- dead code removal --- */'
			, Smalltalk os lineEnding
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunLastLineWithEnd_eolLF [
	"last interval go until end of file and there is an end-of-line"

	lines := lines , #( '' ).
	self runOnIntervals: { (12 to: 21) } withLineEnder: Character lf.

	self
		assert: bulkRewriter stream contents
		equals: 'l1__5' , String lf , 'l2_4' , String lf
			, '/* --- dead code removal ---' , Smalltalk os lineEnding
			, 'l3______10' , String lf , ' --- dead code removal --- */'
			, Smalltalk os lineEnding
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunLineWithComment [

	lines at: 1 put: 'l1*/5'.
	self runOnIntervals: { (1 to: 10) } withLineEnder: Character cr.

	self
		assert: bulkRewriter stream contents
		equals:
			'/* --- dead code removal ---' , Smalltalk os lineEnding , 'l1*_/5'
			, String cr , 'l2_4' , String cr , ' --- dead code removal --- */'
			, Smalltalk os lineEnding , 'l3______10'
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunMiddleLine_eolCR [

	self runOnIntervals: { (7 to: 10) } withLineEnder: Character cr.

	self
		assert: bulkRewriter stream contents
		equals: 'l1__5' , String cr , '/* --- dead code removal ---'
			, Smalltalk os lineEnding , 'l2_4' , String cr
			, ' --- dead code removal --- */' , Smalltalk os lineEnding
			, 'l3______10'
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunMiddleLine_eolCRLF [

	self runOnIntervals: { (8 to: 11) } withLineEnder: String crlf.

	self
		assert: bulkRewriter stream contents
		equals: 'l1__5' , String crlf , '/* --- dead code removal ---'
			, Smalltalk os lineEnding , 'l2_4' , String crlf
			, ' --- dead code removal --- */' , Smalltalk os lineEnding
			, 'l3______10'
]

{ #category : 'tests' }
MiBulkCommentBlockRewriterTest >> testRunMiddleLine_eolLF [

	self runOnIntervals: { (7 to: 10) } withLineEnder: Character lf.

	self
		assert: bulkRewriter stream contents
		equals: 'l1__5' , String lf , '/* --- dead code removal ---'
			, Smalltalk os lineEnding , 'l2_4' , String lf
			, ' --- dead code removal --- */' , Smalltalk os lineEnding
			, 'l3______10'
]
