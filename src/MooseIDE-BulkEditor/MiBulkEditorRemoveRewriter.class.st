Class {
	#name : 'MiBulkEditorRemoveRewriter',
	#superclass : 'MiBulkEditorAbstractRewriter',
	#category : 'MooseIDE-BulkEditor',
	#package : 'MooseIDE-BulkEditor'
}

{ #category : 'running' }
MiBulkEditorRemoveRewriter >> run [ 

	self nextInterval.
	content withIndexDo: [ :c :i |
		(i < interval first) ifTrue: [ stream << c ].
		(i > interval last) ifTrue: [ self nextInterval ]
	]
]
