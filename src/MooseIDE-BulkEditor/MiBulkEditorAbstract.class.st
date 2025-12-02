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

{ #category : 'utilities' }
MiBulkEditorAbstract >> groupByFile: entities [

	^(entities reject: [:e | e sourceAnchor isNil ])
		groupedBy: [ :e | e sourceAnchor fileName ]
]

{ #category : 'intervals' }
MiBulkEditorAbstract >> intervalsToEdit: entities [

	^self sortByPosition: entities
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

{ #category : 'utilities' }
MiBulkEditorAbstract >> rootFolder: entities [

	^entities anyOne mooseModel rootFolder asFileReference
]

{ #category : 'running' }
MiBulkEditorAbstract >> runOn: data [

	| rootFolder |
	rootFolder := self rootFolder: data.

	(self groupByFile: data) associationsDo: [ :fileMethodsAssociation |
		self runOnEntities: fileMethodsAssociation value inFile: (rootFolder / fileMethodsAssociation key)
	].

]

{ #category : 'running' }
MiBulkEditorAbstract >> runOnEntities: entities inFile: aFileReference [

	previousFileContent := aFileReference contents.

	self rewriteFile: aFileReference atIntervals: (self intervalsToEdit: entities).

]

{ #category : 'utilities' }
MiBulkEditorAbstract >> sortByPosition: entities [
	"sort entities in increasing order of their starting position"

	^entities sorted: [ :e | e sourceAnchor startPos ] ascending
]
