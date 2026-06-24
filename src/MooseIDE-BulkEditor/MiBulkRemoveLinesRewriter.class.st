"
A rewriter that removes out the entities from the intial content
"
Class {
	#name : 'MiBulkRemoveLinesRewriter',
	#superclass : 'MiBulkAbstractRewriter',
	#category : 'MooseIDE-BulkEditor',
	#package : 'MooseIDE-BulkEditor'
}

{ #category : 'printing' }
MiBulkRemoveLinesRewriter class >> commandLabel [

	^'Remove entities from source code'
]

{ #category : 'accessing' }
MiBulkRemoveLinesRewriter class >> strictIntervals [
	"For this rewriter it is better to enlarge (with surrounding comments) and/or merge contiguous intervals"

	^false
]

{ #category : 'actions' }
MiBulkRemoveLinesRewriter >> beforeEol: c at: i [
	"Nothing to do before EOL
	Typically, only one of #beforeEol:at: , #afterEol:at: should be defined"

]

{ #category : 'actions' }
MiBulkRemoveLinesRewriter >> insideInterval: c [
	"do not copy the characters inside an interval"

]
