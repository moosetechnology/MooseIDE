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
		'lines',
		'editMode'
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
	lines add: ' --- dead code removal --- */' afterIndex: lineInterval last.
	lines add: '/* --- dead code removal ---' beforeIndex: lineInterval first.
]

{ #category : 'intervals' }
MiBulkEditor >> editInterval: lineInterval [

	(editMode = #comment) ifTrue: [ self commentOutInterval: lineInterval ].
	(editMode = #remove) ifTrue: [ self removeInterval: lineInterval ].
]

{ #category : 'intervals' }
MiBulkEditor >> emptyLinesBetween: first and: last [

	first+1 to: last-1 do: [ :i |
		((lines at: i) allSatisfy: #isSeparator)
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
	lines withIndexDo: [ :line :iLine |
		totalPos := totalPos + line size + 1.
		((totalPos > firstLastPos first)  and: [ startLine = 0 ])
			ifTrue: [ startLine := iLine ].

		((totalPos > firstLastPos last)  and: [ endLine = 0 ])
			ifTrue: [
				endLine := iLine.
				^startLine to: endLine
			].
	].

	^startLine to: lines size

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

{ #category : 'intervals' }
MiBulkEditor >> lineIntervals: methods [

	| intervals |
	intervals := (self sortByLine: methods)
		collect: [ :meth | self firstLastLine: (self methodWithCommentInterval: meth) ].

	^self mergeIntervals: intervals
]

{ #category : 'accessing' }
MiBulkEditor >> lines [

	^lines
]

{ #category : 'intervals' }
MiBulkEditor >> mergeIntervals: intervals [
	"merge together 2 intervals separated only by blank lines"

	| lastInterval merged |
	merged := OrderedCollection new: intervals size.

	lastInterval := intervals first.
	intervals remove: lastInterval.

	intervals do: [ :nextInterval |
		(self emptyLinesBetween: nextInterval last and: lastInterval first)
			ifTrue: [ lastInterval := nextInterval first to: lastInterval last ]
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
MiBulkEditor >> removeInterval: lineInterval [

	| editedLines |
	editedLines := OrderedCollection new: (lines size - lineInterval size).
	
	lines withIndexDo: [ :lineI :i |
		((i < lineInterval first) or: [ i > lineInterval last ])
			ifTrue: [ editedLines add: lineI ]
	].

	^lines := editedLines 
]

{ #category : 'accessing' }
MiBulkEditor >> removeLines [

	editMode := #remove
]

{ #category : 'running' }
MiBulkEditor >> rewriteFile: aFileReference [

	aFileReference delete.
	aFileReference writeStreamDo: [ :st | lines do: [ :line | st << line ; cr ] ].
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

	lines := aFileReference contents lines asOrderedCollection.

	(self lineIntervals: methods) do: [ :interv | self editInterval: interv ].

	self rewriteFile: aFileReference

]

{ #category : 'utilities' }
MiBulkEditor >> sortByLine: methods [
	"sort methods in reverse order (decreasing) of their starting position"
	^methods sorted: [ :m1 :m2 |
		m1 sourceAnchor startPos > m2 sourceAnchor endPos
	]
]

{ #category : 'intervals' }
MiBulkEditor >> uncloseCommentBetween: firstLastLine [

	firstLastLine first to: firstLastLine last do: [ :i |
		lines at: i put: (self uncloseCommentsIn: (lines at: i))
	]
]

{ #category : 'utilities' }
MiBulkEditor >> uncloseCommentsIn: line [

	^(line includesSubstring: '*/')
		ifTrue: [ line copyReplaceAll: '*/' with: '*_/' ]
		ifFalse: [ line ]
]
