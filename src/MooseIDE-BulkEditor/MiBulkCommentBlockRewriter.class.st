"
A rewriter that comments out the entities by adding (C type) block comment around it
"
Class {
	#name : 'MiBulkCommentBlockRewriter',
	#superclass : 'MiBulkAbstractRewriter',
	#category : 'MooseIDE-BulkEditor',
	#package : 'MooseIDE-BulkEditor'
}

{ #category : 'printing' }
MiBulkCommentBlockRewriter class >> commandLabel [

	^'Comment out entities (block comment)'
]

{ #category : 'accessing' }
MiBulkCommentBlockRewriter class >> strictIntervals [
	"For this rewriter it is better to enlarge (with surrounding comments) and/or merge contiguous intervals"

	^false
]

{ #category : 'actions' }
MiBulkCommentBlockRewriter >> beforeEol: c at: i [
	"Nothing to do before EOL
	Typically, only one of #beforeEol:at: , #afterEol:at: should be defined"

]

{ #category : 'actions' }
MiBulkCommentBlockRewriter >> endOfFile [
	"if last interval finishes at end of file (without end-of-line), must add one new line"

	self isWaitingForEol ifFalse: [ ^self ].

	stream << Smalltalk os lineEnding.
	self executeNextLineAction
]

{ #category : 'actions' }
MiBulkCommentBlockRewriter >> insideInterval: c [
	"deal with end of block comment inside an interval
	 we don't want the block comment to end here"

	((c = $/) and: [ previousC = $* ])
		ifTrue: [ stream << $_ ].

	super insideInterval: c.

]

{ #category : 'actions' }
MiBulkCommentBlockRewriter >> intervalEnd: c [
	"no super, override to redefine #nextLineDo: . See comment in super-class"

	self insideInterval: c.
	self nextLineDo: [
		stream
			<< ' --- dead code removal --- */' ;
			<< Smalltalk os lineEnding.
		self getNextInterval
	]


]

{ #category : 'actions' }
MiBulkCommentBlockRewriter >> intervalStart: c [

	stream
		<< '/* --- dead code removal ---' ;
		<< Smalltalk os lineEnding.

	super intervalStart: c
]
