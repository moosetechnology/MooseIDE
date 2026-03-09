Class {
	#name : 'MiBulkRewriterAbstractTest',
	#superclass : 'MiBulkAbstractTest',
	#instVars : [
		'lines'
	],
	#category : 'MooseIDE-BulkEditor-Tests',
	#package : 'MooseIDE-BulkEditor-Tests'
}

{ #category : 'running' }
MiBulkRewriterAbstractTest >> join: lines with: separator [

	^String streamContents: [ :st |
		lines
			do: [ :aLine | st << aLine ]
			separatedBy: [ st << separator ]
	]
]

{ #category : 'running' }
MiBulkRewriterAbstractTest >> joinLinesWith: separator [

	^self join: lines with: separator
]

{ #category : 'tests' }
MiBulkRewriterAbstractTest >> setUp [ 

	super setUp.

	bulkEditor stream: String new writeStream.
	lines := { 'l1__5' . 'l2_4' . 'l3______10' }

]
