Class {
	#name : 'MiBulkEditorAbstractRewriter',
	#superclass : 'Object',
	#instVars : [
		'stream',
		'editIntervals',
		'char',
		'interval',
		'content',
		'nextLineAction',
		'previousC'
	],
	#category : 'MooseIDE-BulkEditor',
	#package : 'MooseIDE-BulkEditor'
}

{ #category : 'actions' }
MiBulkEditorAbstractRewriter >> afterInterval: c [
	"if we waitForEndOfLine, it means we are after the interval but consider we are inside
	 otherwise, all actions default to copying the input"


	self waitForEndOfLine
		ifTrue: [ self insideInterval: c ]
		ifFalse: [ stream << c ]

]

{ #category : 'actions' }
MiBulkEditorAbstractRewriter >> beforeInterval: c [
	"all actions default to copying the input"

	stream << c

]

{ #category : 'accessing' }
MiBulkEditorAbstractRewriter >> content [

	^ content
]

{ #category : 'accessing' }
MiBulkEditorAbstractRewriter >> content: anObject [

	content := anObject
]

{ #category : 'accessing' }
MiBulkEditorAbstractRewriter >> editIntervals [
	^ editIntervals
]

{ #category : 'accessing' }
MiBulkEditorAbstractRewriter >> editIntervals: aCollection [

	editIntervals := aCollection iterator
]

{ #category : 'actions' }
MiBulkEditorAbstractRewriter >> executeNextLineAction [

	nextLineAction value.
	nextLineAction := nil
	
]

{ #category : 'actions' }
MiBulkEditorAbstractRewriter >> insideInterval: c [
	"all actions default to copying the input"

	stream << c

]

{ #category : 'actions' }
MiBulkEditorAbstractRewriter >> intervalEnd: c [
	"end of interval is still inside the interval
	 and we consider we are still in it until the next line"

	self insideInterval: c.
	self nextLineDo: [ self nextInterval ]

]

{ #category : 'actions' }
MiBulkEditorAbstractRewriter >> intervalStart: c [
	"start of interval is inside the interval"

	self insideInterval: c

]

{ #category : 'running' }
MiBulkEditorAbstractRewriter >> lineEnd: c at: i [
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
MiBulkEditorAbstractRewriter >> nextC: i [

	^(i >= content size)
		ifTrue: [ nil ]
		ifFalse: [ content at: (i+1) ]
]

{ #category : 'running' }
MiBulkEditorAbstractRewriter >> nextInterval [
	"if no intervals, create an empty interval"

	^interval := editIntervals hasNext
		ifTrue: [  editIntervals next ]
		ifFalse: [ 0 to: 0 ]
]

{ #category : 'actions' }
MiBulkEditorAbstractRewriter >> nextLineDo: aBlock [

	nextLineAction := aBlock
]

{ #category : 'running' }
MiBulkEditorAbstractRewriter >> run [ 
	"treat each character at a time
	 Consider whether it is before/inside/after the current interval
	 Also look for first and last character of the interval
	 Must have a special treatment for end-of-lines because:
	 - intervals typically do not include them, and we usually want to consider them inside the interval
	 - therer are 3 possible, non exclusive, end-of-lines"

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
			ifTrue: [ self lineEnd: c at: i]
	]
]

{ #category : 'accessing' }
MiBulkEditorAbstractRewriter >> stream [

	^ stream
]

{ #category : 'accessing' }
MiBulkEditorAbstractRewriter >> stream: anObject [

	stream := anObject
]

{ #category : 'running' }
MiBulkEditorAbstractRewriter >> switchCases: rules [

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
MiBulkEditorAbstractRewriter >> waitForEndOfLine [

	^nextLineAction isNotNil
]
