"
Bulk commenter on a Java file: comment out a collection of methods
Can be applied for example on dead methods:
- compute all dead methods in a file -> `deadMethodCollection`
- call: `MiBulkCommenter new runOn: deadMethodCollection.`
- Output the resulting lines in a file
```
bulkCommenter := MiBulkCommenter new.
bulkCommenter runOn: deadMethods.
file := 'SomeFile.java' asFileReference.
file ifExists: [ file delete ].
file writeStreamDo: [ :st | bulkCommenter lines do: [ :line | st << line ; cr ] ].
```
"
Class {
	#name : 'MiBulkCommenter',
	#superclass : 'Object',
	#instVars : [
		'lines'
	],
	#category : 'MooseIDE-BulkCommenter',
	#package : 'MooseIDE-BulkCommenter'
}

{ #category : 'running' }
MiBulkCommenter >> commentOutEntity: method [

	| firstLastLine |

	firstLastLine := self firstLastLine: (self methodWithCommentInterval: method).

	self uncloseCommentBetween: firstLastLine.
	lines add: ' --- dead code removal --- */' afterIndex: firstLastLine last.
	lines add: '/* --- dead code removal ---' beforeIndex: firstLastLine first.
]

{ #category : 'running' }
MiBulkCommenter >> firstLastLine: firstLastPos [
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
MiBulkCommenter >> getCode: methods [

	| file |
	file := methods anyOne mooseModel rootFolder asFileReference / (methods anyOne sourceAnchor fileName).
	^file contents
]

{ #category : 'accessing' }
MiBulkCommenter >> lines [

	^lines
]

{ #category : 'running' }
MiBulkCommenter >> runOn: methods [

	lines := (self getCode: methods) lines asOrderedCollection.

	(self sortByLine: methods) do: [ :meth | self commentOutEntity: meth ].

	^lines
]

{ #category : 'running' }
MiBulkCommenter >> sortByLine: methods [
	"sort methods in reverse order (decreasing) of their starting position"
	^methods sorted: [ :m1 :m2 |
		m1 sourceAnchor startPos > m2 sourceAnchor endPos
	]
]

{ #category : 'running' }
MiBulkCommenter >> uncloseCommentBetween: firstLastLine [

	firstLastLine first to: firstLastLine last do: [ :i |
		lines at: i put: (self uncloseCommentsIn: (lines at: i))
	]
]

{ #category : 'running' }
MiBulkCommenter >> uncloseCommentsIn: line [

	^(line includesSubstring: '*/')
		ifTrue: [ line copyReplaceAll: '*/' with: '*_/' ]
		ifFalse: [ line ]
]
