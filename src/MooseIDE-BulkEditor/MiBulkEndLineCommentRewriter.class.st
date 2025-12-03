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
MiBulkEndLineCommentRewriter >> afterEol: c at: i [
	"Nothing to do after EOL
	Typically, only one of #beforeEol:at: , #afterEol:at: should be defined"

]

{ #category : 'actions' }
MiBulkEndLineCommentRewriter >> intervalEnd: c [
	"override because #nextLineDo: is different
	 see comment in super-class"

	self insideInterval: c.
	self nextLineDo: [
		stream
			<< ' // same constant as: '.
		interval data value do: [ :entity | stream << entity mooseName ] separatedBy: [ stream << ', ' ].
		self getNextInterval
	]


]
