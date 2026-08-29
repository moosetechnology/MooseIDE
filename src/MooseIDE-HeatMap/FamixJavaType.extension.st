Extension { #name : 'FamixJavaType' }

{ #category : '*MooseIDE-HeatMap' }
FamixJavaType >> lastCommit [

	^self appliedDiffs
		ifEmpty: [ 0 asDuration ]
		ifNotEmpty: [ :diffs | ((diffs collect: [ :d | d commit committed_date ]) max) - (Date year: 2025 month: 10 day: 30) ]
]
