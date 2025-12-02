"
a BulkRewriter that remove the editIntervals from the intial content
"
Class {
	#name : 'MiBulkRemoveLinesRewriter',
	#superclass : 'MiBulkAbstractRewriter',
	#category : 'MooseIDE-BulkEditor',
	#package : 'MooseIDE-BulkEditor'
}

{ #category : 'actions' }
MiBulkRemoveLinesRewriter >> endOfFile [
	"nothing to do"
]

{ #category : 'actions' }
MiBulkRemoveLinesRewriter >> insideInterval: c [
	"do not copy the characters inside an interval"

]
