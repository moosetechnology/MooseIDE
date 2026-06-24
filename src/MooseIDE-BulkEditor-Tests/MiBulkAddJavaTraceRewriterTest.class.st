Class {
	#name : 'MiBulkAddJavaTraceRewriterTest',
	#superclass : 'MiBulkRewriterAbstractTest',
	#category : 'MooseIDE-BulkEditor-Tests',
	#package : 'MooseIDE-BulkEditor-Tests'
}

{ #category : 'running' }
MiBulkAddJavaTraceRewriterTest >> rewriterClass [ 

	^MiBulkAddJavaTraceRewriter 
]

{ #category : 'tests' }
MiBulkAddJavaTraceRewriterTest >> testRunOneMethod_eolCR [

	lines := {
'class AClazz {' .
'	void blah() {' .
'		// inside method' .
'	} }'
	}.
	self runOnIntervals: { self interval: 16@48 data: 'blah' } withLineEnder: Character cr.

	self
		assert: bulkRewriter stream contents
		equals:
			'class AClazz {' , String cr ,
			'	void blah() {' , Smalltalk os lineEnding ,
			'System.out.println(">>> blah");' , String cr ,
			'		// inside method' , String cr ,
			'	} }'
]

{ #category : 'tests' }
MiBulkAddJavaTraceRewriterTest >> testRunOneMethod_eolCRLF [

	lines := {
'class AClazz {' .
'	void blah() {' .
'		// inside method' .
'	} }'
	}.
	self runOnIntervals: { self interval: 16@48 data: 'blah' } withLineEnder: String crlf.

	self
		assert: bulkRewriter stream contents
		equals:
			'class AClazz {' , String crlf ,
			'	void blah() {' , Smalltalk os lineEnding ,
			'System.out.println(">>> blah");' , String crlf ,
			'		// inside method' , String crlf ,
			'	} }'
]

{ #category : 'tests' }
MiBulkAddJavaTraceRewriterTest >> testRunOneMethod_eolLF [

	lines := {
'class AClazz {' .
'	void blah() {' .
'		// inside method' .
'	} }'
	}.
	self runOnIntervals: { self interval: 16@48 data: 'blah' } withLineEnder: Character lf.

	self
		assert: bulkRewriter stream contents
		equals:
			'class AClazz {' , String lf ,
			'	void blah() {' , Smalltalk os lineEnding ,
			'System.out.println(">>> blah");' , String lf ,
			'		// inside method' , String lf ,
			'	} }'
]

{ #category : 'tests' }
MiBulkAddJavaTraceRewriterTest >> testRunTwoMethods_eolCR [

	lines := {
'class AClazz {' .
'	void blah() {' .
'		// inside method' .
'	}' .
' void next()' .
'	{ }' .
'}'
	}.
	self runOnIntervals: { (self interval: 17@51 data: 'blah') . (self interval: 54@69 data: 'next') }
	withLineEnder: Character cr.

	self
		assert: bulkRewriter stream contents
		equals:
			'class AClazz {' , String cr ,
			'	void blah() {' , Smalltalk os lineEnding ,
			'System.out.println(">>> blah");' , String cr ,
			'		// inside method' , String cr ,
			'	}' , String cr ,
			' void next()' , String cr ,
			'	{' , Smalltalk os lineEnding ,
			'System.out.println(">>> next"); }' , String cr ,
			'}'
]

{ #category : 'tests' }
MiBulkAddJavaTraceRewriterTest >> testRunTwoMethods_eolLF [

	lines := {
'class AClazz {' .
'	void blah() {' .
'		// inside method' .
'	}' .
' void next()' .
'	{ }' .
'}'
	}.
	self runOnIntervals: { (self interval: 17@51 data: 'blah') . (self interval: 54@69 data: 'next') }
	withLineEnder: Character cr.

	self
		assert: bulkRewriter stream contents
		equals:
			'class AClazz {' , String cr ,
			'	void blah() {' , Smalltalk os lineEnding ,
			'System.out.println(">>> blah");' , String cr ,
			'		// inside method' , String cr ,
			'	}' , String cr ,
			' void next()' , String cr ,
			'	{' , Smalltalk os lineEnding ,
			'System.out.println(">>> next"); }' , String cr ,
			'}'
]

{ #category : 'tests' }
MiBulkAddJavaTraceRewriterTest >> testTraceFullyQualifiedName [

	| interval |
	lines := {
'class AClazz {' .
'	void blah() {' .
'		// inside method' .
'	} }'
	}.
	interval := self interval: 16 @ 48 data: 'blah'.
	interval data parentType: (FamixJavaClass new name: 'AClazz' ; yourself).

	self runOnIntervals: { interval } withLineEnder: Character cr.

	self
		assert: bulkRewriter stream contents
		equals:
			'class AClazz {' , String cr ,
			'	void blah() {' , Smalltalk os lineEnding ,
			'System.out.println(">>> AClazz.blah");' , String cr ,
			'		// inside method' , String cr ,
			'	} }'
]
