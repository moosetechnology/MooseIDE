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
MiBulkAbstractRewriter >> afterInterval: c [
	"if we waitForEndOfLine, it means we are after the interval but consider we are inside
	 otherwise, all actions default to copying the input"


	self waitForEndOfLine
		ifTrue: [ self insideInterval: c ]
		ifFalse: [ stream << c ]

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

{ #category : 'running' }
MiBulkAbstractRewriter >> executeNextLineAction [

	nextLineAction value.
	nextLineAction := nil
	
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
	self nextLineDo: [ self nextInterval ]

]

{ #category : 'actions' }
MiBulkAbstractRewriter >> intervalStart: c [
	"start of interval is inside the interval"

	self insideInterval: c

]

{ #category : 'running' }
MiBulkAbstractRewriter >> lineEnd: c at: i [
	"End of line can be CR, LF or CR+LF
	 treat the end of line if CR or LF alone
	 if CR in CR+LF, do nothing and end-of-line will be treated at next character"

	self waitForEndOfLine ifFalse: [ ^self ].

	(c = Character cr)
	ifTrue: [
		((self nextC: i) = Character lf)
			ifFalse: [ self executeNextLineAction ].
		^self
	].

	(c = Character lf)
	ifTrue: [ self executeNextLineAction ]

	
]

{ #category : 'running' }
MiBulkAbstractRewriter >> nextC: i [

	^(i >= content size)
		ifTrue: [ nil ]
		ifFalse: [ content at: (i+1) ]
]

{ #category : 'running' }
MiBulkAbstractRewriter >> nextInterval [
	"if no intervals, create an empty interval"

	^interval := editIntervals hasNext
		ifTrue: [  editIntervals next ]
		ifFalse: [ 0 to: 0 ]
]

{ #category : 'actions' }
MiBulkAbstractRewriter >> nextLineDo: aBlock [

	nextLineAction := aBlock
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
	self nextInterval.

	content withIndexDo: [ :c :i |
		self switchCases: {
			[ i < interval first ] -> [ self beforeInterval: c ] .
			[ i = interval first ] -> [ self intervalStart: c ] .
			[ i = interval last ]  -> [ self intervalEnd: c ] .
			[ i > interval last ]  -> [ self afterInterval: c ] .
			[ true ]               -> [ self insideInterval: c ]
		}.

		((c = Character cr) or: [ c = Character lf ])
			ifTrue: [ self lineEnd: c at: i].

		previousC := c
	].

	"need to deal with the case of last interval finishing at end of file"
	self waitForEndOfLine ifFalse: [ ^self ].

	stream << Smalltalk os lineEnding.
	self executeNextLineAction
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

{ #category : 'running' }
MiBulkAbstractRewriter >> waitForEndOfLine [

	^nextLineAction isNotNil
]
