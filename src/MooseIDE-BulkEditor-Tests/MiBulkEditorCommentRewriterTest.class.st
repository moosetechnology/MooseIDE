Class {
	#name : 'MiBulkEditorCommentRewriterTest',
	#superclass : 'MiBulkEditorAbstractTest',
	#category : 'MooseIDE-BulkEditor-Tests',
	#package : 'MooseIDE-BulkEditor-Tests'
}

{ #category : 'running' }
MiBulkEditorCommentRewriterTest >> classToTest [ 

	^MiBulkEditorCommentRewriter 
]

{ #category : 'running' }
MiBulkEditorCommentRewriterTest >> setUp [ 

	super setUp.

	bulkEditor stream: String new writeStream.

]

{ #category : 'tests' }
MiBulkEditorCommentRewriterTest >> testCommentOutFirstLineCR [

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
MiBulkEditorCommentRewriterTest >> testCommentOutFirstLineCRLF [

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
MiBulkEditorCommentRewriterTest >> testCommentOutFirstLineLF [

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
MiBulkEditorCommentRewriterTest >> testCommentOutLastLineNoEndCR [
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
MiBulkEditorCommentRewriterTest >> testCommentOutLastLineNoEndCRLF [
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
MiBulkEditorCommentRewriterTest >> testCommentOutLastLineNoEndLF [
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
MiBulkEditorCommentRewriterTest >> testCommentOutLastLineWithEndCR [
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
MiBulkEditorCommentRewriterTest >> testCommentOutLastLineWithEndCRLF [
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
MiBulkEditorCommentRewriterTest >> testCommentOutLastLineWithEndLF [
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
MiBulkEditorCommentRewriterTest >> testCommentOutLineWithComment [

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
MiBulkEditorCommentRewriterTest >> testCommentOutMiddleLineCR [

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
MiBulkEditorCommentRewriterTest >> testCommentOutMiddleLineCRLF [

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
MiBulkEditorCommentRewriterTest >> testCommentOutMiddleLineLF [

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
