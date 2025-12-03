Class {
	#name : 'MiBulkRewriterAbstractTest',
	#superclass : 'MiBulkAbstractTest',
	#category : 'MooseIDE-BulkEditor-Tests',
	#package : 'MooseIDE-BulkEditor-Tests'
}

{ #category : 'tests' }
MiBulkRewriterAbstractTest >> setUp [ 

	super setUp.

	bulkEditor stream: String new writeStream.

]
