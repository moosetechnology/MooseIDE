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
	#superclass : 'MiBulkEditorAbstract',
	#category : 'MooseIDE-BulkEditor',
	#package : 'MooseIDE-BulkEditor'
}

{ #category : 'options' }
MiBulkEditor >> commentLines [

	rewriter := MiBulkCommentBlockRewriter
]

{ #category : 'intervals' }
MiBulkEditor >> emptyLinesBetween: first and: last [

	first+1 to: last-1 do: [ :i |
		((previousFileContent at: i) isSeparator)
			ifFalse: [ ^false ]
	].

	^true
	
]

{ #category : 'initialization' }
MiBulkEditor >> initialize [ 

	super initialize.

	self commentLines 
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
	 - convert entities to position intervals and expand the intervals to include preceeding comment if any
	 - merge intervals separated only by blank lines"

	^self mergeIntervals: (
		(super intervalsToEdit: entities)
			collect: [ :methodInterval | self intervalWithMethodComment: methodInterval ]
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

{ #category : 'options' }
MiBulkEditor >> removeLines [
	rewriter := MiBulkRemoveLinesRewriter
]
