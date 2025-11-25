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

{ #category : 'as yet unclassified' }
MiBulkEditorAbstractRewriter >> nextInterval [
	"if no more intervals, create a intervalafter the end of the content"
	^interval := editIntervals hasNext
		ifTrue: [ editIntervals next ]
		ifFalse: [ (content size + 1) to: (content size + 1) ]
]

{ #category : 'running' }
MiBulkEditorAbstractRewriter >> run [
	self subclassResponsibility 
]

{ #category : 'accessing' }
MiBulkEditorAbstractRewriter >> stream [

	^ stream
]

{ #category : 'accessing' }
MiBulkEditorAbstractRewriter >> stream: anObject [

	stream := anObject
]
