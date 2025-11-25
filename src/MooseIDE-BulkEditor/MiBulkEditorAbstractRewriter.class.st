Class {
	#name : 'MiBulkEditorAbstractRewriter',
	#superclass : 'Object',
	#instVars : [
		'stream',
		'editIntervals',
		'char',
		'interval',
		'content'
	],
	#category : 'MooseIDE-BulkEditor',
	#package : 'MooseIDE-BulkEditor'
}

{ #category : 'actions' }
MiBulkEditorAbstractRewriter >> afterInterval: c [
	"all actions default to copying the input"

	stream << c

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
MiBulkEditorAbstractRewriter >> insideInterval: c [
	"all actions default to copying the input"

	stream << c

]

{ #category : 'actions' }
MiBulkEditorAbstractRewriter >> intervalEnd: c [
	"end of interval is still inside the interval"

	self insideInterval: c.
	self nextInterval 

]

{ #category : 'actions' }
MiBulkEditorAbstractRewriter >> intervalStart: c [
	"start of interval is inside the interval"

	self insideInterval: c

]

{ #category : 'accessing' }
MiBulkEditorAbstractRewriter >> nextInterval [
	"if no more intervals, create a interval after the end of the content"

	^interval := editIntervals hasNext
		ifTrue: [  editIntervals next ]
		ifFalse: [ (content size + 1) to: (content size + 1) ]
]

{ #category : 'running' }
MiBulkEditorAbstractRewriter >> run [ 

	self nextInterval.

	content withIndexDo: [ :c :i |
		self switchCases: {
			[ i < interval first ] -> [ self beforeInterval: c ] .
			[ i = interval first ] -> [ self intervalStart: c ] .
			[ i = interval last ]  -> [ self intervalEnd: c ] .
			[ i > interval last ]  -> [ self afterInterval: c ] .
			[ true ]               -> [ self insideInterval: c ]
		}
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
