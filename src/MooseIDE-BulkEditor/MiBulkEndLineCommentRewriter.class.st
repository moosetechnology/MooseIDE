"
a BulkRewriter that comment out the intervals by adding (C type) block comment around it
"
Class {
	#name : 'MiBulkEndLineCommentRewriter',
	#superclass : 'MiBulkAbstractRewriter',
	#category : 'MooseIDE-BulkEditor',
	#package : 'MooseIDE-BulkEditor'
}

{ #category : 'actions' }
MiBulkEndLineCommentRewriter >> intervalEnd: c [
	"override because #nextLineDo: is different
	 see comment in super-class"

	self insideInterval: c.
	self nextLineDo: [
		stream
			<< ' // '.
		self getNextInterval
	]


]

{ #category : 'actions' }
MiBulkEndLineCommentRewriter >> lineEnd: c at: i [
	"Acts before the end-of-line (which can be CR, LF or CR+LF)
	 On CR or LF alone, executeNextLineAction
	 if LF in CRLF, preceeding CR will have emptied the nextLineAction so ends up doing nothing"

	self isWaitingForEol ifFalse: [ ^self ].

	self executeNextLineAction.

	
]
