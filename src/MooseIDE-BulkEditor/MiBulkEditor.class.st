"
Bulk editor on a Java file: comment out a collection of methods
Can be applied for example on dead methods:
- compute all dead methods in a file -> `deadMethodCollection`
- call: `MiBulkEditor new runOn: deadMethodCollection.`
- Output the resulting lines in a file
```
bulkEditor := MiBulkEditor new.
bulkEditor runOn: deadMethods.
file := 'SomeFile.java' asFileReference.
file ifExists: [ file delete ].
file writeStreamDo: [ :st | bulkEditor lines do: [ :line | st << line ; cr ] ].
```
"
Class {
	#name : 'MiBulkEditor',
	#superclass : 'Object',
	#instVars : [
		'editMode',
		'previousFileContent'
	],
	#category : 'MooseIDE-BulkEditor',
	#package : 'MooseIDE-BulkEditor'
}

{ #category : 'accessing' }
MiBulkEditor >> commentLines [

	editMode := MiBulkCommentBlockRewriter
]

{ #category : 'intervals' }
MiBulkEditor >> emptyLinesBetween: first and: last [

	first+1 to: last-1 do: [ :i |
		((previousFileContent at: i) isSeparator)
			ifFalse: [ ^false ]
	].

	^true
	
]

{ #category : 'running' }
MiBulkEditor >> groupByFile: entities [

	^(entities reject: [:e | e sourceAnchor isNil ])
		groupedBy: [ :e | e sourceAnchor fileName ]
]

{ #category : 'initialization' }
MiBulkEditor >> initialize [ 

	super initialize.

	self commentLines 
]

{ #category : 'intervals' }
MiBulkEditor >> intervalsToEdit: methods [
	"- sort methods in ascending order
	 - convert methods to position intervals and expand the intervals to include method comment if any
	 - merge intervals separated only by blank lines"

	^self mergeIntervals: (
		(self sortByPosition: methods)
			collect: [ :meth | self methodWithCommentInterval: meth ]
	)

]

{ #category : 'intervals' }
MiBulkEditor >> mergeIntervals: intervals [
	"merge together 2 intervals separated only by blank lines"

	| intervalsIterator lastInterval merged |
	merged := OrderedCollection new: intervals size.

	intervalsIterator := intervals iterator withCollectionAPI.
	
	intervalsIterator hasNext ifFalse: [ ^intervals ].

	lastInterval := intervalsIterator next.

	intervalsIterator do: [ :nextInterval |
		(self emptyLinesBetween: lastInterval last and: nextInterval first)
			ifTrue: [ lastInterval := lastInterval first to: nextInterval last ]
			ifFalse: [ 
				merged add: lastInterval.
				lastInterval := nextInterval
			]
	].

	merged add: lastInterval.

	^merged 
]

{ #category : 'intervals' }
MiBulkEditor >> methodWithCommentInterval: method [
	"Adds preceeding comment (if any)) to the interval of a method"

	^method comments
		detect: [ :cmt | cmt sourceAnchor endPos < method sourceAnchor startPos ]
		ifOne: [ :cmt | cmt sourceAnchor startPos to: method sourceAnchor endPos ]
		ifNone: [ method sourceAnchor startPos to: method sourceAnchor endPos ]
]

{ #category : 'accessing' }
MiBulkEditor >> removeLines [

	editMode := MiBulkRemoveLinesRewriter
]

{ #category : 'running' }
MiBulkEditor >> rewriteFile: aFileReference atIntervals: intervalsToEdit [

	aFileReference delete.

	aFileReference writeStreamDo: [ :st |
		editMode new
			stream: st ;
			content: previousFileContent ;
			editIntervals: intervalsToEdit ;
			run ].
]

{ #category : 'running' }
MiBulkEditor >> runOn: entities [

	| rootFolder |
	rootFolder := entities anyOne mooseModel rootFolder asFileReference.

	(self groupByFile: entities) associationsDo: [ :fileMethodsAssociation |
		self runOnEntities: fileMethodsAssociation value inFile: (rootFolder / fileMethodsAssociation key)
	].

]

{ #category : 'running' }
MiBulkEditor >> runOnEntities: entities inFile: aFileReference [

	previousFileContent := aFileReference contents.

	self rewriteFile: aFileReference atIntervals: (self intervalsToEdit: entities).

]

{ #category : 'utilities' }
MiBulkEditor >> sortByPosition: entities [
	"sort entities in increasing order of their starting position"

	^entities sorted: [ :e | e sourceAnchor startPos ] ascending
]
