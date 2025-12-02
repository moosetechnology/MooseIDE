"
a BulkRewriter that comment out the intervals by adding (C type) block comment around it
"
Class {
	#name : 'MiBulkCommentBlockRewriter',
	#superclass : 'MiBulkAbstractRewriter',
	#category : 'MooseIDE-BulkEditor',
	#package : 'MooseIDE-BulkEditor'
}

{ #category : 'actions' }
MiBulkCommentBlockRewriter >> insideInterval: c [
	"all actions default to copying the input"

	((c = $/) and: [ previousC = $* ])
		ifTrue: [ stream << $_ ].

	super insideInterval: c.

]

{ #category : 'actions' }
MiBulkCommentBlockRewriter >> intervalEnd: c [
	"override because #nextLineDo: is different
	 see comment in super-class"

	self insideInterval: c.
	self nextLineDo: [
		stream
			<< ' --- dead code removal --- */' ;
			<< Smalltalk os lineEnding.
		self nextInterval
	]


]

{ #category : 'actions' }
MiBulkCommentBlockRewriter >> intervalStart: c [

	stream
		<< '/* --- dead code removal ---' ;
		<< Smalltalk os lineEnding.

	super intervalStart: c
]

{ #category : 'running' }
MiBulkCommentBlockRewriter >> run [
	"need to deal with the case of last interval finishing at end of file"

	super run.

	self waitForEndOfLine 
		ifTrue: [ 
			stream << Smalltalk os lineEnding.
			self executeNextLineAction ]
]
