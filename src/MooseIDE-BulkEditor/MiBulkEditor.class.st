"
Bulk editor on Java files: comment out or remove a collection of methods
Can be applied for example on dead methods:
- compute all dead methods in a file -> `deadMethodCollection`
- call: `MiBulkEditor new runOn: deadMethodCollection.`

The following will comment out or remove a list of methods from their respective source files
```
bulkEditor := MiBulkEditor new.
bulkEditor runOn: <deadMethodCollection>.
```

The default is to comment out the methods: `bulkEditor commentLines`
The editor can be instructed to remove the methods from their files: `bulkEditor removeLines`
"
Class {
	#name : 'MiBulkEditor',
	#superclass : 'Object',
	#instVars : [
		'previousFileContent',
		'rewriterClass'
	],
	#category : 'MooseIDE-BulkEditor',
	#package : 'MooseIDE-BulkEditor'
}

{ #category : 'intervals' }
MiBulkEditor >> collectIntervals: data [

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
MiBulkEditor >> editFile: aFileReference entities: entities [

	previousFileContent := aFileReference contents.

	self rewriteFile: aFileReference atIntervals: (self intervalsToEdit: entities).

]

{ #category : 'intervals' }
MiBulkEditor >> emptyLinesBetween: first and: last [

	first+1 to: last-1 do: [ :i |
		((previousFileContent at: i) isSeparator)
			ifFalse: [ ^false ]
	].

	^true
	
]

{ #category : 'intervals' }
MiBulkEditor >> enlargeInterval: methodInterval [
	"first see if there is any preceeding comment that could be added to the interval
	 then see if there are indentation spaces to add to the first line"

	| tempInterval |
	self strictIntervals ifTrue: [ ^methodInterval ].

	tempInterval := self intervalWithMethodComment: methodInterval.
	^self includeIndentationSpaces: tempInterval 
]

{ #category : 'utilities' }
MiBulkEditor >> groupByFile: entities [

	^(entities reject: [:e | e sourceAnchor isNil ])
		groupedBy: [ :e | e sourceAnchor fileName ]
]

{ #category : 'intervals' }
MiBulkEditor >> includeIndentationSpaces: bulkInterval [
	"Adds indentation spaces before interval
	 If interval starts at 1, there cannot be anything before
	 If a non space character is found before the begining of the line, then cancel everything"

	| i endOfLine |

	self strictIntervals ifTrue: [ ^bulkInterval ].

	(bulkInterval first = 1) ifTrue: [ ^bulkInterval ].

	i := bulkInterval first - 1.
	endOfLine := String crlf.

	[ endOfLine includes: (previousFileContent at: i) ] 
		whileFalse: [
			(previousFileContent at: i) isSeparator
				ifFalse: [ ^bulkInterval ].
			i := i - 1 ].

	i := i + 1.
	^(i < bulkInterval first)
		ifTrue: [
			MiBulkInterval
				from: i
				to: bulkInterval last
				data: bulkInterval data ]
		ifFalse: [ bulkInterval ]
]

{ #category : 'intervals' }
MiBulkEditor >> intervalWithMethodComment: bulkInterval [
	"Adds preceeding comment (if any) to the interval of a method"

	^bulkInterval data comments
		detect: [ :cmt | cmt sourceAnchor endPos < bulkInterval first ]
		ifOne: [ :cmt |
			MiBulkInterval
				from: cmt sourceAnchor startPos
				to: bulkInterval last
				data: bulkInterval data ]
		ifNone: [ bulkInterval ]
]

{ #category : 'intervals' }
MiBulkEditor >> intervalsToEdit: entities [
	"- sort entities in ascending order
	 - convert entities to position intervals and expand the intervals with preceeding comment or indentation spaces
	 - merge intervals separated only by blank lines"

	^self mergeIntervals: (
		(self sortByPosition: (self collectIntervals: entities))
			collect: [ :methodInterval | self enlargeInterval: methodInterval ]
	)

]

{ #category : 'intervals' }
MiBulkEditor >> mergeIntervals: intervals [
	"merge together 2 intervals separated only by blank lines"

	| intervalsIterator lastInterval merged |

	self strictIntervals ifTrue: [ ^intervals ].

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

{ #category : 'utilities' }
MiBulkEditor >> mooseModel: entities [

	^entities anyOne mooseModel
]

{ #category : 'running' }
MiBulkEditor >> rewriteFile: aFileReference atIntervals: intervalsToEdit [

	aFileReference delete.
	
	aFileReference writeStreamDo: [ :st |
		rewriterClass new
			stream: st ;
			content: previousFileContent ;
			editIntervals: intervalsToEdit ;
			run ].
]

{ #category : 'accessing' }
MiBulkEditor >> rewriterClass: aMiBulkCommentBlockRewriter [ 

	rewriterClass := aMiBulkCommentBlockRewriter
]

{ #category : 'running' }
MiBulkEditor >> runOn: entities [

	| rootFolder |
	rootFolder := (self mooseModel: entities) rootFolder asFileReference.

	(self groupByFile: entities) associationsDo: [ :fileEntitiesAssociation |
		self
			editFile: rootFolder / fileEntitiesAssociation key
			entities: fileEntitiesAssociation value ]
]

{ #category : 'utilities' }
MiBulkEditor >> sortByPosition: intervals [
	"sort intervals in increasing order"

	^intervals sorted: [ :i | i first ] ascending
]

{ #category : 'accessing' }
MiBulkEditor >> strictIntervals [
	"having  strcitIntervals' means, do not enlarge or merge intervals"

	^rewriterClass strictIntervals
]
