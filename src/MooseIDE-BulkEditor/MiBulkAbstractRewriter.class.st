"
Abstract class for BulkRewriter

This is intended for languages based on source file (ie. not Smalltalk)
A BulkRewriter will take:
- some `content` (current source code) to rewrite
- a (write) `stream` to output to
- a collection of `editIntervals` to modify

BulkRewriter sub-classes are specialized according to how they rewrite (or not) the editIntervals

The main method is `run` that treats the input `content` character by character
"
Class {
	#name : 'MiBulkAbstractRewriter',
	#superclass : 'Object',
	#instVars : [
		'stream',
		'editIntervals',
		'interval',
		'content',
		'nextLineAction',
		'previousC'
	],
	#category : 'MooseIDE-BulkEditor',
	#package : 'MooseIDE-BulkEditor'
}

{ #category : 'actions' }
MiBulkAbstractRewriter >> afterEol: c at: i [
	"Acts after the end-of-line (which can be CR, LF or CR+LF)
	 Treat possible end of line action if CR or LF alone
	 if CR in CR+LF, do nothing until following LF (which is the next character)
	
	Typically, only one of #beforeEol:at: , #afterEol:at: should be defined"

	self isWaitingForEol ifFalse: [ ^self ].

	(c = Character lf)
		ifTrue: [
			self executeNextLineAction.
			^self ].

	"c = Character cr"
	((self peekNextC: i) = Character lf)
		ifFalse: [
			self executeNextLineAction ]

]

{ #category : 'actions' }
MiBulkAbstractRewriter >> afterInterval: c [
	"if isWaitingForEol, it means we are after the interval but consider we are inside
	 otherwise, all actions default to copying the input"


	self isWaitingForEol
		ifTrue: [ self insideInterval: c ]
		ifFalse: [ stream << c ]

]

{ #category : 'actions' }
MiBulkAbstractRewriter >> beforeEol: c at: i [
	"Acts before the end-of-line (which can be CR, LF or CR+LF)
	 On CR or LF alone, executeNextLineAction
	 if LF in CRLF, preceeding CR will have emptied the nextLineAction so ends up doing nothing	

	Typically, only one of #beforeEol:at: , #afterEol:at: should be defined"

	self isWaitingForEol ifFalse: [ ^self ].

	self executeNextLineAction
]

{ #category : 'actions' }
MiBulkAbstractRewriter >> beforeInterval: c [
	"all actions default to copying the input"

	stream << c

]

{ #category : 'accessing' }
MiBulkAbstractRewriter >> content [

	^ content
]

{ #category : 'accessing' }
MiBulkAbstractRewriter >> content: anObject [

	content := anObject
]

{ #category : 'accessing' }
MiBulkAbstractRewriter >> editIntervals [
	^ editIntervals
]

{ #category : 'accessing' }
MiBulkAbstractRewriter >> editIntervals: aCollection [

	editIntervals := aCollection iterator
]

{ #category : 'actions' }
MiBulkAbstractRewriter >> endOfFile [
	"deal with the case of last interval finishing at end of file (without end-of-line)"

	self isWaitingForEol ifFalse: [ ^self ].

	stream << Smalltalk os lineEnding.
	self executeNextLineAction
]

{ #category : 'running' }
MiBulkAbstractRewriter >> executeNextLineAction [

	nextLineAction value.
	nextLineAction := nil
	
]

{ #category : 'running' }
MiBulkAbstractRewriter >> getNextInterval [
	"if no intervals, create an empty interval"

	^interval := editIntervals hasNext
		ifTrue: [  editIntervals next ]
		ifFalse: [ 0 to: 0 ]
]

{ #category : 'actions' }
MiBulkAbstractRewriter >> insideInterval: c [
	"all actions default to copying the input"

	stream << c

]

{ #category : 'actions' }
MiBulkAbstractRewriter >> intervalEnd: c [
	"end of interval is still inside the interval
	 and we consider we are still in it until the next line
	 So record what to do when we reach the end of the line (#nextLineDo:)"

	self insideInterval: c.
	self nextLineDo: [ self getNextInterval ]

]

{ #category : 'actions' }
MiBulkAbstractRewriter >> intervalStart: c [
	"start of interval is inside the interval"

	self insideInterval: c

]

{ #category : 'testing' }
MiBulkAbstractRewriter >> isEOL: c [

	^(c = Character cr) or: [ c = Character lf ]
]

{ #category : 'testing' }
MiBulkAbstractRewriter >> isWaitingForEol [

	^nextLineAction isNotNil
]

{ #category : 'actions' }
MiBulkAbstractRewriter >> nextLineDo: aBlock [

	nextLineAction := aBlock
]

{ #category : 'running' }
MiBulkAbstractRewriter >> peekNextC: i [

	^(i >= content size)
		ifTrue: [ nil ]
		ifFalse: [ content at: (i+1) ]
]

{ #category : 'running' }
MiBulkAbstractRewriter >> run [ 
	"treat each character at a time
	 Consider whether it is before/inside/after the current interval
	 Also look for first and last character of the interval
	 Must have a special treatment for end-of-lines because:
	 - intervals typically do not include them, and we usually want to consider them inside the interval
	 - there are 3 possible, non exclusive, end-of-lines: CR, LF, CRLF"

	nextLineAction := nil.
	self getNextInterval.

	content withIndexDo: [ :c :i |
		(self isEOL: c) ifTrue: [ self beforeEol: c at: i ].
		self switchCases: {
			[ i < interval first ] -> [ self beforeInterval: c ] .
			[ i = interval first ] -> [ self intervalStart: c ] .
			[ i = interval last ]  -> [ self intervalEnd: c ] .
			[ i > interval last ]  -> [ self afterInterval: c ] .
			[ true ]               -> [ self insideInterval: c ]
		}.

		(self isEOL: c) ifTrue: [ self afterEol: c at: i ].

		previousC := c
	].

	self endOfFile
]

{ #category : 'accessing' }
MiBulkAbstractRewriter >> stream [

	^ stream
]

{ #category : 'accessing' }
MiBulkAbstractRewriter >> stream: anObject [

	stream := anObject
]

{ #category : 'running' }
MiBulkAbstractRewriter >> switchCases: rules [

	rules do: [ :ruleAssociation || condition action |
		condition := ruleAssociation key.
		action := ruleAssociation value.
		condition value ifTrue: [
			^action value
		]
	].

	^nil
]
