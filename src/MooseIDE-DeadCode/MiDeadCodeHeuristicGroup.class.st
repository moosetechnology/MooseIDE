"
Not a real heuristic, used to group other ones in a tree list (see `#heuristicGroup`)
"
Class {
	#name : 'MiDeadCodeHeuristicGroup',
	#superclass : 'MiDeadCodeAbstractHeuristic',
	#instVars : [
		'name',
		'heuristics'
	],
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'testing' }
MiDeadCodeHeuristicGroup class >> isAbstract [

	^true
]

{ #category : 'accessing' }
MiDeadCodeHeuristicGroup >> description [

	^name , ' heuristics'
]

{ #category : 'accessing' }
MiDeadCodeHeuristicGroup >> heuristics [

	^heuristics ifNil: [ super heuristics ]
]

{ #category : 'accessing' }
MiDeadCodeHeuristicGroup >> heuristics: aCollection [

	heuristics := aCollection 
]

{ #category : 'testing' }
MiDeadCodeHeuristicGroup >> isDead: aTMethod [

	^false
]

{ #category : 'accessing' }
MiDeadCodeHeuristicGroup >> name [

	^name
]

{ #category : 'accessing' }
MiDeadCodeHeuristicGroup >> name: aString [

	name := aString
]

{ #category : 'accessing' }
MiDeadCodeHeuristicGroup >> refuteDead [

	^false
]

{ #category : 'testing' }
MiDeadCodeHeuristicGroup >> selectedByDefault [

	^false
]
