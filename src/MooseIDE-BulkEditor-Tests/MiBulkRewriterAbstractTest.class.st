Class {
	#name : 'MiBulkRewriterAbstractTest',
	#superclass : 'TestCase',
	#instVars : [
		'lines',
		'bulkRewriter'
	],
	#category : 'MooseIDE-BulkEditor-Tests',
	#package : 'MooseIDE-BulkEditor-Tests'
}

{ #category : 'running' }
MiBulkRewriterAbstractTest >> interval: aPoint data: entityName [

	^MiBulkInterval
		from: aPoint x
		to: aPoint y
		data: (FamixJavaMethod new name: entityName ; yourself)
]

{ #category : 'running' }
MiBulkRewriterAbstractTest >> joinLinesWith: separator [

	^String streamContents: [ :st |
		lines
			do: [ :aLine | st << aLine ]
			separatedBy: [ st << separator ]
	]
]

{ #category : 'running' }
MiBulkRewriterAbstractTest >> rewriterClass [

	self subclassResponsibility 
]

{ #category : 'running' }
MiBulkRewriterAbstractTest >> runOnIntervals: intervals withLineEnder: lineEnder [

	bulkRewriter content: (self joinLinesWith: lineEnder).
	bulkRewriter editIntervals: intervals.
	bulkRewriter run
]

{ #category : 'running' }
MiBulkRewriterAbstractTest >> setUp [ 

	super setUp.

	bulkRewriter := self rewriterClass new.
	bulkRewriter stream: String new writeStream.
	lines := { 'l1__5' . 'l2_4' . 'l3______10' }

]
