Class {
	#name : 'MiBulkEditorCommentRewriter',
	#superclass : 'MiBulkEditorAbstractRewriter',
	#instVars : [
		'betweenIntervals',
		'onlyBlankLines'
	],
	#category : 'MooseIDE-BulkEditor',
	#package : 'MooseIDE-BulkEditor'
}

{ #category : 'actions' }
MiBulkEditorCommentRewriter >> insideInterval: c [
	"all actions default to copying the input"

	((c = $/) and: [ previousC = $* ])
		ifTrue: [ stream << $_ ].

	super insideInterval: c.

]

{ #category : 'actions' }
MiBulkEditorCommentRewriter >> intervalEnd: c [
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
MiBulkEditorCommentRewriter >> intervalStart: c [

	stream
		<< '/* --- dead code removal ---' ;
		<< Smalltalk os lineEnding.

	super intervalStart: c
]

{ #category : 'running' }
MiBulkEditorCommentRewriter >> run [
	"need to deal with the case of last interval finishing at end of file"

	super run.

	self waitForEndOfLine 
		ifTrue: [ 
			stream << Smalltalk os lineEnding.
			self executeNextLineAction ]
]
