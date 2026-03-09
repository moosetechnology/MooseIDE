Class {
	#name : 'MiBulkEditorAbstract',
	#superclass : 'Object',
	#instVars : [
		'previousFileContent',
		'rewriter'
	],
	#category : 'MooseIDE-BulkEditor',
	#package : 'MooseIDE-BulkEditor'
}

{ #category : 'intervals' }
MiBulkEditorAbstract >> collectIntervals: data [

	^data
		reject: [ :entity | entity sourceAnchor isNil ]
		thenCollect: [ :entity |
			MiBulkInterval
				from: entity sourceAnchor startPos
				to: entity sourceAnchor endPos
				data: entity
	]
]

{ #category : 'running' }
MiBulkEditorAbstract >> editFile: aFileReference entities: entities [

	previousFileContent := aFileReference contents.

	self rewriteFile: aFileReference atIntervals: (self intervalsToEdit: entities).

]

{ #category : 'utilities' }
MiBulkEditorAbstract >> groupByFile: entities [

	^(entities reject: [:e | e sourceAnchor isNil ])
		groupedBy: [ :e | e sourceAnchor fileName ]
]

{ #category : 'intervals' }
MiBulkEditorAbstract >> intervalsToEdit: data [

	^self sortByPosition: (self collectIntervals: data)
]

{ #category : 'utilities' }
MiBulkEditorAbstract >> mooseModel: entities [

	^entities anyOne mooseModel
]

{ #category : 'running' }
MiBulkEditorAbstract >> rewriteFile: aFileReference atIntervals: intervalsToEdit [

	aFileReference delete.
	
	aFileReference writeStreamDo: [ :st |
		rewriter new
			stream: st ;
			content: previousFileContent ;
			editIntervals: intervalsToEdit ;
			run ].
]

{ #category : 'running' }
MiBulkEditorAbstract >> runOn: data [

	| rootFolder |
	rootFolder := (self mooseModel: data) rootFolder asFileReference.

	(self groupByFile: data) associationsDo: [ :fileEntitiesAssociation |
		self
			editFile: rootFolder / fileEntitiesAssociation key
			entities: fileEntitiesAssociation value ]
]

{ #category : 'utilities' }
MiBulkEditorAbstract >> sortByPosition: intervals [
	"sort intervals in increasing order"

	^intervals sorted: [ :i | i first ] ascending
]
