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

	editMode := #comment
]

{ #category : 'intervals' }
MiBulkEditor >> commentOutInterval: lineInterval [

	self uncloseCommentBetween: lineInterval .
	previousFileContent add: ' --- dead code removal --- */' afterIndex: lineInterval last.
	previousFileContent add: '/* --- dead code removal ---' beforeIndex: lineInterval first.
]

{ #category : 'intervals' }
MiBulkEditor >> editInterval: lineInterval [

	(editMode = #comment) ifTrue: [ self commentOutInterval: lineInterval ].
	(editMode = #remove) ifTrue: [ self removeInterval: lineInterval ].
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
MiBulkEditor >> firstLastLine: firstLastPos [
	"firstLastPos is an interval of start/end position
	 compute and returns from it an interval of lines"

	| startLine endLine totalPos |

	startLine := endLine := 0.
	totalPos := 0.
	previousFileContent withIndexDo: [ :line :iLine |
		totalPos := totalPos + line size + 1.
		((totalPos > firstLastPos first)  and: [ startLine = 0 ])
			ifTrue: [ startLine := iLine ].

		((totalPos > firstLastPos last)  and: [ endLine = 0 ])
			ifTrue: [
				endLine := iLine.
				^startLine to: endLine
			].
	].

	^startLine to: previousFileContent size

]

{ #category : 'running' }
MiBulkEditor >> groupByFile: methods [

	^methods groupedBy: [ :mth | mth sourceAnchor fileName ]
]

{ #category : 'initialization' }
MiBulkEditor >> initialize [ 

	super initialize.

	self commentLines 
]

{ #category : 'accessing' }
MiBulkEditor >> lines [

	^previousFileContent
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

	^method comments
		detect: [ :cmt | cmt sourceAnchor endPos < method sourceAnchor startPos ]
		ifOne: [ :cmt | cmt sourceAnchor startPos to: method sourceAnchor endPos ]
		ifNone: [ method sourceAnchor startPos to: method sourceAnchor endPos ]
]

{ #category : 'intervals' }
MiBulkEditor >> positionIntervals: methods [

	^(self sortByPosition: methods)
		collect: [ :meth |
			self methodWithCommentInterval: meth
		].

]

{ #category : 'intervals' }
MiBulkEditor >> removeInterval: lineInterval [

	| editedLines |
	editedLines := OrderedCollection new: (previousFileContent size - lineInterval size).
	
	previousFileContent withIndexDo: [ :lineI :i |
		((i < lineInterval first) or: [ i > lineInterval last ])
			ifTrue: [ editedLines add: lineI ]
	].

	^previousFileContent := editedLines 
]

{ #category : 'accessing' }
MiBulkEditor >> removeLines [

	editMode := #remove
]

{ #category : 'running' }
MiBulkEditor >> rewriteFile: aFileReference atIntervals: intervalsToEdit [

	aFileReference delete.
	aFileReference writeStreamDo: [ :st |
		self rewriter
			stream: st ;
			previousContent: previousFileContent ;
			editIntervals: intervalsToEdit ;
			run ].
]

{ #category : 'utilities' }
MiBulkEditor >> rewriter [
	"defaults to commenting because it is not destructive"

	(editMode = #comment) ifTrue: [ ^MiBulkEditorCommentRewriter new ].
	(editMode = #remove) ifTrue: [ ^MiBulkEditorRemoveRewriter new ].
	
	^MiBulkEditorCommentRewriter new
]

{ #category : 'running' }
MiBulkEditor >> runOn: methods [

	| rootFolder |
	rootFolder := methods anyOne mooseModel rootFolder asFileReference.

	(self groupByFile: methods) associationsDo: [ :fileMethodsAssociation |
		self runOnMethods: fileMethodsAssociation value inFile: (rootFolder / fileMethodsAssociation key)
	].

]

{ #category : 'running' }
MiBulkEditor >> runOnMethods: methods inFile: aFileReference [

	previousFileContent := aFileReference contents.

	self rewriteFile: aFileReference atIntervals: (self positionIntervals: methods).

]

{ #category : 'utilities' }
MiBulkEditor >> sortByPosition: methods [
	"sort methods in increasing order of their starting position"

	^methods sorted: [ :m | m sourceAnchor startPos ] ascending
]

{ #category : 'intervals' }
MiBulkEditor >> uncloseCommentBetween: firstLastLine [

	firstLastLine first to: firstLastLine last do: [ :i |
		previousFileContent at: i put: (self uncloseCommentsIn: (previousFileContent at: i))
	]
]

{ #category : 'utilities' }
MiBulkEditor >> uncloseCommentsIn: line [

	^(line includesSubstring: '*/')
		ifTrue: [ line copyReplaceAll: '*/' with: '*_/' ]
		ifFalse: [ line ]
]
