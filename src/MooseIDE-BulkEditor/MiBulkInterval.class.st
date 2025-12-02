Class {
	#name : 'MiBulkInterval',
	#superclass : 'Interval',
	#instVars : [
		'data'
	],
	#category : 'MooseIDE-BulkEditor',
	#package : 'MooseIDE-BulkEditor'
}

{ #category : 'instance creation' }
MiBulkInterval class >> from: first to: last data: data [

	^(self from: first to: last)
		data: data
]

{ #category : 'accessing' }
MiBulkInterval >> data [

	^ data
]

{ #category : 'accessing' }
MiBulkInterval >> data: anObject [

	data := anObject
]
