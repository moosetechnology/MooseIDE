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
		'lines'
	],
	#category : 'MooseIDE-BulkEditor',
	#package : 'MooseIDE-BulkEditor'
}

{ #category : 'running' }
MiBulkEditor >> commentOutEntity: method [

	| firstLastLine |

	firstLastLine := self firstLastLine: (self methodWithCommentInterval: method).

	self uncloseCommentBetween: firstLastLine.
	lines add: ' --- dead code removal --- */' afterIndex: firstLastLine last.
	lines add: '/* --- dead code removal ---' beforeIndex: firstLastLine first.
]

{ #category : 'running' }
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
MiBulkEditor >> getCode: methods [

	| file |
	file := methods anyOne mooseModel rootFolder asFileReference / (methods anyOne sourceAnchor fileName).
	^file contents
]

{ #category : 'accessing' }
MiBulkEditor >> lines [

	^lines
]

{ #category : 'running' }
MiBulkEditor >> methodWithCommentInterval: method [

	^method comments
		detect: [ :cmt | cmt sourceAnchor endPos < method sourceAnchor startPos ]
		ifOne: [ :cmt | cmt sourceAnchor startPos to: method sourceAnchor endPos ]
		ifNone: [ method sourceAnchor startPos to: method sourceAnchor endPos ]
]

{ #category : 'running' }
MiBulkEditor >> runOn: methods [

	lines := (self getCode: methods) lines asOrderedCollection.

	(self sortByLine: methods) do: [ :meth | self commentOutEntity: meth ].

	^lines
]

{ #category : 'running' }
MiBulkEditor >> sortByLine: methods [
	"sort methods in reverse order (decreasing) of their starting position"
	^methods sorted: [ :m1 :m2 |
		m1 sourceAnchor startPos > m2 sourceAnchor endPos
	]
]

{ #category : 'running' }
MiBulkEditor >> uncloseCommentBetween: firstLastLine [

	firstLastLine first to: firstLastLine last do: [ :i |
		lines at: i put: (self uncloseCommentsIn: (lines at: i))
	]
]

{ #category : 'running' }
MiBulkEditor >> uncloseCommentsIn: line [

	^(line includesSubstring: '*/')
		ifTrue: [ line copyReplaceAll: '*/' with: '*_/' ]
		ifFalse: [ line ]
]
