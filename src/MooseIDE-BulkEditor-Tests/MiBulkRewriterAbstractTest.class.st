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

{ #category : 'tests' }
MiBulkRewriterAbstractTest >> setUp [ 

	super setUp.

	bulkEditor stream: String new writeStream.

]
